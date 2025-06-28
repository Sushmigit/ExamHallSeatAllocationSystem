<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String msg = "";
    List<Map<String, String>> students = new ArrayList<>();

    if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") == null) {
        String dept = request.getParameter("dept");
        String sem = request.getParameter("sem");
        String sub = request.getParameter("subject");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT sa.student_id, s.name, s.reg_no, sa.timetable_id, sa.venue_id, sa.seat_no, " +
                    "t.exam_name, t.exam_date, t.session, v.venue_name, v.room_no " +
                    "FROM student_allocation sa " +
                    "JOIN student s ON sa.student_id = s.id " +
                    "JOIN timetable t ON sa.timetable_id = t.id " +
                    "JOIN venue v ON sa.venue_id = v.id " +
                    "WHERE s.department=? AND s.semester=? AND s.subject_enrolled=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, dept);
            ps.setString(2, sem);
            ps.setString(3, sub);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("student_id", rs.getString("student_id"));
                row.put("name", rs.getString("name"));
                row.put("regno", rs.getString("reg_no"));
                row.put("timetable_id", rs.getString("timetable_id"));
                row.put("venue_id", rs.getString("venue_id"));
                row.put("seat_no", rs.getString("seat_no"));
                row.put("exam_name", rs.getString("exam_name"));
                row.put("exam_date", rs.getString("exam_date"));
                row.put("session", rs.getString("session"));
                row.put("venue_name", rs.getString("venue_name"));
                row.put("room_no", rs.getString("room_no"));
                students.add(row);
            }
            conn.close();
        } catch (Exception e) {
            msg = "Error: " + e.getMessage();
        }
    }

    if ("POST".equalsIgnoreCase(request.getMethod()) && "deallocate".equals(request.getParameter("action"))) {
        int studentId = Integer.parseInt(request.getParameter("student_id"));
        int timetableId = Integer.parseInt(request.getParameter("timetable_id"));
        int venueId = Integer.parseInt(request.getParameter("venue_id"));
        String seatNo = request.getParameter("seat_no");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            PreparedStatement fetch = conn.prepareStatement("SELECT * FROM student_allocation WHERE student_id=? AND timetable_id=?");
            fetch.setInt(1, studentId);
            fetch.setInt(2, timetableId);
            ResultSet frs = fetch.executeQuery();

            if (frs.next()) {
                String invigilator = frs.getString("invigilator_name");

                PreparedStatement insert = conn.prepareStatement(
                        "INSERT INTO student_deallocation(student_id, timetable_id, venue_id, seat_no, invigilator_name) VALUES (?, ?, ?, ?, ?)");
                insert.setInt(1, studentId);
                insert.setInt(2, timetableId);
                insert.setInt(3, venueId);
                insert.setString(4, seatNo);
                insert.setString(5, invigilator);
                insert.executeUpdate();
                insert.close();
            }
            fetch.close();

            // Delete from student_allocation
            PreparedStatement del = conn.prepareStatement("DELETE FROM student_allocation WHERE student_id=? AND timetable_id=?");
            del.setInt(1, studentId);
            del.setInt(2, timetableId);
            del.executeUpdate();

            // Reset allocated in student table
            PreparedStatement updStudent = conn.prepareStatement("UPDATE student SET allocated=0 WHERE id=?");
            updStudent.setInt(1, studentId);
            updStudent.executeUpdate();

            // Update timetable_allocation
            PreparedStatement updTA = conn.prepareStatement("UPDATE timetable_allocation SET seats_allocated = seats_allocated - 1 WHERE timetable_id=? AND venue_id=?");
            updTA.setInt(1, timetableId);
            updTA.setInt(2, venueId);
            updTA.executeUpdate();

            // Update venue_allocation
            PreparedStatement updVA = conn.prepareStatement("UPDATE venue_allocation SET seats_allocated = seats_allocated - 1, seats_available = seats_available + 1 WHERE venue_id=? AND timetable_id=?");
            updVA.setInt(1, venueId);
            updVA.setInt(2, timetableId);
            updVA.executeUpdate();

            conn.close();
            response.sendRedirect("deallocateStudentSuccess.jsp");
            return;

        } catch (Exception e) {
            msg = "Error during deallocation: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Deallocate Students</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: #f3e7fe;
            padding: 40px;
            font-family: 'Segoe UI', sans-serif;
        }
        .form-box, .table-box {
            background: white;
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        h3 {
            color: #5e2784;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <div class="form-box">
        <h3>Find Allocated Students</h3>
        <% if (!msg.isEmpty()) { %>
        <div class="alert alert-danger"><%= msg %></div>
        <% } %>
        <form method="post">
            <div class="row">
                <div class="col">
                    <input name="dept" class="form-control" placeholder="Department" required/>
                </div>
                <div class="col">
                    <input name="sem" class="form-control" placeholder="Semester" required/>
                </div>
                <div class="col">
                    <input name="subject" class="form-control" placeholder="Subject" required/>
                </div>
                <div class="col">
                    <button type="submit" class="btn btn-primary">Search</button>
                </div>
            </div>
        </form>
    </div>

    <% if (!students.isEmpty()) { %>
    <div class="table-box">
        <h3>Allocated Students</h3>
        <table class="table table-bordered table-striped">
            <thead class="table-light">
            <tr>
                <th>Name</th>
                <th>Reg. No</th>
                <th>Seat No</th>
                <th>Exam</th>
                <th>Date</th>
                <th>Session</th>
                <th>Venue</th>
                <th>Room No</th>
                <th>Action</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map<String, String> s : students) { %>
            <tr>
                <td><%= s.get("name") %></td>
                <td><%= s.get("regno") %></td>
                <td><%= s.get("seat_no") %></td>
                <td><%= s.get("exam_name") %></td>
                <td><%= s.get("exam_date") %></td>
                <td><%= s.get("session") %></td>
                <td><%= s.get("venue_name") %></td>
                <td><%= s.get("room_no") %></td>
                <td>
                    <form method="post">
                        <input type="hidden" name="action" value="deallocate" />
                        <input type="hidden" name="student_id" value="<%= s.get("student_id") %>" />
                        <input type="hidden" name="timetable_id" value="<%= s.get("timetable_id") %>" />
                        <input type="hidden" name="venue_id" value="<%= s.get("venue_id") %>" />
                        <input type="hidden" name="seat_no" value="<%= s.get("seat_no") %>" />
                        <button type="submit" class="btn btn-danger btn-sm">Deallocate</button>
                    </form>
                </td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
    <% } %>
</div>

</body>
</html>
