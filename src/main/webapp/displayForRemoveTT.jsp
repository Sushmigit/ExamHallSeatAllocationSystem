<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Timetables</title>
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
        .btn-purple {
            background-color: transparent;
            border: 1px solid #5e2784;
            color: #5e2784;
            transition: 0.3s;
        }
        .btn-purple:hover {
            background-color: #5e2784;
            color: white;
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
    <h2>Remove Timetables</h2>

    <%
        List<Map<String, String>> timetableList = (List<Map<String, String>>) request.getAttribute("timetableList");
        if (timetableList != null && !timetableList.isEmpty()) {
    %>

    <table class="table table-bordered text-center">
        <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Exam Name</th>
            <th>Subject</th>
            <th>Date</th>
            <th>Session</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <% for (Map<String, String> row : timetableList) { %>
        <tr>
            <td><%= row.get("id") %></td>
            <td><%= row.get("exam_name") %></td>
            <td><%= row.get("subject_name") %></td>
            <td><%= row.get("exam_date") %></td>
            <td><%= row.get("session") %></td>
            <td>
                <form action="RemoveTimetableServlet" method="post">
                    <input type="hidden" name="timetable_id" value="<%= row.get("id") %>">
                    <input type="hidden" name="allocated" value="<%= row.get("allocated") %>">
                    <button type="submit" class="btn btn-purple">Remove</button>
                </form>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <% } else { %>
    <div class="alert alert-warning text-center">No timetables found.</div>
    <% } %>
</div>

</body>
</html>
