<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chi tiết đơn vị vận chuyển</title>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        table {
            border-collapse: collapse;
            width: 800px;
        }
        td {
            padding: 8px;
            border: 1px solid #ccc;
        }
        td:first-child {
            background-color: #f2f2f2;
            font-weight: bold;
            width: 200px;
        }
        img {
            max-width: 300px;
            border: 1px solid #ccc;
            padding: 4px;
        }
    </style>
</head>
<body>
    <h2>Chi Tiết Đơn Vị Vận Chuyển</h2>
    <table>
        <tr><td>Tên công ty:</td><td>${transport.companyName}</td></tr>
        <tr><td>Thông tin liên hệ:</td><td>${transport.contactInfo}</td></tr>
        <tr><td>Trạng thái đăng ký:</td><td>${transport.registrationStatus}</td></tr>
        <tr><td>Ngày tạo:</td><td>${transport.createdAt}</td></tr>
        <tr><td>Địa chỉ:</td><td>${transport.location}</td></tr>
        <tr><td>Số xe:</td><td>${transport.vehicleCount}</td></tr>
        <tr><td>Sức chứa:</td><td>${transport.capacity}</td></tr>
        <tr><td>Nhân lực bốc xếp:</td><td>${transport.loader}</td></tr>

        <div class="images-section">
                                <div class="images-grid">
                                    <div class="image-item">
                                        <div class="image-label">
                                            <i class="fas fa-certificate"></i>
                                            Giấy phép kinh doanh
                                        </div>
                                        <div class="image-container">
                                            <c:if test="${not empty unitT.businessCertificate}">
                                                <img src="${unitT.businessCertificate}" 
                                                     alt="Giấy phép kinh doanh"
                                                     class="detail-image" 
                                                     onclick="openImageModal(this.src, 'Giấy phép kinh doanh')">
                                            </c:if>
                                            <c:if test="${empty unitT.businessCertificate}">
                                                <div class="no-image">
                                                    <i class="fas fa-image"></i>
                                                    <span>Chưa có hình ảnh</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>

                                    <div class="image-item">
                                        <div class="image-label">
                                            <i class="fas fa-shield-alt"></i>
                                            Bảo hiểm
                                        </div>
                                        <div class="image-container">
                                            <c:if test="${not empty unitT.insurance}">
                                                <img src="${unitT.insurance}" 
                                                     alt="Bảo hiểm"
                                                     class="detail-image" 
                                                     onclick="openImageModal(this.src, 'Bảo hiểm')">
                                            </c:if>
                                            <c:if test="${empty unitT.insurance}">
                                                <div class="no-image">
                                                    <i class="fas fa-image"></i>
                                                    <span>Chưa có hình ảnh</span>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
    </table>
</body>
</html>
