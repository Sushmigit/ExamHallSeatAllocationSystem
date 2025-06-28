package com.example.examhallseatallocationsystem;



import java.io.IOException;
import java.sql.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/DeallocateServlet")
public class DeallocateServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int timetableId = Integer.parseInt(request.getParameter("timetable_id"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

            // 1. Move student allocations to student_deallocation
            PreparedStatement ps1 = conn.prepareStatement("SELECT * FROM student_allocation WHERE timetable_id=?");
            ps1.setInt(1, timetableId);
            ResultSet rs1 = ps1.executeQuery();
            while (rs1.next()) {
                PreparedStatement insert = conn.prepareStatement(
                        "INSERT INTO student_deallocation (student_id, timetable_id, venue_id, seat_no, invigilator_name) VALUES (?, ?, ?, ?, ?)");
                insert.setInt(1, rs1.getInt("student_id"));
                insert.setInt(2, rs1.getInt("timetable_id"));
                insert.setInt(3, rs1.getInt("venue_id"));
                insert.setString(4, rs1.getString("seat_no"));
                insert.setString(5, rs1.getString("invigilator_name"));
                insert.executeUpdate();

                // Update allocated=0 in student table
                PreparedStatement upd = conn.prepareStatement("UPDATE student SET allocated=0 WHERE id=?");
                upd.setInt(1, rs1.getInt("student_id"));
                upd.executeUpdate();
            }

            // Delete from student_allocation
            PreparedStatement del1 = conn.prepareStatement("DELETE FROM student_allocation WHERE timetable_id=?");
            del1.setInt(1, timetableId);
            del1.executeUpdate();

            // 2. Move timetable allocation
            PreparedStatement ps2 = conn.prepareStatement("SELECT * FROM timetable_allocation WHERE timetable_id=?");
            ps2.setInt(1, timetableId);
            ResultSet rs2 = ps2.executeQuery();
            while (rs2.next()) {
                PreparedStatement insert = conn.prepareStatement(
                        "INSERT INTO timetable_deallocation (timetable_id, venue_id, seats_allocated, invigilator) VALUES (?, ?, ?, ?)");
                insert.setInt(1, rs2.getInt("timetable_id"));
                insert.setInt(2, rs2.getInt("venue_id"));
                insert.setInt(3, rs2.getInt("seats_allocated"));
                insert.setString(4, rs2.getString("invigilator"));
                insert.executeUpdate();
            }

            PreparedStatement del2 = conn.prepareStatement("DELETE FROM timetable_allocation WHERE timetable_id=?");
            del2.setInt(1, timetableId);
            del2.executeUpdate();

            // Update allocated = 0 in timetable table
            PreparedStatement updateTimetable = conn.prepareStatement("UPDATE timetable SET allocated=0 WHERE id=?");
            updateTimetable.setInt(1, timetableId);
            updateTimetable.executeUpdate();

            // 3. Update venue_allocation
            PreparedStatement ps3 = conn.prepareStatement("SELECT * FROM venue_allocation WHERE timetable_id=?");
            ps3.setInt(1, timetableId);
            ResultSet rs3 = ps3.executeQuery();
            while (rs3.next()) {
                int venueId = rs3.getInt("venue_id");
                int seatsAllocated = rs3.getInt("seats_allocated");

                // Count students deallocated for this venue
                PreparedStatement count = conn.prepareStatement(
                        "SELECT COUNT(*) FROM student_deallocation WHERE timetable_id=? AND venue_id=?");
                count.setInt(1, timetableId);
                count.setInt(2, venueId);
                ResultSet crs = count.executeQuery();
                crs.next();
                int studentsRemoved = crs.getInt(1);

                int newSeatsAllocated = seatsAllocated - studentsRemoved;
                int newSeatsAvailable = rs3.getInt("seats_available") + studentsRemoved;

                if (newSeatsAllocated == 0) {
                    // Move to venue_deallocation
                    PreparedStatement insert = conn.prepareStatement(
                            "INSERT INTO venue_deallocation (venue_id, timetable_id, invigilator, seats_allocated, seats_available) VALUES (?, ?, ?, ?, ?)");
                    insert.setInt(1, venueId);
                    insert.setInt(2, timetableId);
                    insert.setString(3, rs3.getString("invigilator"));
                    insert.setInt(4, seatsAllocated);
                    insert.setInt(5, rs3.getInt("seats_available"));
                    insert.executeUpdate();

                    // Delete from venue_allocation
                    PreparedStatement del = conn.prepareStatement("DELETE FROM venue_allocation WHERE id=?");
                    del.setInt(1, rs3.getInt("id"));
                    del.executeUpdate();

                    // Also remove invigilator if no more entries for this venue
                    PreparedStatement checkInvig = conn.prepareStatement(
                            "SELECT COUNT(*) FROM venue_allocation WHERE venue_id=?");
                    checkInvig.setInt(1, venueId);
                    ResultSet checkRs = checkInvig.executeQuery();
                    checkRs.next();
                    if (checkRs.getInt(1) == 0) {
                        PreparedStatement invigDel = conn.prepareStatement(
                                "SELECT * FROM invigilator_allocation WHERE timetable_id=? AND venue_id=?");
                        invigDel.setInt(1, timetableId);
                        invigDel.setInt(2, venueId);
                        ResultSet invigRs = invigDel.executeQuery();
                        while (invigRs.next()) {
                            int invigilatorId = invigRs.getInt("invigilator_id");

                            // Move to invigilator_deallocation
                            PreparedStatement insertInv = conn.prepareStatement(
                                    "INSERT INTO invigilator_deallocation (invigilator_id, timetable_id, venue_id) VALUES (?, ?, ?)");
                            insertInv.setInt(1, invigilatorId);
                            insertInv.setInt(2, timetableId);
                            insertInv.setInt(3, venueId);
                            insertInv.executeUpdate();

                            // Delete from invigilator_allocation
                            PreparedStatement delInv = conn.prepareStatement(
                                    "DELETE FROM invigilator_allocation WHERE invigilator_id=? AND timetable_id=? AND venue_id=?");
                            delInv.setInt(1, invigilatorId);
                            delInv.setInt(2, timetableId);
                            delInv.setInt(3, venueId);
                            delInv.executeUpdate();

                            // Update allocated=0 in invigilator table
                            PreparedStatement updateInv = conn.prepareStatement(
                                    "UPDATE invigilator SET allocated=0 WHERE id=?");
                            updateInv.setInt(1, invigilatorId);
                            updateInv.executeUpdate();
                        }
                    }
                } else {
                    // Just update venue allocation counts
                    PreparedStatement upd = conn.prepareStatement(
                            "UPDATE venue_allocation SET seats_allocated=?, seats_available=? WHERE id=?");
                    upd.setInt(1, newSeatsAllocated);
                    upd.setInt(2, newSeatsAvailable);
                    upd.setInt(3, rs3.getInt("id"));
                    upd.executeUpdate();
                }
            }

            conn.close();
            response.sendRedirect("deallocationSuccess.jsp"); // Redirect to your department-sem filter page
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}

