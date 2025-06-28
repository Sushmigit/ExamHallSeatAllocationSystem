package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/ShowInvigilatorForRemove")
public class ShowInvigilatorForRemove extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Map<String, String>> invList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123"
            );

            PreparedStatement ps = conn.prepareStatement("SELECT * FROM invigilator");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> inv = new HashMap<>();
                inv.put("id", String.valueOf(rs.getInt("id")));
                inv.put("name", rs.getString("name"));
                inv.put("department", rs.getString("department"));
                inv.put("allocated", rs.getString("allocated")); // make sure 'allocated' column exists
                invList.add(inv);
            }

            rs.close();
            ps.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("invList", invList);
        RequestDispatcher rd = request.getRequestDispatcher("removeInvigilator.jsp");
        rd.forward(request, response);
    }
}
