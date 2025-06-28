package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DisplayAllocatedInv")
public class DisplayAllocatedInv extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Map<String, String>> allocatedList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT * FROM invigilator_allocation";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                int invigilatorId = rs.getInt("invigilator_id");
                int venueId = rs.getInt("venue_id");
                int timetableId = rs.getInt("timetable_id");

                Map<String, String> row = new HashMap<>();

                // Get invigilator details
                PreparedStatement invStmt = conn.prepareStatement("SELECT name FROM invigilator WHERE id = ?");
                invStmt.setInt(1, invigilatorId);
                ResultSet invRs = invStmt.executeQuery();
                if (invRs.next()) {
                    row.put("invigilator", invRs.getString("name"));
                }
                invRs.close();
                invStmt.close();

                // Get venue details
                PreparedStatement venueStmt = conn.prepareStatement("SELECT venue_name, room_no FROM venue WHERE id = ?");
                venueStmt.setInt(1, venueId);
                ResultSet venueRs = venueStmt.executeQuery();
                if (venueRs.next()) {
                    row.put("venue_name", venueRs.getString("venue_name"));
                    row.put("room_no", venueRs.getString("room_no"));
                }
                venueRs.close();
                venueStmt.close();

                // Get timetable (exam) details
                PreparedStatement examStmt = conn.prepareStatement("SELECT exam_name, subject_name, exam_date, session FROM timetable WHERE id = ?");
                examStmt.setInt(1, timetableId);
                ResultSet examRs = examStmt.executeQuery();
                if (examRs.next()) {
                    row.put("exam_name", examRs.getString("exam_name"));
                    row.put("subject_name", examRs.getString("subject_name"));
                    row.put("exam_date", examRs.getString("exam_date"));
                    row.put("session", examRs.getString("session"));
                }
                examRs.close();
                examStmt.close();

                allocatedList.add(row);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("invList", allocatedList);
        request.setAttribute("type", "allocated");  // You can use this in JSP to show/hide headings if needed
        RequestDispatcher rd = request.getRequestDispatcher("displayallunallinv.jsp");
        rd.forward(request, response);
    }
}
