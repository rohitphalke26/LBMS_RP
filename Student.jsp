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
    <title>Student Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('images/15.jpg');
            background-size: cover;
            background-position: center;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            animation: fadeIn 1s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .container {
            width: 50%;
            background: rgba(0, 0, 0, 0.7);
            padding: 40px;
            color: white;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(255, 255, 255, 0.5);
            animation: slideIn 1s ease-in-out;
        }

        @keyframes slideIn {
            from { transform: translateY(-50px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        input, select {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            transition: 0.3s;
        }

        input:focus, select:focus {
            box-shadow: 0px 0px 10px rgba(255, 204, 0, 0.8);
            outline: none;
        }

        .gender-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .gender-container input {
            margin: 0;
            transform: scale(1.2);
        }

        .buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }

        button {
            background: #ffcc00;
            padding: 12px 20px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
            transition: 0.3s ease-in-out;
        }

        button:hover {
            background: #e6b800;
            transform: scale(1.05);
            box-shadow: 0px 0px 10px rgba(255, 204, 0, 0.8);
        }

        .delete-btn {
            background: red;
            color: white;
        }

        .delete-btn:hover {
            background: darkred;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Student Registration</h2>
        <form method="post">
            <label>Name:</label>
            <input type="text" name="s_name" required>
            
            <label>Class:</label>
            <select name="s_class" required>
                <option value="">Select</option>
                <option value="BBA">BBA</option>
                <option value="BCA">BCA</option>
                <option value="MCA">MCA</option>
                <option value="MBA">MBA</option>
            </select>
            
            <label>Card No:</label>
            <input type="number" name="s_rollno" required>
            
            <label>Gender:</label>
            <div class="gender-container">
                <input type="radio" name="s_gender" value="Male" required> <label>Male</label>
                <input type="radio" name="s_gender" value="Female"> <label>Female</label>
            </div>
            
            <label>Mobile No:</label>
            <input type="text" name="s_phone" required>
            
            <label>Email:</label>
            <input type="email" name="s_email" required>
            
            <div class="buttons">
                <button type="submit" name="submit">Submit</button>
                <button type="submit" name="update">Update</button>
                <button type="submit" name="delete" class="delete-btn">Delete</button>
                <button type="button" onclick="window.location.href='Home.jsp';">Back</button>
            </div>
        </form>
    </div>
    
    <%
        if (request.getParameter("submit") != null) {
            String name = request.getParameter("s_name");
            String studentClass = request.getParameter("s_class");
            int rollNo = Integer.parseInt(request.getParameter("s_rollno"));
            String gender = request.getParameter("s_gender");
            String phone = request.getParameter("s_phone");
            String email = request.getParameter("s_email");
            
            Connection conn = null;
            PreparedStatement pst = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");
                String query = "INSERT INTO student (s_name, s_class, s_rollno, s_gender, s_phno, s_email) VALUES (?, ?, ?, ?, ?, ?)";
                pst = conn.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, studentClass);
                pst.setInt(3, rollNo);
                pst.setString(4, gender);
                pst.setString(5, phone);
                pst.setString(6, email);
                pst.executeUpdate();
                out.println("<script>alert('Record saved successfully!');</script>");
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            } finally {
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            }
        }
        
        if (request.getParameter("update") != null) {
            String name = request.getParameter("s_name");
            String studentClass = request.getParameter("s_class");
            int rollNo = Integer.parseInt(request.getParameter("s_rollno"));
            String gender = request.getParameter("s_gender");
            String phone = request.getParameter("s_phone");
            String email = request.getParameter("s_email");
            
            Connection conn = null;
            PreparedStatement pst = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");
                String query = "UPDATE student SET s_name=?, s_class=?, s_gender=?, s_phno=?, s_email=? WHERE s_rollno=?";
                pst = conn.prepareStatement(query);
                pst.setString(1, name);
                pst.setString(2, studentClass);
                pst.setString(3, gender);
                pst.setString(4, phone);
                pst.setString(5, email);
                pst.setInt(6, rollNo);
                int rowsUpdated = pst.executeUpdate();
                out.println("<script>alert('Record updated successfully!');</script>");
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            } finally {
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            }
        }

        if (request.getParameter("delete") != null) {
            String name = request.getParameter("s_name");
            int rollNo = Integer.parseInt(request.getParameter("s_rollno"));

            Connection conn = null;
            PreparedStatement pst = null;
            try {
                Class.forName("com.mysql.jdbc.Driver");
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");
                String query = "DELETE FROM student WHERE s_name=? AND s_rollno=?";
                pst = conn.prepareStatement(query);
                pst.setString(1, name);
                pst.setInt(2, rollNo);
                pst.executeUpdate();
                out.println("<script>alert('Record deleted successfully!');</script>");
            } catch (Exception e) {
                out.println("<script>alert('Error: " + e.getMessage() + "');</script>");
            } finally {
                if (pst != null) pst.close();
                if (conn != null) conn.close();
            }
        }
    %>
</body>
</html>
