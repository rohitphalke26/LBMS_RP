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
    <title>Book Details</title>
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

          /* Delete Button */
          .delete-btn {
            background-color: #ff4d4d;
            color: white;
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease-in-out;
        }

        .delete-btn:hover {
            background-color: #cc0000;
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

        /* Success Message */
        .success-message {
            color: #4CAF50;
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
        <h2>Book Details</h2>

        <!-- Search Form -->
        <form method="post">
            <input type="text" name="search_query" placeholder="Enter Book Name or Book ID">
            <button type="submit" name="search">Search</button>
        </form>

        <%
            Connection con = null;
            PreparedStatement ps = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");

                // Handle delete request
                String deleteId = request.getParameter("delete_id");
                if (deleteId != null && deleteId.matches("\\d+")) { // Ensure it's a valid number
                    PreparedStatement deleteStmt = con.prepareStatement("DELETE FROM book_details WHERE b_id = ?");
                    deleteStmt.setInt(1, Integer.parseInt(deleteId));
                    int rowsAffected = deleteStmt.executeUpdate();
                    deleteStmt.close();

                    if (rowsAffected > 0) {
                        out.println("<p class='success-message'>Book deleted successfully.</p>");
                    } else {
                        out.println("<p class='error-message'>Error deleting book.</p>");
                    }
                }

                // Fetch books
                String searchQuery = request.getParameter("search_query");
                String query = "SELECT * FROM book_details";

                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    query += " WHERE book_name LIKE ? OR b_id LIKE ?";
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
                    out.println("<tr><th>Book ID</th><th>Book Name</th><th>Book Category</th><th>Book Author</th><th>Book Publisher</th><th>Book Pages</th><th>Book Qty.</th><th>Edition</th><th>Action</th></tr>");

                    while (rs.next()) {
                        String bookName = rs.getString("book_name");
                        if (bookName == null || bookName.isEmpty()) {
                            bookName = "<span class='error-message'>Missing Data</span>";
                        }

                        int bookId = rs.getInt("b_id"); // Book ID for deletion

                        out.println("<tr>");
                        out.println("<td>" + bookId + "</td>");
                        out.println("<td>" + bookName + "</td>");
                        out.println("<td>" + rs.getString("b_category") + "</td>");
                        out.println("<td>" + rs.getString("b_author") + "</td>");
                        out.println("<td>" + rs.getString("b_publisher") + "</td>");
                        out.println("<td>" + rs.getInt("b_pages") + "</td>");
                        out.println("<td>" + rs.getInt("b_qty") + "</td>");
                        out.println("<td>" + rs.getInt("b_edition") + "</td>");

                        // Delete button inside a form
                        out.println("<td>");
                        out.println("<form method='post' onsubmit='return confirm(\"Are you sure you want to delete this book?\");'>");
                        out.println("<input type='hidden' name='delete_id' value='" + bookId + "'>");
                        out.println("<button type='submit' name='delete' class='delete-btn'>Delete</button>");
                        out.println("</form>");
                        out.println("</td>");

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
