<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable Reallocation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .success-box {
            background-color: white;
            border-radius: 15px;
            padding: 40px;
            text-align: center;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            max-width: 500px;
            width: 100%;
        }

        .success-box h2 {
            color: #5e2784;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .btn-purple {
            background-color: transparent;
            border: 1px solid #5e2784;
            color: #5e2784;
            transition: 0.3s;
            padding: 10px 25px;
            margin-top: 15px;
        }

        .btn-purple:hover {
            background-color: #5e2784;
            color: white;
        }
    </style>
</head>
<body>

<div class="success-box">
    <h2>Timetable is  Reallocated Successfully!</h2>
    <a href="timetablemanagement.jsp" class="btn btn-purple">Go to Timetable Management</a>
</div>

</body>
</html>
