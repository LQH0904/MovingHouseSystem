<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>

<%
    int userId = Integer.parseInt(request.getParameter("id"));
    User user = new UserDAO().getUserById(userId);
%>

<html>
<head>
    <title>Xác Nhận Xóa Khách Hàng</title>
</head>
<body>
    <h2>Xác Nhận Xóa Khách Hàng</h2>
    <p>Bạn có chắc chắn muốn xóa người dùng sau không?</p>

    <table>
        <tr><td><b>ID:</b></td><td><%= user.getUserId() %></td></tr>
        <tr><td><b>Tên:</b></td><td><%= user.getUsername() %></td></tr>
        <tr><td><b>Email:</b></td><td><%= user.getEmail() %></td></tr>
        <tr><td><b>Vai Trò:</b></td><td><%= user.getRole().getRoleName() %></td></tr>
    </table>

    <form action="<%= request.getContextPath() %>/Staff/DeleteUserServlet" method="post">
        <input type="hidden" name="id" value="<%= user.getUserId() %>">
        <button type="submit">Xác Nhận Xóa</button>
        <button type="button" onclick="window.location.href='<%= request.getContextPath() %>/page/staff/CustomerList.jsp'">Hủy</button>
    </form>
</body>
</html>
