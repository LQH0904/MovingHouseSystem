<%-- 
    Document   : account_not_active
    Created on : Jun 17, 2025, 03:29:00 AM
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Account Not Active</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f2f2f2;
                text-align: center;
                padding-top: 100px;
            }
            .container {
                background-color: white;
                display: inline-block;
                padding: 40px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.2);
            }
            h1 {
                color: #ff4c4c;
                font-size: 48px;
            }
            p {
                font-size: 18px;
                color: #333;
            }
            .btn {
                margin-top: 20px;
                padding: 10px 25px;
                font-size: 16px;
                color: white;
                background-color: #007BFF;
                border: none;
                border-radius: 5px;
                text-decoration: none;
                cursor: pointer;
            }
            .btn:hover {
                background-color: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Account Not Active</h1>
            <p>Your account is not active. Please contact support or wait for admin approval.</p>
            <a href="${pageContext.request.contextPath}/logout" class="btn">Back</a>
        </div>
    </body>
</html>