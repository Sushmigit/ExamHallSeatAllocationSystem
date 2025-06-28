<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(to bottom, #f5ebff, #e5d8ff);
            color: #4B0082;
        }

        h1 {
            text-align: center;
            padding: 30px;
            font-size: 2em;
        }

        .dashboard {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 40px;
            padding: 30px 60px;
            justify-items: center;
        }

        .card {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            text-align: center;
            padding: 20px;
            width: 250px;
            transition: transform 0.3s ease;
        }

        .card:hover {
            transform: scale(1.05);
        }

        .card img {
            border-radius: 50%;
            width: 150px;
            height: 150px;
            border: 3px solid #4B0082;
            object-fit: cover;
        }

        .card p {
            margin-top: 15px;
            font-weight: bold;
            color: #4B0082;
        }

        .card a {
            text-decoration: none;
            color: inherit;
        }

        @media (max-width: 768px) {
            .dashboard {
                grid-template-columns: 1fr; /* One card per row on small screens */
            }
        }
    </style>
</head>
<body>

<h1>Welcome to the Admin Dashboard</h1>

<div class="dashboard">
    <div class="card">
        <a href="timetablemanagement.jsp">
            <img src="images/exam.jpg" alt="Timetable and Seat Allocation" />
            <p>Timetable and Seat Allocation</p>
        </a>
    </div>

    <div class="card">
        <a href="studentmanagement.jsp">
            <img src="images/students.jpg" alt="Student Management" />
            <p>Student Management</p>
        </a>
    </div>

    <div class="card">
        <a href="venuemanagement.jsp">
            <img src="images/venue.png" alt="Venue Management" />
            <p>Venue Management</p>
        </a>
    </div>

    <div class="card">
        <a href="invigilatormanagement.jsp">
            <img src="images/invigilators.jpg" alt="Invigilator Management" />
            <p>Invigilator Management</p>
        </a>
    </div>
</div>

</body>
</html>
