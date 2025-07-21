<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../../page/login/head.jsp"/>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng nhập</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
        <script src="https://cdn.tailwindcss.com"></script>
        <style>
            /* Custom animations */
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
            .fade-in {
                animation: fadeIn 0.6s ease-out forwards;
            }
            .hover-scale {
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }
            .hover-scale:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.15);
            }
            .form-group {
                position: relative;
                margin-bottom: 1.5rem;
            }
            .form-group input,
            .form-group select {
                transition: all 0.3s ease;
            }
            .form-group label {
                position: absolute;
                left: 1rem;
                top: 0.75rem;
                color: #6b7280;
                transition: all 0.3s ease;
                pointer-events: none;
                font-size: 1rem;
            }
            .form-group input:focus + label,
            .form-group input:not(:placeholder-shown) + label,
            .form-group select:focus + label,
            .form-group select:not([value=""]) + label {
                transform: translateY(-1.8rem);
                font-size: 0.75rem;
                color: #3b82f6;
                background: #fff;
                padding: 0 0.25rem;
            }
            .form-group select:not([value=""]) + label {
                transform: translateY(-1.8rem);
                font-size: 0.75rem;
                color: #3b82f6;
            }
            .left-section::before {
                content: '';
                position: absolute;
                inset: 0;
                background: linear-gradient(135deg, rgba(0, 0, 0, 0.5), rgba(0, 0, 0, 0.3));
                border-radius: 1.5rem 0 0 1.5rem;
                z-index: 1;
            }
        </style>
    </head>
    <body class="bg-gradient-to-br from-blue-600 to-indigo-400 flex items-center justify-center min-h-screen p-4">
        <div class="container max-w-4xl w-full bg-white rounded-3xl shadow-2xl flex overflow-hidden animate-[fadeIn_0.6s_ease-out]">
            <!-- Left Section -->
            <div class="left-section relative flex-1 bg-[url('img/bgr.jpg')] bg-cover bg-center p-8 flex flex-col justify-between text-white min-w-[300px]">
                <div class="relative z-10">
                    <h1 class="text-3xl font-bold tracking-tight">Work for Day</h1>
                    <p class="mt-2 text-sm opacity-80">Nền tảng kết nối dịch vụ vận chuyển và kho bãi</p>
                </div>
                <div class="relative z-10 flex space-x-4">
                    <button onclick="location.href = 'signup'" class="bg-white text-blue-600 px-6 py-2 rounded-full font-medium hover-scale hover:bg-blue-50 transition-colors">Đăng ký</button>
                    <button onclick="window.location.href = 'http://localhost:9999/HouseMovingSystem/homePage/homePage.html'" class="bg-transparent border border-white px-6 py-2 rounded-full font-medium hover-scale hover:bg-white hover:text-blue-600 transition-colors">Trang chủ</button>            </div>
            </div>

            <!-- Right Section -->
            <div class="right-section flex-1 p-10 flex flex-col justify-center min-w-[300px]">
                <h2 class="text-2xl font-semibold text-gray-800 mb-6 text-center">Chào mừng bạn đến với Website</h2>

                <c:if test="${not empty mess}">
                    <p class="text-red-500 font-medium text-center mb-4">${mess}</p>
                </c:if>
                <c:if test="${not empty error}">
                    <p class="text-red-500 font-medium text-center mb-4">${error}</p>
                </c:if>

                <form id="loginForm" action="login" method="post" class="space-y-6">
                    <div class="form-group">
                        <select name="role_id" id="role_id" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 bg-white" required>
                            <option value="" disabled>Chọn vai trò</option>
                            <option value="1">Quản trị viên</option>
                            <option value="2">Điều hành</option>
                            <option value="3">Nhân viên</option>
                            <option value="4">Đơn vị vận chuyển</option>
                            <option value="5">Đơn vị kho bãi</option>
                            <option value="6" selected>Khách hàng</option>
                        </select>
                        <label for="role_id">Vai trò</label>
                    </div>
                    <div class="form-group">
                        <input type="text" name="email" id="email" value="${email != null ? email : ''}" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder=" " required />
                        <label for="email">Email</label>
                    </div>
                    <div class="form-group">
                        <input type="password" name="password" id="password" class="w-full p-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500" placeholder=" " required />
                        <label for="password">Mật khẩu</label>
                    </div>

                    <a href="forgot" class="text-blue-600 text-sm hover:underline text-right block">Quên mật khẩu?</a>

                    <button type="submit" class="w-full bg-blue-600 text-white py-3 rounded-lg font-medium hover-scale hover:bg-blue-700 transition-colors">Đăng nhập</button>

                    <div class="flex items-center justify-center space-x-4 my-4">
                        <span class="h-px w-12 bg-gray-300"></span>
                        <span class="text-gray-500 text-sm">hoặc</span>
                        <span class="h-px w-12 bg-gray-300"></span>
                    </div>

                    <button type="button" class="google-login w-full bg-white text-gray-800 py-3 rounded-lg font-medium border border-gray-300 hover-scale hover:bg-gray-50 transition-colors flex items-center justify-center space-x-2" onclick="loginWithGoogle()">
                        <img src="https://developers.google.com/identity/images/g-logo.png" alt="Google Logo" class="w-5 h-5" />
                        <span>Đăng nhập với Google</span>
                    </button>

                    <button type="button" class="w-full bg-gray-100 text-gray-800 py-3 rounded-lg font-medium hover-scale hover:bg-gray-200 transition-colors" onclick="location.href = 'signup'">Tạo tài khoản</button>
                </form>
            </div>
        </div>

        <script>
            function loginWithGoogle() {
                const roleId = document.getElementById('role_id').value;
                const googleAuthUrl = 'https://accounts.google.com/o/oauth2/auth?scope=email profile openid' +
                        '&redirect_uri=http://localhost:9999/HouseMovingSystem/LoginGoogleServlet' +
                        '&response_type=code' +
                        '&client_id=820713583757-asdgtkcasbf9maf6uvu91kpc67k5d418.apps.googleusercontent.com' +
                        '&approval_prompt=force' +
                        '&state=role_id=' + encodeURIComponent(roleId);
                window.location.href = googleAuthUrl;
            }

            document.addEventListener('DOMContentLoaded', () => {
                const select = document.getElementById('role_id');
                const label = select.nextElementSibling;
                if (select.value !== '') {
                    label.style.transform = 'translateY(-1.8rem)';
                    label.style.fontSize = '0.75rem';
                    label.style.color = '#3b82f6';
                    label.style.background = '#fff';
                    label.style.padding = '0 0.25rem';
                }
            });
        </script>
    </body>
</html>