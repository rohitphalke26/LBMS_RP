<%
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            cookie.setMaxAge(0); // Expire the cookie
            cookie.setPath("/"); // Ensure it's deleted across the app
            response.addCookie(cookie);
        }
    }
    
    // Invalidate session if needed
    session.invalidate();
    
    // Redirect to login page
    response.sendRedirect("AdminLogin.jsp");
%>
