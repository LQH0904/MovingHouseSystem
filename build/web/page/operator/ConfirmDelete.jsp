<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>

<html>
<head>
    <title>Xác Nhận Xóa Người Dùng</title>
</head>
<body>
    <h2>Xác Nhận Xóa Người Dùng</h2>
    <p>Bạn có xác nhận xóa Người dùng: <%= request.getAttribute("user").getUsername() %> </p>
    <p>Email: <%= request.getAttribute("user").getEmail() %> </p>
    <p>Vai trò: <%= request.getAttribute("user").getRole().getRoleName() %> </p>

    <form action="DeleteUserServlet" method="post">
        <input type="hidden" name="userId" value="<%= request.getAttribute("user").getUserId() %>" />
        <button type="submit" name="action" value="confirm">Xác Nhận</button>
        <button type="button" onclick="window.location.href='UserListServlet'">Hủy Bỏ</button>
    </form>
</body>
</html>
