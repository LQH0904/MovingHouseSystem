<%-- 
    Document   : confirm.jsp
    Created on : Jun 4, 2025, 10:59:47 PM
    Author     : admin
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác nhận tài khoản - Dịch vụ vận chuyển nhà</title>
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
            .confirm-container {
                max-width: 400px;
                padding: 30px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
                animation: fadeIn 0.5s ease-in;
            }
            .confirm-header {
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
            .resend-link {
                text-align: center;
                margin-top: 15px;
                font-size: 0.9rem;
            }
            .resend-link a {
                color: #007bff;
                text-decoration: none;
            }
            .resend-link a:hover {
                text-decoration: underline;
            }
            .alert {
                font-size: 0.85rem;
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
                .confirm-container {
                    margin: 20px;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="confirm-container animate__animated animate__fadeIn">
            <h2 class="confirm-header">Xác nhận tài khoản</h2>

            <% 
                String error = (String) request.getAttribute("error"); 
                if (error == null) {
                    error = request.getParameter("error");
                }
                String success = request.getParameter("success");
                String resent = request.getParameter("resent");
            %>

            <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
            <% } else if (success != null) { %>
            <div class="alert alert-success">
                Tài khoản đã được tạo thành công! 
                <a href="<%= request.getContextPath() %>/login" class="alert-link">Vui lòng đăng nhập.</a>
            </div>
            <% } else if (resent != null) { %>
            <div class="alert alert-info">Mã xác nhận đã được gửi lại, vui lòng kiểm tra email.</div>
            <% } %>

            <form action="signup" method="post" id="confirmForm" novalidate>
                <input type="hidden" name="action" value="confirm">
                <div class="mb-3">
                    <label for="code" class="form-label">Mã xác nhận</label>
                    <div class="input-group">
                        <span class="input-group-text"><i class="fas fa-key"></i></span>
                        <input type="text" class="form-control" id="code" name="code" placeholder="Nhập mã 6 chữ số" required>
                    </div>
                    <div class="invalid-feedback">Mã xác nhận phải là 6 chữ số.</div>
                </div>
                <button type="submit" class="btn btn-primary w-100" id="submitBtn">Xác nhận</button>
            </form>
            <div class="resend-link mt-3">
                Chưa nhận được mã? <a href="signup?action=resend">Gửi lại mã</a>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                const $submitBtn = $('#submitBtn');

                $('#confirmForm').on('submit', function (e) {
                    let isValid = true;
                    const $code = $('#code');

                    $('.form-control').removeClass('is-invalid');

                    const codeRegex = /^\d{6}$/;
                    if (!codeRegex.test($code.val())) {
                        $code.addClass('is-invalid');
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