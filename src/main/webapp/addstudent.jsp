<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Student</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            height: 100vh;
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .form-wrapper {
            background: white;
            border-radius: 15px;
            padding: 40px;
            width: 100%;
            max-width: 500px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #5e2784;
            font-weight: bold;
            margin-bottom: 20px;
        }

        h4 {
            text-align: center;
            color: #7a419d;
            margin-bottom: 30px;
        }

        label {
            font-weight: 500;
            color: #333;
        }

        .form-control, .form-select {
            margin-bottom: 15px;
        }

        .btn-purple {
            background-color: #5e2784;
            color: white;
            width: 100%;
            padding: 10px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            transition: 0.3s;
        }

        .btn-purple:hover {
            background-color: #4a1f68;
        }
    </style>
</head>
<body>

<div class="form-wrapper">
    <h2>Add Student</h2>
    <h4>Enter Student Details</h4>
    <form action="InsertStudentServlet" method="post">
        <label>Name:</label>
        <input type="text" name="name" class="form-control" required>

        <label>Registration Number:</label>
        <input type="text" name="reg_no" class="form-control" required>

        <label>Department:</label>
        <select name="department" class="form-select" required>
            <option value="">Select Department</option>
            <option value="CSE">CSE</option>
            <option value="ECE">ECE</option>
            <option value="EEE">EEE</option>
            <option value="IT">IT</option>
            <option value="MECH">MECH</option>
        </select>

        <label>Semester:</label>
        <select name="semester" class="form-select" required>
            <option value="">Select Semester</option>
            <% for (int i = 1; i <= 8; i++) { %>
            <option value="<%= i %>"><%= i %></option>
            <% } %>
        </select>

        <label>Subject Enrolled:</label>
        <input type="text" name="subject_enrolled" class="form-control" required>

        <button type="submit" class="btn btn-purple mt-3">Add Student</button>
    </form>
</div>

</body>
</html>
