package com.example.examhallseatallocationsystem;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/RemoveTimetableServlet")
public class RemoveTimetableServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int timetableId = Integer.parseInt(request.getParameter("timetable_id"));
        int allocated = Integer.parseInt(request.getParameter("allocated"));

        if (allocated == 1) {
            RequestDispatcher rd = request.getRequestDispatcher("errorRemoveTT.jsp");
            rd.forward(request, response);
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            PreparedStatement ps = conn.prepareStatement("DELETE FROM timetable WHERE id = ?");
            ps.setInt(1, timetableId);
            ps.executeUpdate();

            conn.close();
            RequestDispatcher rd = request.getRequestDispatcher("successRemoveTT.jsp");
            rd.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("Error occurred while removing timetable.");
        }
    }
}
