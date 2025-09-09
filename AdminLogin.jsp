<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
    <title>Admin Login & Registration</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-image: url('images/77.jpg');
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
            width: 30%;
            background: rgba(0, 0, 0, 0.7);
            padding: 30px;
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

        .input-container {
            position: relative;
            width: 100%;
        }

        input {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: none;
            border-radius: 5px;
            transition: 0.3s;
        }

        input:focus {
            box-shadow: 0px 0px 10px rgba(255, 204, 0, 0.8);
            outline: none;
        }

        .toggle-password {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #ffcc00;
            font-size: 18px;
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
            transition: 0.3s;
        }

        button:hover {
            background: #e6b800;
            transform: scale(1.05);
            box-shadow: 0px 0px 10px rgba(255, 204, 0, 0.8);
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Admin Login</h2>
        <form method="post">
            <label>Username:</label>
            <input type="text" name="username" required>
            
            <label>Password:</label>
            <div class="input-container">
                <input type="password" id="password" name="password" required>
                <span class="toggle-password" onclick="togglePassword()">👁️</span>
            </div>
            
            <div class="buttons">
                <button type="submit" name="login">Login</button>
                <button type="submit" name="register">Register</button>
            </div>
        </form>
    </div>
    
    <script>
        function togglePassword() {
            var passwordField = document.getElementById("password");
            if (passwordField.type === "password") {
                passwordField.type = "text";
            } else {
                passwordField.type = "password";
            }
        }
    </script>

    <%
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/lbms", "root", "");

            // Handling login
            if (request.getParameter("login") != null) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                String query = "SELECT * FROM admin WHERE username = ? AND password = ?";
                pst = conn.prepareStatement(query);
                pst.setString(1, username);
                pst.setString(2, password);
                rs = pst.executeQuery();

                if (rs.next()) {
                    // **Setting session after login**
                    session.setAttribute("adminUser", username);
                    response.sendRedirect("Home.jsp");  // Redirect to home page
                } else {
                    out.println("<script>alert('Invalid Username or Password! Please try again.');</script>");
                }
            }

            // Handling registration
            if (request.getParameter("register") != null) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");

                String checkQuery = "SELECT * FROM admin WHERE username = ?";
                pst = conn.prepareStatement(checkQuery);
                pst.setString(1, username);
                rs = pst.executeQuery();

                if (rs.next()) {
                    out.println("<script>alert('Username already exists! Try a different one.');</script>");
                } else {
                    String insertQuery = "INSERT INTO admin (username, password) VALUES (?, ?)";
                    pst = conn.prepareStatement(insertQuery);
                    pst.setString(1, username);
                    pst.setString(2, password);
                    pst.executeUpdate();
                    out.println("<script>alert('Registration successful! You can now login.');</script>");
                }
            }
        } catch (Exception e) {
            out.println("<script>alert('Database Error: " + e.getMessage() + "');</script>");
        } finally {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        }
    %>
</body>
</html>
