<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    String action = request.getParameter("action");
    String selectedTid = request.getParameter("tid");
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

        if ("reallocate".equals(action) && request.getMethod().equals("POST")) {
            String newVenue = request.getParameter("venue");
            String roomNo = request.getParameter("room");
            int timetableId = Integer.parseInt(request.getParameter("tid"));

            // Get old timetable allocation
            PreparedStatement getOldTA = conn.prepareStatement("SELECT * FROM timetable_allocation WHERE timetable_id=?");
            getOldTA.setInt(1, timetableId);
            ResultSet taRs = getOldTA.executeQuery();

            if (taRs.next()) {
                int oldVenueId = taRs.getInt("venue_id");
                int allocatedSeats = taRs.getInt("seats_allocated");
                String oldInv = taRs.getString("invigilator");

                // Get new venue
                PreparedStatement venueStmt = conn.prepareStatement("SELECT * FROM venue WHERE venue_name=? AND room_no=?");
                venueStmt.setString(1, newVenue);
                venueStmt.setString(2, roomNo);
                ResultSet venueRs = venueStmt.executeQuery();

                if (!venueRs.next()) {
                    message = "Venue not found.";
                } else {
                    int newVenueId = venueRs.getInt("id");
                    int totalSeats = venueRs.getInt("total_seats");

                    PreparedStatement vaStmt = conn.prepareStatement("SELECT * FROM venue_allocation WHERE venue_id=?");
                    vaStmt.setInt(1, newVenueId);
                    ResultSet vaRs = vaStmt.executeQuery();

                    String invName = "";
                    boolean isNew = !vaRs.next();
                    int avail = isNew ? totalSeats : vaRs.getInt("seats_available");

                    if (avail < allocatedSeats) {
                        message = "Not enough available seats in the new venue.";
                    } else {
                        if (isNew) {
                            PreparedStatement invSel = conn.prepareStatement("SELECT * FROM invigilator WHERE allocated=0 LIMIT 1");
                            ResultSet invRs = invSel.executeQuery();
                            if (invRs.next()) {
                                invName = invRs.getString("name");
                                int invId = invRs.getInt("id");

                                PreparedStatement invAlloc = conn.prepareStatement("INSERT INTO invigilator_allocation (invigilator_id, timetable_id, venue_id) VALUES (?, ?, ?)");
                                invAlloc.setInt(1, invId);
                                invAlloc.setInt(2, timetableId);
                                invAlloc.setInt(3, newVenueId);
                                invAlloc.executeUpdate();

                                PreparedStatement markInv = conn.prepareStatement("UPDATE invigilator SET allocated=1 WHERE id=?");
                                markInv.setInt(1, invId);
                                markInv.executeUpdate();

                                PreparedStatement insertVA = conn.prepareStatement("INSERT INTO venue_allocation (venue_id, timetable_id, invigilator, seats_allocated, seats_available) VALUES (?, ?, ?, ?, ?)");
                                insertVA.setInt(1, newVenueId);
                                insertVA.setInt(2, timetableId);
                                insertVA.setString(3, invName);
                                insertVA.setInt(4, allocatedSeats);
                                insertVA.setInt(5, totalSeats - allocatedSeats);
                                insertVA.executeUpdate();
                            } else {
                                message = "No available invigilator.";
                            }
                        } else {
                            invName = vaRs.getString("invigilator");
                            PreparedStatement updateVA = conn.prepareStatement("UPDATE venue_allocation SET seats_allocated = seats_allocated + ?, seats_available = seats_available - ? WHERE venue_id=?");
                            updateVA.setInt(1, allocatedSeats);
                            updateVA.setInt(2, allocatedSeats);
                            updateVA.setInt(3, newVenueId);
                            updateVA.executeUpdate();
                        }

                        if (message.equals("")) {
                            PreparedStatement updateTA = conn.prepareStatement("UPDATE timetable_allocation SET venue_id=?, invigilator=? WHERE timetable_id=?");
                            updateTA.setInt(1, newVenueId);
                            updateTA.setString(2, invName);
                            updateTA.setInt(3, timetableId);
                            updateTA.executeUpdate();

                            PreparedStatement seatQuery = conn.prepareStatement("SELECT seat_no FROM student_allocation WHERE venue_id=?");
                            seatQuery.setInt(1, newVenueId);
                            ResultSet seatRs = seatQuery.executeQuery();
                            Set<String> usedSeats = new HashSet<>();
                            while (seatRs.next()) {
                                usedSeats.add(seatRs.getString("seat_no"));
                            }
                            seatRs.close();
                            seatQuery.close();

                            PreparedStatement fetchStudents = conn.prepareStatement("SELECT student_id FROM student_allocation WHERE timetable_id=?");
                            fetchStudents.setInt(1, timetableId);
                            ResultSet studRs = fetchStudents.executeQuery();

                            PreparedStatement updateSA = conn.prepareStatement("UPDATE student_allocation SET venue_id=?, invigilator_name=?, seat_no=? WHERE timetable_id=? AND student_id=?");
                            int seatNo = 1;
                            while (studRs.next()) {
                                int sid = studRs.getInt("student_id");
                                String newSeat;
                                do {
                                    newSeat = "S" + seatNo++;
                                } while (usedSeats.contains(newSeat));
                                usedSeats.add(newSeat);

                                updateSA.setInt(1, newVenueId);
                                updateSA.setString(2, invName);
                                updateSA.setString(3, newSeat);
                                updateSA.setInt(4, timetableId);
                                updateSA.setInt(5, sid);
                                updateSA.addBatch();
                            }
                            updateSA.executeBatch();

                            PreparedStatement updateOldVA = conn.prepareStatement("UPDATE venue_allocation SET seats_allocated = seats_allocated - ?, seats_available = seats_available + ? WHERE venue_id=?");
                            updateOldVA.setInt(1, allocatedSeats);
                            updateOldVA.setInt(2, allocatedSeats);
                            updateOldVA.setInt(3, oldVenueId);
                            updateOldVA.executeUpdate();

                            PreparedStatement checkOld = conn.prepareStatement("SELECT seats_allocated FROM venue_allocation WHERE venue_id=?");
                            checkOld.setInt(1, oldVenueId);
                            ResultSet rsCheck = checkOld.executeQuery();
                            if (rsCheck.next() && rsCheck.getInt("seats_allocated") == 0) {
                                PreparedStatement insertVD = conn.prepareStatement("INSERT INTO venue_deallocation (venue_id, timetable_id, invigilator, seats_allocated, seats_available) SELECT venue_id, timetable_id, invigilator, seats_allocated, seats_available FROM venue_allocation WHERE venue_id=?");
                                insertVD.setInt(1, oldVenueId);
                                insertVD.executeUpdate();

                                PreparedStatement delOld = conn.prepareStatement("DELETE FROM venue_allocation WHERE venue_id=?");
                                delOld.setInt(1, oldVenueId);
                                delOld.executeUpdate();

                                PreparedStatement delInvAlloc = conn.prepareStatement("DELETE FROM invigilator_allocation WHERE venue_id=? AND timetable_id=?");
                                delInvAlloc.setInt(1, oldVenueId);
                                delInvAlloc.setInt(2, timetableId);
                                delInvAlloc.executeUpdate();

                                PreparedStatement updateInv = conn.prepareStatement("UPDATE invigilator SET allocated=0 WHERE name=?");
                                updateInv.setString(1, oldInv);
                                updateInv.executeUpdate();
                            }

                            response.sendRedirect("reallocationTTSuccess.jsp");
                            return;
                        }
                    }
                }
            } else {
                message = "Invalid timetable.";
            }
        }
    } catch (Exception e) {
        message = "Error: " + e.getMessage();
        e.printStackTrace();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Timetable Reallocation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="p-4">
<h3 class="text-center text-primary">Timetable Reallocation</h3>

<form method="get" class="mb-4">
    Department: <input name="dept" required class="form-control w-25 d-inline-block" />
    Semester: <input name="sem" required class="form-control w-25 d-inline-block" />
    <button class="btn btn-secondary">Fetch Timetables</button>
</form>

<%
    if (request.getParameter("dept") != null) {
        PreparedStatement ps = conn.prepareStatement("SELECT * FROM timetable WHERE department=? AND semester=? AND allocated=1");
        ps.setString(1, request.getParameter("dept"));
        ps.setString(2, request.getParameter("sem"));
        ResultSet trs = ps.executeQuery();
%>
<table class="table table-bordered text-center">
    <thead>
    <tr><th>Subject</th><th>Exam</th><th>Date</th><th>Session</th><th>Reallocate</th></tr>
    </thead>
    <tbody>
    <%
        while (trs.next()) {
    %>
    <tr>
        <td><%= trs.getString("subject_name") %></td>
        <td><%= trs.getString("exam_name") %></td>
        <td><%= trs.getString("exam_date") %></td>
        <td><%= trs.getString("session") %></td>
        <td>
            <form method="post" class="d-flex gap-2">
                <input type="hidden" name="action" value="reallocate"/>
                <input type="hidden" name="tid" value="<%= trs.getInt("id") %>"/>
                <input name="venue" placeholder="Venue" required class="form-control" />
                <input name="room" placeholder="Room No" required class="form-control" />
                <button class="btn btn-danger btn-sm">Reallocate</button>
            </form>
        </td>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>

<% if (!message.isEmpty()) { %>
<div class="alert alert-danger mt-3"><%= message %></div>
<% } %>

</body>
</html>
