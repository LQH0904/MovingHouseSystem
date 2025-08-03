<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="model.Users" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // Kiểm tra session
    if (session.getAttribute("acc") == null) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }

    // Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserRoleId = userAccount.getRoleId();
%>
<html>
    <head>
        <title>Danh Sách Người Dùng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/UserList.css">

        <%-- CSS cho nút và modal để đảm bảo hoạt động --%>
        <style>
            body {
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    background-color: #f4f7f9;
    color: #333;
}

.div3 {
    padding: 24px;
}

.user-list-title {
    font-size: 28px;
    font-weight: 600;
    color: #2c3e50;
    margin-bottom: 24px;
}

/* --- Khu vực điều khiển (Tìm kiếm, Lọc, Nút) --- */
.form-container {
    background-color: #ffffff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.role-select-form {
    display: flex;
    align-items: center;
    gap: 12px; /* Khoảng cách giữa các phần tử */
}

.role-select, input[name="searchKeyword"] {
    padding: 10px 12px;
    border: 1px solid #dcdfe6;
    border-radius: 6px;
    font-size: 14px;
    transition: border-color 0.2s, box-shadow 0.2s;
}
.role-select:focus, input[name="searchKeyword"]:focus {
    outline: none;
    border-color: #409eff;
    box-shadow: 0 0 0 2px rgba(64, 158, 255, 0.2);
}

.search-btn, .add-user-btn {
    padding: 10px 20px;
    border-radius: 6px;
    border: none;
    font-size: 14px;
    font-weight: 500;
    cursor: pointer;
    transition: background-color 0.2s, transform 0.1s;
}
.search-btn {
    background-color: #409eff;
    color: white;
}
.add-user-btn {
    background-color: #67c23a;
    color: white;
}
.search-btn:hover, .add-user-btn:hover {
    opacity: 0.85;
}
.search-btn:active, .add-user-btn:active {
    transform: scale(0.98);
}

/* --- Bảng dữ liệu chuyên nghiệp --- */
.user-list-table {
    width: 100%;
    border-collapse: collapse;
    background-color: #ffffff;
    border-radius: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    overflow: hidden; /* Để bo góc table hoạt động */
}

.user-list-table th, .user-list-table td {
    padding: 16px;
    text-align: left;
    border-bottom: 1px solid #e8eaed;
}

.user-list-table thead th {
    background-color: #f8f9fa;
    font-size: 13px;
    font-weight: 600;
    color: #606266;
    text-transform: uppercase;
}

.user-list-table tbody tr:hover {
    background-color: #f5f7fa;
}

.user-list-table td {
    color: #3f444a;
}

/* --- "Pill" hiển thị trạng thái hiện đại --- */
.status-pill {
    padding: 4px 12px;
    border-radius: 20px;
    font-size: 12px;
    font-weight: 600;
    text-align: center;
    display: inline-block;
}
.status-active {
    color: #1a936f;
    background-color: rgba(45, 206, 137, 0.15);
}
.status-inactive {
    color: #f56c6c;
    background-color: rgba(245, 108, 108, 0.15);
}

