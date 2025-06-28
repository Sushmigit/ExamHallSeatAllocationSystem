<%@ page import="java.sql.*,java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    boolean showForm = true;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String regno = request.getParameter("regno");
        String dept = request.getParameter("dept");
        String sem = request.getParameter("sem");
        String subject = request.getParameter("subject");
        String exam = request.getParameter("exam");
        String date = request.getParameter("date");
        String ses = request.getParameter("session");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM student WHERE reg_no=? AND department=? AND semester=? AND subject_enrolled=?");
            ps.setString(1, regno);
            ps.setString(2, dept);
            ps.setString(3, sem);
            ps.setString(4, subject);
            ResultSet rs = ps.executeQuery();

            if (!rs.next()) {
                message = "Student not found.";
            } else if (rs.getInt("allocated") == 1) {
                message = "Student already allocated.";
            } else {
                int studentId = rs.getInt("id");

                PreparedStatement tt = conn.prepareStatement("SELECT * FROM timetable WHERE department=? AND semester=? AND subject_name=? AND exam_name=? AND exam_date=? AND session=?");
                tt.setString(1, dept);
                tt.setString(2, sem);
                tt.setString(3, subject);
                tt.setString(4, exam);
                tt.setString(5, date);
                tt.setString(6, ses);
                ResultSet ttrs = tt.executeQuery();

                if (ttrs.next()) {
                    int timetableId = ttrs.getInt("id");

                    // Venue selection logic
                    PreparedStatement venueStmt = conn.prepareStatement(
                            "SELECT v.id, v.total_seats, va.seats_available, va.invigilator FROM venue v " +
                                    "LEFT JOIN venue_allocation va ON v.id = va.venue_id " +
                                    "WHERE v.allocated = 0 OR va.seats_available > 0 ORDER BY v.id"
                    );
                    ResultSet venueRs = venueStmt.executeQuery();
                    boolean allocated = false;

                    while (venueRs.next()) {
                        int venueId = venueRs.getInt("id");
                        int totalSeats = venueRs.getInt("total_seats");
                        int availableSeats = venueRs.getInt("seats_available");
                        String invigilator = venueRs.getString("invigilator");

                        if (availableSeats == 0) availableSeats = totalSeats;

                        if (availableSeats >= 1) {
                            boolean isAllocated = (invigilator != null);

                            if (!isAllocated) {
                                PreparedStatement inv = conn.prepareStatement("SELECT * FROM invigilator WHERE allocated=0 LIMIT 1");
                                ResultSet invrs = inv.executeQuery();
                                if (invrs.next()) {
                                    invigilator = invrs.getString("name");
                                    int invId = invrs.getInt("id");

                                    PreparedStatement invAlloc = conn.prepareStatement("INSERT INTO invigilator_allocation(invigilator_id, timetable_id, venue_id) VALUES (?, ?, ?)");
                                    invAlloc.setInt(1, invId);
                                    invAlloc.setInt(2, timetableId);
                                    invAlloc.setInt(3, venueId);
                                    invAlloc.executeUpdate();

                                    PreparedStatement markInv = conn.prepareStatement("UPDATE invigilator SET allocated=1 WHERE id=?");
                                    markInv.setInt(1, invId);
                                    markInv.executeUpdate();
                                } else {
                                    continue;
                                }
                                inv.close();
                            }

                            // Allocate student
                            // Get the last seat_no used for this timetable and venue
                            String seatPrefix = "S";
                            int nextSeatNo = 1;

                            PreparedStatement seatCheck = conn.prepareStatement("SELECT seat_no FROM student_allocation WHERE timetable_id=? AND venue_id=?");
                            seatCheck.setInt(1, timetableId);
                            seatCheck.setInt(2, venueId);
                            ResultSet seatRs = seatCheck.executeQuery();

                            Set<Integer> usedSeats = new HashSet<>();
                            while (seatRs.next()) {
                                String sn = seatRs.getString("seat_no"); // Example: S1, S2
                                if (sn != null && sn.startsWith("S")) {
                                    try {
                                        int seatNum = Integer.parseInt(sn.substring(1));
                                        usedSeats.add(seatNum);
                                    } catch (NumberFormatException e) {
                                        // Ignore malformed seat numbers
                                    }
                                }
                            }
                            seatRs.close();
                            seatCheck.close();

// Find next available seat number
                            while (usedSeats.contains(nextSeatNo)) {
                                nextSeatNo++;
                            }
                            String finalSeat = seatPrefix + nextSeatNo;

// Allocate student with unique seat number
                            PreparedStatement insertAlloc = conn.prepareStatement("INSERT INTO student_allocation(student_id, timetable_id, venue_id, seat_no, invigilator_name) VALUES (?, ?, ?, ?, ?)");
                            insertAlloc.setInt(1, studentId);
                            insertAlloc.setInt(2, timetableId);
                            insertAlloc.setInt(3, venueId);
                            insertAlloc.setString(4, finalSeat);
                            insertAlloc.setString(5, invigilator);
                            insertAlloc.executeUpdate();


                            PreparedStatement updateStud = conn.prepareStatement("UPDATE student SET allocated=1 WHERE id=?");
                            updateStud.setInt(1, studentId);
                            updateStud.executeUpdate();

                            if (isAllocated) {
                                PreparedStatement updateVA = conn.prepareStatement("UPDATE venue_allocation SET seats_allocated = seats_allocated + 1, seats_available = seats_available - 1 WHERE venue_id=?");
                                updateVA.setInt(1, venueId);
                                updateVA.executeUpdate();
                            } else {
                                PreparedStatement insertVA = conn.prepareStatement("INSERT INTO venue_allocation(venue_id, timetable_id, invigilator, seats_allocated, seats_available) VALUES (?, ?, ?, ?, ?)");
                                insertVA.setInt(1, venueId);
                                insertVA.setInt(2, timetableId);
                                insertVA.setString(3, invigilator);
                                insertVA.setInt(4, 1);
                                insertVA.setInt(5, totalSeats - 1);
                                insertVA.executeUpdate();
                            }

                            PreparedStatement markVenue = conn.prepareStatement("UPDATE venue SET allocated=1 WHERE id=?");
                            markVenue.setInt(1, venueId);
                            markVenue.executeUpdate();

                            // timetable_allocation update/insert
                            PreparedStatement checkTA = conn.prepareStatement("SELECT * FROM timetable_allocation WHERE timetable_id=? AND venue_id=?");
                            checkTA.setInt(1, timetableId);
                            checkTA.setInt(2, venueId);
                            ResultSet taRs = checkTA.executeQuery();
                            if (taRs.next()) {
                                PreparedStatement updateTA = conn.prepareStatement("UPDATE timetable_allocation SET seats_allocated = seats_allocated + 1 WHERE timetable_id=? AND venue_id=?");
                                updateTA.setInt(1, timetableId);
                                updateTA.setInt(2, venueId);
                                updateTA.executeUpdate();
                            } else {
                                PreparedStatement insertTA = conn.prepareStatement("INSERT INTO timetable_allocation(timetable_id, venue_id, seats_allocated, invigilator) VALUES (?, ?, ?, ?)");
                                insertTA.setInt(1, timetableId);
                                insertTA.setInt(2, venueId);
                                insertTA.setInt(3, 1);
                                insertTA.setString(4, invigilator);
                                insertTA.executeUpdate();
                            }

                            PreparedStatement updateTT = conn.prepareStatement("UPDATE timetable SET allocated=1 WHERE id=?");
                            updateTT.setInt(1, timetableId);
                            updateTT.executeUpdate();

                            response.sendRedirect("allocateStudentSuccess.jsp");
                            return;
                        }
                    }
                    message = "No venue found with available seats.";
                } else {
                    message = "Timetable not found.";
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Allocate Seat</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: #f3e7fe;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }

        .form-box {
            width: 450px;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h3 {
            color: #5e2784;
            text-align: center;
            margin-bottom: 25px;
        }

        .btn-purple {
            background-color: #5e2784;
            color: white;
            width: 100%;
        }

        .btn-purple:hover {
            background-color: #42125e;
        }

        .error-msg {
            color: red;
            text-align: center;
        }
    </style>
</head>
<body>
<div class="form-box">
    <h3>Allocate Student to Seat</h3>
    <% if (!message.isEmpty()) { %>
    <p class="error-msg"><%= message %></p>
    <% } %>
    <form method="post">
        <input name="regno" class="form-control mb-2" placeholder="Registration Number" required />
        <input name="dept" class="form-control mb-2" placeholder="Department" required />
        <input name="sem" class="form-control mb-2" placeholder="Semester" required />
        <input name="subject" class="form-control mb-2" placeholder="Subject" required />
        <input name="exam" class="form-control mb-2" placeholder="Exam Name" required />
        <input name="date" type="date" class="form-control mb-2" required />
        <input name="session" class="form-control mb-2" placeholder="Session" required />
        <button type="submit" class="btn btn-purple mt-3">Allocate Seat</button>
    </form>
</div>
</body>
</html>
