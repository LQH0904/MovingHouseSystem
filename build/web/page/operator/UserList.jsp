<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Danh Sách Người Dùng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/UserList.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
                <h2 class="user-list-title">Danh Sách Người Dùng</h2>

                <div class="form-container">
                    <form method="post" action="${pageContext.request.contextPath}/UserListServlet" class="role-select-form">
                        <select name="roleId" onchange="this.form.submit()" class="role-select">
                            <option value="">Hiển thị tất cả</option>
                            <option value="1" ${roleId == '1' ? 'selected' : ''}>Quản trị viên</option>
                            <option value="2" ${roleId == '2' ? 'selected' : ''}>Người điều hành</option>
                            <option value="3" ${roleId == '3' ? 'selected' : ''}>Nhân viên</option>
                            <option value="4" ${roleId == '4' ? 'selected' : ''}>Đơn vị vận chuyển</option>
                            <option value="5" ${roleId == '5' ? 'selected' : ''}>Kho bãi</option>
                            <option value="6" ${roleId == '6' ? 'selected' : ''}>Khách hàng</option>
                        </select>
                        <input type="text" name="searchKeyword" placeholder="Tìm theo tên/email" value="${param.searchKeyword}" />
                        <button type="submit" class="search-btn">Tìm kiếm</button>
                    </form>

                    <button class="add-user-btn" onclick="window.location.href = '${pageContext.request.contextPath}/page/operator/AddUser.jsp'">
                        Thêm Người Dùng
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
                            <th style="width: 220px;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}" varStatus="loop">
                            <tr>
                                <td>${loop.index + 1 + (currentPage - 1) * 15}</td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>${user.role.roleName}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 'active'}">Đang hoạt động</c:when>
                                        <c:otherwise>Ngưng hoạt động</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
  <c:if test="${user.role.roleId != 1}">
    <form method="post" action="DetailUserServlet" style="display:inline;">
        <input type="hidden" name="id" value="${user.userId}" />
        <button type="submit" class="detail-btn">Chi tiết</button>
    </form>
    <button class="delete-btn" onclick="showConfirmDelete('${user.userId}', '${user.username}', '${user.email}', '${user.role.roleName}')">Xóa</button>
  </c:if>
</td>


                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="pagination-wrapper" style="text-align:center; margin-top:20px;">
                    <c:if test="${totalPages > 1}">
                        <form id="paginationForm" method="post" action="${pageContext.request.contextPath}/UserListServlet" style="display: inline-block;">
                            <input type="hidden" name="roleId" value="${roleId}" />
                            <input type="hidden" name="searchKeyword" value="${searchKeyword}" />
                            <input type="hidden" name="page" id="pageInput" value="${currentPage}" />

                            <div class="pagination-buttons">
                                <!-- Nút trang trước -->
                                <button type="button" onclick="goToPage(${currentPage - 1})" ${currentPage == 1 ? 'disabled' : ''}>
                                    &laquo;
                                </button>

                                <!-- Số trang -->
                                <c:forEach var="i" begin="1" end="${totalPages}">
                                    <button type="button" onclick="goToPage(${i})"
                                            class="page-link ${i == currentPage ? 'active' : ''}">${i}</button>
                                </c:forEach>

                                <!-- Nút trang sau -->
                                <button type="button" onclick="goToPage(${currentPage + 1})" ${currentPage == totalPages ? 'disabled' : ''}>
                                    &raquo;
                                </button>
                            </div>
                        </form>
                    </c:if>
                </div>




                <div id="deleteModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <h2>Thông Báo</h2>
                        <p>Bạn có xác nhận xóa người dùng:</p>
                        <table>
                            <tr><td><strong>Tên Người Dùng:</strong></td><td id="userName"></td></tr>
                            <tr><td><strong>Email:</strong></td><td id="userEmail"></td></tr>
                            <tr><td><strong>Vai Trò:</strong></td><td id="userRole"></td></tr>
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
                window.location.href = 'Operator/DeleteUserServlet?id=' + userIdToDelete;
            }
            function goToPage(pageNumber) {
                document.getElementById('pageInput').value = pageNumber;
                document.getElementById('paginationForm').submit();
            }
        </script>
    </body>
</html>
