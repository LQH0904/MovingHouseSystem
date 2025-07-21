<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hồ sơ người dùng</title>
        
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/profile.css">

        <style>
            body {
                font-family: Arial, sans-serif;
                margin: 0;
                padding: 20px;
                background-color: #f5f5f5;
            }
            .profile-container {
                max-width: 1000px;
                margin: 0 auto;
                background: white;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .profile-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
                border-bottom: 1px solid #eee;
                padding-bottom: 20px;
            }
            .profile-avatar {
                width: 120px;
                height: 120px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 30px;
                border: 3px solid #ddd;
            }
            .profile-info {
                flex-grow: 1;
            }
            .profile-name {
                font-size: 24px;
                margin: 0 0 5px 0;
                color: #333;
            }
            .profile-email {
                color: #666;
                margin: 0 0 10px 0;
            }
            .profile-actions {
                margin-top: 20px;
            }
            .btn {
                padding: 10px 15px;
                margin-right: 10px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
                text-decoration: none;
                display: inline-block;
            }
            .btn-primary {
                background-color: #4CAF50;
                color: white;
            }
            .btn-secondary {
                background-color: #2196F3;
                color: white;
            }
            .btn-danger {
                background-color: #f44336;
                color: white;
            }
            .message {
                padding: 10px;
                margin-bottom: 20px;
                border-radius: 4px;
            }
            .success {
                background-color: #dff0d8;
                color: #3c763d;
            }
            .error {
                background-color: #f2dede;
                color: #a94442;
            }
            .section {
                margin-bottom: 30px;
                padding-bottom: 20px;
                border-bottom: 1px solid #eee;
            }
            .section-title {
                font-size: 18px;
                color: #333;
                margin-bottom: 15px;
            }
        </style>
    </head>
    <body>
        <div class="profile-container">
            <c:if test="${not empty message}">
                <div class="message success">${message}</div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="message error">${error}</div>
            </c:if>

            <div class="profile-header">
                <div class="profile-info">
                    <h1 class="profile-name">${profile.firstName} ${profile.lastName}</h1>
                    <p class="profile-email">${profile.email}</p>
                    <div class="profile-actions">
                        <a href="profile?action=update" class="btn btn-primary">Cập nhật thông tin</a>
                        <a href="page/staff/change-password.jsp" class="btn btn-secondary">Đổi mật khẩu</a>
                    </div>
                </div>
            </div>

            <div class="section">
                <h2 class="section-title">Thông tin cá nhân</h2>
                <p><strong>Họ và tên:</strong> ${profile.firstName} ${profile.lastName}</p>
                <p><strong>Email:</strong> ${profile.email}</p>
                <p><strong>Số điện thoại:</strong> ${profile.phoneNumber}</p>
                <p><strong>Ngày sinh:</strong> ${profile.dateOfBirth}</p>
                <p><strong>Giới tính:</strong> ${profile.gender}</p>
            </div>

            <div class="section">
                <h2 class="section-title">Địa chỉ</h2>
                <p><strong>Quốc gia:</strong> ${profile.country}</p>
                <p><strong>Thành phố:</strong> ${profile.city}</p>
                <p><strong>Quận/Huyện:</strong> ${profile.district}</p>
                <p><strong>Đường/Phố:</strong> ${profile.street}</p>
                <p><strong>Mã bưu điện:</strong> ${profile.postalCode}</p>
            </div>

            <div class="section">
                <h2 class="section-title">Tùy chỉnh</h2>
                <p><strong>Ngôn ngữ ưa thích:</strong> ${profile.languagePreference}</p>
                <p><strong>Giao diện:</strong> ${profile.themePreference}</p>

            </div>

            <div class="section">
                <h2 class="section-title">Liên kết mạng xã hội</h2>
                <p><strong>Facebook:</strong> ${profile.facebookLink}</p>
                <p><strong>Google:</strong> ${profile.googleLink}</p>
                <p><strong>Twitter:</strong> ${profile.twitterLink}</p>
            </div>
        </div>
    </body>
</html>