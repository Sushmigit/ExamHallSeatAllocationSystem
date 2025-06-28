<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Timetable Management</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome (for icons) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" integrity="sha512-9usAa10IRO0HhonpyAIVpjrylPvoDwiPUiKdWk5t3PyolY1cOd4DSE0Ga+ri4AuTroPR5aQvXU9xC6qOPnzFeg==" crossorigin="anonymous" referrerpolicy="no-referrer" />

    <style>
        body {
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .dashboard {
            padding: 50px 0;
            text-align: center;
        }

        .dashboard h1 {
            color: #5e2784;
            font-weight: bold;
            margin-bottom: 40px;
        }

        .card {
            border-radius: 15px;
            padding: 30px;
            background-color: #eee1f7;
            transition: transform 0.3s;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            height: 280px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
        }

        .card:hover {
            transform: scale(1.03);
        }

        .card i {
            font-size: 60px;
            color: #5e2784;
            margin-bottom: 10px;
        }

        .btn-purple {
            background-color: transparent;
            border: 1px solid #5e2784;
            color: #5e2784;
            transition: 0.3s;
        }

        .btn-purple:hover {
            background-color: #5e2784;
            color: white;
        }
    </style>
</head>
<body>

<div class="container dashboard">
    <h1>Timetable Management</h1>
    <div class="row justify-content-center g-4">
        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card">
                <i class="fas fa-calendar-plus"></i>
                <h5>Insert Timetable</h5>
                <a href="inserttimetable.jsp" class="btn btn-purple mt-2">Go to Insert Timetable</a>
            </div>
        </div>
        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card">
                <i class="fas fa-tasks"></i>
                <h5>Allocate & Deallocate</h5>
                <a href="selectDeptSem.jsp" class="btn btn-purple mt-2">Go to Allocate & Deallocate</a>
            </div>
        </div>
        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card">
                <i class="fas fa-eye"></i>
                <h5>View Timetable</h5>
                <a href="examOptions.jsp" class="btn btn-purple mt-2">Go to View Timetable</a>
            </div>
        </div>
        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card">
                <i class="fas fa-trash-alt"></i>
                <h5>Remove Timetable</h5>
                <a href="selectDeptSemForRemoveTT.jsp" class="btn btn-purple mt-2">Go to Remove Timetable</a>
            </div>
        </div>
        <div class="col-sm-6 col-md-4 col-lg-3">
            <div class="card">
                <i class="fas fa-random"></i>
                <h5>Reallocate</h5>
                <a href="reallocateTimetable.jsp" class="btn btn-purple mt-2">Go to Reallocate</a>
            </div>
        </div>
    </div>
</div>

</body>
</html>
