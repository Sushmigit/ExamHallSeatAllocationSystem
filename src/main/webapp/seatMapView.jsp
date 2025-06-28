<%@ page import="java.util.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Seat Allocation View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        html, body {
            height: 100%;
            margin: 0;
            background: linear-gradient(to bottom, #f3e7fe, #d1bfff);
            font-family: 'Segoe UI', sans-serif;
        }
        .container {
            max-width: 1000px;
            margin: 40px auto;
            background-color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .seat-grid {
            display: grid;
            grid-template-columns: repeat(10, 40px);
            gap: 10px;
            justify-content: center;
            margin-top: 20px;
        }
        .seat {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
        }
        .red { background-color: red; }
        .green { background-color: green; }
    </style>
</head>
<body>

<div class="container">
    <h4 class="text-center">Seat Allocation for Venue: <%= request.getAttribute("venue") %>, Room: <%= request.getAttribute("room") %></h4>

    <div class="text-center mt-3">
        <span class="badge bg-danger">Unallocated</span>
        <span class="badge bg-success ms-3">Allocated</span>
    </div>

    <h6 class="text-center mt-4">Hover on seats to view details</h6>

    <div class="seat-grid">
        <%
            List<Boolean> seatStatus = (List<Boolean>) request.getAttribute("seatStatus");
            List<Map<String, String>> students = (List<Map<String, String>>) request.getAttribute("students");
            Map<String, String> exam = (Map<String, String>) request.getAttribute("exam");

            // Map seat_no (like "S1") to student
            Map<String, Map<String, String>> seatToStudent = new HashMap<>();
            for (Map<String, String> s : students) {
                seatToStudent.put(s.get("seat_no"), s);
            }

            for (int i = 0; i < seatStatus.size(); i++) {
                String seatId = "S" + (i + 1);
                boolean allocated = seatStatus.get(i);
                String tooltip = "Seat Unallocated";

                if (allocated && seatToStudent.containsKey(seatId)) {
                    Map<String, String> s = seatToStudent.get(seatId);
                    tooltip = "Seat No: " + s.get("seat_no") +
                            "\nName: " + s.get("name") +
                            "\nReg No: " + s.get("regno");
                    if (exam != null && !exam.isEmpty()) {
                        tooltip += "\nExam: " + exam.get("exam_name") +
                                "\nDate: " + exam.get("exam_date") +
                                "\nSession: " + exam.get("session");
                    }
                }
        %>
        <div class="seat <%= allocated ? "green" : "red" %>"
             data-bs-toggle="tooltip"
             data-bs-placement="top"
             title="<%= tooltip.replace("\"", "&quot;").replace("\n", "&#10;") %>">
        </div>
        <% } %>
    </div>
</div>

<script>
    // Enable all Bootstrap tooltips
    document.addEventListener("DOMContentLoaded", function () {
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl)
        });
    });
</script>

</body>
</html>
