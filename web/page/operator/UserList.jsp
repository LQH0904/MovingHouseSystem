<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="java.util.List" %>
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
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="/Layout/operator/Header.jsp"></jsp:include> </div>
                <div class="div3"> 
                    <h2 class="user-list-title">Danh Sách Người Dùng</h2>

                    <div class="form-container">
                        <form method="get" action="<%= request.getContextPath() %>/UserListServlet" class="role-select-form">
                        <select name="roleId" onchange="this.form.submit()" class="role-select">
                            <option value="">Hiển thị tất cả</option>
                            <option value="1" <%= "1".equals(request.getParameter("roleId")) ? "selected" : "" %>>Hiển thị quản trị viên</option>                            
                            <option value="2" <%= "2".equals(request.getParameter("roleId")) ? "selected" : "" %>>Hiển thị người điều hành</option>
                            <option value="3" <%= "3".equals(request.getParameter("roleId")) ? "selected" : "" %>>Hiển thị Nhân viên</option>
                            <option value="4" <%= "4".equals(request.getParameter("roleId")) ? "selected" : "" %>>Hiển thị đơn vị vận chuyển</option>
                            <option value="5" <%= "5".equals(request.getParameter("roleId")) ? "selected" : "" %>>Hiển thị kho bãi</option>
                            <option value="6" <%= "6".equals(request.getParameter("roleId")) ? "selected" : "" %>>Hiển thị khách hàng</option>
                        </select>
<input type="text" name="searchKeyword" value="<%= request.getParameter("searchKeyword") != null ? request.getParameter("searchKeyword") : "" %>" />

        <button type="submit" class="search-btn">Tìm kiếm</button>
                    </form>

                    <button class="add-user-btn" onclick="window.location.href = '<%= request.getContextPath() %>/page/operator/AddUser.jsp'">Thêm Người Dùng</button>
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
                        <%
                            List<User> users = (List<User>) request.getAttribute("users");
                            if (users != null) {
                                int stt = 1;
                                for (User user : users) {
                        %>
                        <tr>
                            <td><%= stt++ %></td>
                            <td><%= user.getUsername() %></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getRole().getRoleName() %></td>
                            <td><%= user.getStatus().equalsIgnoreCase("active") ? "Đang hoạt động" : "Ngưng hoạt động" %></td>
                            <td>
                                <c:if test="${user.role.roleId != 1}">
                                    <button class="detail-btn" onclick="window.location.href = '<%= request.getContextPath() %>/DetailUserServlet?id=<%= user.getUserId() %>'">Chi tiết</button>
                                    <button class="delete-btn" onclick="showConfirmDelete(<%= user.getUserId() %>, '<%= user.getUsername() %>', '<%= user.getEmail() %>', '<%= user.getRole().getRoleName() %>')">Xóa</button>
                                </c:if>                           
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                                out.println("Không có người dùng để hiển thị.");
                            }
                        %>
                    </tbody>
                </table>
                <div class="pagination-wrapper">

                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <span class="page-link active">${i}</span>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="UserListServlet?page=${i}" class="page-link">${i}</a>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>

                <div id="deleteModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <h2>Thông Báo</h2>
                        <p>Bạn có xác nhận xóa người dùng:</p>
                        <table>
                            <tr>
                                <td><strong>Tên Người Dùng:</strong></td>
                                <td id="userName"></td>
                            </tr>
                            <tr>
                                <td><strong>Email:</strong></td>
                                <td id="userEmail"></td>
                            </tr>
                            <tr>
                                <td><strong>Vai Trò:</strong></td>
                                <td id="userRole"></td>
                            </tr>
                        </table>
                        <br>
                        <button onclick="confirmDelete()">Xác Nhận</button>
                        <button onclick="closeModal()">Hủy Bỏ</button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            var userIdToDelete = null;

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
        </script>

    </body>
</html>
