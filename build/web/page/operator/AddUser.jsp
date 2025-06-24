<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
<head>
    <title>Thêm Khách Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/AddCustomer.css">
</head>
<body>
    <h2 style="text-align:center;">Thêm Khách Hàng</h2>

    <div class="add-user-form">
        <form action="<%= request.getContextPath() %>/Staff/AddUserServlet" method="post">
            <label for="username">Tên Người Dùng:</label>
            <input type="text" id="username" name="username" class="form-input" value="" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" class="form-input" required
                   pattern="[a-zA-Z0-9._%+-]+@gmail\.com"
                   title="Vui lòng nhập địa chỉ Gmail hợp lệ (kết thúc bằng @gmail.com)">

            <label for="password">Mật Khẩu:</label>
            <input type="password" id="password" name="password" class="form-input" value="" required>

            <label for="status">Trạng Thái:</label>
            <select name="status" id="status" class="form-select">
                <option value="Đang hoạt động">Đang hoạt động</option>
                <option value="Ngưng hoạt động">Ngưng hoạt động</option>
            </select>

            <!-- RoleId luôn là customer -->
            <input type="hidden" name="roleId" value="6">

            <button type="submit" class="submit-btn">Thêm</button>
            <button type="button" class="submit-btn" style="background-color: #6c757d;"
                    onclick="window.location.href='<%= request.getContextPath() %>/CustomerListServlet'">Hủy</button>
        </form>
    </div>
</body>
</html>
