<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin | Exam Seating</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: url("images/classroom.jpg") no-repeat center center fixed;
            background-size: cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }

        .overlay {
            background-color: rgba(255, 255, 255, 0.85);
            padding: 40px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.2);
        }

        h1 {
            color: #4B0082;
            margin-bottom: 20px;
        }

        p {
            font-size: 16px;
            color: #333;
        }

        .login-btn {
            margin-top: 20px;
            padding: 10px 20px;
            background-color: white;
            color: #4B0082;
            border: 2px solid #4B0082;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: 0.3s ease;
        }

        .login-btn:hover {
            background-color: #4B0082;
            color: white;
        }
    </style>
</head>
<body>
<div class="overlay">
    <h1>ExamHall Seating Arrangement System</h1>
    <h2>Welcome, Admin!</h2>
    <p>Manage your exam seating arrangements, student details, venues,<br/> and invigilators efficiently from the dashboard.</p>
    <form action="admin_login.jsp">
        <button type="submit" class="login-btn">Go to Login</button>
    </form>
</div>
</body>
</html>
