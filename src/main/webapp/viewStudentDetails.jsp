<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Students</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            padding: 40px;
            height:100%;
        }

        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        h3 {
            color: #5e2784;
            text-align: center;
            margin-bottom: 25px;
        }

        .btn-purple {
            background-color: #5e2784;
            color: white;
        }

        .btn-purple:hover {
            background-color: #42125e;
        }
    </style>
</head>
<body>

<%
    String type = request.getParameter("type"); // "all" or "allocated"
    String dept = request.getParameter("dept");
    String sem = request.getParameter("sem");
    String sub = request.getParameter("sub");
%>

<div class="container">
    <h3>Select Department, Semester & Subject</h3>
    <form method="get">
        <input type="hidden" name="type" value="<%= type %>"/>
        <div class="row mb-3">
            <div class="col">
                <label>Department</label>
                <select name="dept" class="form-select" required>
                    <option value="" disabled selected>Select</option>
                    <option value="CSE" <%= "CSE".equals(dept) ? "selected" : "" %>>CSE</option>
                    <option value="ECE" <%= "ECE".equals(dept) ? "selected" : "" %>>ECE</option>
                    <option value="EEE" <%= "EEE".equals(dept) ? "selected" : "" %>>EEE</option>
                </select>
            </div>
            <div class="col">
                <label>Semester</label>
                <select name="sem" class="form-select" required>
                    <option value="" disabled selected>Select</option>
                    <% for(int i=1; i<=8; i++) { %>
                    <option value="<%= i %>" <%= (String.valueOf(i).equals(sem)) ? "selected" : "" %>><%= i %></option>
                    <% } %>
                </select>
            </div>
            <div class="col">
                <label>Subject</label>
                <input type="text" class="form-control" name="sub" value="<%= sub != null ? sub : "" %>" required>
            </div>
        </div>
        <button type="submit" class="btn btn-purple w-100">View Students</button>
    </form>
</div>

<%
    if (dept != null && sem != null && sub != null) {
        List<Map<String, String>> students = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql;
            PreparedStatement stmt;

            if ("allocated".equals(type)) {
                sql = "SELECT s.name, s.reg_no, s.department, s.semester, s.subject_enrolled, " +
                        "t.exam_name, t.exam_date, t.session, v.venue_name, v.room_no " +
                        "FROM student s " +
                        "JOIN student_allocation sa ON s.id = sa.student_id " +
                        "JOIN timetable t ON sa.timetable_id = t.id " +
                        "JOIN venue v ON sa.venue_id = v.id " +
                        "WHERE s.department=? AND s.semester=? AND s.subject_enrolled=? AND s.allocated=1";
            } else {
                sql = "SELECT name, reg_no, department, semester, subject_enrolled, allocated " +
                        "FROM student WHERE department=? AND semester=? AND subject_enrolled=?";
            }

            stmt = conn.prepareStatement(sql);
            stmt.setString(1, dept);
            stmt.setString(2, sem);
            stmt.setString(3, sub);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> student = new HashMap<>();
                student.put("name", rs.getString("name"));
                student.put("regno", rs.getString("reg_no"));
                student.put("department", rs.getString("department"));
                student.put("semester", rs.getString("semester"));
                student.put("subject", rs.getString("subject_enrolled"));

                if ("allocated".equals(type)) {
                    student.put("exam", rs.getString("exam_name"));
                    student.put("date", rs.getString("exam_date"));
                    student.put("session", rs.getString("session"));
                    student.put("venue", rs.getString("venue_name"));
                    student.put("room", rs.getString("room_no"));
                } else {
                    student.put("allocated", rs.getString("allocated"));
                }

                students.add(student);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
%>

<div class="container mt-4">
    <h3><%= "allocated".equals(type) ? "Allocated Students with Exam & Venue Details" : "All Students" %></h3>
    <table class="table table-bordered text-center mt-3">
        <thead class="table-light">
        <tr>
            <th>Name</th>
            <th>Reg. No</th>
            <th>Department</th>
            <th>Semester</th>
            <th>Subject</th>
            <% if ("allocated".equals(type)) { %>
            <th>Exam</th>
            <th>Date</th>
            <th>Session</th>
            <th>Venue</th>
            <th>Room No</th>
            <% } else { %>
            <th>Status</th>
            <% } %>
        </tr>
        </thead>
        <tbody>
        <% if (students.isEmpty()) { %>
        <tr><td colspan="<%= "allocated".equals(type) ? 10 : 6 %>" class="text-danger">No records found.</td></tr>
        <% } else {
            for (Map<String, String> s : students) { %>
        <tr>
            <td><%= s.get("name") %></td>
            <td><%= s.get("regno") %></td>
            <td><%= s.get("department") %></td>
            <td><%= s.get("semester") %></td>
            <td><%= s.get("subject") %></td>
            <% if ("allocated".equals(type)) { %>
            <td><%= s.get("exam") %></td>
            <td><%= s.get("date") %></td>
            <td><%= s.get("session") %></td>
            <td><%= s.get("venue") %></td>
            <td><%= s.get("room") %></td>
            <% } else { %>
            <td><%= "1".equals(s.get("allocated")) ? "Allocated" : "Unallocated" %></td>
            <% } %>
        </tr>
        <% } } %>
        </tbody>
    </table>
</div>

<% } %>

</body>
</html>
