<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Students</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        html, body {
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            height : 100%;
        }
        .container {
            margin-top: 60px;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            color: #5e2784;
            text-align: center;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Student Management - Remove Students</h2>
    <table class="table table-bordered text-center">
        <thead class="table-light">
        <tr>
            <th>Name</th>
            <th>Reg No</th>
            <th>Semester</th>
            <th>Subject</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Map<String, String>> studentList = (List<Map<String, String>>) request.getAttribute("studentList");
            if (studentList != null && !studentList.isEmpty()) {
                for (Map<String, String> s : studentList) {
        %>
        <tr>
            <td><%= s.get("name") %></td>
            <td><%= s.get("regno") %></td>
            <td><%= s.get("semester") %></td>
            <td><%= s.get("subject") %></td>
            <td><%= "1".equals(s.get("allocated")) ? "Allocated" : "Unallocated" %></td>
            <td>
                <form action="RemoveStudentServlet" method="post">
                    <input type="hidden" name="student_id" value="<%= s.get("id") %>"/>
                    <input type="hidden" name="allocated" value="<%= s.get("allocated") %>"/>
                    <button type="submit" class="btn btn-danger">Remove</button>
                </form>
            </td>
        </tr>
        <%
            }
        } else {
        %>
        <tr><td colspan="6" class="text-danger">No students found.</td></tr>
        <% } %>
        </tbody>
    </table>
</div>
</body>
</html>
