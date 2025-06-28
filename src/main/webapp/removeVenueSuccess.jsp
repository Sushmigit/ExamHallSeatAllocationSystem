<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Venue Removed</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }

        .custom-alert {
            background-color: #fff;
            border-left: 6px solid #5e2784;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            text-align: center;
        }

        .custom-alert h4 {
            color: #5e2784;
            margin-bottom: 20px;
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
<div class="custom-alert">
    <h4>Venue successfully removed.</h4>
    <a href="venuemanagement.jsp" class="btn btn-purple mt-3">Back to Venue Management</a>
</div>
</body>
</html>
