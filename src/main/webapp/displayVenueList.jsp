<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Venue List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
        }
        .full-height {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }
        .container {
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 900px;
        }
        h2 {
            color: #5e2784;
            text-align: center;
            margin-bottom: 30px;
        }
        .table thead {
            background-color: #f2e9fb;
        }
    </style>
</head>
<body>

<div class="full-height">
    <div class="container">
        <h2><%= request.getAttribute("title") %></h2>

        <%
            List<Map<String, String>> venues = (List<Map<String, String>>) request.getAttribute("venueList");
            if (venues != null && !venues.isEmpty()) {
        %>
        <table class="table table-bordered text-center">
            <thead class="table-light">
            <tr>
                <th>Venue Name</th>
                <th>Room No</th>
                <th>Seats Allocated</th>
                <th>Seats Available</th>
                <th>Invigilator</th>
            </tr>
            </thead>
            <tbody>
            <% for (Map<String, String> v : venues) { %>
            <tr>
                <td><%= v.get("venue_name") %></td>
                <td><%= v.get("room_no") %></td>
                <td><%= v.get("seats_allocated") %></td>
                <td><%= v.get("seats_available") %></td>
                <td><%= v.get("invigilator") %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
        <div class="alert alert-warning text-center">No venue data found.</div>
        <% } %>
    </div>
</div>

</body>
</html>
