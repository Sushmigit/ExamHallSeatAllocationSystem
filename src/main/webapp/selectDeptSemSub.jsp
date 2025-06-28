<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Select Department & Semester</title>
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
        <h2>Select Department and Semester</h2>
        <form action="DisplayStudentForRemove" method="get">
            <div class="mb-3">
                <label class="form-label">Department</label>
                <select name="dept" class="form-select" required>
                    <option value="" disabled selected>Select Department</option>
                    <option value="CSE">Computer Science Engineering</option>
                    <option value="ECE">Electronics & Communication</option>
                    <option value="EEE">Electrical Engineering</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Semester</label>
                <select name="sem" class="form-select" required>
                    <option value="" disabled selected>Select Semester</option>
                    <option value="1">1st Semester</option>
                    <option value="2">2nd Semester</option>
                    <option value="3">3rd Semester</option>
                    <option value="4">4th Semester</option>
                    <option value="5">5th Semester</option>
                    <option value="6">6th Semester</option>
                    <option value="7">7th Semester</option>
                    <option value="8">8th Semester</option>
                </select>
            </div>
            <div class="mb-3">
                <label class="form-label">Subject</label>
                <input type="text" class="form-control" name="sub" placeholder="Enter Subject" required />
            </div>
            <button type="submit" class="btn btn-purple w-100">Submit</button>
        </form>
    </div>
</div>

</body>
</html>
