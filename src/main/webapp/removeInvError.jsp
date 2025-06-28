<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cannot Remove Invigilator</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body {
            background: linear-gradient(to bottom, #ffe6e6, #f9c2c2);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: 'Segoe UI', sans-serif;
        }
    </style>
</head>
<body>
<div class="alert alert-danger text-center p-4">
    <h4>The Invigilator is currently assigned.</h4>
    <p>Please dismiss it first before removal.</p>
    <a href="invigilatormanagement.jsp" class="btn btn-danger mt-3">Back to Invigilator Management</a>
</div>
</body>
</html>
