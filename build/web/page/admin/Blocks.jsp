<%-- 
    Document   : Blocks
    Created on : Jul 11, 2025, 7:21:15 AM
    Author     : admin
--%>

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head><title>Danh sách người dùng bị chặn</title></head>
<body>
<h2>Người dùng bị chặn</h2>
<table border="1">
    <tr><th>ID</th><th>User ID</th><th>Lý do</th><th>Thời gian</th></tr>
    <c:forEach var="b" items="${blocks}">
        <tr>
            <td>${b.id}</td>
            <td>${b.userId}</td>
            <td>${b.reason}</td>
            <td>${b.blockedAt}</td>
        </tr>
    </c:forEach>
</table>
</body>
</html>

