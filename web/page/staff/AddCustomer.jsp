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
        <tr>
                            <td>Tên Người Dùng:</td>
                            <td><input type="text" name="username" class="form-input" required></td>
                        </tr>
                        <tr>
                            <td>Mật khẩu:</td>
                            <td><input type="password" name="password" class="form-input" required></td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td><input type="email" name="email" class="form-input" required></td>
                        </tr>

        <label for="status">Trạng Thái:</label>
        <select name="status" id="status" class="form-select">
            <option value="Đang hoạt động">Đang hoạt động</option>
            <option value="Ngưng hoạt động">Ngưng hoạt động</option>
        </select>

        <input type="hidden" name="roleId" value="6">

        <button type="submit" class="submit-btn">Thêm</button>
        <button type="button" class="submit-btn" style="background-color: #6c757d;"
                onclick="window.location.href='<%= request.getContextPath() %>/CustomerListServlet'">Hủy</button>
    </form>
</div>

</body>
</html>
