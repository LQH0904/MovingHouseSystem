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
            .error-message {
                color: #dc3545;
                font-size: 0.85rem;
                margin-bottom: 5px;
                display: none;
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
            /* ===== CSS CHO MODAL CHÍNH SÁCH ===== */

            /* Overlay */
            .overlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(4px);
                z-index: 999;
                animation: fadeIn 0.3s ease;
            }

            /* Modal container */
            .modal {
                display: none;
                position: fixed;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                width: 90%;
                max-width: 700px;
                max-height: 85vh;
                background: white;
                border-radius: 16px;
                box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
                z-index: 1000;
                animation: modalSlideIn 0.4s ease;
                overflow: hidden;
            }

            @keyframes modalSlideIn {
                from {
                    opacity: 0;
                    transform: translate(-50%, -60%);
                    scale: 0.9;
                }
                to {
                    opacity: 1;
                    transform: translate(-50%, -50%);
                    scale: 1;
                }
            }

            /* Modal header */
            .modal::before {
                content: "Chính Sách & Điều Khoản";
                display: block;
                background: linear-gradient(135deg, #007bff 0%, #0056b3 100%);
                color: white;
                padding: 24px 30px;
                font-size: 20px;
                font-weight: 600;
                margin: 0;
                position: relative;
            }

            /* Modal close button */
            .modal-close {
                position: absolute;
                top: 20px;
                right: 25px;
                font-size: 28px;
                font-weight: 300;
                cursor: pointer;
                color: white;
                opacity: 0.8;
                transition: all 0.3s ease;
                width: 35px;
                height: 35px;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
                z-index: 1001;
            }

            .modal-close:hover {
                opacity: 1;
                background: rgba(255, 255, 255, 0.15);
                transform: rotate(90deg);
            }

            /* Modal content area */
            #modalContent {
                padding: 30px;
                max-height: 60vh;
                overflow-y: auto;
                background: #fff;
            }

            /* Custom scrollbar cho modal content */
            #modalContent::-webkit-scrollbar {
                width: 8px;
            }

            #modalContent::-webkit-scrollbar-track {
                background: #f1f1f1;
                border-radius: 4px;
            }

            #modalContent::-webkit-scrollbar-thumb {
                background: linear-gradient(135deg, #007bff, #0056b3);
                border-radius: 4px;
            }

            #modalContent::-webkit-scrollbar-thumb:hover {
                background: linear-gradient(135deg, #0056b3, #004085);
            }

            /* ===== POLICY ITEMS - PHẦN CHÍNH ===== */

            .policy-item {
                margin-bottom: 28px;
                padding: 24px;
                background: linear-gradient(145deg, #f8f9fa 0%, #ffffff 100%);
                border-radius: 12px;
                border-left: 4px solid #007bff;
                transition: all 0.3s ease;
                position: relative;
                box-shadow: 0 2px 8px rgba(0, 123, 255, 0.08);
            }

            .policy-item:hover {
                background: linear-gradient(145deg, #e3f2fd 0%, #f8f9fa 100%);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0, 123, 255, 0.15);
                border-left-color: #0056b3;
            }

            .policy-item:last-child {
                margin-bottom: 0;
            }

            /* Policy item title */
            .policy-item .title {
                font-size: 18px;
                font-weight: 700;
                color: #2c3e50;
                margin-top: 0;
                margin-bottom: 16px;
                display: flex;
                align-items: center;
                gap: 12px;
                position: relative;
                line-height: 1.4;
            }

            .policy-item .title::before {
                content: "";
                width: 10px;
                height: 10px;
                background: linear-gradient(135deg, #007bff, #0056b3);
                border-radius: 50%;
                flex-shrink: 0;
                box-shadow: 0 2px 4px rgba(0, 123, 255, 0.3);
            }

            /* Policy item content */
            .policy-item .content {
                font-size: 15px;
                line-height: 1.7;
                color: #495057;
                white-space: pre-wrap;
                margin-top: 5px;
                margin-left: 22px;
                text-align: justify;
                position: relative;
            }

            .policy-item .content::first-line {
                font-weight: 500;
                color: #343a40;
            }

            /* Màu sắc khác nhau cho từng policy item */
            .policy-item:nth-child(1) {
                border-left-color: #dc3545;
            }

            .policy-item:nth-child(1) .title::before {
                background: linear-gradient(135deg, #dc3545, #c82333);
            }

            .policy-item:nth-child(1):hover {
                background: linear-gradient(145deg, #f8d7da 0%, #ffffff 100%);
                box-shadow: 0 8px 25px rgba(220, 53, 69, 0.15);
            }

            .policy-item:nth-child(2) {
                border-left-color: #fd7e14;
            }

            .policy-item:nth-child(2) .title::before {
                background: linear-gradient(135deg, #fd7e14, #e8650e);
            }

            .policy-item:nth-child(2):hover {
                background: linear-gradient(145deg, #ffeaa7 0%, #ffffff 100%);
                box-shadow: 0 8px 25px rgba(253, 126, 20, 0.15);
            }

            .policy-item:nth-child(3) {
                border-left-color: #28a745;
            }

            .policy-item:nth-child(3) .title::before {
                background: linear-gradient(135deg, #28a745, #1e7e34);
            }

            .policy-item:nth-child(3):hover {
                background: linear-gradient(145deg, #d4edda 0%, #ffffff 100%);
                box-shadow: 0 8px 25px rgba(40, 167, 69, 0.15);
            }

            .policy-item:nth-child(4) {
                border-left-color: #17a2b8;
            }

            .policy-item:nth-child(4) .title::before {
                background: linear-gradient(135deg, #17a2b8, #138496);
            }

            .policy-item:nth-child(4):hover {
                background: linear-gradient(145deg, #d1ecf1 0%, #ffffff 100%);
                box-shadow: 0 8px 25px rgba(23, 162, 184, 0.15);
            }

            /* Loading state */
            .modal-loading {
                text-align: center;
                padding: 60px 20px;
            }

            .modal-loading::before {
                content: "";
                display: inline-block;
                width: 40px;
                height: 40px;
                border: 4px solid #f3f3f3;
                border-top: 4px solid #007bff;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-bottom: 20px;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Error state */
            .modal-error {
                background: linear-gradient(145deg, #f8d7da 0%, #ffffff 100%);
                border-left-color: #dc3545;
                color: #721c24;
            }

            .modal-error .title {
                color: #dc3545;
            }

            /* Responsive cho modal */
            @media (max-width: 768px) {
                .modal {
                    width: 95%;
                    max-height: 90vh;
                    margin: 20px;
                }

                .modal::before {
                    padding: 20px;
                    font-size: 18px;
                }

                .modal-close {
                    top: 15px;
                    right: 20px;
                    font-size: 24px;
                }

                #modalContent {
                    padding: 20px;
                    max-height: 65vh;
                }

                .policy-item {
                    padding: 20px;
                    margin-bottom: 20px;
                }

                .policy-item .title {
                    font-size: 16px;
                    gap: 10px;
                }

                .policy-item .title::before {
                    width: 8px;
                    height: 8px;
                }

                .policy-item .content {
                    font-size: 14px;
                    margin-left: 18px;
                }
            }

            @media (max-width: 480px) {
                .modal {
                    width: 98%;
                    margin: 10px;
                }

                .modal::before {
                    padding: 16px;
                    font-size: 16px;
                }

                #modalContent {
                    padding: 16px;
                }

                .policy-item {
                    padding: 16px;
                }

                .policy-item .title {
                    font-size: 15px;
                }

                .policy-item .content {
                    font-size: 13px;
                    margin-left: 16px;
                }
            }

            /* Animation khi đóng modal */
            .modal.closing {
                animation: modalSlideOut 0.3s ease forwards;
            }

            .overlay.closing {
                animation: fadeOut 0.3s ease forwards;
            }

            @keyframes modalSlideOut {
                from {
                    opacity: 1;
                    transform: translate(-50%, -50%);
                    scale: 1;
                }
                to {
                    opacity: 0;
                    transform: translate(-50%, -60%);
                    scale: 0.9;
                }
            }

            @keyframes fadeOut {
                from {
                    opacity: 1;
                }
                to {
                    opacity: 0;
                }
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
            <% if (error != null) {%>
            <div class="alert alert-danger"><%= error%></div>
            <% }%>
            <form action="signup" method="post" id="signupForm" novalidate>
                <div class="mb-3">
                    <label for="username" class="form-label">Tên đăng nhập</label>
                    <div class="error-message" id="username_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-user"></i></span>
                        <input type="text" class="form-control" id="username" name="username" placeholder="Nhập tên đăng nhập" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="error-message" id="email_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email của bạn" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <div class="error-message" id="password_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-lock"></i></span>
                        <input type="password" class="form-control" id="password" name="password" placeholder="Nhập mật khẩu" required>
                    </div>
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
                                    $('.error-message').hide().text('');
                                    $('.form-control').removeClass('is-invalid');

                                    // Validate username
                                    const $username = $('#username');
                                    if (!$username.val()) {
                                        $('#username_error').text('Vui lòng nhập tên đăng nhập.').show();
                                        $username.addClass('is-invalid');
                                        isValid = false;
                                    } else if ($username.val().length < 3 || $username.val().length > 20) {
                                        $('#username_error').text('Tên đăng nhập phải từ 3 đến 20 ký tự.').show();
                                        $username.addClass('is-invalid');
                                        isValid = false;
                                    }

                                    // Validate email
                                    const $email = $('#email');
                                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                                    if (!$email.val()) {
                                        $('#email_error').text('Vui lòng nhập email.').show();
                                        $email.addClass('is-invalid');
                                        isValid = false;
                                    } else if (!emailRegex.test($email.val())) {
                                        $('#email_error').text('Vui lòng nhập email hợp lệ.').show();
                                        $email.addClass('is-invalid');
                                        isValid = false;
                                    }

                                    // Validate password
                                    const $password = $('#password');
                                    if (!$password.val()) {
                                        $('#password_error').text('Vui lòng nhập mật khẩu.').show();
                                        $password.addClass('is-invalid');
                                        isValid = false;
                                    } else if ($password.val().length < 6) {
                                        $('#password_error').text('Mật khẩu phải có ít nhất 6 ký tự.').show();
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



                            function toggleButton() {
                                const checkbox = document.getElementById("agreeCheck");
                                const button = document.getElementById("confirmBtn");
                                if (button) {
                                    button.disabled = !checkbox.checked;
                                }
                            }
                            const contextPath = '${pageContext.request.contextPath}';

                            function showModal() {
                                document.getElementById("overlay").style.display = "block";
                                document.getElementById("policyModal").style.display = "block";
                                fetch(contextPath + '/get-policy-data')

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
                            document.getElementById("submitBtn").disabled = true; // Khóa nút ban đầu

                            function toggleButton() {
                                const checkbox = document.getElementById("agreeCheck");
                                const button = document.getElementById("submitBtn");
                                button.disabled = !checkbox.checked;
                            }
        </script>
    </body>
</html>