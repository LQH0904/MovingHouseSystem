<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../page/login/head.jsp"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Đăng nhập</title>
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;600;700&display=swap" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&display=swap" rel="stylesheet">
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
            .container {
                display: flex;
                max-width: 900px;
                height: auto;
                background: #fff;
                border-radius: 30px;
                overflow: hidden;
                box-shadow: 0 10px 40px rgba(0, 0, 0, 0.2);
                margin: 50px auto;
            }

            .left-section {
                flex: 1;
                background: url('img/bgr.jpg') center center / cover no-repeat;
                position: relative;
                color: white;
                padding: 30px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                border-radius: 30px 0 0 30px;
                min-width: 300px;
            }

            .overlay {
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.4);
                z-index: 1;
                border-radius: 30px 0 0 30px;
            }

            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-family: Poppins, sans-serif;
                font-size: 16px;
                margin-bottom: 15px;
            }
            .right-section {
                flex: 1;
                padding: 40px;
                box-sizing: border-box;
                word-wrap: break-word;
                overflow-wrap: break-word;
                min-width: 300px;
            }

            .error-message {
                color: red;
                font-weight: bold;
                margin-top: 10px;
                margin-bottom: 10px;
                word-break: break-word;
                max-width: 100%;
                text-align: center;

                .right-section p {
                    max-width: 100%;
                    word-break: break-word;
                }

                .form-group select:focus {
                    outline: none;
                    border-color: #007bff;
                }
            </style>
        </head>
        <body>
            <div class="container">
                <!-- Left Section -->
                <div class="left-section">
                    <div class="overlay"></div>
                    <div class="left-header" style="position: relative;
                         z-index: 2;">
                        <span>Work for Day</span>
                        <div class="buttons">
                            <button onclick="location.href = 'signup'">Sign Up</button>
                            <button onclick="location.href = '#'">Home</button>
                        </div>
                    </div>
                </div>

                <div class="right-section">
                    <p class="logo">Welcome to Website</p>

                    <c:if test="${not empty mess}">
                        <p style="color: red;
                        font-weight: bold;">${mess}</p>
                    </c:if>
                    <c:if test="${not empty error}">
                        <p style="color: red;
                        font-weight: bold;">${error}</p>
                    </c:if>


                    <form id="loginForm" action="login" method="post">
                        <div class="form-group">
                            <select name="role_id" id="role_id" required>
                                <option value="1">Admin</option>
                                <option value="2">Operator</option>
                                <option value="3">Staff</option>
                                <option value="4">Đơn vị vận chuyển</option>
                                <option value="5">Đơn vị kho bãi</option>
                                <option value="6" selected>Khách hàng</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <input type="text" name="email" id="email" value="${email != null ? email : ''}" required />
                            <label for="email">Email</label>
                        </div>
                        <div class="form-group">
                            <input type="password" name="password" id="password" required />
                            <label for="password">Password</label>
                        </div>

                        <a href="forgot" class="forgot-password">Quên mật khẩu?</a>
                        <div class="or-divider">— hoặc —</div>

                        <button type="button" class="google-login" onclick="loginWithGoogle()">
                            <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo" />
                            Đăng nhập với Google
                        </button>

                        <button type="submit" class="login-btn">Đăng nhập</button>

                        <button type="button" class="google-login" onclick="location.href = 'signup'" 
                                style="margin-top: 10px;
                                width: 100%;
                                padding: 10px;
                                color: black;
                                border: none;
                                border-radius: 10px;
                                cursor: pointer;">
                            Tạo tài khoản
                        </button>
                    </form>
                </div>
            </div>

            <script>
                function loginWithGoogle() {
                    const roleId = document.getElementById('role_id').value;
                    const googleAuthUrl = 'https://accounts.google.com/o/oauth2/auth?scope=email profile openid' +
                            '&redirect_uri=http://localhost:8080/HouseMovingSystem/LoginGoogleServlet' +
                            '&response_type=code' +
                            '&client_id=820713583757-asdgtkcasbf9maf6uvu91kpc67k5d418.apps.googleusercontent.com' +
                            '&approval_prompt=force' +
                            '&state=role_id=' + encodeURIComponent(roleId);
                    window.location.href = googleAuthUrl;
                }
            </script>
        </body>
    </html>
