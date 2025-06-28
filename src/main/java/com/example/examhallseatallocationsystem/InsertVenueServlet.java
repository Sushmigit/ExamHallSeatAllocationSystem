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

@WebServlet("/InsertVenueServlet")
public class InsertVenueServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Replace with your actual DB details
    private static final String DB_URL = "jdbc:mysql://localhost:3306/examhallseatprj";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "123Sushmi@123";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String venueName = request.getParameter("venue_name");
        String roomNo = request.getParameter("room_no");
        String totalSeatsStr = request.getParameter("total_seats");

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            int totalSeats = Integer.parseInt(totalSeatsStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);

            String sql = "INSERT INTO venue (venue_name, room_no, total_seats) VALUES (?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, venueName);
            stmt.setString(2, roomNo);
            stmt.setInt(3, totalSeats);

            int result = stmt.executeUpdate();

            if (result > 0) {
                response.sendRedirect("addvenuesuccess.jsp");
            } else {
                response.setContentType("text/html");
                response.getWriter().println("<h3 style='color:red;'>Failed to insert venue!</h3>");
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
