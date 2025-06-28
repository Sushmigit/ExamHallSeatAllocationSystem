<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    String action = request.getParameter("action");

    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

        if ("reallocate".equals(action) && request.getMethod().equals("POST")) {
            int studentId = Integer.parseInt(request.getParameter("sid"));
            String newVenue = request.getParameter("venue");
            String roomNo = request.getParameter("room");

            // Get old student allocation
            PreparedStatement oldAlloc = conn.prepareStatement("SELECT * FROM student_allocation WHERE student_id=?");
            oldAlloc.setInt(1, studentId);
            ResultSet rsOld = oldAlloc.executeQuery();

            if (!rsOld.next()) {
                message = "Student not allocated yet.";
            } else {
                int timetableId = rsOld.getInt("timetable_id");
                int oldVenueId = rsOld.getInt("venue_id");
                String oldInv = rsOld.getString("invigilator_name");

                // Get new venue
                PreparedStatement venueStmt = conn.prepareStatement("SELECT * FROM venue WHERE venue_name=? AND room_no=?");
                venueStmt.setString(1, newVenue);
                venueStmt.setString(2, roomNo);
                ResultSet venueRs = venueStmt.executeQuery();

                if (!venueRs.next()) {
                    message = "New venue does not exist.";
                } else {
                    int newVenueId = venueRs.getInt("id");
                    int totalSeats = venueRs.getInt("total_seats");

                    PreparedStatement vaStmt = conn.prepareStatement("SELECT * FROM venue_allocation WHERE venue_id=?");
                    vaStmt.setInt(1, newVenueId);
                    ResultSet vaRs = vaStmt.executeQuery();

                    String invName = "";
                    boolean isNew = !vaRs.next();
                    int availSeats = isNew ? totalSeats : vaRs.getInt("seats_available");

                    if (availSeats < 1) {
                        message = "Not enough seats available.";
                    } else {
                        if (isNew) {
                            // Get unallocated invigilator
                            PreparedStatement invSel = conn.prepareStatement("SELECT * FROM invigilator WHERE allocated=0 LIMIT 1");
                            ResultSet invRs = invSel.executeQuery();
                            if (invRs.next()) {
                                invName = invRs.getString("name");
                                int invId = invRs.getInt("id");

                                // Allocate invigilator
                                PreparedStatement invAlloc = conn.prepareStatement("INSERT INTO invigilator_allocation(invigilator_id, timetable_id, venue_id) VALUES (?, ?, ?)");
                                invAlloc.setInt(1, invId);
                                invAlloc.setInt(2, timetableId);
                                invAlloc.setInt(3, newVenueId);
                                invAlloc.executeUpdate();

                                PreparedStatement markInv = conn.prepareStatement("UPDATE invigilator SET allocated=1 WHERE id=?");
                                markInv.setInt(1, invId);
                                markInv.executeUpdate();

                                // Insert into venue_allocation
                                PreparedStatement insertVA = conn.prepareStatement("INSERT INTO venue_allocation (venue_id, timetable_id, invigilator, seats_allocated, seats_available) VALUES (?, ?, ?, ?, ?)");
                                insertVA.setInt(1, newVenueId);
                                insertVA.setInt(2, timetableId);
                                insertVA.setString(3, invName);
                                insertVA.setInt(4, 1);
                                insertVA.setInt(5, totalSeats - 1);
                                insertVA.executeUpdate();
                            } else {
                                message = "No available invigilators.";
                            }
                        } else {
                            invName = vaRs.getString("invigilator");

                            PreparedStatement updateVA = conn.prepareStatement("UPDATE venue_allocation SET seats_allocated = seats_allocated + 1, seats_available = seats_available - 1 WHERE venue_id=?");
                            updateVA.setInt(1, newVenueId);
                            updateVA.executeUpdate();
                        }

                        if (message.equals("")) {
                            // Generate new seat no
                            PreparedStatement seatCheck = conn.prepareStatement("SELECT seat_no FROM student_allocation WHERE venue_id=?");
                            seatCheck.setInt(1, newVenueId);
                            ResultSet sRs = seatCheck.executeQuery();
                            Set<String> usedSeats = new HashSet<>();
                            while (sRs.next()) usedSeats.add(sRs.getString("seat_no"));

                            int sn = 1;
                            String newSeat;
                            do {
                                newSeat = "S" + sn++;
                            } while (usedSeats.contains(newSeat));

                            // Update student_allocation
                            PreparedStatement updSA = conn.prepareStatement("UPDATE student_allocation SET venue_id=?, seat_no=?, invigilator_name=? WHERE student_id=?");
                            updSA.setInt(1, newVenueId);
                            updSA.setString(2, newSeat);
                            updSA.setString(3, invName);
                            updSA.setInt(4, studentId);
                            updSA.executeUpdate();

                            // Update old venue
                            PreparedStatement updateOldVA = conn.prepareStatement("UPDATE venue_allocation SET seats_allocated = seats_allocated - 1, seats_available = seats_available + 1 WHERE venue_id=?");
                            updateOldVA.setInt(1, oldVenueId);
                            updateOldVA.executeUpdate();

                            // If old venue is now empty
                            PreparedStatement checkOld = conn.prepareStatement("SELECT seats_allocated FROM venue_allocation WHERE venue_id=?");
                            checkOld.setInt(1, oldVenueId);
                            ResultSet rs = checkOld.executeQuery();
                            if (rs.next() && rs.getInt("seats_allocated") == 0) {
                                PreparedStatement insVD = conn.prepareStatement("INSERT INTO venue_deallocation (venue_id, timetable_id, invigilator, seats_allocated, seats_available) SELECT venue_id, timetable_id, invigilator, seats_allocated, seats_available FROM venue_allocation WHERE venue_id=?");
                                insVD.setInt(1, oldVenueId);
                                insVD.executeUpdate();

                                PreparedStatement delVA = conn.prepareStatement("DELETE FROM venue_allocation WHERE venue_id=?");
                                delVA.setInt(1, oldVenueId);
                                delVA.executeUpdate();

                                PreparedStatement delIA = conn.prepareStatement("DELETE FROM invigilator_allocation WHERE venue_id=? AND timetable_id=?");
                                delIA.setInt(1, oldVenueId);
                                delIA.setInt(2, timetableId);
                                delIA.executeUpdate();

                                PreparedStatement updInv = conn.prepareStatement("UPDATE invigilator SET allocated=0 WHERE name=?");
                                updInv.setString(1, oldInv);
                                updInv.executeUpdate();
                            }

                            response.sendRedirect("studentReallocationSuccess.jsp");
                            return;
                        }
                    }
                }
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
    <title>Student Reallocation</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
</head>
<body class="p-4">
<h3 class="text-center text-primary">Single Student Reallocation</h3>

<form method="get" class="mb-4">
    Department: <input name="dept" required class="form-control w-25 d-inline-block" />
    Semester: <input name="sem" required class="form-control w-25 d-inline-block" />
    Subject: <input name="sub" required class="form-control w-25 d-inline-block" />
    <button class="btn btn-secondary">Fetch Students</button>
</form>

<%
    if (request.getParameter("dept") != null) {
        PreparedStatement ps = conn.prepareStatement("SELECT s.id, s.name, s.reg_no, sa.seat_no, sa.invigilator_name FROM student s JOIN student_allocation sa ON s.id = sa.student_id WHERE s.department=? AND s.semester=? AND s.subject_enrolled=?");
        ps.setString(1, request.getParameter("dept"));
        ps.setString(2, request.getParameter("sem"));
        ps.setString(3, request.getParameter("sub"));
        ResultSet rs = ps.executeQuery();
%>
<table class="table table-bordered text-center">
    <thead>
    <tr><th>Name</th><th>Reg No</th><th>Seat No</th><th>Invigilator</th><th>Reallocate</th></tr>
    </thead>
    <tbody>
    <%
        while (rs.next()) {
    %>
    <tr>
        <td><%= rs.getString("name") %></td>
        <td><%= rs.getString("reg_no") %></td>
        <td><%= rs.getString("seat_no") %></td>
        <td><%= rs.getString("invigilator_name") %></td>
        <td>
            <form method="post" class="d-flex gap-2">
                <input type="hidden" name="action" value="reallocate"/>
                <input type="hidden" name="sid" value="<%= rs.getInt("id") %>"/>
                <input name="venue" placeholder="Venue" required class="form-control" />
                <input name="room" placeholder="Room No" required class="form-control" />
                <button class="btn btn-danger btn-sm">Reallocate</button>
            </form>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>
<% } %>

<% if (!message.isEmpty()) { %>
<div class="alert alert-danger mt-3"><%= message %></div>
<% } %>

</body>
</html>
