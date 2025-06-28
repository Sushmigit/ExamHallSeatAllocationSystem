package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/DisplayCompletelyAllocatedVenues")
public class DisplayCompletelyAllocatedVenues extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> venueList = new ArrayList<>();
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT va.venue_id, va.seats_allocated, va.seats_available, va.invigilator, v.venue_name, v.room_no " +
                    "FROM venue_allocation va JOIN venue v ON va.venue_id = v.id " +
                    "WHERE va.seats_available = 0";

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("venue_name", rs.getString("venue_name"));
                row.put("room_no", rs.getString("room_no"));
                row.put("seats_allocated", rs.getString("seats_allocated"));
                row.put("seats_available", rs.getString("seats_available"));
                row.put("invigilator", rs.getString("invigilator"));
                venueList.add(row);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("venueList", venueList);
        request.setAttribute("title", "Completely Allocated Venues");
        request.getRequestDispatcher("displayVenueList.jsp").forward(request, response);
    }
}
