<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Chi Tiết Người Dùng</title>
    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fc;
        }

        .layout-container {
            display: flex;
            height: 100vh;
        }

        .sidebar {
            width: 250px;
            background-color: #1e1e2f;
            color: white;
            height: 100vh;
            overflow-y: auto;
            position: fixed;
            top: 0;
            left: 0;
        }

        .main-content {
            margin-left: 250px;
            width: calc(100% - 250px);
            display: flex;
            flex-direction: column;
            height: 100vh;
        }

        .header {
            height: 70px;
            background-color: #4e61cb;
            color: white;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 20px;
            flex-shrink: 0;
        }

        .header-right {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        .content {
            flex-grow: 1;
            overflow-y: auto;
            padding: 30px;
        }

        h2.user-list-title {
            margin-bottom: 20px;
            text-align: center;
        }

        .user-list-table {
            width: 100%;
            border-collapse: collapse;
            background-color: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
        }

        .user-list-table th {
            background-color: #3BAFDA;
            color: white;
            text-align: left;
            padding: 12px 16px;
            width: 30%;
        }

        .user-list-table td {
            padding: 12px 16px;
            background-color: #f8f9fc;
        }

        .add-user-btn {
            margin-top: 20px;
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
        }

        .add-user-btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
<div class="layout-container">
    <div class="sidebar">
        <jsp:include page="/Layout/operator/SideBar.jsp"/>
    </div>

    <div class="main-content">
        <div class="header">
            <div class="logo">
                <img src="${pageContext.request.contextPath}/images/logo.png" alt="Logo" height="50" />
            </div>
            <div class="header-right">
                <button class="add-user-btn">Tài Khoản</button>
                <button class="add-user-btn" style="background-color: gray;">Đăng Xuất</button>
            </div>
        </div>

        <div class="content">
            <h2 class="user-list-title">Chi Tiết Người Dùng</h2>

            <c:choose>
                <c:when test="${roleId == 2 || roleId == 3 || roleId == 6}">
                    <table class="user-list-table">
                        <tr><th>Tên người dùng</th><td>${user.username}</td></tr>
                        <tr><th>Email</th><td>${user.email}</td></tr>
                        <tr><th>Vai trò</th><td>${user.role.roleName}</td></tr>
                        <tr><th>Trạng thái</th><td>${user.status}</td></tr>
                        <tr><th>Ngày tạo</th><td>${user.createdAt}</td></tr>
                        <tr><th>Ngày cập nhật</th><td>${user.updatedAt}</td></tr>
                    </table>
                </c:when>

                <c:when test="${roleId == 4}">
                    <table class="user-list-table">
                        <tr><th>Tên công ty</th><td>${transportUnit.companyName}</td></tr>
                        <tr><th>Thông tin liên hệ</th><td>${transportUnit.contactInfo}</td></tr>
                        <tr><th>Trạng thái đăng ký</th><td>${transportUnit.registrationStatus}</td></tr>
                        <tr><th>Ngày tạo</th><td>${transportUnit.createdAt}</td></tr>
                        <tr><th>Địa điểm</th><td>${transportUnit.location}</td></tr>
                        <tr><th>Số lượng xe</th><td>${transportUnit.vehicleCount}</td></tr>
                        <tr><th>Sức chứa</th><td>${transportUnit.capacity}</td></tr>
                        <tr><th>Người bốc xếp</th><td>${transportUnit.loader}</td></tr>
                        <tr><th>Giấy phép kinh doanh</th><td>${transportUnit.businessCertificate}</td></tr>
                        <tr><th>Bảo hiểm</th><td>${transportUnit.insurance}</td></tr>
                    </table>
                </c:when>

                <c:when test="${roleId == 5}">
                    <table class="user-list-table">
                        <tr><th>Tên kho</th><td>${storageUnit.warehouseName}</td></tr>
                        <tr><th>Địa điểm</th><td>${storageUnit.location}</td></tr>
                        <tr><th>Trạng thái đăng ký</th><td>${storageUnit.registrationStatus}</td></tr>
                        <tr><th>Ngày tạo</th><td>${storageUnit.createdAt}</td></tr>
                        <tr><th>Giấy phép KD</th><td>${storageUnit.businessCertificate}</td></tr>
                        <tr><th>Diện tích</th><td>${storageUnit.area}</td></tr>
                        <tr><th>Số nhân viên</th><td>${storageUnit.employee}</td></tr>
                        <tr><th>SĐT</th><td>${storageUnit.phoneNumber}</td></tr>
                    </table>
                </c:when>

                <c:otherwise>
                    <p>Không tìm thấy thông tin chi tiết cho người dùng này.</p>
                </c:otherwise>
            </c:choose>

            <br><button onclick="history.back()" class="add-user-btn">Quay lại</button>
        </div>
    </div>
</div>
</body>
</html>
