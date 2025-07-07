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
    <title>Đặt mật khẩu mới</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        i#iconsee:hover {
            color: rgba(0, 0, 0, 0.5);
            cursor: pointer;
        }
        h2 {
            color: #111;
        }
        .input-group {
            position: relative;
            margin-bottom: 15px;
        }
        .input-group i {
            position: absolute;
            right: 10px;
            top: 50%;
            transform: translateY(-50%);
        }
        button {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h2>Đặt mật khẩu mới</h2>
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
                <p style="background-color: #e74c3c; color: #ffffff; font-weight: bold; padding: 12px 20px; border-radius: 8px; margin: 10px 0; text-align: center; box-shadow: 0 2px 6px rgba(0, 0, 0, 0.2);">
                    ${error}
                </p>
            </c:if>

            <c:if test="${not empty successfully}">
                <p class="message success" style="color: green; font-weight: bold; padding: 10px; border-radius: 5px;">
                    ${successfully}
                </p>
            </c:if>

            <button type="submit">Tiếp tục</button>
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

