package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/InsertStudentServlet")
public class InsertStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Update with your DB credentials
    private static final String DB_URL = "jdbc:mysql://localhost:3306/examhallseatprj";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "123Sushmi@123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String regNo = request.getParameter("reg_no");
        String department = request.getParameter("department");
        String semester = request.getParameter("semester");
        String subjectEnrolled = request.getParameter("subject_enrolled");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO student (name, reg_no, department, semester, subject_enrolled) VALUES (?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, name);
            stmt.setString(2, regNo);
            stmt.setString(3, department);
            stmt.setString(4, semester);
            stmt.setString(5, subjectEnrolled);

            int result = stmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("addstudentsuccess.jsp");
            } else {
                response.setContentType("text/html");
                response.getWriter().println("<h3 style='color:red;'>Failed to insert student record!</h3>");
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
