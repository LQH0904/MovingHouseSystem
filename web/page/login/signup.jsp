<%-- 
    Document   : signup
    Created on : Jun 4, 2025, 10:45:35 PM
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký - Dịch vụ vận chuyển nhà</title>
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
            .signup-container {
                max-width: 500px;
                padding: 30px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
                animation: fadeIn 0.5s ease-in;
            }
            .signup-header {
                text-align: center;
                margin-bottom: 25px;
                color: #007bff;
                font-weight: 700;
                font-size: 1.8rem;
            }
            .form-control {
                border-radius: 8px;
                padding-left: 40px;
            }
            .input-group-text {
                background: #f8f9fa;
                border: none;
                border-radius: 8px 0 0 8px;
            }
            .form-control.is-invalid {
                border-color: #dc3545;
            }
            .invalid-feedback {
                font-size: 0.85rem;
            }
            .btn-primary {
                background: #007bff;
                border: none;
                border-radius: 8px;
                padding: 12px;
                font-weight: 600;
                transition: transform 0.2s, background 0.3s;
            }
            .btn-primary:hover {
                background: #0056b3;
                transform: scale(1.05);
            }
            .login-link {
                text-align: center;
                margin-top: 15px;
                font-size: 0.9rem;
            }
            .login-link a {
                color: #007bff;
                text-decoration: none;
            }
            .login-link a:hover {
                text-decoration: underline;
            }
            .nav-tabs {
                margin-bottom: 20px;
                display: flex;
                flex-wrap: nowrap;
                width: 100%;
                border-bottom: 2px solid #007bff;
            }
            .nav-tabs .nav-link {
                color: #007bff;
                font-weight: 500;
                border: none;
                padding: 10px 20px;
                transition: all 0.3s;
            }
            .nav-tabs .nav-link.active {
                background: #007bff;
                color: white;
                border: 2px solid #007bff;
                border-bottom: none;
                border-radius: 8px 8px 0 0;
            }
            .nav-tabs .nav-link:hover:not(.active) {
                background: #e9f0ff;
                color: #0056b3;
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
                .signup-container {
                    margin: 20px;
                    padding: 20px;
                }
                .nav-tabs .nav-link {
                    padding: 8px 12px;
                    font-size: 0.9rem;
                }
            }
            .overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.5);
                z-index: 999;
            }

            .modal {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                max-height: 80vh;
                overflow-y: auto;
                z-index: 1000;
                width: 90%;
                max-width: 600px;
                box-shadow: 0 8px 16px rgba(0,0,0,0.2);
            }

            .modal-close {
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 1.5rem;
                color: #333;
                cursor: pointer;
            }

            .policy-item .title {
                font-weight: bold;
                margin-top: 15px;
            }

            .policy-item .content {
                white-space: pre-wrap;
                margin-top: 5px;
            }

        </style>
    </head>
    <body>
        <div class="signup-container animate__animated animate__fadeIn">
            <ul class="nav nav-tabs" id="signupTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/signup">Khách hàng</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" href="${pageContext.request.contextPath}/signup_transport">Đơn vị vận chuyển</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" href="${pageContext.request.contextPath}/signup_storage">Đơn vị kho bãi</a>
                </li>
            </ul>
            <h2 class="signup-header">Đăng ký tài khoản Khách hàng</h2>
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null && !error.trim().isEmpty()) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>
            <form action="signup" method="post" id="signupForm" novalidate>
                <div class="mb-3">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                    </div>
                    <div class="invalid-feedback">Tên đăng nhập phải từ 3 đến 20 ký tự.</div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                    <div class="invalid-feedback">Vui lòng nhập email hợp lệ.</div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
                    <div class="invalid-feedback">Mật khẩu phải có ít nhất 6 ký tự.</div>
                </div>
                <div class="mb-3">
                    <label>
                        <input type="checkbox" id="agreeCheck" onchange="toggleButton()"> Tôi đồng ý với 
                        <a href="javascript:void(0)" onclick="showModal()" style="color: #007bff; text-decoration: underline;">các chính sách</a>
                        của nhà phát triển.
                    </label>


                    <!-- Modal -->
                    <div class="overlay" id="overlay" onclick="hideModal()"></div>
                    <div class="modal" id="policyModal">
                        <span class="modal-close" onclick="hideModal()">×</span>
                        <div id="modalContent">
                        </div>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary w-100" id="submitBtn">Đăng ký</button>
            </form>
            <div class="login-link">
                Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
                            $(document).ready(function () {
                                const $submitBtn = $('#submitBtn');
                                const originalBtnText = $submitBtn.text();

                                $('#signupForm').on('submit', function (e) {
                                    let isValid = true;
                                    const $username = $('#username');
                                    const $email = $('#email');
                                    const $password = $('#password');

                                    $('.form-control').removeClass('is-invalid');

                                    if ($username.val().length < 3 || $username.val().length > 20) {
                                        $username.addClass('is-invalid');
                                        isValid = false;
                                    }

                                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                    if (!emailRegex.test($email.val())) {
                                        $email.addClass('is-invalid');
                                        isValid = false;
                                    }

                                    if ($password.val().length < 6) {
                                        $password.addClass('is-invalid');
                                        isValid = false;
                                    }

                                    if (!isValid) {
                                        e.preventDefault();
                                    } else {
                                        $submitBtn.text('Đang xử lý...').prop('disabled', true);
                                    }
                                });
                            });
        </script>
        <script>
            function toggleButton() {
                const checkbox = document.getElementById("agreeCheck");
                const button = document.getElementById("confirmBtn");
                if (button) {
                    button.disabled = !checkbox.checked;
                }
            }

            function showModal() {
                document.getElementById("overlay").style.display = "block";
                document.getElementById("policyModal").style.display = "block";
                fetch('${pageContext.request.contextPath}/get-policy-data')
                        .then(response => {
                            if (!response.ok)
                                throw new Error("Lỗi khi tải dữ liệu");
                            return response.text();
                        })
                        .then(html => {
                            document.getElementById("modalContent").innerHTML = html;
                        })
                        .catch(error => {
                            document.getElementById("modalContent").innerHTML = "<p class='text-danger'>Không thể tải chính sách. Vui lòng thử lại sau.</p>";
                            console.error(error);
                        });
            }

            function hideModal() {
                document.getElementById("overlay").style.display = "none";
                document.getElementById("policyModal").style.display = "none";
            }
        </script>    
    </body>
</html>