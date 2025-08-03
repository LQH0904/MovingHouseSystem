<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Users" %>
<html>
    <head>
        <title>Danh Sách Khách Hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/CustomerList.css">

        <style>
            /* ===== CSS CHO DIV3 - KHU VỰC NỘI DUNG CHÍNH ===== */
            .div3 {
                padding: 24px;
                background: #f8fafc;
                min-height: calc(100vh - 80px);
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            /* ===== TIÊU ĐỀ TRANG ===== */
            .user-list-title {
                font-size: 26px;
                font-weight: 700;
                color: #1e293b;
                margin-bottom: 24px;
                text-align: center;
                position: relative;
                padding-bottom: 12px;
            }

            .user-list-title::after {
                content: '';
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 60px;
                height: 3px;
                background: linear-gradient(90deg, #3b82f6, #8b5cf6);
                border-radius: 2px;
            }

            /* ===== THANH CÔNG CỤ ===== */
            .toolbar-row {
                display: flex;
                justify-content: flex-start;
                align-items: center;
                margin-bottom: 20px;
                padding: 16px 20px;
                background: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
            }

            /* ===== FORM TÌM KIẾM ===== */
            .search-form {
                display: flex;
                gap: 12px;
                align-items: center;
            }

            .search-input {
                padding: 10px 14px;
                border: 1px solid #d1d5db;
                border-radius: 6px;
                font-size: 14px;
                width: 280px;
                transition: all 0.2s ease;
                background: #ffffff;
            }

            .search-input:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .search-input::placeholder {
                color: #9ca3af;
            }

            .search-btn {
                padding: 10px 20px;
                background: #3b82f6;
                color: white;
                border: none;
                border-radius: 6px;
                font-size: 14px;
                font-weight: 500;
                cursor: pointer;
                transition: all 0.2s ease;
            }

            .search-btn:hover {
                background: #2563eb;
                transform: translateY(-1px);
            }

            /* ===== BẢNG DANH SÁCH ===== */
            .user-list-table {
                width: 100%;
                background: white;
                border-radius: 8px;
                overflow: hidden;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
                border: 1px solid #e2e8f0;
                margin-bottom: 20px;
            }
            .status-active {
                background: #10b981;
                color: white;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.3px;
                display: inline-block;
            }

            .status-banned {
                background: #ef4444;
                color: white;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.3px;
                display: inline-block;
            }

            .user-list-table thead {
                background: #374151;
            }

            .user-list-table thead th {
                padding: 16px 12px;
                text-align: left;
                font-weight: 600;
                font-size: 13px;
                color: white;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }
            .overlay {
                z-index: 500;
            }
            .sidebar .hori-selector {
                left: 0 !important; /* không cần chạy ngang */
                width: 100%;        /* full chiều rộng tab */
                height: 50px;       /* hoặc chiều cao của từng menu */
                top: calc(50px * index); /* bạn phải tính vị trí top theo tab index */
            }

            .user-list-table tbody tr {
                transition: background-color 0.2s ease;
                border-bottom: 1px solid #f3f4f6;
            }

            .user-list-table tbody tr:hover {
                background: #f9fafb;
            }

            .user-list-table tbody tr:last-child {
                border-bottom: none;
            }

            .user-list-table tbody td {
                padding: 14px 12px;
                font-size: 14px;
                color: #374151;
                vertical-align: middle;
            }

            .user-list-table tbody td:first-child {
                font-weight: 600;
                color: #6b7280;
            }

            /* ===== TRẠNG THÁI NGƯỜI DÙNG ===== */
            .user-list-table tbody td span[style*="green"] {
                background: #10b981 !important;
                color: white !important;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.3px;
                display: inline-block;
            }

            .user-list-table tbody td span[style*="red"] {
                background: #ef4444 !important;
                color: white !important;
                padding: 4px 10px;
                border-radius: 12px;
                font-size: 11px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.3px;
                display: inline-block;
            }

            /* ===== CÁC NÚT HÀNH ĐỘNG ===== */
            .action-btn {
                padding: 6px 14px;
                border: none;
                border-radius: 5px;
                color: white;
                cursor: pointer;
                margin: 0 3px;
                font-size: 12px;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.3px;
                transition: all 0.2s ease;
            }

            .action-btn:hover {
                transform: translateY(-1px);
                opacity: 0.9;
            }

            .ban-btn {
                background: #f59e0b;
                border: 1px solid #d97706;
            }

            .ban-btn:hover {
                background: #d97706;
            }

            .unban-btn {
                background: #10b981;
                border: 1px solid #059669;
            }

            .unban-btn:hover {
                background: #059669;
            }

            /* ===== PHÂN TRANG ===== */
            .pagination-container {
                display: inline-flex;
                justify-content: center;
                align-items: center;
                gap: 4px;
            }

            .pagination-container a.page-link {
                display: inline-block;
                padding: 8px 12px;
                border: 1px solid #d1d5db;
                border-radius: 5px;
                background-color: #fff;
                color: #374151;
                text-decoration: none;
                transition: all 0.2s;
                font-size: 13px;
                font-weight: 500;
            }

            .pagination-container a.page-link:hover {
                color: #3b82f6;
                border-color: #3b82f6;
                background: #eff6ff;
            }

            .pagination-container a.page-link.active {
                background-color: #3b82f6;
                color: white;
                border-color: #3b82f6;
                font-weight: 600;
            }

            /* ===== SỬA LỖI MODAL - QUAN TRỌNG ===== */
            .modal {
                display: none; /* Ẩn mặc định */
                position: absolute;
                z-index: 99999 !important; /* Tăng z-index cao hơn */
                left: 50%;
                top: 50%;
                width: 100%;
                height: 100%;
                overflow: auto;
                background-color: rgba(0, 0, 0, 0.6);
                /* Quan trọng: Không đặt flex properties ở đây */
            }

            /* Khi modal được hiển thị */
            .modal.show {
                display: flex !important;
                align-items: center;
                justify-content: center;
                animation: fadeIn 0.3s ease;
            }

            .modal-content {
                background-color: #fff;
                padding: 25px 30px;
                border-radius: 10px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
                width: 90%;
                max-width: 450px;
                text-align: center;
                position: relative;
                /* Đảm bảo modal-content không bị ảnh hưởng bởi positioning */
                margin: auto;
            }

            .modal-content h2 {
                margin-top: 0;
                margin-bottom: 15px;
                font-size: 22px;
                color: #333;
                font-weight: 600;
            }

            .modal-content p {
                margin-bottom: 25px;
                font-size: 16px;
                line-height: 1.6;
                color: #555;
            }

            .modal-buttons {
                display: flex;
                justify-content: center;
                gap: 12px;
            }

            .modal-buttons button {
                padding: 10px 20px;
                font-size: 15px;
                cursor: pointer;
                border-radius: 6px;
                border: 1px solid #ccc;
                font-weight: 500;
                transition: all 0.2s;
                min-width: 120px;
            }

            #confirmBtn {
                background-color: #dc3545;
                color: white;
                border-color: #dc3545;
            }

            #confirmBtn:hover {
                background-color: #c82333;
                border-color: #bd2130;
            }

            .cancel-btn {
                background-color: #6c757d;
                color: white;
                border-color: #6c757d;
            }

            .cancel-btn:hover {
                background-color: #5a6268;
                border-color: #545b62;
            }

            .close {
                color: #aaa;
                position: absolute;
                top: 10px;
                right: 15px;
                font-size: 28px;
                font-weight: bold;
                cursor: pointer;
                transition: color 0.2s;
            }

            .close:hover {
                color: #333;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.9);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            /* ===== RESPONSIVE ===== */
            @media (max-width: 768px) {
                .div3 {
                    padding: 16px;
                }

                .toolbar-row {
                    flex-direction: column;
                    gap: 12px;
                    align-items: stretch;
                }

                .search-input {
                    width: 100%;
                }

                .user-list-table {
                    font-size: 12px;
                }

                .user-list-table thead th,
                .user-list-table tbody td {
                    padding: 10px 8px;
                }

                .action-btn {
                    padding: 5px 10px;
                    font-size: 11px;
                }

                .modal-content {
                    width: 95%;
                    padding: 20px;
                }
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/staff/SideBar.jsp" /></div>
            <div class="div2"><jsp:include page="/Layout/staff/Header.jsp" /></div>
            <div class="div3">
                <h2 class="user-list-title">Danh Sách Khách Hàng</h2>

                <div class="toolbar-row">
                    <form method="get" action="${pageContext.request.contextPath}/CustomerListServlet" class="search-form">
                        <input type="text" name="keyword" placeholder="Tìm theo tên hoặc email" value="${param.keyword}" class="search-input"/>
                        <button type="submit" class="search-btn">Tìm</button>
                    </form>
                </div>

                <table class="user-list-table">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Tên Người Dùng</th>
                            <th>Email</th>
                            <th>Trạng Thái</th>
                            <th style="width: 200px;">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${users}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * 15 + loop.index + 1}</td>
                                <td>${user.username}</td>
                                <td>${user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 'active'}">
                                            <span class="status-active">Hoạt động</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-banned">Hạn chế</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:if test="${user.role.roleId == 6}">
                                        <c:choose>
                                            <c:when test="${user.status == 'active'}">
                                                <button class="action-btn ban-btn" onclick="showConfirmModal('${user.userId}', '${user.username}', 'ban')">Hạn chế</button>
                                            </c:when>
                                            <c:otherwise>
                                                <button class="action-btn unban-btn" onclick="showConfirmModal('${user.userId}', '${user.username}', 'unban')">Kích hoạt</button>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div style="text-align: center; margin-top: 20px;">
                    <c:if test="${totalPages > 1}">
                        <span style="display: block; margin-bottom: 12px; color: #606266; font-size: 14px;">Trang ${currentPage} / ${totalPages}</span>
                        <div class="pagination-container">
                            <c:if test="${currentPage > 1}">
                                <a href="${pageContext.request.contextPath}/CustomerListServlet?page=${currentPage - 1}&keyword=${param.keyword}" class="page-link">&laquo;</a>
                            </c:if>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <a href="${pageContext.request.contextPath}/CustomerListServlet?page=${i}&keyword=${param.keyword}" class="page-link ${i == currentPage ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                            <c:if test="${currentPage < totalPages}">
                                <a href="${pageContext.request.contextPath}/CustomerListServlet?page=${currentPage + 1}&keyword=${param.keyword}" class="page-link">&raquo;</a>
                            </c:if>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>

        <div id="confirmModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2 id="modalTitle"></h2>
                <p id="modalText"></p>
                <div class="modal-buttons">
                    <button id="confirmBtn" onclick="confirmAction()">Xác Nhận</button>
                    <button class="cancel-btn" onclick="closeModal()">Hủy Bỏ</button>
                </div>
            </div>
        </div>

        <script>
            let userIdToAction = null;
            let actionToPerform = null;

            // Thay thế hàm showConfirmModal hiện tại bằng code này:
            function showConfirmModal(userId, username, action) {
                const modal = document.getElementById("confirmModal");
                const title = document.getElementById("modalTitle");
                const text = document.getElementById("modalText");
                const confirmBtn = document.getElementById("confirmBtn");

                userIdToAction = userId;
                actionToPerform = action;

                if (action === 'ban') {
                    title.innerText = "Xác nhận Hạn chế";
                    text.innerHTML = `Bạn có chắc muốn <strong>hạn chế</strong> tài khoản của khách hàng <strong>${username}</strong>?`;
                    confirmBtn.innerText = "Xác nhận Hạn chế";
                    confirmBtn.style.backgroundColor = '#ffc107';
                    confirmBtn.style.borderColor = '#ffc107';
                    confirmBtn.style.color = '#212529';
                } else if (action === 'unban') {
                    title.innerText = "Xác nhận Kích hoạt";
                    text.innerHTML = `Bạn có chắc muốn <strong>kích hoạt</strong> lại tài khoản của khách hàng <strong>${username}</strong>?`;
                    confirmBtn.innerText = "Xác nhận Kích hoạt";
                    confirmBtn.style.backgroundColor = '#28a745';
                    confirmBtn.style.borderColor = '#28a745';
                    confirmBtn.style.color = 'white';
                }

                // SỬA LỖI: Sử dụng class 'show' thay vì trực tiếp set display
                modal.classList.add('show');
            }

            function closeModal() {
                const modal = document.getElementById("confirmModal");
                modal.classList.remove('show');
            }

            // Thêm đoạn code này để đóng modal khi click bên ngoài
            window.onclick = function (event) {
                const modal = document.getElementById("confirmModal");
                if (event.target === modal) {
                    closeModal();
                }
            };

            function confirmAction() {
                if (!userIdToAction || !actionToPerform)
                    return;

                let url = '';
                if (actionToPerform === 'ban' || actionToPerform === 'unban') {
                    url = '${pageContext.request.contextPath}/staff/UpdateCustomerStatusServlet?id=' + userIdToAction + '&action=' + actionToPerform;
                }

                if (url) {
                    window.location.href = url;
                }
            }

        </script>
    </body>
</html>