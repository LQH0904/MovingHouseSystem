<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.UserAdmin"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <%-- Ensure these paths are correct relative to your webapp root --%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/dashboard.css">
        
    </head>
    <body>
        
        <jsp:include page="../../Layout/admin/Header.jsp"></jsp:include>
        <jsp:include page="../../Layout/admin/SizeBar.jsp"></jsp:include>
        <jsp:include page="../../Layout/admin/HomePage.jsp"></jsp:include>
        <%
            UserAdmin loggedInUser = (UserAdmin) session.getAttribute("loggedInUser");
            if (loggedInUser == null) {
                response.sendRedirect("login.jsp"); // Redirect to login if not logged in
                return;
            }
        %>
        <div class="container">
            <div class="logout-link">
                <p>Xin chào, <%= loggedInUser.getUsername() %> (<%= loggedInUser.getRole() %>)! <a href="LoginAdminServlet?action=logout">Đăng xuất</a></p>
            </div>
            <h1>Trang quản trị hệ thống Moving Service</h1>

            <p class="welcome-message">Chào mừng bạn đến với bảng điều khiển quản trị. Tại đây, bạn có thể quản lý các khía cạnh khác nhau của hệ thống.</p>

            <h2 class="section-title">Chức năng chính</h2>
            <div class="function-list nav-links">
                <ul>
                    <li><a href="#">Quản lý Đơn hàng (Chưa triển khai)</a></li>
                    <li><a href="#">Quản lý Người dùng (Chưa triển khai)</a></li>
                    <li><a href="#">Quản lý Khách hàng (Chưa triển khai)</a></li>
                </ul>
            </div>

            <h2 class="section-title">Quản lý Logs</h2>
            <div class="function-list nav-links">
                <ul>
                    <li><a href="LogViewerServlet?type=system">Xem Nhật ký Hoạt động Hệ thống</a></li>
                    <li><a href="LogViewerServlet?type=data_change">Xem Nhật ký Thay đổi Dữ liệu</a></li>
                </ul>
            </div>

            <%-- Add more sections/links for other functionalities as you implement them --%>

        </div>
        <%-- Optional: Add Bootstrap JS if you use Bootstrap components that require it --%>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>