<%-- 
    Document   : newpassword
    Created on : May 31, 2025, 1:30:04 AM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../../page/login/pass.jsp"/>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt mật khẩu mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #007bff, #80d0ff);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
            font-family: 'Segoe UI', sans-serif;
        }
        .newpassword-container {
            max-width: 400px;
            padding: 30px;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 15px;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            animation: fadeIn 0.5s ease-in;
        }
        .newpassword-header {
            text-align: center;
            margin-bottom: 25px;
            color: #007bff;
            font-weight: 700;
            font-size: 1.8rem;
        }
        #rule {
            text-align: center;
            font-size: 0.9rem;
            color: #333;
            margin-bottom: 20px;
        }
        .input-group {
            position: relative;
            margin-bottom: 15px;
        }
        .form-control {
            border-radius: 8px;
            padding-left: 40px;
        }
        .input-group i {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
            color: #007bff;
            cursor: pointer;
            z-index: 10;
        }
        .input-group i:hover {
            color: #0056b3;
        }
        .btn-primary {
            background: #007bff;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
            transition: transform 0.2s, background 0.3s;
            width: 100%;
        }
        .btn-primary:hover {
            background: #0056b3;
            transform: scale(1.05);
        }
        .message {
            font-size: 0.85rem;
            text-align: center;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
        }
        .message.error {
            background-color: #e74c3c;
            color: #ffffff;
            font-weight: bold;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);
        }
        .message.success {
            color: green;
            font-weight: bold;
        }
        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        @media (max-width: 576px) {
            .newpassword-container {
                margin: 20px;
                padding: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="newpassword-container animate__animated animate__fadeIn">
        <h2 class="newpassword-header">Đặt mật khẩu mới</h2>
        <p id="rule">Mật khẩu mạnh kết hợp chữ cái, tối thiểu 6 ký tự.</p>

        <form id="f1" action="confirmpass" method="post">
            <input type="hidden" name="email" value="${resetUsername}" />
            <input type="hidden" name="role_id" value="${resetRoleId}" />

            <div class="input-group">
                <input id="pass1" type="password" name="password" placeholder="Mật khẩu mới" required minlength="6" class="form-control" />
                <i class="fa-solid fa-eye-slash" onclick="togglePasswordVisibility('pass1', this)"></i>
            </div>

            <div class="input-group">
                <input id="pass2" type="password" name="cfpassword" placeholder="Xác nhận mật khẩu mới" required minlength="6" class="form-control" />
                <i class="fa-solid fa-eye-slash" onclick="togglePasswordVisibility('pass2', this)"></i>
            </div>

            <c:if test="${not empty error}">
                <p class="message error">${error}</p>
            </c:if>

            <c:if test="${not empty successfully}">
                <p class="message success">${successfully}</p>
            </c:if>

            <button type="submit" class="btn btn-primary">Tiếp tục</button>
        </form>
    </div>

    <script>
        function togglePasswordVisibility(inputId, iconElement) {
            const input = document.getElementById(inputId);
            const isPassword = input.type === 'password';
            input.type = isPassword ? 'text' : 'password';
            iconElement.classList.toggle('fa-eye');
            iconElement.classList.toggle('fa-eye-slash');
        }
    </script>
</body>
</html>