<%-- 
    Document   : signup_storage
    Created on : Jun 17, 2025, 02:42:00 AM
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký Đơn vị Kho bãi</title>
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
        </style>
    </head>
    <body>
        <div class="signup-container animate__animated animate__fadeIn">
            <ul class="nav nav-tabs" id="signupTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link" href="${pageContext.request.contextPath}/signup">Khách hàng</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" href="${pageContext.request.contextPath}/signup_transport">Đơn vị vận chuyển</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/signup_storage">Đơn vị kho bãi</a>
                </li>
            </ul>
            <h2 class="signup-header">Đăng ký Đơn vị Kho bãi</h2>
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>
            <form action="signup_storage" method="post" id="signupForm" enctype="multipart/form-data" novalidate>
                <div class="mb-3">
                    <label for="warehouse_name" class="form-label">Tên kho bãi</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-warehouse"></i></span>
                        <input type="text" class="form-control" id="warehouse_name" name="warehouse_name" placeholder="Nhập tên kho bãi" required>
                    </div>
                    <div class="invalid-feedback">Tên kho bãi phải từ 3 đến 150 ký tự.</div>
                </div>
                <div class="mb-3">
                    <label for="phone_number" class="form-label">Số điện thoại</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                        <input type="text" class="form-control" id="phone_number" name="phone_number" placeholder="Nhập số điện thoại" required>
                    </div>
                    <div class="invalid-feedback">Vui lòng nhập số điện thoại hợp lệ (10-15 chữ số).</div>
                </div>
                <div class="mb-3">
                    <label for="business_certificate" class="form-label">Giấy phép kinh doanh (ảnh)</label>
                    <div class="input-group">
                        <input type="file" class="form-control" id="business_certificate" name="business_certificate" accept=".jpg,.jpeg,.png" required>
                    </div>
                    <div class="invalid-feedback">Vui lòng chọn file ảnh (.jpg, .jpeg, .png).</div>
                </div>
                <div class="mb-3">
                    <label for="location" class="form-label">Địa điểm</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                        <input type="text" class="form-control" id="location" name="location" placeholder="Nhập địa điểm">
                    </div>
                    <div class="invalid-feedback">Địa điểm phải từ 5 đến 255 ký tự.</div>
                </div>
                <div class="mb-3">
                    <label for="area" class="form-label">Diện tích (m²)</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-ruler"></i></span>
                        <input type="text" class="form-control" id="area" name="area" placeholder="Nhập diện tích" pattern="^\\d+(\\.\\d{1,2})?$">
                    </div>
                    <div class="invalid-feedback">Vui lòng nhập diện tích hợp lệ (tối đa 200 ký tự, định dạng số với tối đa 2 chữ số thập phân).</div>
                </div>
                <div class="mb-3">
                    <label for="employee" class="form-label">Số lượng nhân viên</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-users"></i></span>
                        <input type="number" class="form-control" id="employee" name="employee" placeholder="Nhập số lượng nhân viên" min="0" required>
                    </div>
                    <div class="invalid-feedback">Vui lòng nhập số lượng hợp lệ.</div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email" required>
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
                    $('.form-control').removeClass('is-invalid');

                    const $warehouse_name = $('#warehouse_name');
                    if ($warehouse_name.val().length < 3 || $warehouse_name.val().length > 150) {
                        $warehouse_name.addClass('is-invalid');
                        isValid = false;
                    }

                    const $phone_number = $('#phone_number');
                    const phoneRegex = /^[0-9]{10,15}$/;
                    if (!phoneRegex.test($phone_number.val())) {
                        $phone_number.addClass('is-invalid');
                        isValid = false;
                    }

                    const $business_certificate = $('#business_certificate');
                    if (!$business_certificate.val()) {
                        $business_certificate.addClass('is-invalid');
                        isValid = false;
                    } else {
                        const allowedExtensions = /(\.jpg|\.jpeg|\.png)$/i;
                        if (!allowedExtensions.test($business_certificate.val())) {
                            $business_certificate.addClass('is-invalid');
                            isValid = false;
                        }
                    }

                    const $location = $('#location');
                    if ($location.val() && ($location.val().length < 5 || $location.val().length > 255)) {
                        $location.addClass('is-invalid');
                        isValid = false;
                    }

                    const $area = $('#area');
                    const areaRegex = /^\d+(\.\d{1,2})?$/;
                    if ($area.val() && ($area.val().length > 200 || !areaRegex.test($area.val()))) {
                        $area.addClass('is-invalid');
                        isValid = false;
                    }

                    const $employee = $('#employee');
                    if ($employee.val() < 0) {
                        $employee.addClass('is-invalid');
                        isValid = false;
                    }

                    const $email = $('#email');
                    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
                    if (!emailRegex.test($email.val())) {
                        $email.addClass('is-invalid');
                        isValid = false;
                    }

                    const $password = $('#password');
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
    </body>
</html>