package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/RemoveVenueServlet")
public class RemoveVenueServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int venueId = Integer.parseInt(request.getParameter("venue_id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            // Step 1: Check if venue is allocated
            PreparedStatement checkStmt = conn.prepareStatement("SELECT allocated FROM venue WHERE id = ?");
            checkStmt.setInt(1, venueId);
            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                boolean allocated = rs.getBoolean("allocated");
                if (allocated) {
                    conn.close();
                    request.getRequestDispatcher("removeVenueError.jsp").forward(request, response);
                    return;
                }
            }

            // Step 2: Delete venue
            PreparedStatement deleteStmt = conn.prepareStatement("DELETE FROM venue WHERE id = ?");
            deleteStmt.setInt(1, venueId);
            deleteStmt.executeUpdate();

            conn.close();
            request.getRequestDispatcher("removeVenueSuccess.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
