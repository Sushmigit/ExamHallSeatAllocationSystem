package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DisplayRemoveTT")
public class DisplayRemoveTT extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dept = request.getParameter("dept");
        String sem = request.getParameter("sem");

        List<Map<String, String>> timetableList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT * FROM timetable WHERE department = ? AND semester = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, dept);
            stmt.setString(2, sem);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("id", rs.getString("id"));
                row.put("exam_name", rs.getString("exam_name"));
                row.put("subject_name", rs.getString("subject_name"));
                row.put("exam_date", rs.getString("exam_date"));
                row.put("session", rs.getString("session"));
                row.put("allocated", rs.getString("allocated"));
                timetableList.add(row);
            }

            request.setAttribute("timetableList", timetableList);
            RequestDispatcher rd = request.getRequestDispatcher("displayForRemoveTT.jsp");
            rd.forward(request, response);
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
