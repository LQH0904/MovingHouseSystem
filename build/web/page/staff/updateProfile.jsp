<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Staff" %>
<%@ page import="model.UserStaff" %>

<%
    String type = (String) request.getAttribute("type");
    if (type == null) {
        type = request.getParameter("type");
    }
%>

<!DOCTYPE html>
<html>
    <head>
        <title>Cập nhật hồ sơ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/UpDateProfile.css">

    </head>
    <body>
        <div class="profile-container">
            <h2>Cập nhật hồ sơ</h2>
            <% if (request.getParameter("success") != null) { %>
            <div class="alert alert-success">Cập nhật thành công!</div>
            <% } else if ("wrongOldPass".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">Mật khẩu cũ không đúng!</div>
            <% } else if ("notMatch".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger">Mật khẩu mới và nhập lại không khớp!</div>
            <% } %>

            <form action="updateProfile" method="post" enctype="multipart/form-data">
                <input type="hidden" name="type" value="<%= type %>">

                <% if ("staff".equals(type)) {
                     Staff staff = (Staff) request.getAttribute("staff");
                %>
                <input type="hidden" name="id" value="<%= staff.getStaffId() %>">
                <input type="hidden" name="currentAvatar" value="<%= staff.getAvatarUrl() %>">

                <div class="form-group">
                    <label>Họ và tên</label>
                    <input type="text" name="fullName" value="<%= staff.getFullName() %>" required>
                </div>

                <div class="form-group">
                    <label>Phòng ban</label>
                    <input type="text" name="department" value="<%= staff.getDepartment() %>">
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="<%= staff.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="<%= staff.getPhone() %>">
                </div>

                <div class="form-group">
                    <label>Địa chỉ</label>
                    <input type="text" name="address" value="<%= staff.getAddress() != null ? staff.getAddress() : "" %>">
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="active" <%= "active".equals(staff.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                        <option value="inactive" <%= "inactive".equals(staff.getStatus()) ? "selected" : "" %>>Ngưng hoạt động</option>
                    </select>
                </div>

                <% } else {
                     UserStaff user = (UserStaff) request.getAttribute("user");
                %>
                <input type="hidden" name="id" value="<%= user.getUserId() %>">
                <input type="hidden" name="currentAvatar" value="<%= user.getAvatarUrl() %>">

                <div class="form-group">
                    <label>Tên đăng nhập</label>
                    <input type="text" name="username" value="<%= user.getUsername() %>" required>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="email" name="email" value="<%= user.getEmail() %>" required>
                </div>

                <div class="form-group">
                    <label>Số điện thoại</label>
                    <input type="text" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>">
                </div>

                <div class="form-group">
                    <label>Địa chỉ</label>
                    <input type="text" name="address" value="<%= user.getAddress() != null ? user.getAddress() : "" %>">
                </div>

                <div class="form-group">
                    <label>Trạng thái</label>
                    <select name="status">
                        <option value="active" <%= "active".equals(user.getStatus()) ? "selected" : "" %>>Hoạt động</option>
                        <option value="inactive" <%= "inactive".equals(user.getStatus()) ? "selected" : "" %>>Ngưng hoạt động</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Mật khẩu cũ</label>
                    <input type="password" name="oldPassword">
                </div>

                <div class="form-group">
                    <label>Mật khẩu mới</label>
                    <input type="password" name="newPassword">
                </div>

                <div class="form-group">
                    <label>Nhập lại mật khẩu mới</label>
                    <input type="password" name="confirmPassword">
                </div>

                <% } %>

                <div class="form-group">
                    <label>Ảnh đại diện</label>
                    <input type="file" name="avatar" accept="image/*">
                </div>

                <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                <a href="${pageContext.request.contextPath}/homeStaff" class="btn btn-secondary">Quay về trang chủ</a>
            </form>
        </div>
    </body>
</html>
