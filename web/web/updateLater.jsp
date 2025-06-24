<%-- 
    Document   : updateLater
    Created on : Jun 7, 2025, 2:11:40 AM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Coming Soon</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: linear-gradient(135deg, #6e8efb, #a777e3);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #fff;
            text-align: center;
        }
        .container {
            max-width: 600px;
            padding: 20px;
        }
        h1 {
            font-size: 3em;
            margin-bottom: 20px;
        }
        p {
            font-size: 1.2em;
            margin-bottom: 30px;
        }
        .countdown {
            font-size: 2em;
            margin-bottom: 30px;
        }
        .email-form input {
            padding: 10px;
            font-size: 1em;
            border: none;
            border-radius: 5px;
            margin-right: 10px;
        }
        .email-form button {
            padding: 10px 20px;
            font-size: 1em;
            border: none;
            border-radius: 5px;
            background: #ff6f61;
            color: #fff;
            cursor: pointer;
        }
        .email-form button:hover {
            background: #e55a50;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Sắp Ra Mắt!</h1>       
        <button onclick="location.href='logout'">Back</button>
    </div>
</body>
</html>
