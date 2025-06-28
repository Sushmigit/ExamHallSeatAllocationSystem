package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DisplayAllocatedTT")
public class DisplayAllocatedTT extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String dept = request.getParameter("dept");
        String sem = request.getParameter("sem");

        List<Map<String, String>> allocatedList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT t.exam_name, t.subject_name, t.exam_date, t.session, ta.seats_allocated, ta.invigilator, ta.venue_id, " +
                    "v.venue_name, v.room_no " +
                    "FROM timetable t " +
                    "JOIN timetable_allocation ta ON t.id = ta.timetable_id " +
                    "JOIN venue v ON ta.venue_id = v.id " +
                    "WHERE t.department = ? AND t.semester = ? AND t.allocated = 1";

            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, dept);
            stmt.setString(2, sem);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("exam_name", rs.getString("exam_name"));
                row.put("subject_name", rs.getString("subject_name"));
                row.put("exam_date", rs.getString("exam_date"));
                row.put("session", rs.getString("session"));
                row.put("seats_allocated", rs.getString("seats_allocated"));
                row.put("invigilator", rs.getString("invigilator"));
                row.put("venue_name", rs.getString("venue_name"));
                row.put("room_no", rs.getString("room_no"));
                allocatedList.add(row);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("dept", dept);
        request.setAttribute("sem", sem);
        request.setAttribute("examList", allocatedList);
        request.setAttribute("type", "allocated");
        RequestDispatcher rd = request.getRequestDispatcher("displayAllocatedAndUnallocatedTT.jsp");
        rd.forward(request, response);
    }
}
