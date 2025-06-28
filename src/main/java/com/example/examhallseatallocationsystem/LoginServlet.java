package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    // Change DB credentials as needed
    private static final String DB_URL = "jdbc:mysql://localhost:3306/examhallseatprj";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "123Sushmi@123";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement stmt = conn.prepareStatement(
                    "SELECT * FROM users WHERE username = ? AND password = ?"
            );
            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                // Login success
                response.sendRedirect("Success.jsp");
            } else {
                // Login failed
                PrintWriter out = response.getWriter();
                out.println("<h3>Invalid username or password</h3>");
                request.getRequestDispatcher("Login.jsp").include(request, response);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace(); // Log the actual exception to console
            PrintWriter out = response.getWriter();
            out.println("<h3>Internal Error: " + e.getMessage() + "</h3>");
            // optional: out.println("<pre>" + e + "</pre>");
        }

    }
}
