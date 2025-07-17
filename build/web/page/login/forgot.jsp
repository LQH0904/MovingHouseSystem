<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../../page/login/pass.jsp"/>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quên mật khẩu</title>
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
            .forgot-container {
                max-width: 500px;
                padding: 30px;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
                animation: fadeIn 0.5s ease-in;
            }
            .forgot-header {
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
            .form-group select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 8px;
                font-size: 16px;
                line-height: 1.5;
                height: auto;
                min-height: 44px;
                box-sizing: border-box;
            }
            .btn-primary, .btn-success {
                background: #007bff;
                border: none;
                border-radius: 8px;
                padding: 12px;
                font-weight: 600;
                transition: transform 0.2s, background 0.3s;
            }
            .btn-primary:hover, .btn-success:hover {
                background: #0056b3;
                transform: scale(1.05);
            }
            .btn-secondary {
                background: #6c757d;
                border: none;
                border-radius: 8px;
                padding: 10px;
                font-weight: 600;
                transition: transform 0.2s, background 0.3s;
            }
            .btn-secondary:hover {
                background: #5a6268;
                transform: scale(1.05);
            }
            .message {
                font-size: 0.85rem;
                color: #dc3545;
                text-align: center;
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
                .forgot-container {
                    margin: 20px;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="forgot-container animate__animated animate__fadeIn">
            <a href="login" class="btn btn-secondary back-button">← Quay lại Đăng nhập</a>
            <h2 class="forgot-header">Quên mật khẩu</h2>

            <!-- Step 1: Enter email and role -->
            <c:if test="${empty requestScope.step || requestScope.step == 'enterEmail'}">
                <p class="text-center">Vui lòng chọn vai trò và nhập email để khôi phục mật khẩu</p>
                <form action="forgot" method="post">
                    <div class="form-group">
                        <select name="role_id" id="role_id" required class="form-control">
                            <option value="2">Điều hành</option>
                            <option value="3">Nhân viên</option>
                            <option value="4">Đơn vị vận chuyển</option>
                            <option value="5">Đơn vị kho bãi</option>
                            <option value="6" selected>Khách hàng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-envelope"></i></span>
                            <input type="email" name="email" placeholder="Địa chỉ Email" required
                                   value="${requestScope.email != null ? requestScope.email : ''}" class="form-control" />
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary w-100">Gửi mã khôi phục</button>
                </form>
                <c:if test="${not empty requestScope.message}">
                    <p class="message mt-3">${requestScope.message}</p>
                </c:if>
            </c:if>

            <!-- Step 2: Enter code -->
            <c:if test="${requestScope.step == 'enterCode'}">
                <p class="text-center">Mã khôi phục đã được gửi đến email:</p>
                <p class="text-center"><strong>${requestScope.email}</strong></p>
                <form action="confirmresetcode" method="post">
                    <input type="hidden" name="email" value="${requestScope.email}" />
                    <input type="hidden" name="role_id" value="${requestScope.role_id}" />
                    <div class="form-group">
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-key"></i></span>
                            <input type="text" name="resetcode" placeholder="Nhập mã khôi phục" required
                                   value="${requestScope.code != null ? requestScope.code : ''}" class="form-control" />
                        </div>
                    </div>
                    <button type="submit" class="btn btn-success w-100">Xác nhận mã khôi phục</button>
                </form>
                <c:if test="${not empty requestScope.message}">
                    <p class="message mt-3">${requestScope.message}</p>
                </c:if>
            </c:if>
        </div>
    </body>
</html>