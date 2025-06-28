package com.example.examhallseatallocationsystem;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/SeatMapViewer")
public class SeatMapViewer extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String venueName = request.getParameter("venue_name");
        String roomNo = request.getParameter("room_no");

        List<Boolean> seatStatus = new ArrayList<>();
        List<Map<String, String>> studentDetails = new ArrayList<>();
        Map<String, String> examDetails = new HashMap<>();
        int totalSeats = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            // Step 1: Fetch venue_id and total_seats
            PreparedStatement venueStmt = conn.prepareStatement("SELECT id, total_seats FROM venue WHERE venue_name = ? AND room_no = ?");
            venueStmt.setString(1, venueName);
            venueStmt.setString(2, roomNo);
            ResultSet vrs = venueStmt.executeQuery();

            if (vrs.next()) {
                int venueId = vrs.getInt("id");
                totalSeats = vrs.getInt("total_seats");

                // Initialize all seats as unallocated
                for (int i = 0; i < totalSeats; i++) {
                    seatStatus.add(false);
                }

                // Step 2: Fetch allocated seats and students
                PreparedStatement allocStmt = conn.prepareStatement(
                        "SELECT student_id, seat_no, timetable_id FROM student_allocation WHERE venue_id = ?");
                allocStmt.setInt(1, venueId);
                ResultSet ars = allocStmt.executeQuery();

                Set<Integer> seenSeats = new HashSet<>();
                int timetableId = -1;

                while (ars.next()) {
                    String seatStr = ars.getString("seat_no"); // e.g., S1
                    int seatNo = -1;

                    if (seatStr != null && seatStr.startsWith("S")) {
                        try {
                            seatNo = Integer.parseInt(seatStr.substring(1)) - 1; // Convert "S1" to 0
                        } catch (NumberFormatException e) {
                            seatNo = -1;
                        }
                    }

                    int studentId = ars.getInt("student_id");
                    timetableId = ars.getInt("timetable_id");
                    System.out.println(studentId);
                    System.out.println(timetableId);
                    if (seatNo >= 0 && seatNo < totalSeats) {
                        seatStatus.set(seatNo, true); // Mark seat as green (allocated)
                    }

                    // Fetch student details
                    PreparedStatement studentStmt = conn.prepareStatement("SELECT name, reg_no FROM student WHERE id = ?");
                    studentStmt.setInt(1, studentId);
                    ResultSet srs = studentStmt.executeQuery();

                    if (srs.next()) {
                        Map<String, String> student = new HashMap<>();
                        student.put("name", srs.getString("name"));
                        student.put("regno", srs.getString("reg_no"));
                        student.put("seat_no", seatStr); // Keep original string like "S1"
                        studentDetails.add(student);
                    }
                    srs.close();
                }
                ars.close();
                allocStmt.close();

                // Step 3: Fetch exam details using timetable_id
                if (timetableId != -1) {
                    PreparedStatement examStmt = conn.prepareStatement("SELECT exam_name, exam_date, session FROM timetable WHERE id = ?");
                    examStmt.setInt(1, timetableId);
                    ResultSet ers = examStmt.executeQuery();

                    if (ers.next()) {
                        examDetails.put("exam_name", ers.getString("exam_name"));
                        examDetails.put("exam_date", ers.getString("exam_date"));
                        examDetails.put("session", ers.getString("session"));
                    }
                    ers.close();
                    examStmt.close();
                }
            }

            vrs.close();
            venueStmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // Set attributes for JSP
        request.setAttribute("venue", venueName);
        request.setAttribute("room", roomNo);
        request.setAttribute("seatStatus", seatStatus);
        request.setAttribute("students", studentDetails);
        request.setAttribute("exam", examDetails);

        request.getRequestDispatcher("seatMapView.jsp").forward(request, response);
    }
}