/* --- Các nút thao tác trong bảng --- */
.action-btn {
    padding: 6px 12px; margin: 0 2px;
    font-size: 13px; font-weight: 500;
    border-radius: 5px; border: none;
    color: white; cursor: pointer;
    transition: opacity 0.2s;
}
.action-btn:hover { opacity: 0.8; }
.detail-btn { background-color: #007bff; }
.ban-btn { background-color: #ffc107; color: #333; }
.unban-btn { background-color: #28a745; }
.delete-btn { background-color: #dc3545; }


/* --- Phân trang được làm đẹp --- */
.pagination-wrapper {
    margin-top: 24px;
    display: flex;
    justify-content: center;
}
.pagination-buttons button {
    background-color: #fff;
    color: #606266;
    border: 1px solid #dcdfe6;
    padding: 8px 14px;
    margin: 0 4px;
    border-radius: 6px;
    cursor: pointer;
    transition: all 0.2s;
}
.pagination-buttons button:hover {
    color: #409eff;
    border-color: #409eff;
}
.pagination-buttons button.active {
    background-color: #409eff;
    color: white;
    border-color: #409eff;
}
.pagination-buttons button:disabled {
    opacity: 0.6;
    cursor: not-allowed;
}

/* --- Modal được làm mượt mà hơn --- */
@keyframes fadeIn {
    from { opacity: 0; }
    to { opacity: 1; }
}
@keyframes slideUp {
    from { transform: translateY(20px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
}

.modal {
    animation: fadeIn 0.3s ease-out;
}
.modal-content {
    animation: slideUp 0.4s ease-out;
    box-shadow: 0 8px 30px rgba(0,0,0,0.15);
}
.modal-buttons .cancel-btn {
    background-color: #909399;
    color: white;
}

            .action-btn {
                padding: 5px 10px;
                border: none;
                border-radius: 4px;
                color: white;
                cursor: pointer;
                margin: 0 3px;
                font-size: 14px;
            }
            .detail-btn {
                background-color: #007bff;
            }
            .ban-btn {
                background-color: #ffc107;
                color: black;
            }
            .unban-btn {
                background-color: #28a745;
            }
            .delete-btn {
                background-color: #dc3545;
            }

            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0,0,0,0.5);
            }
            .modal-content {
                background-color: #fefefe;
                margin: 15% auto;
                padding: 20px;
                border: 1px solid #888;
                width: 80%;
                max-width: 500px;
                text-align: center;
                border-radius: 8px;
            }
            .modal-content h2 {
                margin-top: 0;
            }
            .modal-content p {
                font-size: 16px;
                line-height: 1.5;
            }
            .modal-content strong {
                color: #c00;
            }
            .modal-buttons {
                margin-top: 20px;
            }
            .modal-buttons button {
                padding: 10px 20px;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .modal-buttons button:first-child {
                background-color: #dc3545;
                color: white;
                margin-right: 10px;
            }
            .modal-buttons button.cancel-btn {
                background-color: #ccc;
            }
            .close {
                color: #aaa;
                float: right;
                font-size: 28px;
                font-weight: bold;
            }
            .close:hover, .close:focus {
                color: black;
                text-decoration: none;
                cursor: pointer;
            }

            .pagination-buttons button {
                margin: 0 2px;
            }
            .pagination-buttons button.active {
                background-color: #007bff;
                color: white;
                border-color: #007bff;
            }
        </style>
    </head>
    <body>
        <div class="parent">
        <%-- Sidebar và Header --%>
        <% if (currentUserRoleId == 2) { %>
            <div class="div1"><jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include></div>
            <div class="div2"><jsp:include page="../../Layout/operator/Header.jsp"></jsp:include></div>
        <% } else if (currentUserRoleId == 3) { %>
            <div class="div1"><jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include></div>
            <div class="div2"><jsp:include page="../../Layout/staff/Header.jsp"></jsp:include></div>
        <% } %>

        <div class="div3">
            <h2 class="user-list-title">Quản lý Người Dùng</h2>

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
                    <input type="text" name="searchKeyword" placeholder="Tìm theo tên hoặc email..." value="${param.searchKeyword}" />
                    <button type="submit" class="search-btn">Tìm kiếm</button>
                </form>
                <button class="add-user-btn" onclick="window.location.href = 'http://localhost:9999/HouseMovingSystem/operator/listApplication'">
                    Duyệt đơn vị mới
                </button>
            </div>

            <table class="user-list-table">
    <thead>
        <tr>
            <th>STT</th>
            <th>Tên Người Dùng</th>
            <th>Email</th>
            <th>Vai Trò</th>
            <th>Trạng Thái</th>
            <th style="width: 260px;">Thao Tác</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="user" items="${users}" varStatus="loop">
            <tr>
                <td>${loop.index + 1 + (currentPage - 1) * 15}</td>
                <td>${user.username}</td>
                <td>${user.email}</td>
                
                <td>
                    <c:choose>
                        <c:when test="${user.role.roleId == 1}">Quản trị viên</c:when>
                        <c:when test="${user.role.roleId == 2}">Người điều hành</c:when>
                        <c:when test="${user.role.roleId == 3}">Nhân viên</c:when>
                        <c:when test="${user.role.roleId == 4}">Đơn vị vận chuyển</c:when>
                        <c:when test="${user.role.roleId == 5}">Kho bãi</c:when>
                        <c:when test="${user.role.roleId == 6}">Khách hàng</c:when>
                        <c:otherwise>
                            ${user.role.roleName}
                        </c:otherwise>
                    </c:choose>
                </td>
                
                <td>
                    <c:choose>
                        <c:when test="${user.status == 'active'}">
                            <span class="status-pill status-active">Hoạt động</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-pill status-inactive">Hạn chế</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:if test="${user.role.roleId != 1}">
                        <form method="post" action="DetailUserServlet" style="display:inline;">
                            <input type="hidden" name="id" value="${user.userId}" />
                            <button type="submit" class="action-btn detail-btn">Chi tiết</button>
                        </form>
                        <c:choose>
                            <c:when test="${user.status == 'active'}">
                                <button class="action-btn ban-btn" onclick="showConfirmModal('${user.userId}', '${user.username}', 'ban')">Hạn chế</button>
                            </c:when>
                            <c:otherwise>
                                <button class="action-btn unban-btn" onclick="showConfirmModal('${user.userId}', '${user.username}', 'unban')">Kích hoạt</button>
                            </c:otherwise>
                        </c:choose>
                        <%--
                        <button class="action-btn delete-btn" onclick="showConfirmModal('${user.userId}', '${user.username}', 'delete')">Xóa</button>
                        --%>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

            <div class="pagination-wrapper" style="text-align:center; margin-top:24px;">
                <c:if test="${totalPages > 1}">
                    <form id="paginationForm" method="post" action="${pageContext.request.contextPath}/UserListServlet" style="display: inline-block;">
                        <input type="hidden" name="roleId" value="${roleId}" />
                        <input type="hidden" name="searchKeyword" value="${searchKeyword}" />
                        <input type="hidden" name="page" id="pageInput" value="${currentPage}" />
                        <div class="pagination-buttons">
                            <button type="button" onclick="goToPage(${currentPage - 1})" ${currentPage == 1 ? 'disabled' : ''}>&laquo;</button>
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <button type="button" onclick="goToPage(${i})" class="${i == currentPage ? 'active' : ''}">${i}</button>
                            </c:forEach>
                            <button type="button" onclick="goToPage(${currentPage + 1})" ${currentPage == totalPages ? 'disabled' : ''}>&raquo;</button>
                        </div>
                    </form>
                </c:if>
            </div>
                <%-- Modal xác nhận hành động --%>
                <div id="confirmModal" class="modal">
                    <div class="modal-content">
                        <span class="close" onclick="closeModal()">&times;</span>
                        <h2 id="modalTitle">Xác nhận hành động</h2>
                        <p id="modalText"></p>
                        <div class="modal-buttons">
                            <button id="confirmBtn" onclick="confirmAction()">Xác Nhận</button>
                            <button class="cancel-btn" onclick="closeModal()">Hủy Bỏ</button>
                        </div>
                    </div>
                </div>

            </div>
        </div>

        <script>
            let userIdToAction = null;
            let actionToPerform = null;

            // Hàm hiển thị modal đa năng
            function showConfirmModal(userId, username, action) {
                const modal = document.getElementById("confirmModal");
                const modalText = document.getElementById("modalText");
                const confirmBtn = document.getElementById("confirmBtn");

                userIdToAction = userId;
                actionToPerform = action;

                if (action === 'ban') {
                    modalText.innerHTML = `Bạn có chắc muốn <strong>HẠN CHẾ</strong> tài khoản của người dùng <strong>${username}</strong>?`;
                    confirmBtn.innerHTML = "Xác nhận Hạn chế";
                } else if (action === 'unban') {
                    modalText.innerHTML = `Bạn có chắc muốn <strong>KÍCH HOẠT</strong> lại tài khoản của người dùng <strong>${username}</strong>?`;
                    confirmBtn.innerHTML = "Xác nhận Kích hoạt";
                } else if (action === 'delete') {
                    modalText.innerHTML = `Hành động này không thể hoàn tác! <br/> Bạn có chắc chắn muốn <strong>XÓA VĨNH VIỄN</strong> người dùng <strong>${username}</strong>?`;
                    confirmBtn.innerHTML = "XÁC NHẬN XÓA";
                }
                modal.style.display = "block";
            }

            function closeModal() {
                document.getElementById("confirmModal").style.display = "none";
            }

            // Hàm xác nhận hành động đa năng
            function confirmAction() {
                if (!userIdToAction || !actionToPerform)
                    return;

                let url = '';
                if (actionToPerform === 'ban' || actionToPerform === 'unban') {
                    url = '${pageContext.request.contextPath}/operator/UpdateUserStatusServlet?id=' + userIdToAction;
                } else if (actionToPerform === 'delete') {
                    url = '${pageContext.request.contextPath}/operator/DeleteUserServlet?id=' + userIdToAction;
                }

                if (url) {
                    window.location.href = url;
                }
            }

            // Hàm JavaScript cho phân trang
            function goToPage(pageNumber) {
                // Đảm bảo không đi ra ngoài giới hạn trang
                if (pageNumber < 1 || pageNumber > ${totalPages}) {
                    return;
                }
                document.getElementById('pageInput').value = pageNumber;
                document.getElementById('paginationForm').submit();
            }
        </script>
    </body>
</html>