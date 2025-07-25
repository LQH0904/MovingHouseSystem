<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.User" %>

<html>
<head>
    <title>Danh Sách Khách Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/CustomerList.css">
</head>
<body>
<div class="parent">
    <div class="div3">
        <h2 class="user-list-title">Danh Sách Khách Hàng</h2>

        <div class="form-container">
            <button class="add-user-btn"
                    onclick="window.location.href = '${pageContext.request.contextPath}/page/staff/AddCustomer.jsp'">
                Thêm Khách Hàng
            </button>
        </div>

        <table class="user-list-table" border="1">
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên Người Dùng</th>
                    <th>Email</th>
                    <th>Vai Trò</th>
                    <th>Trạng Thái</th>
                    <th>Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${users}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1 + (currentPage - 1) * 15}</td>
                        <td>${user.username}</td>
                        <td>${user.email}</td>
                        <td>${user.role.roleName}</td>
                        <td>${user.status}</td>
                        <td>
                            <button class="delete-btn"
                                    onclick="showConfirmDelete('${user.userId}', '${user.username}', '${user.email}', '${user.role.roleName}')">
                                Xóa
                            </button>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <!-- Phân trang -->
        <div style="text-align: center; margin-top: 20px;">
            <c:if test="${totalPages > 1}">
                <span>Trang ${currentPage} / ${totalPages}</span><br><br>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/CustomerListServlet?page=${i}" class="page-link ${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </c:if>
        </div>

        <!-- Modal xác nhận xóa -->
        <div id="deleteModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2>Xác Nhận Xóa</h2>
                <p>Bạn có chắc chắn muốn xóa người dùng sau?</p>
                <table>
                    <tr><td><b>Tên:</b></td><td id="userName"></td></tr>
                    <tr><td><b>Email:</b></td><td id="userEmail"></td></tr>
                    <tr><td><b>Vai Trò:</b></td><td id="userRole"></td></tr>
                </table>
                <br>
                <button onclick="confirmDelete()">Xác Nhận</button>
                <button onclick="closeModal()">Hủy Bỏ</button>
            </div>
        </div>
    </div>
</div>

<script>
    let userIdToDelete = null;

    function showConfirmDelete(userId, username, email, role) {
        document.getElementById("deleteModal").style.display = "block";
        document.getElementById("userName").innerText = username;
        document.getElementById("userEmail").innerText = email;
        document.getElementById("userRole").innerText = role;
        userIdToDelete = userId;
    }

    function closeModal() {
        document.getElementById("deleteModal").style.display = "none";
    }

    function confirmDelete() {
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "${pageContext.request.contextPath}/Staff/DeleteUserServlet";

        const input = document.createElement("input");
        input.type = "hidden";
        input.name = "id";
        input.value = userIdToDelete;

        form.appendChild(input);
        document.body.appendChild(form);
        form.submit();
    }
</script>

</body>
</html>
