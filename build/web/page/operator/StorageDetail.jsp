<%-- 
    Document   : StorageDetail
    Created on : Jul 23, 2025, 8:15:35 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Chi Tiết Kho Bãi</h2>
<table border="1">
    <tr><td>Tên kho:</td><td>${storage.warehouseName}</td></tr>
    <tr><td>Địa chỉ:</td><td>${storage.location}</td></tr>
    <tr><td>Trạng thái đăng ký:</td><td>${storage.registrationStatus}</td></tr>
    <tr><td>Ngày tạo:</td><td>${storage.createdAt}</td></tr>
    <tr><td>Chứng chỉ KD:</td><td>${storage.businessCertificate}</td></tr>
    <tr><td>Diện tích:</td><td>${storage.area}</td></tr>
    <tr><td>Nhân viên:</td><td>${storage.employee}</td></tr>
    <tr><td>Số điện thoại:</td><td>${storage.phoneNumber}</td></tr>
    <tr><td>Bảo hiểm:</td><td>${storage.insurance}</td></tr>
    <tr><td>Bản vẽ sàn:</td><td>${storage.floorPlan}</td></tr>
</table>
    </body>
</html>
