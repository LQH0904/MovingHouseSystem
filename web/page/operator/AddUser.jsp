<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<html>
    <head>
        <title>Thêm Nhân Viên</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/AddCustomer.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include>
                </div>
                <div class="div3">
                    <h2 style="text-align:center;">Thêm Nhân Viên</h2>

                <%-- Thông báo lỗi --%>
                <% String error = (String) request.getAttribute("error"); %>
                <% if (error != null) {%>
                <div style="color: red; text-align: center; margin-bottom: 10px;"><%= error%></div>
                <% } %>

                <%-- Thông báo mật khẩu đã gửi email --%>
                <% String pass = (String) request.getAttribute("password"); %>
                <% if (pass != null) {%>
                <div style="color: green; text-align: center; margin-bottom: 10px;">
                    Mật khẩu đã gửi qua email: <strong><%= pass%></strong>
                </div>
                <% }%>

                <div class="add-user-form">
<form action="<%= request.getContextPath()%>/AddStaffServlet" method="post">
                        <label for="username">Tên Người Dùng:</label>
                        <input type="text" id="username" name="username" class="form-input" required>

                        <label for="email">Email:</label>
                        <input type="email" id="email" name="email" class="form-input" required
                               pattern="[a-zA-Z0-9._%+-]+@gmail\.com"
                               title="Vui lòng nhập địa chỉ Gmail hợp lệ (kết thúc bằng @gmail.com)">

                        <label for="status">Trạng Thái:</label>
                        <select name="status" id="status" class="form-select">
                            <option value="Đang hoạt động">Đang hoạt động</option>
                            <option value="Ngưng hoạt động">Ngưng hoạt động</option>
                        </select>

                        <input type="hidden" name="roleId" value="3">

                        <button type="submit" class="submit-btn">Thêm</button>
                        <button type="button" class="submit-btn" style="background-color: #6c757d;"
                                onclick="window.location.href = '<%= request.getContextPath()%>/UserListServlet'">Hủy</button>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
