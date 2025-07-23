<%-- 
    Document   : TransportDetail
    Created on : Jul 23, 2025, 8:15:57 AM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <h2>Chi Tiết Đơn Vị Vận Chuyển</h2>
<table border="1">
    <tr><td>Tên công ty:</td><td>${transport.companyName}</td></tr>
    <tr><td>Thông tin liên hệ:</td><td>${transport.contactInfo}</td></tr>
    <tr><td>Trạng thái đăng ký:</td><td>${transport.registrationStatus}</td></tr>
    <tr><td>Ngày tạo:</td><td>${transport.createdAt}</td></tr>
    <tr><td>Địa chỉ:</td><td>${transport.location}</td></tr>
    <tr><td>Số xe:</td><td>${transport.vehicleCount}</td></tr>
    <tr><td>Sức chứa:</td><td>${transport.capacity}</td></tr>
    <tr><td>Nhân lực bốc xếp:</td><td>${transport.loader}</td></tr>
    <tr><td>Chứng chỉ KD:</td><td>${transport.businessCertificate}</td></tr>
    <tr><td>Bảo hiểm:</td><td>${transport.insurance}</td></tr>
</table>

    </body>
</html>
