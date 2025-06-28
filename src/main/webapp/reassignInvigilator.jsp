<%@ page import="java.sql.*, java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String message = "";
    Connection conn = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/examhallseatprj", "root", "123Sushmi@123");

        if ("POST".equalsIgnoreCase(request.getMethod()) && request.getParameter("action") != null) {
            int timetableId = Integer.parseInt(request.getParameter("timetable_id"));
            int venueId = Integer.parseInt(request.getParameter("venue_id"));
            String oldInv = request.getParameter("old_invigilator");
            String newInv = request.getParameter("new_invigilator");

            // Get new invigilator ID
            PreparedStatement getNewId = conn.prepareStatement("SELECT id FROM invigilator WHERE name=?");
            getNewId.setString(1, newInv);
            ResultSet rsNew = getNewId.executeQuery();
            int newInvId = 0;
            if (rsNew.next()) {
                newInvId = rsNew.getInt("id");
            }

            // 1. Update invigilator_allocation
            PreparedStatement updIA = conn.prepareStatement("UPDATE invigilator_allocation SET invigilator_id=? WHERE timetable_id=? AND venue_id=?");
            updIA.setInt(1, newInvId);
            updIA.setInt(2, timetableId);
            updIA.setInt(3, venueId);
            updIA.executeUpdate();

            // 2. Update invigilator status
            PreparedStatement freeOld = conn.prepareStatement("UPDATE invigilator SET allocated=0 WHERE name=?");
            freeOld.setString(1, oldInv);
            freeOld.executeUpdate();

            PreparedStatement allocNew = conn.prepareStatement("UPDATE invigilator SET allocated=1 WHERE name=?");
            allocNew.setString(1, newInv);
            allocNew.executeUpdate();

            // 3. Update timetable_allocation
            PreparedStatement updTA = conn.prepareStatement("UPDATE timetable_allocation SET invigilator=? WHERE timetable_id=? AND venue_id=?");
            updTA.setString(1, newInv);
            updTA.setInt(2, timetableId);
            updTA.setInt(3, venueId);
            updTA.executeUpdate();

            // 4. Update venue_allocation
            PreparedStatement updVA = conn.prepareStatement("UPDATE venue_allocation SET invigilator=? WHERE venue_id=? AND timetable_id=?");
            updVA.setString(1, newInv);
            updVA.setInt(2, venueId);
            updVA.setInt(3, timetableId);
            updVA.executeUpdate();

            // 5. Update student_allocation
            PreparedStatement updSA = conn.prepareStatement("UPDATE student_allocation SET invigilator_name=? WHERE timetable_id=? AND venue_id=?");
            updSA.setString(1, newInv);
            updSA.setInt(2, timetableId);
            updSA.setInt(3, venueId);
            updSA.executeUpdate();

            message = "Invigilator reassigned successfully.";
        }

        // Fetch available invigilators
        PreparedStatement avlInv = conn.prepareStatement("SELECT name FROM invigilator WHERE allocated=0");
        ResultSet rsInv = avlInv.executeQuery();
        List<String> availableInvs = new ArrayList<>();
        while (rsInv.next()) {
            availableInvs.add(rsInv.getString("name"));
        }

        // Fetch assigned invigilators
        String query = "SELECT ia.invigilator_id, i.name as invigilator_name, i.department, t.subject_name, v.venue_name, v.room_no, t.exam_date, t.session, ta.timetable_id, v.id as venue_id " +
                "FROM invigilator_allocation ia " +
                "JOIN invigilator i ON ia.invigilator_id = i.id " +
                "JOIN timetable t ON ia.timetable_id = t.id " +
                "JOIN venue v ON ia.venue_id = v.id " +
                "JOIN timetable_allocation ta ON ta.timetable_id = t.id AND ta.venue_id = v.id";
        PreparedStatement ps = conn.prepareStatement(query);
        ResultSet rs = ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reassign Invigilator</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" />
    <style>
        .header-purple { background-color: #6f42c1; color: white; }
        .rounded-table { border-radius: 10px; overflow: hidden; box-shadow: 0 0 10px #ccc; }
    </style>
</head>
<body class="p-4">
<h3 class="text-center text-uppercase">Assigned Invigilator List</h3>

<div class="table-responsive rounded-table">
    <table class="table table-bordered text-center">
        <thead class="header-purple">
        <tr>
            <th>Invigilator Name</th>
            <th>Department</th>
            <th>Subject Name</th>
            <th>Venue Name</th>
            <th>Room No</th>
            <th>Date</th>
            <th>Session</th>
            <th>Choose Invigilator</th>
            <th>Reassign</th>
        </tr>
        </thead>
        <tbody>
        <%
            while (rs.next()) {
        %>
        <tr>
            <td><%= rs.getString("invigilator_name") %></td>
            <td><%= rs.getString("department") %></td>
            <td><%= rs.getString("subject_name") %></td>
            <td><%= rs.getString("venue_name") %></td>
            <td><%= rs.getString("room_no") %></td>
            <td><%= rs.getDate("exam_date") %></td>
            <td><%= rs.getString("session") %></td>
            <td>
                <form method="post" class="d-flex gap-2 align-items-center">
                    <input type="hidden" name="action" value="reassign"/>
                    <input type="hidden" name="timetable_id" value="<%= rs.getInt("timetable_id") %>"/>
                    <input type="hidden" name="venue_id" value="<%= rs.getInt("venue_id") %>"/>
                    <input type="hidden" name="old_invigilator" value="<%= rs.getString("invigilator_name") %>"/>

                    <select name="new_invigilator" class="form-select" required>
                        <option disabled selected>Choose</option>
                        <% for (String inv : availableInvs) { %>
                        <option value="<%= inv %>"><%= inv %></option>
                        <% } %>
                    </select>

                    <button class="btn btn-danger btn-sm">Reassign</button>
                </form>
            </td>
            <td></td>
        </tr>
        <% } %>
        </tbody>
    </table>
</div>

<% if (!message.isEmpty()) { %>
<div class="alert alert-info mt-3 text-center"><%= message %></div>
<% } %>
</body>
</html>

<%
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
