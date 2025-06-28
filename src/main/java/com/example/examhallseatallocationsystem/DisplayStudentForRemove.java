package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DisplayStudentForRemove")
public class DisplayStudentForRemove extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dept = request.getParameter("dept");
        String sem = request.getParameter("sem");
        String sub = request.getParameter("sub");

        List<Map<String, String>> studentList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT * FROM student WHERE department = ? AND semester = ? AND subject_enrolled = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, dept);
            stmt.setString(2, sem);
            stmt.setString(3, sub);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", String.valueOf(rs.getInt("id"))); // assuming primary key
                row.put("name", rs.getString("name"));
                row.put("regno", rs.getString("reg_no"));
                row.put("semester", rs.getString("semester"));
                row.put("subject", rs.getString("subject_enrolled"));
                row.put("allocated", rs.getString("allocated")); // important
                studentList.add(row);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("studentList", studentList);
        request.getRequestDispatcher("displayStudentForRemove.jsp").forward(request, response);
    }
}
