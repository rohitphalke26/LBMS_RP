<%@ page import="java.sql.*, java.text.SimpleDateFormat, java.util.Date" %>
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
    <title>Return Book</title>
    <style>
        /* Page Background */
        body {
            font-family: Arial, sans-serif;
            background: url('images/30.jpg') no-repeat center center fixed;
            background-size: cover;
            text-align: center;
            opacity: 0;
            animation: fadeIn 1s forwards;
        }

        /* Fade-in animation */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        /* Centered Box */
        .container {
            width: 60%;
            margin: auto;
            background: rgba(0, 0, 0, 0.8);
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0px 0px 20px rgba(255, 165, 0, 0.6); /* Light Orange Glow */
            color: white;
            animation: slideIn 1s ease-in-out;
        }

        /* Slide-in animation */
        @keyframes slideIn {
            from { transform: scale(0.9); opacity: 0; }
            to { transform: scale(1); opacity: 1; }
        }

        /* Input & Button Styling */
        input, select, button {
            width: 90%;
            padding: 12px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 16px;
        }

        /* Styled Buttons */
        button {
            background-color: orange;
            color: black;
            font-weight: bold;
            cursor: pointer;
            border: none;
            transition: all 0.3s ease-in-out;
        }

        button:hover {
            background-color: orange;
            transform: scale(1.05);
        }

        /* Table Styling */
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
            background: rgba(255, 255, 255, 0.9);
            color: black;
        }

        table, th, td {
            border: 1px solid #ccc;
        }

        th, td {
            padding: 12px;
            text-align: center;
        }

        /* Error Messages */
        .message {
            color: #ff4d4d;
            font-weight: bold;
        }

        /* Back Button */
        .home-btn {
            display: inline-block;
            margin-top: 15px;
            text-decoration: none;
            background-color: orange;
            color: black;
            padding: 12px 20px;
            border-radius: 5px;
            font-size: 16px;
            transition: all 0.3s ease-in-out;
        }

        .home-btn:hover {
            background-color: orange;
            transform: scale(1.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Return Book</h2>
        <form method="post">
            <input type="text" name="student_id" placeholder="Student ID" required>
            <input type="text" name="book_id" placeholder="Book ID" required>
            <input type="date" name="return_date" required>
            <button type="submit" name="fetch">Fetch Details</button>
        </form>

        <%
            String studentId = request.getParameter("student_id");
            String bookId = request.getParameter("book_id");
            String returnDateStr = request.getParameter("return_date");

            if (request.getParameter("fetch") != null) {
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    Class.forName("com.mysql.jdbc.Driver");
                    con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");

                    String query = "SELECT * FROM issue_details WHERE s_rollno = ? AND b_id = ?";
                    ps = con.prepareStatement(query);
                    ps.setString(1, studentId);
                    ps.setString(2, bookId);
                    rs = ps.executeQuery();

                    if (rs.next()) {
                        String sName = rs.getString("s_name");
                        String cardNo = rs.getString("s_rollno");
                        String bName = rs.getString("book_name");
                        String issueDateStr = rs.getString("issue_date");

                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        Date issueDate = sdf.parse(issueDateStr);
                        Date returnDate = sdf.parse(returnDateStr);

                        long diff = returnDate.getTime() - issueDate.getTime();
                        int daysBetween = (int) (diff / (1000 * 60 * 60 * 24));
                        int charge = (daysBetween > 7) ? (daysBetween - 7) * 5 : 0;

                        session.setAttribute("charge", charge);
                        session.setAttribute("card_no", cardNo);

                        out.println("<table>");
                        out.println("<tr><th>Student ID</th><th>Student Name</th><th>Card No</th><th>Book ID</th><th>Book Name</th><th>Issue Date</th><th>Return Date</th><th>Late Fee</th></tr>");
                        out.println("<tr><td>" + studentId + "</td><td>" + sName + "</td><td>" + cardNo + "</td><td>" + bookId + "</td><td>" + bName + "</td><td>" + issueDateStr + "</td><td>" + returnDateStr + "</td><td>₹" + charge + "</td></tr>");
                        out.println("</table>");

                        out.println("<form method='post'>");
                        out.println("<input type='hidden' name='student_id' value='" + studentId + "'>");
                        out.println("<input type='hidden' name='book_id' value='" + bookId + "'>");
                        out.println("<input type='hidden' name='s_name' value='" + sName + "'>");
                        out.println("<input type='hidden' name='card_no' value='" + cardNo + "'>");
                        out.println("<input type='hidden' name='b_name' value='" + bName + "'>");
                        out.println("<input type='hidden' name='issue_date' value='" + issueDateStr + "'>");
                        out.println("<input type='hidden' name='return_date' value='" + returnDateStr + "'>");
                        out.println("<button type='submit' name='submit'>Submit</button>");
                        out.println("</form>");
                    } else {
                        out.println("<p class='message'>No issue record found for this Student ID and Book ID.</p>");
                    }
                } catch (Exception e) {
                    out.println("<p class='message'>Error: " + e.getMessage() + "</p>");
                }
            }

            if (request.getParameter("submit") != null) {
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");
                PreparedStatement ps = con.prepareStatement("INSERT INTO return_details (s_id, s_name, card_no, b_id, b_name, issue_date, return_date, charges) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
                ps.setString(1, studentId);
                ps.setString(2, request.getParameter("s_name"));
                ps.setString(3, request.getParameter("card_no"));
                ps.setString(4, bookId);
                ps.setString(5, request.getParameter("b_name"));
                ps.setString(6, request.getParameter("issue_date"));
                ps.setString(7, request.getParameter("return_date"));
                ps.setInt(8, (int) session.getAttribute("charge"));
                ps.executeUpdate();

                // Delete record from issue_details
                ps = con.prepareStatement("DELETE FROM issue_details WHERE s_rollno = ?");
                ps.setString(1, studentId);
                ps.executeUpdate();

                // Add qty record in book
                ps = con.prepareStatement("UPDATE book_details SET b_qty = b_qty + 1 WHERE b_id = ?");
                ps.setString(1, bookId);
                ps.executeUpdate();

                out.println("<p class='message'>Book returned successfully!</p>");
            }
        %>
        <a href="Home.jsp" class="home-btn">Back to Home</a>
    </div>
</body>
</html>
