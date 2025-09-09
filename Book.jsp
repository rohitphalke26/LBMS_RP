<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
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
    <title>Book Registration</title>
    <style>
        /* Import Google Font */
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap');

        /* Background */
        body {
            font-family: 'Poppins', sans-serif;
            background: url('images/66.jpg') no-repeat center center/cover;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        /* Dark Glassmorphism Box */
        .container {
            width: 65%;  /* Increased size */
            padding: 50px;
            background: rgba(12, 12, 12, 0.85);
            backdrop-filter: blur(10px);
            border-radius: 15px;
            box-shadow: 0px 6px 25px rgba(237, 236, 236, 0.6);
            color: white;
            animation: fadeIn 0.8s ease-in-out;
        }

        /* Heading */
        h2 {
            font-size: 32px;
            color: #ffcc00;
            font-weight: 700;
            text-transform: uppercase;
            text-align: center;
            margin-bottom: 30px;
        }

        /* Form Grid Layout */
        .form-group {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
        }

        .form-group div {
            width: 48%; /* Two-column layout */
        }

        /* Labels */
        label {
            display: block;
            font-weight: bold;
            margin-top: 12px;
            font-size: 16px;
            color: #ffcc00;
        }

        /* Input Fields */
        input, select {
            width: 100%;
            padding: 12px;
            margin-top: 5px;
            border: none;
            border-radius: 10px;
            font-size: 16px;
            background: white;
            color: black;
            outline: none;
            transition: 0.3s;
        }

        input:focus, select:focus {
            background: #f5f5f5;
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.2);
        }

        /* Buttons */
        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }

        button {
            background: linear-gradient(135deg, #ffcc00, #ff9900);
            color: black;
            padding: 14px 24px;
            border: none;
            font-size: 17px;
            font-weight: bold;
            border-radius: 10px;
            cursor: pointer;
            transition: 0.3s;
        }

        button:hover {
            background: linear-gradient(135deg, #ff9900, #ff6600);
            transform: scale(1.06);
            box-shadow: 0px 0px 14px rgba(255, 165, 0, 0.8);
        }

        /* Fade-in Animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Book Registration</h2>
        <form method="post">
            <div class="form-group">
                <div>
                    <label>Book ID:</label>
                    <input type="text" name="b_id" required>

                    <label>Book Title:</label>
                    <input type="text" name="book_name" required>

                    <label>Genre:</label>
                    <select name="b_category" required>
                        <option value="">Select Category</option>
                        <option value="Educational">Educational</option>
                        <option value="Drama">Drama</option>
                        <option value="Science">Science</option>
                        <option value="Sports">Sports</option>
                    </select>

                    <label>Author Name:</label>
                    <input type="text" name="b_author" required>
                </div>

                <div>
                    <label>Publisher:</label>
                    <input type="text" name="b_publisher" required>

                    <label>Number of Pages:</label>
                    <input type="number" name="b_pages" required>

                    <label>Available Copies:</label>
                    <input type="number" name="b_qty" required>

                    <label>Edition:</label>
                    <input type="text" name="b_edition" required>
                </div>
            </div>

            <div class="buttons">
                <button type="submit" name="add">Add</button>
                <button type="submit" name="update">Update</button>
                <button type="button" onclick="window.location.href='Home.jsp';">Back</button>
            </div>
        </form>
    </div>

    <%
        if (request.getParameter("add") != null) {
            int bookID = Integer.parseInt(request.getParameter("b_id"));
            String bookName = request.getParameter("book_name");
            String category = request.getParameter("b_category");
            String author = request.getParameter("b_author");
            String publisher = request.getParameter("b_publisher");
            int pages = Integer.parseInt(request.getParameter("b_pages"));
            int qty = Integer.parseInt(request.getParameter("b_qty"));
            String edition = request.getParameter("b_edition");

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");
                 PreparedStatement pst = conn.prepareStatement("INSERT INTO book_details (b_id, book_name, b_category, b_author, b_publisher, b_pages, b_qty, b_edition) VALUES (?, ?, ?, ?, ?, ?, ?, ?)")) {

                Class.forName("com.mysql.jdbc.Driver");

                pst.setInt(1, bookID);
                pst.setString(2, bookName);
                pst.setString(3, category);
                pst.setString(4, author);
                pst.setString(5, publisher);
                pst.setInt(6, pages);
                pst.setInt(7, qty);
                pst.setString(8, edition);
                pst.executeUpdate();
                out.println("<script>alert('Record saved successfully!');</script>");
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            }
        }

        if (request.getParameter("update") != null) {
            int bookID = Integer.parseInt(request.getParameter("b_id"));
            String bookName = request.getParameter("book_name");
            String category = request.getParameter("b_category");
            String author = request.getParameter("b_author");
            String publisher = request.getParameter("b_publisher");
            int pages = Integer.parseInt(request.getParameter("b_pages"));
            int qty = Integer.parseInt(request.getParameter("b_qty"));
            String edition = request.getParameter("b_edition");

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");
                 PreparedStatement pst = conn.prepareStatement("UPDATE book_details SET book_name=?, b_category=?, b_author=?, b_publisher=?, b_pages=?, b_qty=?, b_edition=? WHERE b_id=?")) {

                Class.forName("com.mysql.jdbc.Driver");

                pst.setString(1, bookName);
                pst.setString(2, category);
                pst.setString(3, author);
                pst.setString(4, publisher);
                pst.setInt(5, pages);
                pst.setInt(6, qty);
                pst.setString(7, edition);
                pst.setInt(8, bookID);
                int rowsUpdated = pst.executeUpdate();
                out.println(rowsUpdated > 0 ? "<script>alert('Record updated successfully!');</script>" : "<script>alert('No record found to update!');</script>");
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            }
        }
    %>
</body>
</html>
