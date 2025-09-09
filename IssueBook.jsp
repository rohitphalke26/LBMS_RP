<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
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
    <title>Issue Book - Library Management System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body {
            background: url('images/77.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
        }
        .container {
            max-width: 900px;
            margin-top: 50px;
            background: rgba(0, 0, 0, 0.8);
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(255, 165, 0, 0.5);
            animation: fadeIn 0.8s ease-in-out;
        }
        .btn-orange {
            background-color: orange;
            color: white;
            width: 100%;
            border: none;
            font-weight: bold;
        }
        .btn-orange:hover {
            background-color: darkorange;
        }
        .table {
            background: white;
            color: black;
        }
        .table th {
            background: rgb(26, 25, 24);
            color: white;
        }
    </style>
</head>
<body>

<div class="container">
    <h2 class="text-center">Issue Book</h2>

    <!-- Back to Home Button -->
    <a href="Home.jsp" class="btn btn-orange mb-3">Back to Home</a>

    <!-- Input Form -->
    <form method="post">
        <div class="mb-3">
            <label for="studentId" class="form-label">Student ID</label>
            <input type="text" class="form-control" id="studentId" name="studentId" required>
        </div>
        <div class="mb-3">
            <label for="bookId" class="form-label">Book ID</label>
            <input type="text" class="form-control" id="bookId" name="bookId" required>
        </div>
        <button type="submit" class="btn btn-orange" name="fetchDetails">Fetch Details</button>
    </form>

    <%
        String url = "jdbc:mysql://localhost:3306/lbms";
        String user = "root";
        String password = "";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        String studentId = request.getParameter("studentId");
        String bookId = request.getParameter("bookId");

        String s_name = "", s_class = "", s_rollno = "";
        String book_name = "";

        if (request.getParameter("fetchDetails") != null) {
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);

                // Fetch Student Details
                ps = conn.prepareStatement("SELECT * FROM student WHERE s_rollno = ?");
                ps.setString(1, studentId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    s_name = rs.getString("s_name");
                    s_class = rs.getString("s_class");
                    s_rollno = rs.getString("s_rollno");
    %>
    <h4 class="mt-4 text-warning">Student Details</h4>
    <table class="table table-bordered">
        <tr>
            <th>Name</th><th>Class</th><th>Card No</th>
        </tr>
        <tr>
            <td><%= s_name %></td>
            <td><%= s_class %></td>
            <td><%= s_rollno %></td>
        </tr>
    </table>

    <%
                } else {
                    out.println("<div class='alert alert-danger mt-3'>Student ID not found.</div>");
                }
                rs.close();
                ps.close();

                // Fetch Book Details
                ps = conn.prepareStatement("SELECT * FROM book_details WHERE b_id = ?");
                ps.setString(1, bookId);
                rs = ps.executeQuery();
                if (rs.next()) {
                    int bookQty = rs.getInt("b_qty");
                   String b_author = rs.getString("b_author");
                    book_name = rs.getString("book_name");

                    if (bookQty > 0) {
    %>
    <h4 class="mt-4 text-warning">Book Details</h4>
    <table class="table table-bordered">
        <tr>
            <th>Book Name</th><th>Book ID</th><th>Author</th><th>Quantity</th>
        </tr>
        <tr>
            <td><%= book_name %></td>
            <td><%= bookId %></td>
            <td><%= b_author %></td>
            <td><%= bookQty %></td>
        </tr>
    </table>

    <!-- Issue Book Form -->
    <form method="post">
        <input type="hidden" name="studentId" value="<%= studentId %>">
        <input type="hidden" name="bookId" value="<%= bookId %>">
        <input type="hidden" name="s_name" value="<%= s_name %>">
        <input type="hidden" name="s_class" value="<%= s_class %>">
        <input type="hidden" name="s_rollno" value="<%= s_rollno %>">
        <input type="hidden" name="book_name" value="<%= book_name %>">
        <div class="mb-3">
            <label for="issueDate" class="form-label">Issue Date</label>
            <input type="date" class="form-control" id="issueDate" name="issueDate" required>
        </div>
        <button type="submit" class="btn btn-orange" name="issueBook">Issue Book</button>
    </form>

    <%
                    } else {
                        out.println("<div class='alert alert-warning mt-3'>Book is out of stock.</div>");
                    }
                } else {
                    out.println("<div class='alert alert-danger mt-3'>Book ID not found.</div>");
                }
                rs.close();
                ps.close();
                conn.close();

            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='alert alert-danger mt-3'>Error: " + e.getMessage() + "</div>");
            }
        }

        // Issue Book
        if (request.getParameter("issueBook") != null) {
            studentId = request.getParameter("studentId");
            bookId = request.getParameter("bookId");
            String issueDate = request.getParameter("issueDate");
            s_name = request.getParameter("s_name");
            s_class = request.getParameter("s_class");
            s_rollno = request.getParameter("s_rollno");
            book_name = request.getParameter("book_name");

            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection(url, user, password);

                // Check if the book is still available
                ps = conn.prepareStatement("SELECT b_qty FROM book_details WHERE b_id = ?");
                ps.setString(1, bookId);
                rs = ps.executeQuery();
                if (rs.next() && rs.getInt("b_qty") > 0) {
                    // Insert into issue_details table
                    ps = conn.prepareStatement("INSERT INTO issue_details (s_name, s_rollno, s_class, book_name, b_id, issue_date) VALUES (?, ?, ?, ?, ?, ?)");
                    ps.setString(1, s_name);
                    ps.setString(2, s_rollno);
                    ps.setString(3, s_class);
                    ps.setString(4, book_name);
                    ps.setString(5, bookId);
                    ps.setString(6, issueDate);
                    ps.executeUpdate();
                    ps.close();

                    // Reduce book quantity
                    ps = conn.prepareStatement("UPDATE book_details SET b_qty = b_qty - 1 WHERE b_id = ?");
                    ps.setString(1, bookId);
                    ps.executeUpdate();
                    ps.close();

                    out.println("<div class='alert alert-success mt-3'>Book issued successfully!</div>");
                } else {
                    out.println("<div class='alert alert-danger mt-3'>Book not available.</div>");
                }
                conn.close();

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    %>

</div>

</body>
</html>
