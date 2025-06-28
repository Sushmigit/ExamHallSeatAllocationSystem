<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Remove Venue</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <style>
        html,body {
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
    <h2>Remove Venue</h2>
    <table class="table table-bordered text-center">
        <thead class="table-light">
        <tr>
            <th>Venue Name</th>
            <th>Room No</th>
            <th>Total Seats</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM venue");

                while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("venue_name") %></td>
            <td><%= rs.getString("room_no") %></td>
            <td><%= rs.getInt("total_seats") %></td>
            <td>
                <form action="RemoveVenueServlet" method="post">
                    <input type="hidden" name="venue_id" value="<%= rs.getInt("id") %>" />
                    <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                </form>
            </td>
        </tr>
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='4' class='text-danger'>Error loading venues</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
