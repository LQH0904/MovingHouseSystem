<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.StorageUnit1" %>
<%
    StorageUnit1 su = (StorageUnit1) request.getAttribute("storageUnit");
%>
<html>
<head>
    <title>Chi Tiết Kho Bãi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/Detail.css" />
</head>
<body>
    <h2>Chi Tiết Kho Bãi</h2>
    <table>
        <tr><td><strong>Tên kho:</strong></td><td><%= su.getWarehouseName() %></td></tr>
        <tr><td><strong>Vị trí:</strong></td><td><%= su.getLocation() %></td></tr>
        <tr><td><strong>Giấy phép KD:</strong></td><td><%= su.getBusinessCertificate() %></td></tr>
        <tr><td><strong>Diện tích:</strong></td><td><%= su.getArea() %></td></tr>
        <tr><td><strong>Nhân viên:</strong></td><td><%= su.getEmployee() %></td></tr>
        <tr><td><strong>SĐT:</strong></td><td><%= su.getPhoneNumber() %></td></tr>
        <tr><td><strong>Trạng thái đăng ký:</strong></td><td><%= su.getRegistrationStatus() %></td></tr>
        <tr><td><strong>Bảo hiểm:</strong></td><td><%= su.getInsurance() %></td></tr>
        <tr><td><strong>Sơ đồ tầng:</strong></td><td><%= su.getFloorPlan() %></td></tr>
    </table>
    <br>
    <button onclick="history.back()">Quay lại</button>
</body>
</html>
