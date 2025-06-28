package com.example.examhallseatallocationsystem;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;
import java.util.*;

@WebServlet("/AllocateServlet")
public class AllocateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int timetableId = Integer.parseInt(request.getParameter("timetable_id"));

        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            // 1. Fetch the timetable details
            PreparedStatement ts = conn.prepareStatement("SELECT * FROM timetable WHERE id=?");
            ts.setInt(1, timetableId);
            ResultSet tr = ts.executeQuery();
            if (!tr.next()) {
                response.getWriter().println("Invalid Timetable ID");
                return;
            }

            String dept = tr.getString("department");
            String sem = tr.getString("semester");
            String subject = tr.getString("subject_name");

            // 2. Get list of students not allocated yet
            PreparedStatement studentStmt = conn.prepareStatement(
                    "SELECT * FROM student WHERE department=? AND semester=? AND subject_enrolled=? AND allocated=0"
            );
            studentStmt.setString(1, dept);
            studentStmt.setString(2, sem);
            studentStmt.setString(3, subject);
            ResultSet studentRs = studentStmt.executeQuery();

            List<Integer> studentIds = new ArrayList<>();
            while (studentRs.next()) {
                studentIds.add(studentRs.getInt("id"));
            }
            studentRs.close();
            studentStmt.close();

            if (studentIds.isEmpty()) {
                response.getWriter().println("No students found for allocation.");
                return;
            }

            int studentCount = studentIds.size();
            boolean allocated = false;

            // 3. Search venue
            PreparedStatement venueStmt = conn.prepareStatement(
                    "SELECT v.id, v.total_seats, va.seats_available, va.invigilator " +
                            "FROM venue v LEFT JOIN venue_allocation va ON v.id = va.venue_id " +
                            "WHERE v.allocated = 0 OR va.seats_available IS NOT NULL " +
                            "ORDER BY v.id"
            );
            ResultSet venueRs = venueStmt.executeQuery();

            while (venueRs.next()) {
                int venueId = venueRs.getInt("id");
                int totalSeats = venueRs.getInt("total_seats");
                int availableSeats = venueRs.getInt("seats_available") == 0 ? totalSeats : venueRs.getInt("seats_available");
                String invigilatorName = venueRs.getString("invigilator");

                if (availableSeats >= studentCount) {
                    boolean isAlreadyAllocated = (invigilatorName != null);

                    // Assign invigilator if not already present
                    if (!isAlreadyAllocated) {
                        PreparedStatement invStmt = conn.prepareStatement("SELECT * FROM invigilator WHERE allocated=0 LIMIT 1");
                        ResultSet invRs = invStmt.executeQuery();
                        if (invRs.next()) {
                            invigilatorName = invRs.getString("name");
                            int invigilatorId = invRs.getInt("id");

                            PreparedStatement invAlloc = conn.prepareStatement(
                                    "INSERT INTO invigilator_allocation(invigilator_id, timetable_id, venue_id) VALUES (?, ?, ?)"
                            );
                            invAlloc.setInt(1, invigilatorId);
                            invAlloc.setInt(2, timetableId);
                            invAlloc.setInt(3, venueId);
                            invAlloc.executeUpdate();
                            invAlloc.close();

                            PreparedStatement updateInv = conn.prepareStatement("UPDATE invigilator SET allocated=1 WHERE id=?");
                            updateInv.setInt(1, invigilatorId);
                            updateInv.executeUpdate();
                            updateInv.close();
                        } else {
                            continue; // no invigilator available
                        }
                        invRs.close();
                        invStmt.close();
                    }

                    // Get already used seat numbers
                    PreparedStatement seatCheck = conn.prepareStatement(
                            "SELECT seat_no FROM student_allocation WHERE venue_id=?"
                    );
                    seatCheck.setInt(1, venueId);
                    ResultSet seatRs = seatCheck.executeQuery();
                    Set<String> usedSeats = new HashSet<>();
                    while (seatRs.next()) {
                        usedSeats.add(seatRs.getString("seat_no"));
                    }
                    seatRs.close();
                    seatCheck.close();

                    // Allocate students with unique seat numbers
                    PreparedStatement sa = conn.prepareStatement(
                            "INSERT INTO student_allocation(student_id, timetable_id, venue_id, seat_no, invigilator_name) VALUES (?, ?, ?, ?, ?)"
                    );

                    int seatNo = 1;
                    for (int sid : studentIds) {
                        String seat;
                        do {
                            seat = "S" + seatNo++;
                        } while (usedSeats.contains(seat));

                        sa.setInt(1, sid);
                        sa.setInt(2, timetableId);
                        sa.setInt(3, venueId);
                        sa.setString(4, seat);
                        sa.setString(5, invigilatorName);
                        sa.addBatch();

                        usedSeats.add(seat);
                    }
                    sa.executeBatch();
                    sa.close();

                    // Update student allocation
                    PreparedStatement updateStudents = conn.prepareStatement("UPDATE student SET allocated=1 WHERE id=?");
                    for (int sid : studentIds) {
                        updateStudents.setInt(1, sid);
                        updateStudents.addBatch();
                    }
                    updateStudents.executeBatch();
                    updateStudents.close();

                    // Update timetable
                    PreparedStatement updateT = conn.prepareStatement("UPDATE timetable SET allocated=1 WHERE id=?");
                    updateT.setInt(1, timetableId);
                    updateT.executeUpdate();
                    updateT.close();

                    // Handle venue_allocation insert/update
                    if (isAlreadyAllocated) {
                        PreparedStatement updateVA = conn.prepareStatement(
                                "UPDATE venue_allocation SET seats_allocated = seats_allocated + ?, seats_available = seats_available - ? WHERE venue_id=?"
                        );
                        updateVA.setInt(1, studentCount);
                        updateVA.setInt(2, studentCount);
                        updateVA.setInt(3, venueId);
                        updateVA.executeUpdate();
                        updateVA.close();
                    } else {
                        PreparedStatement insertVA = conn.prepareStatement(
                                "INSERT INTO venue_allocation(venue_id, timetable_id, invigilator, seats_allocated, seats_available) VALUES (?, ?, ?, ?, ?)"
                        );
                        insertVA.setInt(1, venueId);
                        insertVA.setInt(2, timetableId);
                        insertVA.setString(3, invigilatorName);
                        insertVA.setInt(4, studentCount);
                        insertVA.setInt(5, totalSeats - studentCount);
                        insertVA.executeUpdate();
                        insertVA.close();
                    }

                    // Mark venue as allocated
                    PreparedStatement updateVenue = conn.prepareStatement("UPDATE venue SET allocated=1 WHERE id=?");
                    updateVenue.setInt(1, venueId);
                    updateVenue.executeUpdate();
                    updateVenue.close();

                    // Insert timetable allocation
                    PreparedStatement ta = conn.prepareStatement(
                            "INSERT INTO timetable_allocation(timetable_id, venue_id, seats_allocated, invigilator) VALUES (?, ?, ?, ?)"
                    );
                    ta.setInt(1, timetableId);
                    ta.setInt(2, venueId);
                    ta.setInt(3, studentCount);
                    ta.setString(4, invigilatorName);
                    ta.executeUpdate();
                    ta.close();

                    allocated = true;
                    break;
                }
            }
            venueRs.close();
            venueStmt.close();

            if (allocated) {
                response.sendRedirect("allocationSuccess.jsp");
            } else {
                response.getWriter().println("No venue with enough available seats or invigilators found.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error occurred: " + e.getMessage());
        }
    }
}
