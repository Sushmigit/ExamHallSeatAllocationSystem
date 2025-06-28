<%@ page import="java.sql.*" %>
<%
    String exam_name = request.getParameter("exam_name");
    String subject_name = request.getParameter("subject_name");
    String department = request.getParameter("department");
    String semester = request.getParameter("semester");
    String exam_date = request.getParameter("exam_date");
    String sess = request.getParameter("session");

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/your_db_name", "your_username", "your_password");

        String sql = "INSERT INTO timetable (exam_name, subject_name, department, semester, exam_date, session) VALUES (?, ?, ?, ?, ?, ?)";
        stmt = conn.prepareStatement(sql);
        stmt.setString(1, exam_name);
        stmt.setString(2, subject_name);
        stmt.setString(3, department);
        stmt.setString(4, semester);
        stmt.setString(5, exam_date);
        stmt.setString(6, sess);

        int rows = stmt.executeUpdate();
        if (rows > 0) {
            response.sendRedirect("insertSuccess.jsp");
        } else {
            out.println("<h3 style='color:red;'>Failed to insert timetable!</h3>");
        }
    } catch (Exception e) {
        out.println("<h3 style='color:red;'>Error: " + e.getMessage() + "</h3>");
    } finally {
        if (stmt != null) try { stmt.close(); } catch (Exception e) {}
        if (conn != null) try { conn.close(); } catch (Exception e) {}
    }
%>
