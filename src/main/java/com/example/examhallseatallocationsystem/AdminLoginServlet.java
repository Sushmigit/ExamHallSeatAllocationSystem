package com.example.examhallseatallocationsystem;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
@WebServlet("/AdminLoginServlet")
public class AdminLoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            PreparedStatement ps = con.prepareStatement("SELECT * FROM admin_login WHERE username=? AND password=?");
            ps.setString(1, uname);
            ps.setString(2, pass);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.getWriter().println("Invalid Login Credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Login failed due to internal error");
        }
    }
}
