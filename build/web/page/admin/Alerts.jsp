<%-- 
    Document   : Alerts
    Created on : Jul 10, 2025, 6:20:44 AM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Danh sách cảnh cáo</title></head>
<body>
<h2>Cảnh cáo bảo mật</h2>
<table border="1">
    <tr><th>ID</th><th>User ID</th><th>Nội dung</th><th>Thời gian</th></tr>
    <c:forEach var="a" items="${alerts}">
        <tr>
            <td>${a.id}</td>
            <td>${a.userId}</td>
            <td>${a.alertMessage}</td>
            <td>${a.createdAt}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>

