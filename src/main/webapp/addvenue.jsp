<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Exam Venue</title>
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

        .form-control {
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
    <h2>Add Exam Venue</h2>
    <h4>Enter Venue Details</h4>
    <form action="InsertVenueServlet" method="post">
        <div>
            <label>Venue Name:</label>
            <input type="text" name="venue_name" class="form-control" required>
        </div>
        <div>
            <label>Room Number:</label>
            <input type="text" name="room_no" class="form-control" required>
        </div>
        <div>
            <label>Total Seats:</label>
            <input type="number" name="total_seats" class="form-control" required min="1">
        </div>

        <button type="submit" class="btn btn-purple mt-3">Add Venue</button>
    </form>
</div>

</body>
</html>
