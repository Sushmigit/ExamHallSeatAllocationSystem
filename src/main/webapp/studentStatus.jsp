<%@ page import="java.sql.*, java.util.*" %>
<%
    String reg = request.getParameter("reg_no");
    String name = request.getParameter("name");
    String sub = request.getParameter("subject");
    String exam = request.getParameter("exam");
    String dept = request.getParameter("dept");
    String sem = request.getParameter("sem");

    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

    PreparedStatement ps = conn.prepareStatement("SELECT s.id, sa.*, t.exam_name, t.subject_name, t.exam_date, t.session, v.venue_name, v.room_no " +
            "FROM student s " +
            "JOIN student_allocation sa ON s.id = sa.student_id " +
            "JOIN timetable t ON sa.timetable_id = t.id " +
            "JOIN venue v ON sa.venue_id = v.id " +
            "WHERE s.reg_no=? AND s.name=? AND s.subject_enrolled=? AND s.department=? AND s.semester=? AND t.exam_name=?");
    ps.setString(1, reg);
    ps.setString(2, name);
    ps.setString(3, sub);
    ps.setString(4, dept);
    ps.setString(5, sem);
    ps.setString(6, exam);

    ResultSet rs = ps.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Exam Allocation Status</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body { background-color: #f9f6fc; }
        .box { background: white; border-radius: 10px; padding: 20px; box-shadow: 0 0 10px #ccc; }
        .title-purple { color: #6f42c1; }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">
<div class="box">
    <% if (rs.next()) { %>
    <h4 class="title-purple text-center mb-4">Exam Allocation Details</h4>
    <table class="table table-bordered text-center">
        <tr><th>Exam Name</th><td><%= rs.getString("exam_name") %></td></tr>
        <tr><th>Subject</th><td><%= rs.getString("subject_name") %></td></tr>
        <tr><th>Date</th><td><%= rs.getDate("exam_date") %></td></tr>
        <tr><th>Session</th><td><%= rs.getString("session") %></td></tr>
        <tr><th>Venue</th><td><%= rs.getString("venue_name") %></td></tr>
        <tr><th>Room No</th><td><%= rs.getString("room_no") %></td></tr>
        <tr><th>Seat No</th><td><%= rs.getString("seat_no") %></td></tr>
        <tr><th>Invigilator</th><td><%= rs.getString("invigilator_name") %></td></tr>
    </table>
    <% } else { %>
    <div class="alert alert-warning">Not allocated as of yet.</div>
    <% } %>
</div>
</body>
</html>
