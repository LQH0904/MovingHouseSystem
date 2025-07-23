<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật thông tin cá nhân</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/Info.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    </head>
    <body>
        <div class="form-container">
             
            <h1>Cập nhật thông tin cá nhân</h1>
            

            <form action="http://localhost:9999/HouseMovingSystem/profile" method="post">
                <input type="hidden" name="action" value="updateBasicInfo">

                <h2 class="section-title">Thông tin cơ bản</h2>
                <div class="form-row">
                    <div class="form-group">
                        <label for="firstName">Họ</label>
                        <input type="text" id="firstName" name="firstName" value="${profile.firstName}" required>
                    </div>
                    <div class="form-group">
                        <label for="lastName">Tên</label>
                        <input type="text" id="lastName" name="lastName" value="${profile.lastName}" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" value="${profile.email}" required disabled>
                </div>

                <div class="form-group">
                    <label for="phoneNumber">Số điện thoại</label>
                    <input type="tel" id="phoneNumber" name="phoneNumber" value="${profile.phoneNumber}">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="dateOfBirth">Ngày sinh</label>
                        <input type="date" id="dateOfBirth" name="dateOfBirth" value="${profile.dateOfBirth}">
                    </div>
                    <div class="form-group">
                        <label for="gender">Giới tính</label>
                        <select id="gender" name="gender">
                            <option value="Nam" ${profile.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                            <option value="Nữ" ${profile.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            <option value="Khác" ${profile.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                        </select>
                    </div>
                </div>

                <h2 class="section-title">Địa chỉ</h2>
                <div class="form-group">
                    <label for="country">Quốc gia</label>
                    <input type="text" id="country" name="country" value="${profile.country}">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="city">Thành phố</label>
                        <input type="text" id="city" name="city" value="${profile.city}">
                    </div>
                    <div class="form-group">
                        <label for="district">Quận/Huyện</label>
                        <input type="text" id="district" name="district" value="${profile.district}">
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="street">Đường/Phố</label>
                        <input type="text" id="street" name="street" value="${profile.street}">
                    </div>
                    <div class="form-group">
                        <label for="postalCode">Mã bưu điện</label>
                        <input type="text" id="postalCode" name="postalCode" value="${profile.postalCode}">
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                    <a href="profile" class="btn btn-secondary">Hủy bỏ</a>
                </div>
            </form>
        </div>
    </body>
</html>