<%--
    Document : orderHistory
    Created on : Aug 2, 2025, 1:12:09 PM
    Author : admin
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.OrderDAO2" %>
<%@ page import="model.Orders" %>
<%@ page import="model.Users" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%!
    private String formatDate(java.sql.Timestamp timestamp) {
        if (timestamp == null) {
            return "";
        }
        return new java.text.SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(timestamp);
    }
    private String formatVND(BigDecimal amount) {
        if (amount == null) {
            return "0 VND";
        }
        java.text.DecimalFormat df = new java.text.DecimalFormat("#,###");
        return df.format(amount) + " VND";
    }
    private String getStatusIcon(String status) {
        switch (status != null ? status.toLowerCase() : "") {
            case "pending":
                return "<i class='fas fa-clock' title='Chờ xử lý'></i>";
            case "in_progress":
                return "<i class='fas fa-truck' title='Đang xử lý'></i>";
            case "delivered":
                return "<i class='fas fa-check-circle' title='Đã giao'></i>";
            case "cancelled":
                return "<i class='fas fa-times-circle' title='Đã hủy'></i>";
            default:
                return "<i class='fas fa-question-circle' title='Không xác định'></i>";
        }
    }
%>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }
    Users userAccount = (Users) session.getAttribute("acc");
    if (userAccount.getRoleId() != 6) {
        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only customers can access this page");
        return;
    }
    int currentUserId = userAccount.getUserId();
    OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
    int pageSize = 7;
    int currentPage = 1;
    String pageParam = request.getParameter("page");
    if (pageParam != null && !pageParam.isEmpty()) {
        try {
            currentPage = Integer.parseInt(pageParam);
            if (currentPage < 1) {
                currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
    }
    int offset = (currentPage - 1) * pageSize;
    int totalOrders = orderDAO.getTotalOrderCount(String.valueOf(currentUserId));
    int totalPages = (int) Math.ceil((double) totalOrders / pageSize);
    List<Orders> orders = orderDAO.getOrderList(null, null, null, null, null, null, String.valueOf(currentUserId), "created_at", "desc", pageSize, offset);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Lịch Sử Đơn Hàng</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>
            body {
                background-color: #F5F7FA;
                font-family: 'Poppins', sans-serif;
                margin: 0;
                padding: 0;
                line-height: 1.5;
                display: flex;
                min-height: 100vh;
            }
            .container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 1rem;
                flex-grow: 1;
            }
            h2 {
                color: #4A5568;
                font-weight: 600;
                text-align: left;
                margin: 0.5rem 0 1rem;
                font-size: 1.5rem;
                display: flex;
                align-items: center;
            }
            h2 i {
                margin-right: 0.5rem;
                color: #6B46C1;
            }
            .sidebar {
                width: 250px;
                background: linear-gradient(to bottom, #B794F4, #C9A7F4);
                color: white;
                height: 100vh;
                position: fixed;
                top: 0;
                left: 0;
                padding-top: 10px;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
                z-index: 1000;
            }
            .sidebar .sidebar-item {
                padding: 6px 12px;
                font-size: 0.85rem;
                color: #fff;
                text-decoration: none;
                display: flex;
                align-items: center;
                transition: background-color 0.3s ease;
            }
            .sidebar .sidebar-item:hover {
                background-color: rgba(255, 255, 255, 0.2);
            }
            .sidebar .sidebar-item.active {
                background-color: rgba(255, 255, 255, 0.3);
            }
            .main-content {
                margin-left: 250px;
                width: calc(100% - 250px);
                padding: 1rem;
                box-sizing: border-box;
            }
            .section {
                background-color: #FFFFFF;
                border-radius: 8px;
                padding: 1rem;
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
                margin-bottom: 1rem;
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                border-spacing: 0;
                background: #FFFFFF;
                border-radius: 8px;
                overflow: hidden;
            }
            .table thead th {
                background: #FFFFFF;
                color: #000000;
                font-weight: 600;
                padding: 10px;
                text-align: center;
                text-transform: uppercase;
                border-bottom: 2px solid #E2E8F0;
            }
            .table thead th i {
                margin-left: 0.25rem;
            }
            .table tbody tr:nth-child(even) {
                background-color: #F9FAFB;
            }
            .table tbody tr:hover {
                background-color: #EDF2F7;
                transition: background-color 0.3s ease;
            }
            .table tbody td {
                padding: 10px;
                color: #2D3748;
                text-align: center;
                border-bottom: 1px solid #E2E8F0;
            }
            .table tbody td:nth-child(1) {
                font-size: 0.875rem;
            }
            .btn-primary {
                background: linear-gradient(90deg, #48BB78 0%, #81E6D9 100%);
                color: white;
                padding: 0.4rem 0.8rem;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.875rem;
                transition: transform 0.2s ease, box-shadow 0.3s ease;
            }
            .btn-primary:hover {
                transform: translateY(-1px);
                background: linear-gradient(90deg, #2F855A 0%, #4FD1C5 100%);
                box-shadow: 0 2px 6px rgba(72, 187, 120, 0.3);
            }
            .btn-secondary {
                background: linear-gradient(90deg, #E53E3E 0%, #F687B3 100%);
                color: white;
                padding: 0.4rem 0.8rem;
                border-radius: 4px;
                border: none;
                cursor: pointer;
                font-weight: 500;
                font-size: 0.875rem;
                transition: transform 0.2s ease, box-shadow 0.3s ease;
            }
            .btn-secondary:hover {
                transform: translateY(-1px);
                background: linear-gradient(90deg, #C53030 0%, #ED64A6 100%);
                box-shadow: 0 2px 6px rgba(229, 62, 62, 0.3);
            }
            .nav-icons {
                display: flex;
                gap: 0.75rem;
                margin-bottom: 1rem;
            }
            .nav-icons a {
                color: #4A5568;
                font-size: 1.5rem;
                transition: color 0.3s ease, transform 0.2s ease;
            }
            .nav-icons a:hover {
                color: #6B46C1;
                transform: scale(1.1);
            }
            .nav-links {
                display: flex;
                gap: 1rem;
                justify-content: flex-end;
                margin: 1rem 0;
            }
            .nav-links a {
                text-decoration: none;
                color: #6B46C1;
                font-weight: 500;
                font-size: 0.9rem;
                padding: 0.4rem 0.8rem;
                border-radius: 4px;
                display: flex;
                align-items: center;
                gap: 0.25rem;
                transition: background-color 0.3s, color 0.3s;
            }
            .nav-links a:hover {
                background-color: #6B46C1;
                color: white;
            }
            .nav-links a i {
                font-size: 0.9rem;
            }
            .message {
                display: none;
                max-width: 600px;
                margin: 0.5rem auto;
                padding: 0.75rem;
                border-radius: 6px;
                font-size: 0.9rem;
                font-weight: 500;
                text-align: center;
                box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
            }
            .success {
                background-color: #e6ffed;
                color: #207d3c;
                border: 1px solid #a2f5c1;
                display: <%= (request.getAttribute("successMessage") != null && !request.getAttribute("successMessage").toString().isEmpty()) ? "block" : "none"%>;
            }
            .error {
                background-color: #ffecec;
                color: #c0392b;
                border: 1px solid #f5a2a2;
                display: <%= (request.getAttribute("errorMessage") != null && !request.getAttribute("errorMessage").toString().isEmpty()) ? "block" : "none"%>;
            }
            .pagination {
                display: flex;
                justify-content: center;
                gap: 0.5rem;
                margin-top: 1rem;
            }
            .pagination a {
                text-decoration: none;
                color: #6B46C1;
                padding: 0.5rem 1rem;
                border-radius: 4px;
                border: 1px solid #E2E8F0;
                background-color: #FFFFFF;
                font-size: 0.875rem;
                transition: background-color 0.3s, color 0.3s;
            }
            .pagination a:hover:not(.disabled) {
                background-color: #6B46C1;
                color: white;
            }
            .pagination a.active {
                background-color: #6B46C1;
                color: white;
                border-color: #6B46C1;
            }
            .pagination a.disabled {
                color: #A0AEC0;
                cursor: not-allowed;
                background-color: #F7FAFC;
            }
            /* Modal Styles */
            .modal {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.5);
                z-index: 1000;
                justify-content: center;
                align-items: center;
            }
            .modal-content {
                background-color: #FFFFFF;
                border-radius: 8px;
                padding: 1.5rem;
                max-width: 600px;
                width: 90%;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
                text-align: center;
                animation: slideIn 0.3s ease-out;
            }
            .modal-content h3 {
                color: #4A5568;
                font-size: 1.25rem;
                font-weight: 600;
                margin-bottom: 1rem;
            }
            .modal-content p {
                color: #2D3748;
                font-size: 0.9rem;
                margin-bottom: 1.5rem;
            }
            .modal-buttons {
                display: flex;
                justify-content: center;
                gap: 1rem;
            }
            .total-row {
                margin-top: 1rem;
                font-weight: 600;
                color: #2D3748;
                text-align: right;
            }
            @keyframes slideIn {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }
            @media (max-width: 768px) {
                .container {
                    padding: 0.5rem;
                }
                .table thead th, .table tbody td {
                    font-size: 0.7rem;
                    padding: 6px;
                }
                .table tbody td:nth-child(1) {
                    font-size: 0.75rem;
                }
                .btn-primary, .btn-secondary {
                    width: 100%;
                    padding: 0.3rem;
                }
                .nav-links {
                    flex-direction: column;
                    gap: 0.5rem;
                }
                .nav-icons {
                    justify-content: flex-end;
                }
                h2 {
                    font-size: 1.2rem;
                }
                .pagination a {
                    padding: 0.4rem 0.8rem;
                    font-size: 0.75rem;
                }
                .modal-content {
                    width: 95%;
                    padding: 1rem;
                }
                .modal-content h3 {
                    font-size: 1.1rem;
                }
                .modal-content p {
                    font-size: 0.85rem;
                }
                .sidebar {
                    width: 200px;
                }
                .main-content {
                    margin-left: 200px;
                    width: calc(100% - 200px);
                }
            }
        </style>
        <script>
            function showConfirmModal(orderId) {
                const modal = document.getElementById('confirmModal');
                const orderIdSpan = document.getElementById('orderId');
                orderIdSpan.textContent = orderId;
                document.getElementById('confirmButton').onclick = function () {
                    document.getElementById('form-' + orderId).submit();
                };
                modal.style.display = 'flex';
            }
            function closeModal() {
                document.getElementById('confirmModal').style.display = 'none';
            }
            function showOrderDetails(orderId) {
                fetch('${pageContext.request.contextPath}/orderDetails?orderId=' + orderId)
                    .then(response => {
                        if (!response.ok) {
                            throw new Error('Network response was not ok: ' + response.statusText);
                        }
                        return response.json();
                    })
                    .then(data => {
                        const modal = document.getElementById('orderDetailsModal');
                        const orderIdSpan = document.getElementById('orderDetailsId');
                        const contentDiv = document.getElementById('orderDetailsContent');
                        orderIdSpan.textContent = orderId;
                        if (!data || data.length === 0) {
                            contentDiv.innerHTML = '<p class="text-gray-500">Không có chi tiết đơn hàng nào.</p>';
                        } else {
                            let totalPrice = 0;
                            let html = '<table class="table"><thead><tr><th>Tên mặt hàng</th><th>Số lượng</th><th>Khối lượng (kg)</th><th>Thể tích (m³)</th><th>Ghi chú</th><th>Giá</th></tr></thead><tbody>';
                            data.forEach(detail => {
                                const quantity = detail.quantity !== null && detail.quantity !== undefined ? detail.quantity : 0;
                                const weightKg = detail.weightKg !== null && detail.weightKg !== undefined ? Number(detail.weightKg) : '0';
                                const volumeM3 = detail.volumeM3 !== null && detail.volumeM3 !== undefined ? Number(detail.volumeM3) : '0';
                                const note = detail.note !== null && detail.note !== undefined ? detail.note : 'N/A';
                                const itemPrice = detail.itemPrice !== null && detail.itemPrice !== undefined ? Number(detail.itemPrice) : '0';
                                totalPrice += parseFloat(itemPrice);
                                html += '<tr>' +
                                        '<td>' + (detail.itemName || 'N/A') + '</td>' +
                                        '<td>' + quantity + '</td>' +
                                        '<td>' + weightKg + '</td>' +
                                        '<td>' + volumeM3 + '</td>' +
                                        '<td>' + note + '</td>' +
                                        '<td>' + itemPrice + ' VND</td>' +
                                        '</tr>';
                            });
                            html += '</tbody></table>';
                            html += '<div class="total-row">Tổng cộng: ' + totalPrice + ' VND</div>';
                            contentDiv.innerHTML = html;
                        }
                        modal.style.display = 'flex';
                    })
                    .catch(error => {
                        console.error('Error fetching order details:', error);
                        const contentDiv = document.getElementById('orderDetailsContent');
                        contentDiv.innerHTML = '<p class="text-red-500">Không thể tải chi tiết đơn hàng: ' + error.message + '</p>';
                        document.getElementById('orderDetailsModal').style.display = 'flex';
                    });
            }
            function closeDetailsModal() {
                document.getElementById('orderDetailsModal').style.display = 'none';
            }
            window.onclick = function (event) {
                const confirmModal = document.getElementById('confirmModal');
                const detailsModal = document.getElementById('orderDetailsModal');
                if (event.target === confirmModal) {
                    closeModal();
                }
                if (event.target === detailsModal) {
                    closeDetailsModal();
                }
            };
        </script>
    </head>
    <body class="bg-gray-100">
        <div class="sidebar">
            <div class="sidebar-item">Customer</div>
            <a href="${pageContext.request.contextPath}/transport" class="sidebar-item">Dashboard</a>
            <a href="${pageContext.request.contextPath}/orderHistory" class="sidebar-item active">Đơn hàng vận chuyển</a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">Đăng xuất</a>
        </div>
        <div class="main-content">
            <div class="container mx-auto px-4 py-4">
                <h2><i class="fas fa-history mr-2"></i> Lịch Sử Đơn Hàng</h2>
                <div class="message success" id="successMessage">${successMessage}</div>
                <div class="message error" id="errorMessage">${errorMessage}</div>
                <div class="nav-icons mb-2">
                    <a href="${pageContext.request.contextPath}/notifications" title="Thông báo" aria-label="Xem thông báo">
                        <i class="fas fa-bell"></i>
                    </a>
                </div>
                <div class="section">
                    <table class="table">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> Mã Đơn Hàng</th>
                                <th><i class="fas fa-calendar-day"></i> Ngày Tạo</th>
                                <th><i class="fas fa-truck"></i> Thời Gian Giao</th>
                                <th><i class="fas fa-circle-notch"></i> Trạng Thái</th>
                                <th><i class="fas fa-money-bill-wave"></i> Tổng Phí</th>
                                <th><i class="fas fa-conveyor-belt"></i> Dịch Vụ</th>
                                <th><i class="fas fa-tools"></i> Thao Tác</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (orders != null && !orders.isEmpty()) {
                                    for (Orders order : orders) {
                            %>
                            <tr>
                                <td><a href="javascript:void(0)" onclick="showOrderDetails(<%= order.getOrderId()%>)" class="text-blue-600 hover:underline"><%= order.getOrderId()%></a></td>
                                <td><%= formatDate(order.getCreatedAt())%></td>
                                <td><%= formatDate(order.getDeliverySchedule())%></td>
                                <td><%= getStatusIcon(order.getOrderStatus())%></td>
                                <td><%= formatVND(order.getTotalFee())%></td>
                                <td><%= order.getServiceType() != null ? order.getServiceType() : "N/A"%></td>
                                <td>
                                    <% if ("in_progress".equals(order.getOrderStatus())) {%>
                                    <form id="form-<%= order.getOrderId()%>" action="${pageContext.request.contextPath}/orderHistory?page=<%= currentPage%>" method="post">
                                        <input type="hidden" name="orderId" value="<%= order.getOrderId()%>">
                                        <button type="button" class="btn-primary" onclick="showConfirmModal(<%= order.getOrderId()%>)">Đã nhận</button>
                                    </form>
                                    <% } else if ("delivered".equals(order.getOrderStatus())) { %>
                                    <button class="btn-primary" disabled>Đánh giá chất lượng</button>
                                    <% } %>
                                </td>
                            </tr>
                            <%
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="7" class="text-center text-gray-500">Không có đơn hàng nào.</td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                    <div class="pagination">
                        <%
                            if (totalPages > 1) {
                                if (currentPage > 1) {
                        %>
                        <a href="${pageContext.request.contextPath}/orderHistory?page=<%= currentPage - 1%>">Trước</a>
                        <%
                        } else {
                        %>
                        <a class="disabled">Trước</a>
                        <%
                            }
                            for (int i = 1; i <= totalPages; i++) {
                        %>
                        <a href="${pageContext.request.contextPath}/orderHistory?page=<%= i%>" <%= (i == currentPage) ? "class='active'" : ""%>><%= i%></a>
                        <%
                            }
                            if (currentPage < totalPages) {
                        %>
                        <a href="${pageContext.request.contextPath}/orderHistory?page=<%= currentPage + 1%>">Sau</a>
                        <%
                        } else {
                        %>
                        <a class="disabled">Sau</a>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/login"><i class="fas fa-home"></i> Về Trang Chủ</a>
                    <a href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt"></i> Đăng Xuất</a>
                </div>
                <!-- Confirmation Modal -->
                <div id="confirmModal" class="modal">
                    <div class="modal-content">
                        <h3>Xác nhận giao hàng</h3>
                        <p>Bạn có chắc chắn đã nhận được đơn hàng <span id="orderId"></span> không?</p>
                        <div class="modal-buttons">
                            <button id="confirmButton" class="btn-primary">Xác nhận</button>
                            <button class="btn-secondary" onclick="closeModal()">Hủy</button>
                        </div>
                    </div>
                </div>
                <!-- Order Details Modal -->
                <div id="orderDetailsModal" class="modal">
                    <div class="modal-content">
                        <h3>Chi tiết đơn hàng <span id="orderDetailsId"></span></h3>
                        <div id="orderDetailsContent"></div>
                        <div class="modal-buttons">
                            <button class="btn-secondary" onclick="closeDetailsModal()">Đóng</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>