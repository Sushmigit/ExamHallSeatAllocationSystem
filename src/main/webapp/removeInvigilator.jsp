<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Remove Invigilators</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        html, body {
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            height:100%;
        }
        .container {
            margin-top: 60px;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #5e2784;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Invigilator Management - Remove Invigilators</h2>
    <table class="table table-bordered text-center">
        <thead class="table-light">
        <tr>
            <th>Name</th>
            <th>Department</th>
            <th>Status</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            List<Map<String, String>> invList = (List<Map<String, String>>) request.getAttribute("invList");
            for (Map<String, String> inv : invList) {
        %>
        <tr>
            <td><%= inv.get("name") %></td>
            <td><%= inv.get("department") %></td>
            <td><%= "1".equals(inv.get("allocated")) ? "Allocated" : "Unallocated" %></td>
            <td>
                <form action="RemoveInvigilatorServlet" method="post">
                    <input type="hidden" name="invigilator_id" value="<%= inv.get("id") %>" />
                    <input type="hidden" name="allocated" value="<%= inv.get("allocated") %>" />
                    <button type="submit" class="btn btn-danger">Remove</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
