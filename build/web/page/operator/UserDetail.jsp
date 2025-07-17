<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%
    User user = (User) request.getAttribute("user");
%>
<html>
<head>
    <title>Chi Tiết Người Dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/Detail.css" />
</head>
<body>
    <h2>Chi Tiết Người Dùng</h2>
    <table>
        <tr><td><strong>Tên người dùng:</strong></td><td><%= user.getUsername() %></td></tr>
        <tr><td><strong>Email:</strong></td><td><%= user.getEmail() %></td></tr>
        <tr><td><strong>Vai trò:</strong></td><td><%= user.getRole().getRoleName() %></td></tr>
        <tr><td><strong>Trạng thái:</strong></td><td><%= user.getStatus() %></td></tr>
        <tr><td><strong>Ngày tạo:</strong></td><td><%= user.getCreatedAt() %></td></tr>
        <tr><td><strong>Ngày cập nhật:</strong></td><td><%= user.getUpdatedAt() %></td></tr>
    </table>
    <br>
    <button onclick="history.back()">Quay lại</button>
</body>
</html>
