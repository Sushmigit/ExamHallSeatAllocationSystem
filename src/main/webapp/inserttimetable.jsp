<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Insert Timetable</title>
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

        .form-select, .form-control {
            margin-top: 5px;
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
    <h2>Insert Timetable</h2>
    <h4>Enter Exam Details</h4>
    <form action="InsertTimetableServlet" method="post">
        <div>
            <label>Exam Name:</label>
            <input type="text" name="exam_name" class="form-control" required>
        </div>
        <div>
            <label>Subject Name:</label>
            <input type="text" name="subject_name" class="form-control" required>
        </div>
        <div>
            <label>Department:</label>
            <select name="department" class="form-select" required>
                <option value="">Select Department</option>
                <option value="CSE">CSE</option>
                <option value="ECE">ECE</option>
                <option value="EEE">EEE</option>
                <option value="IT">IT</option>
            </select>
        </div>
        <div>
            <label>Semester:</label>
            <select name="semester" class="form-select" required>
                <option value="">Select Semester</option>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
                <option value="4">4</option>
                <option value="5">5</option>
                <option value="6">6</option>
                <option value="7">7</option>
                <option value="8">8</option>
            </select>
        </div>
        <div>
            <label>Exam Date:</label>
            <input type="date" name="exam_date" class="form-control" required>
        </div>
        <div>
            <label>Session:</label>
            <select name="session" class="form-select" required>
                <option value="">Select Session</option>
                <option value="FN">FN</option>
                <option value="AN">AN</option>
            </select>
        </div>

        <button type="submit" class="btn btn-purple mt-3">Insert Timetable</button>
    </form>
</div>

</body>
</html>
