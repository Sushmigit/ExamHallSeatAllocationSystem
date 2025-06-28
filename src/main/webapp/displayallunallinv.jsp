<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Invigilator Details</title>
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
        List<Map<String, String>> invList = (List<Map<String, String>>) request.getAttribute("invList");
    %>

    <h2><%= "allocated".equals(type) ? "Allocated Invigilators" : "Unallocated Invigilators" %></h2>

    <%
        if (invList == null || invList.isEmpty()) {
    %>
    <div class="alert alert-warning text-center">
        No invigilators are currently <strong><%= type %></strong>.
    </div>
    <%
    } else {
    %>

    <table class="table table-bordered text-center">
        <thead class="table-light">
        <tr>
            <% if ("allocated".equals(type)) { %>
            <th>Exam Name</th>
            <th>Subject Name</th>
            <th>Exam Date</th>
            <th>Session</th>
            <th>Invigilator</th>
            <th>Venue Name</th>
            <th>Room No</th>
            <% } else { %>
            <th>Invigilator Name</th>
            <th>Department</th>
            <% } %>
        </tr>
        </thead>
        <tbody>
        <%
            for (Map<String, String> row : invList) {
        %>
        <tr>
            <% if ("allocated".equals(type)) { %>
            <td><%= row.get("exam_name") %></td>
            <td><%= row.get("subject_name") %></td>
            <td><%= row.get("exam_date") %></td>
            <td><%= row.get("session") %></td>
            <td><%= row.get("invigilator") %></td>
            <td><%= row.get("venue_name") %></td>
            <td><%= row.get("room_no") %></td>
            <% } else { %>
            <td><%= row.get("invigilator") %></td>
            <td><%= row.get("department") %></td>
            <% } %>
        </tr>
        <% } %>
        </tbody>
    </table>

    <% } %>
</div>
</body>
</html>
