package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/RemoveStudentServlet")
public class RemoveStudentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int studentId = Integer.parseInt(request.getParameter("student_id"));
        int allocated = Integer.parseInt(request.getParameter("allocated"));

        if (allocated == 1) {
            response.sendRedirect("removeStudentError.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123"
            );

            PreparedStatement ps = conn.prepareStatement("DELETE FROM student WHERE id = ?");
            ps.setInt(1, studentId);
            ps.executeUpdate();

            conn.close();
            response.sendRedirect("removeStudentSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
