package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/DisplayUnallocatedVenues")
public class DisplayUnallocatedVenues extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> venueList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123"
            );

            String sql = "SELECT venue_name, room_no, total_seats FROM venue WHERE allocated = 0";

            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("venue_name", rs.getString("venue_name"));
                row.put("room_no", rs.getString("room_no"));
                row.put("seats_allocated", "0");
                row.put("seats_available", rs.getString("total_seats")); // total seats = available here
                row.put("invigilator", "Not Assigned");
                venueList.add(row);
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("venueList", venueList);
        request.setAttribute("title", "Available (Unallocated) Venues");
        request.getRequestDispatcher("displayVenueList.jsp").forward(request, response);
    }
}
