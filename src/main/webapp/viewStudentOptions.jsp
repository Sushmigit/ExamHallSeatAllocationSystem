<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>View Student Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome CDN -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        body {
            margin: 0;
            height: 100vh;
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            flex-direction: column;
        }

        .options {
            display: flex;
            gap: 40px;
        }

        .card-box {
            background: white;
            padding: 30px;
            border-radius: 15px;
            width: 280px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }

        .card-box:hover {
            transform: scale(1.05);
        }

        .card-box h5 {
            color: #5e2784;
            margin-bottom: 20px;
        }

        .card-box .btn {
            border: 1px solid #5e2784;
            color: #5e2784;
        }

        .card-box .btn:hover {
            background-color: #5e2784;
            color: white;
        }

        h2 {
            color: #5e2784;
            margin-bottom: 40px;
        }

        footer {
            position: absolute;
            bottom: 15px;
            font-size: 14px;
            color: #5e2784;
        }

        .icon {
            font-size: 30px;
            margin-bottom: 15px;
            color: #5e2784;
        }
    </style>
</head>
<body>

<h2>View Student Details</h2>

<div class="options">
    <div class="card-box">
        <div class="icon"><i class="fas fa-user-graduate"></i></div>
        <h5>View All Students</h5>
        <form action="viewStudentDetails.jsp" method="get">
            <input type="hidden" name="type" value="all">
            <button type="submit" class="btn">Go to View All Students</button>
        </form>
    </div>

    <div class="card-box">
        <div class="icon"><i class="fas fa-clipboard-check"></i></div>
        <h5>View Allocated Students</h5>
        <form action="viewStudentDetails.jsp" method="get">
            <input type="hidden" name="type" value="allocated">
            <button type="submit" class="btn">Go to Allocated Students</button>
        </form>
    </div>
</div>

<footer>© 2025 Exam Seating System | Student Management Functionalities</footer>

</body>
</html>
