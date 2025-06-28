<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%
    if (session.getAttribute("studentUser") == null) {
        response.sendRedirect("studentLogin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Enter Exam Details</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <style>
        body { background-color: #f9f6fc; }
        .btn-purple { background-color: #6f42c1; color: white; }
    </style>
</head>
<body class="d-flex justify-content-center align-items-center vh-100">
<form method="post" action="studentStatus.jsp" class="border p-4 bg-white rounded shadow" style="width: 500px;">
    <h4 class="mb-3 text-center text-purple">Enter Exam Details</h4>
    <input name="reg_no" class="form-control mb-2" placeholder="Register Number" required />
    <input name="name" class="form-control mb-2" placeholder="Name" required />
    <input name="subject" class="form-control mb-2" placeholder="Subject" required />
    <input name="exam" class="form-control mb-2" placeholder="Exam Name" required />
    <input name="dept" class="form-control mb-2" placeholder="Department" required />
    <input name="sem" class="form-control mb-2" placeholder="Semester" required />
    <button class="btn btn-purple w-100">Check Allocation</button>
</form>
</body>
</html>
