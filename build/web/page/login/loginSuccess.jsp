<%-- 
    Document   : loginSuccess
    Created on : May 30, 2025, 11:36:05 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Model.Users"%>

<%
    if (session.getAttribute("acc") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Login Success</title>
    </head>
    <body>
        <%
            Users user = (Users) session.getAttribute("acc");
        %>
        <h1>Login Successful!</h1>
        <p>Welcome, <strong><%= user.getUsername() %></strong>!</p>
        <p>Email: <%= user.getEmail() %></p>
        <p>Role ID: <%= user.getRoleId() %></p>
        <p>Status: <%= "active".equalsIgnoreCase(user.getStatus()) ? "Active" : "Inactive" %></p>
        <p>Password Hash: <%= user.getPasswordHash() %></p>

    </body>
    <form action="logout" method="post" style="margin-top:20px;">
        <button type="submit">Logout</button>
    </form>

</html>


