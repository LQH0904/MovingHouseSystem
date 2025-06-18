<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.User" %>
<%@ page import="dao.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>

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
    <button class="add-user-btn" onclick="window.location.href = '<%= request.getContextPath() %>/page/staff/AddCustomer.jsp'">Thêm Khách Hàng</button>
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
    int stt = 1;
    if (users != null) {
        for (User user : users) {
                        %>
                        <tr>
                            <td><%= stt++ %></td>
                            <td><%= user.getUsername() %></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getRole().getRoleName() %></td>
                            <td><%= user.getStatus() %></td>
                            <td>
                                <button class="delete-btn"
                                        onclick="showConfirmDelete(<%= user.getUserId() %>, '<%= user.getUsername() %>', '<%= user.getEmail() %>', '<%= user.getRole().getRoleName() %>')">
                                    Xóa
                                </button>
                            </td>
                        </tr>
                        <%
                                }
                            } else {
                        %>
                        <tr><td colspan="6">Không có khách hàng để hiển thị.</td></tr>
                        <%
                            }
                        %>

                    </tbody>
                </table>

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
                window.location.href = '<%= request.getContextPath() %>/Staff/DeleteUserServlet?id=' + userIdToDelete;
            }
        </script>
    </body>
</html>
