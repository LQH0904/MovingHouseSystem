<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.TransportUnit1" %>
<%
    TransportUnit1 tu = (TransportUnit1) request.getAttribute("transportUnit");
%>
<html>
<head>
    <title>Chi Tiết Đơn Vị Vận Chuyển</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/Detail.css" />
</head>
<body>
    <h2>Chi Tiết Đơn Vị Vận Chuyển</h2>
    <table>
        <tr><td><strong>Tên công ty:</strong></td><td><%= tu.getCompanyName() %></td></tr>
        <tr><td><strong>Liên hệ:</strong></td><td><%= tu.getContactInfo() %></td></tr>
        <tr><td><strong>Vị trí:</strong></td><td><%= tu.getLocation() %></td></tr>
        <tr><td><strong>Số lượng xe:</strong></td><td><%= tu.getVehicleCount() %></td></tr>
        <tr><td><strong>Sức chứa:</strong></td><td><%= tu.getCapacity() %></td></tr>
        <tr><td><strong>Nhân lực bốc xếp:</strong></td><td><%= tu.getLoader() %></td></tr>
        <tr><td><strong>Giấy phép KD:</strong></td><td><%= tu.getBusinessCertificate() %></td></tr>
        <tr><td><strong>Bảo hiểm:</strong></td><td><%= tu.getInsurance() %></td></tr>
        <tr><td><strong>Trạng thái đăng ký:</strong></td><td><%= tu.getRegistrationStatus() %></td></tr>
    </table>
    <br>
    <button onclick="history.back()">Quay lại</button>
</body>
</html>
