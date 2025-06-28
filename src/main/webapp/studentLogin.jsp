<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String message = "";
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String uname = request.getParameter("username");
        String pwd = request.getParameter("password");

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

        PreparedStatement ps = conn.prepareStatement("SELECT * FROM student_login WHERE username=? AND password=?");
        ps.setString(1, uname);
        ps.setString(2, pwd);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            session.setAttribute("studentUser", uname);
            response.sendRedirect("studentDetailsForm.jsp");
            return;
        } else {
            message = "Invalid credentials.";
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Login</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body { background-color: #f9f6fc; }
        .card { background: white; border-radius: 10px; box-shadow: 0 0 10px #ccc; }
        .btn-purple { background-color: #6f42c1; color: white; }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">
<div class="card p-4" style="width: 400px;">
    <h4 class="text-center mb-3 text-purple">Student Login</h4>
    <form method="post">
        <input type="text" name="username" class="form-control mb-3" placeholder="Username" required />
        <input type="password" name="password" class="form-control mb-3" placeholder="Password" required />
        <button class="btn btn-purple w-100">Login</button>
    </form>
    <% if (!message.isEmpty()) { %>
    <div class="alert alert-danger mt-3"><%= message %></div>
    <% } %>
</div>
</body>
</html>
