package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/InsertInvigilatorServlet")
public class InsertInvigilatorServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Replace with your DB credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/examhallseatprj";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "123Sushmi@123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String department = request.getParameter("department");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO invigilator (name, department) VALUES (?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, department);

            int result = stmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("addinvigilatorsuccess.jsp");
            } else {
                response.setContentType("text/html");
                response.getWriter().println("<h3 style='color:red;'>Failed to insert invigilator!</h3>");
            }

        } catch (Exception e) {
            response.setContentType("text/html");
            response.getWriter().println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception ex) {
                ex.printStackTrace();
            }
        }
    }
}
