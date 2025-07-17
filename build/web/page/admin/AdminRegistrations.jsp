<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Trang Quản Trị Viên - Quản lý đăng ký</title>

</head>
<body>
<div class="parent">

    <div class="div3">
        <h2 class="page-title">Quản Lý Đăng Ký Đơn Vị</h2>
        <p>Chào mừng bạn đến với khu vực quản lý dành cho Quản trị viên!</p>
        <p>Ở đây bạn có thể duyệt yêu cầu đăng ký từ Đơn vị vận chuyển hoặc Kho bãi.</p>
        
         <div style="margin-top: 20px;">
            <h3>Chức năng bảo mật</h3>
            <ul>
                <li><a href="${pageContext.request.contextPath}/admin/alerts"> Quản lý cảnh cáo bảo mật</a></li>
                <li><a href="${pageContext.request.contextPath}/admin/blocks"> Quản lý người dùng bị chặn</a></li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
