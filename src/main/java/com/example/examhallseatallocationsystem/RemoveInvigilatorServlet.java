package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;

@WebServlet("/RemoveInvigilatorServlet")
public class RemoveInvigilatorServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int invigilatorId = Integer.parseInt(request.getParameter("invigilator_id"));
        int allocated = Integer.parseInt(request.getParameter("allocated"));

        if (allocated == 1) {
            response.sendRedirect("removeInvError.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123"
            );

            PreparedStatement ps = conn.prepareStatement("DELETE FROM invigilator WHERE id = ?");
            ps.setInt(1, invigilatorId);
            ps.executeUpdate();

            ps.close();
            conn.close();

            response.sendRedirect("removeInvSuccess.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
