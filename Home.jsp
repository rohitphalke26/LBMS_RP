<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    // Check if user is logged in
    String adminUser = (String) session.getAttribute("adminUser");

    // If session is null, redirect to login page
    if (adminUser == null) {
        response.sendRedirect("AdminLogin.jsp?error=Please+login+first!");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Library Dashboard</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f5f5f5;
            height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .header {
            background-color: black;
            color: rgb(249, 249, 245);
            padding: 15px;
            font-size: 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .logo-container {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .logo-container img {
            height: 40px;
            width: auto;
        }
        .container {
            display: flex;
            flex-grow: 1;
            height: calc(100vh - 50px);
        }
        .sidebar {
            background: linear-gradient(to bottom, #ffcc00, #ff9900);
            padding: 20px;
            width: 250px;
            display: flex;
            flex-direction: column;
            justify-content: space-evenly;
            height: 100%;
        }
        .sidebar button {
            width: 100%;
            padding: 15px;
            margin: 5px 0;
            background-color: #333;
            color: white;
            border: none;
            cursor: pointer;
            font-size: 18px;
            border-radius: 5px;
            transition: background 0.3s;
        }
        .sidebar button:hover {
            background-color: #555;
        }
        .content {
            flex-grow: 1;
            background-image: url('images/10.jpeg');
            background-size: cover;
            background-position: center;
            display: flex;
            justify-content: flex-end;
            align-items: flex-start;
            padding: 20px;
            position: relative;
        }
        .footer {
            position: absolute;
            bottom: 10px;
            right: 10px;
            color: white;
            background: rgba(0, 0, 0, 0.7);
            padding: 10px 15px;
            border-radius: 5px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="header">
        <div class="logo-container">
            <img src="images/12.png" alt="Library Logo"> 
            <span> LIBRARY MANAGEMENT SYSTEM.</span>
        </div>
        <button onclick="location.href='Logout.jsp'">Logout</button>
    </div>
    <div class="container">
        <div class="sidebar">
            <button onclick="location.href='Student.jsp'">Student</button>
            <button onclick="location.href='Book.jsp'">Book</button>
            <button onclick="location.href='IssueBook.jsp'">Issue Book</button>
            <button onclick="location.href='ReturnBook.jsp'">Return Book</button>
            <button onclick="location.href='IssueDetails.jsp'">Issue Details</button>
            <button onclick="location.href='ReturnDetails.jsp'">Return Details</button>
            <button onclick="location.href='StudentDetails.jsp'">Student Details</button>
            <button onclick="location.href='BookDetails.jsp'">Book Details</button>
        </div>
        <div class="content">
            <div class="footer">Developed By: Mr. Sanket Zagade </div>
        </div>
    </div>
</body>
</html>
