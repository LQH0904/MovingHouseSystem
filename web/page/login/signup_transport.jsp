<%-- 
    Document   : signup_transport
    Created on : Jun 17, 2025, 02:42:00 AM
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng ký Đơn vị Vận chuyển</title>
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
        </style>
    </head>
    <body>
        <div class="signup-container animate__animated animate__fadeIn">
            <ul class="nav nav-tabs" id="signupTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <a class="nav-link" href="${pageContext.request.contextPath}/signup">Khách hàng</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link active" href="${pageContext.request.contextPath}/signup_transport">Đơn vị vận chuyển</a>
                </li>
                <li class="nav-item" role="presentation">
                    <a class="nav-link" href="${pageContext.request.contextPath}/signup_storage">Đơn vị kho bãi</a>
                </li>
            </ul>
            <h2 class="signup-header">Đăng ký Đơn vị Vận chuyển</h2>
            <% String error = (String) request.getAttribute("error"); %>
            <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } %>
            <form action="signup_transport" method="post" id="signupForm" enctype="multipart/form-data" novalidate>
                <div class="mb-3">
                    <label for="company_name" class="form-label">Tên công ty</label>
                    <div class="error-message" id="company_name_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-building"></i></span>
                        <input type="text" class="form-control" id="company_name" name="company_name" placeholder="Nhập tên công ty" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="contact_info" class="form-label">Thông tin liên hệ</label>
                    <div class="error-message" id="contact_info_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-phone"></i></span>
                        <input type="text" class="form-control" id="contact_info" name="contact_info" placeholder="Email hoặc số điện thoại">
                    </div>
                </div>
                <div class="mb-3">
                    <label for="business_certificate" class="form-label">Giấy phép kinh doanh (ảnh)</label>
                    <div class="error-message" id="business_certificate_error"></div>
                    <div class="input-group">
                        <input type="file" class="form-control" id="business_certificate" name="business_certificate" accept=".jpg,.jpeg,.png" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="insurance" class="form-label">Giấy tờ bảo hiểm (ảnh)</label>
                    <div class="error-message" id="insurance_error"></div>
                    <div class="input-group">
                        <input type="file" class="form-control" id="insurance" name="insurance" accept=".jpg,.jpeg,.png" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="location" class="form-label">Địa điểm</label>
                    <div class="error-message" id="location_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-map-marker-alt"></i></span>
                        <input type="text" class="form-control" id="location" name="location" placeholder="Nhập địa điểm">
                    </div>
                </div>
                <div class="mb-3">
                    <label for="vehicle_count" class="form-label">Số lượng xe</label>
                    <div class="error-message" id="vehicle_count_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-truck"></i></span>
                        <input type="number" class="form-control" id="vehicle_count" name="vehicle_count" placeholder="Nhập số lượng xe" min="1" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="capacity" class="form-label">Tải trọng (tấn)</label>
                    <div class="error-message" id="capacity_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-weight-hanging"></i></span>
                        <input type="number" class="form-control" id="capacity" name="capacity" placeholder="Nhập tải trọng" step="0.1" min="0.1" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="loader" class="form-label">Số lượng nhân viên bốc vác</label>
                    <div class="error-message" id="loader_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-users"></i></span>
                        <input type="number" class="form-control" id="loader" name="loader" placeholder="Nhập số lượng nhân viên" min="0" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label for="email" class="form-label">Email</label>
                    <div class="error-message" id="email_error"></div>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                        <input type="email" class="form-control" id="email" name="email" placeholder="Nhập email" required>
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

                    // Validate company_name
                    const $company_name = $('#company_name');
                    if (!$company_name.val()) {
                        $('#company_name_error').text('Vui lòng nhập tên công ty.').show();
                        $company_name.addClass('is-invalid');
                        isValid = false;
                    } else if ($company_name.val().length < 3 || $company_name.val().length > 150) {
                        $('#company_name_error').text('Tên công ty phải từ 3 đến 150 ký tự.').show();
                        $company_name.addClass('is-invalid');
                        isValid = false;
                    }

                    // Validate contact_info
                    const $contact_info = $('#contact_info');
                    if ($contact_info.val() && ($contact_info.val().length < 5 || $contact_info.val().length > 255)) {
                        $('#contact_info_error').text('Thông tin liên hệ phải từ 5 đến 255 ký tự.').show();
                        $contact_info.addClass('is-invalid');
                        isValid = false;
                    }

                    // Validate business_certificate
                    const $business_certificate = $('#business_certificate');
                    if (!$business_certificate.val()) {
                        $('#business_certificate_error').text('Vui lòng chọn file giấy phép kinh doanh.').show();
                        $business_certificate.addClass('is-invalid');
                        isValid = false;
                    } else {
                        const allowedExtensions = /(\.jpg|\.jpeg|\.png)$/i;
                        if (!allowedExtensions.test($business_certificate.val())) {
                            $('#business_certificate_error').text('File phải có định dạng .jpg, .jpeg hoặc .png.').show();
                            $business_certificate.addClass('is-invalid');
                            isValid = false;
                        }
                    }

                    // Validate insurance
                    const $insurance = $('#insurance');
                    if (!$insurance.val()) {
                        $('#insurance_error').text('Vui lòng chọn file giấy tờ bảo hiểm.').show();
                        $insurance.addClass('is-invalid');
                        isValid = false;
                    } else {
                        const allowedExtensions = /(\.jpg|\.jpeg|\.png)$/i;
                        if (!allowedExtensions.test($insurance.val())) {
                            $('#insurance_error').text('File bảo hiểm phải có định dạng .jpg, .jpeg hoặc .png.').show();
                            $insurance.addClass('is-invalid');
                            isValid = false;
                        }
                    }

                    // Validate location
                    const $location = $('#location');
                    if ($location.val() && ($location.val().length < 5 || $location.val().length > 100)) {
                        $('#location_error').text('Địa điểm phải từ 5 đến 100 ký tự.').show();
                        $location.addClass('is-invalid');
                        isValid = false;
                    }

                    // Validate vehicle_count
                    const $vehicle_count = $('#vehicle_count');
                    if (!$vehicle_count.val()) {
                        $('#vehicle_count_error').text('Vui lòng nhập số lượng xe.').show();
                        $vehicle_count.addClass('is-invalid');
                        isValid = false;
                    } else if ($vehicle_count.val() < 1) {
                        $('#vehicle_count_error').text('Số lượng xe phải tối thiểu 1.').show();
                        $vehicle_count.addClass('is-invalid');
                        isValid = false;
                    }

                    // Validate capacity
                    const $capacity = $('#capacity');
                    if (!$capacity.val()) {
                        $('#capacity_error').text('Vui lòng nhập tải trọng.').show();
                        $capacity.addClass('is-invalid');
                        isValid = false;
                    } else if ($capacity.val() < 0.1) {
                        $('#capacity_error').text('Tải trọng phải tối thiểu 0.1 tấn.').show();
                        $capacity.addClass('is-invalid');
                        isValid = false;
                    }

                    // Validate loader
                    const $loader = $('#loader');
                    if (!$loader.val()) {
                        $('#loader_error').text('Vui lòng nhập số lượng nhân viên bốc vác.').show();
                        $loader.addClass('is-invalid');
                        isValid = false;
                    } else if ($loader.val() < 0) {
                        $('#loader_error').text('Số lượng nhân viên không được âm.').show();
                        $loader.addClass('is-invalid');
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