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

@WebServlet("/InsertTimetableServlet")
public class InsertTimetableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Change these as per your MySQL setup
    private static final String DB_URL = "jdbc:mysql://localhost:3306/examhallseatprj";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "123Sushmi@123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String examName = request.getParameter("exam_name");
        String subjectName = request.getParameter("subject_name");
        String department = request.getParameter("department");
        String semester = request.getParameter("semester");
        String examDate = request.getParameter("exam_date");
        String session = request.getParameter("session");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO timetable (exam_name, subject_name, department, semester, exam_date, session) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, examName);
            stmt.setString(2, subjectName);
            stmt.setString(3, department);
            stmt.setString(4, semester);
            stmt.setString(5, examDate);
            stmt.setString(6, session);

            int result = stmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("inserttimetablesuccess.jsp");
            } else {
                response.setContentType("text/html");
                response.getWriter().println("<h3 style='color:red;'>Failed to insert timetable!</h3>");
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
