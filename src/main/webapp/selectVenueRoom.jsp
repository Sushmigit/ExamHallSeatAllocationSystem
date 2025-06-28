<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Venue & Room</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
        }

        .full-height {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .form-container {
            max-width: 500px;
            width: 100%;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        h2 {
            color: #5e2784;
            text-align: center;
            margin-bottom: 25px;
        }

        .btn-purple {
            background-color: #5e2784;
            color: white;
            border: none;
        }

        .btn-purple:hover {
            background-color: #481a66;
        }
    </style>
</head>
<body>

<div class="full-height">
    <div class="form-container">
        <h2>Select Venue and Room</h2>
        <form action="SeatMapViewer" method="get">
            <div class="mb-3">
                <label class="form-label">Venue</label>
                <input type="text" class="form-control" name="venue_name" placeholder="Enter Venue Name" required />
            </div>
            <div class="mb-3">
                <label class="form-label">Room No</label>
                <input type="text" class="form-control" name="room_no" placeholder="Enter Room Number" required />
            </div>
            <button type="submit" class="btn btn-purple w-100">View Seat Map</button>
        </form>
    </div>
</div>

</body>
</html>
