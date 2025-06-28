package com.example.examhallseatallocationsystem;

import java.io.IOException;
import java.sql.*;
import java.util.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DisplayUnallocatedInv")
public class DisplayUnallocatedInv extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        List<Map<String, String>> unallocatedList = new ArrayList<>();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            String sql = "SELECT * FROM invigilator WHERE allocated = 0";
            PreparedStatement stmt = conn.prepareStatement(sql);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Map<String, String> row = new HashMap<>();
                row.put("invigilator", rs.getString("name"));
                row.put("department", rs.getString("department"));
                unallocatedList.add(row);
            }

            rs.close();
            stmt.close();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("invList", unallocatedList);
        request.setAttribute("type", "unallocated");
        RequestDispatcher rd = request.getRequestDispatcher("displayallunallinv.jsp");
        rd.forward(request, response);
    }
}
