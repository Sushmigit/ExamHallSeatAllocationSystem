<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Timetable Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            background: white;
            margin-top: 50px;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            color: #5e2784;
            text-align: center;
            margin-bottom: 25px;
        }
    </style>
</head>
<body>
<div class="container">
    <%
        String type = (String) request.getAttribute("type");
        List<Map<String, String>> examList = (List<Map<String, String>>) request.getAttribute("examList");
    %>

    <h2><%= "allocated".equals(type) ? "Allocated Exams" : "Unallocated Exams" %></h2>

    <%
        if (examList == null || examList.isEmpty()) {
    %>
    <div class="alert alert-warning text-center">
        No timetables are currently <strong><%= type %></strong>.
    </div>
    <%
    } else {
    %>

    <table class="table table-bordered text-center">
        <thead class="table-light">
        <tr>
            <th>Exam Name</th>
            <th>Subject Name</th>
            <th>Date</th>
            <th>Session</th>
            <%
                if ("allocated".equals(type)) {
            %>
            <th>Seats Allocated</th>
            <th>Invigilator</th>
            <th>Venue Name</th>
            <th>Room No</th>
            <% } %>
        </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, String> row : examList) {
        %>
        <tr>
            <td><%= row.get("exam_name") %></td>
            <td><%= row.get("subject_name") %></td>
            <td><%= row.get("exam_date") %></td>
            <td><%= row.get("session") %></td>
            <%
                if ("allocated".equals(type)) {
            %>
            <td><%= row.get("seats_allocated") %></td>
            <td><%= row.get("invigilator") %></td>
            <td><%= row.get("venue_name") %></td>
            <td><%= row.get("room_no") %></td>
            <% } %>
        </tr>
        <% } %>
        </tbody>
    </table>

    <%
        }
    %>
</div>
</body>
</html>
