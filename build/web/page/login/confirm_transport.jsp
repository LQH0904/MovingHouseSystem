<%-- 
    Document   : confirm_transport
    Created on : Jun 17, 2025, 03:04:00 AM
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác nhận Đăng ký Đơn vị Vận chuyển</title>
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
        .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 8px;
            padding: 12px;
            font-weight: 600;
            transition: transform 0.2s, background 0.3s;
        }
        .btn-secondary:hover {
            background: #5a6268;
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
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @media (max-width: 576px) {
            .confirm-container { margin: 20px; padding: 20px; }
        }
    </style>
</head>
<body>
    <div class="confirm-container animate__animated animate__fadeIn">
        <h2 class="confirm-header">Xác nhận Đăng ký</h2>
        <% String error = (String) request.getAttribute("error"); %>
        <% String success = (String) request.getAttribute("success"); %>
        <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
        <% } %>
        <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
        <div class="login-link">
            <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
        <% } else { %>
        <form action="signup_transport" method="post" id="confirmForm" novalidate>
            <input type="hidden" name="action" value="confirm">
            <div class="mb-3">
                <label for="code" class="form-label">Mã xác nhận</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-key"></i></span>
                    <input type="text" class="form-control" id="code" name="code" placeholder="Nhập mã xác nhận" required>
                </div>
                <div class="invalid-feedback">Vui lòng nhập mã xác nhận.</div>
            </div>
            <button type="submit" class="btn btn-primary w-100 mb-2" id="submitBtn">Xác nhận</button>
            <button type="button" class="btn btn-secondary w-100" id="resendBtn" onclick="resendCode()">Gửi lại mã</button>
        </form>
        <div class="login-link">
            Đã có tài khoản? <a href="${pageContext.request.contextPath}/login">Đăng nhập</a>
        </div>
        <% } %>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function () {
            const $submitBtn = $('#submitBtn');
            const originalBtnText = $submitBtn.text();

            $('#confirmForm').on('submit', function (e) {
                let isValid = true;
                $('.form-control').removeClass('is-invalid');

                const $code = $('#code');
                if (!$code.val()) {
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

        function resendCode() {
            const $resendBtn = $('#resendBtn');
            $resendBtn.text('Đang gửi...').prop('disabled', true);
            $.ajax({
                url: '${pageContext.request.contextPath}/signup_transport',
                type: 'POST',
                data: { action: 'resend' },
                success: function(response) {
                    window.location.reload(); // Reload để hiển thị thông báo
                },
                error: function(xhr, status, error) {
                    $resendBtn.text('Gửi lại mã').prop('disabled', false);
                    alert('Gửi mã thất bại, vui lòng thử lại.');
                }
            });
        }
    </script>
</body>
</html>