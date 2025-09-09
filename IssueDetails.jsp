<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Check if user is logged in
    String adminUser = (String) session.getAttribute("adminUser");

    // If session is null, redirect to login page
    if (adminUser == null) {
        response.sendRedirect("AdminLogin.jsp?error=Please+login+first!");
        return;
    }
%>
<html>
<head>
    <title>Issue Book Details</title>
    <style>
        /* Background Styling */
        body {
            font-family: Arial, sans-serif;
            background: url('images/01.jpg') no-repeat center center fixed;
            background-size: cover;
            text-align: center;
            opacity: 0;
            animation: fadeIn 1s forwards;
        }

        /* Fade-in Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Main Container */
        .container {
            width: 80%;
            margin: auto;
            background: rgba(0, 0, 0, 0.8);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 0px 20px rgba(255, 165, 0, 0.6);
            color: white;
            animation: slideIn 1s ease-in-out;
        }

        /* Slide-in Animation */
        @keyframes slideIn {
            from { transform: scale(0.9); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        /* Search Box */
        input[type="text"] {
            width: 50%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        /* Buttons */
        button {
            background-color: #ffcc00;
            color: black;
            font-weight: bold;
            cursor: pointer;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            transition: all 0.3s ease-in-out;
        }

        button:hover {
            background-color: #e6b800;
            transform: scale(1.05);
        }

        /* Table Styling */
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.9);
            color: black;
            border-radius: 10px;
            overflow: hidden;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 12px;
            text-align: center;
        }

        th {
            background-color: #ffcc00;
            color: black;
        }

        /* Error Message */
        .error-message {
            color: #ff4d4d;
            font-weight: bold;
            margin-top: 10px;
        }

        /* Back Button */
        .home-btn {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            background-color: #ffcc00;
            color: black;
            padding: 12px 20px;
            border-radius: 5px;
            font-size: 16px;
            transition: all 0.3s ease-in-out;
        }

        .home-btn:hover {
            background-color: #e6b800;
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Issue Book Details</h2>
        
        <!-- Search Form -->
        <form method="post">
            <input type="text" name="search_query" placeholder="Enter Student Name or Card No">
            <button type="submit" name="search">Search</button>
        </form>

        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");

                String searchQuery = request.getParameter("search_query");
                String query = "SELECT * FROM issue_details";

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    query += " WHERE s_name LIKE ? OR s_rollno LIKE ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, "%" + searchQuery + "%");
                    ps.setString(2, "%" + searchQuery + "%");
                } else {
                    ps = con.prepareStatement(query);
                }

                rs = ps.executeQuery();

                if (!rs.isBeforeFirst()) { // If no records found
                    out.println("<p class='error-message'>No records found.</p>");
                } else {
                    out.println("<table>");
                    out.println("<tr><th>Student Name</th><th>Card No</th><th>Class</th><th>Book Name</th><th>Book ID</th><th>Issue Date</th></tr>");

                    while (rs.next()) {
                        String sName = rs.getString("s_name");
                        if (sName == null || sName.isEmpty()) {
                            sName = "<span class='error-message'>Missing Data</span>";
                        }

                        out.println("<tr>");
                        out.println("<td>" + sName + "</td>");
                        out.println("<td>" + rs.getString("s_rollno") + "</td>");
                        out.println("<td>" + rs.getString("s_class") + "</td>");
                        out.println("<td>" + rs.getString("book_name") + "</td>");
                        out.println("<td>" + rs.getString("b_id") + "</td>");
                        out.println("<td>" + rs.getString("issue_date") + "</td>");
                        out.println("</tr>");
                    }

                    out.println("</table>");
                }
            } catch (Exception e) {
                out.println("<p class='error-message'>Error: " + e.getMessage() + "</p>");
            } finally {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            }
        %>

        <a href="Home.jsp" class="home-btn">Back to Home</a>
    </div>
</body>
</html>
