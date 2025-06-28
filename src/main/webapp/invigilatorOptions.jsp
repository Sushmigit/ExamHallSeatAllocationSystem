<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Exam Allocation Options</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            margin: 0;
            height: 100vh;
            background: linear-gradient(to bottom, #e7c9f3, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .option-box {
            display: flex;
            justify-content: center;
            gap: 40px;
        }

        .card-option {
            background: white;
            border-radius: 15px;
            padding: 30px;
            text-align: center;
            width: 300px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: transform 0.3s;
        }

        .card-option:hover {
            transform: scale(1.05);
        }

        .card-option.left {
            background: #f4f0f9;
        }

        .card-option.right {
            background: #e6d4f8;
        }

        .card-option h4 {
            color: #5e2784;
            margin-top: 15px;
            margin-bottom: 20px;
        }

        .btn-outline-purple {
            color: #5e2784;
            border: 1px solid #5e2784;
            background: transparent;
            transition: 0.3s;
        }

        .btn-outline-purple:hover {
            background: #5e2784;
            color: white;
        }

        .footer-text {
            position: absolute;
            bottom: 20px;
            font-size: 14px;
            color: #5e2784;
        }

        .icon {
            font-size: 48px;
            color: #5e2784;
        }
    </style>
</head>
<body>

<div>
    <h2 class="text-center mb-5" style="color: #5e2784;">Exam Allocation Options</h2>

    <div class="option-box">
        <!-- Allocated Exams -->
        <div class="card-option left">
            <div class="icon">✔️</div>
            <h4>Allocated Invigilators</h4>
            <form action="DisplayAllocatedInv" method="get">
                <input type="hidden" name="type" value="allocated">
                <button type="submit" class="btn btn-outline-purple">Go to Allocated Invigilators</button>
            </form>
        </div>

        <!-- Unallocated Exams -->
        <div class="card-option right">
            <div class="icon">📋</div>
            <h4>Available Invigilators</h4>
            <form action="DisplayUnallocatedInv" method="get">
                <input type="hidden" name="type" value="unallocated">
                <button type="submit" class="btn btn-outline-purple">Go to Unallocated Invigilators</button>
            </form>
        </div>
    </div>

    <p class="text-center footer-text mt-5">
        © 2025 Exam Seating System | Exam Allocation Functionalities
    </p>
</div>

</body>
</html>
