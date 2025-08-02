<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách đơn hàng chờ duyệt</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Chỉ styling cho phần content, không động đến layout chính */
        .div3 {
            padding: 2rem !important;
            background-color: #f8fafc !important;
        }

        /* Page header styling */
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .page-header h2 {
            font-size: 1.875rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            margin: 0;
        }

        .page-header p {
            opacity: 0.9;
            font-size: 1rem;
            margin: 0.5rem 0 0 0;
        }

        /* Stats container */
        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            padding: 1.5rem;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            border-left: 4px solid #3b82f6;
        }

        .stat-card h3 {
            color: #64748b;
            font-size: 0.875rem;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin: 0;
        }

        .stat-card p {
            font-size: 2rem;
            font-weight: 700;
            color: #1e293b;
            margin: 0.5rem 0 0 0;
        }

        /* Table container */
        .modern-table-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }

        .modern-table-header {
            background: #f8fafc;
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .modern-table-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin: 0;
        }

        /* Search input */
        .search-input {
            width: 100%;
            max-width: 300px;
            padding: 0.75rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.875rem;
            margin-bottom: 1.5rem;
            font-family: inherit;
        }

        .search-input:focus {
            outline: none;
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        /* Modern table styling */
        .modern-orders-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.875rem;
            font-family: inherit;
        }

        .modern-orders-table thead {
            background: #f1f5f9;
        }

        .modern-orders-table th {
            padding: 1rem;
            text-align: left;
            font-weight: 600;
            color: #475569;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 0.75rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .modern-orders-table td {
            padding: 1rem;
            border-bottom: 1px solid #f1f5f9;
            vertical-align: middle;
        }

        .modern-orders-table tbody tr {
            transition: all 0.2s ease;
        }

        .modern-orders-table tbody tr:hover {
            background-color: #f8fafc;
            transform: translateY(-1px);
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        /* Cell styling */
        .order-id {
            font-weight: 600;
            color: #3b82f6;
            font-family: 'Courier New', monospace;
        }

        .customer-name {
            font-weight: 500;
            color: #1e293b;
        }

        .date-cell {
            color: #64748b;
            font-size: 0.8125rem;
        }

        .location-cell {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            color: #475569;
        }

        /* Action button */
        .modern-action-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            font-size: 0.8125rem;
            transition: all 0.2s ease;
            box-shadow: 0 2px 4px rgba(16, 185, 129, 0.2);
        }

        .modern-action-btn:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 8px rgba(16, 185, 129, 0.3);
            text-decoration: none;
            color: white;
        }

        .modern-action-btn:active {
            transform: translateY(0);
        }

        /* Empty state */
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #64748b;
        }

        .empty-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }

        .empty-state h3 {
            margin: 1rem 0 0.5rem 0;
            color: #374151;
        }

        .empty-state p {
            margin: 0;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .div3 {
                padding: 1rem !important;
            }
            
            .modern-orders-table {
                font-size: 0.75rem;
            }
            
            .modern-orders-table th,
            .modern-orders-table td {
                padding: 0.5rem;
            }
            
            .location-cell {
                max-width: 120px;
            }

            .stats-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="parent">
        <div class="div1">
            <jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
        </div>
        <div class="div2">
            <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
        </div>
        <div class="div3">
            <div class="page-header fade-in">
                <h2>
                    <i class="fas fa-clipboard-check"></i>
                    Danh sách đơn hàng đang chờ duyệt
                </h2>
                <p>Quản lý và xét duyệt các đơn hàng đang chờ xử lý</p>
            </div>

            <div class="stats-container fade-in">
                <div class="stat-card">
                    <h3>Tổng đơn hàng</h3>
                    <p id="total-orders">${orders.size()}</p>
                </div>
                <div class="stat-card">
                    <h3>Chờ duyệt</h3>
                    <p id="pending-orders">${orders.size()}</p>
                </div>
            </div>

            <div class="modern-table-container fade-in">
                <div class="modern-table-header">
                    <h3>
                        <i class="fas fa-list"></i>
                        Danh sách đơn hàng
                    </h3>
                </div>
                
                <div style="padding: 1.5rem 1.5rem 0;">
                    <input type="text" class="search-input" placeholder="Tìm kiếm đơn hàng..." id="searchInput">
                </div>

                <c:choose>
                    <c:when test="${empty orders}">
                        <div class="empty-state">
                            <i class="fas fa-inbox"></i>
                            <h3>Không có đơn hàng nào</h3>
                            <p>Hiện tại không có đơn hàng nào đang chờ duyệt</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <table class="modern-orders-table" id="orders-table">
                            <thead>
                                <tr>
                                    <th><i class="fas fa-hashtag"></i> Mã đơn hàng</th>
                                    <th><i class="fas fa-user"></i> Tên khách hàng</th>
                                    <th><i class="fas fa-calendar"></i> Ngày tạo</th>
                                    <th><i class="fas fa-map-marker-alt"></i> Điểm lấy hàng</th>
                                    <th><i class="fas fa-shipping-fast"></i> Điểm giao hàng</th>
                                    <th><i class="fas fa-cogs"></i> Thao tác</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}" varStatus="status">
                                    <tr class="order-row" style="animation-delay: ${status.index * 0.1}s">
                                        <td class="order-id">#${order.orderId}</td>
                                        <td class="customer-name">${order.fullName}</td>
                                        <td class="date-cell">${order.createdAt}</td>
                                        <td class="location-cell" title="${order.pickupLocation}">
                                            ${order.pickupLocation}
                                        </td>
                                        <td class="location-cell" title="${order.shippingLocation}">
                                            ${order.shippingLocation}
                                        </td>
                                        <td>
                                            <a href="${pageContext.request.contextPath}/staff/order-approve?action=detail&id=${order.orderId}" 
                                               class="modern-action-btn"
                                               onclick="showLoading(this)">
                                                <i class="fas fa-eye"></i>
                                                Xét Duyệt
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <script>
        // Add loading animation when clicking action buttons
        function showLoading(button) {
            const originalText = button.innerHTML;
            button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang tải...';
            button.style.pointerEvents = 'none';
            
            // Reset after 3 seconds if page doesn't navigate
            setTimeout(() => {
                button.innerHTML = originalText;
                button.style.pointerEvents = 'auto';
            }, 3000);
        }

        // Add fade-in animation to table rows
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('.order-row');
            rows.forEach((row, index) => {
                row.style.opacity = '0';
                row.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    row.style.transition = 'all 0.5s ease';
                    row.style.opacity = '1';
                    row.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Add search functionality
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('input', function(e) {
                    const searchTerm = e.target.value.toLowerCase();
                    const rows = document.querySelectorAll('.order-row');
                    
                    rows.forEach(row => {
                        const text = row.textContent.toLowerCase();
                        if (text.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }
        });

        // Add hover effects and tooltips
        document.querySelectorAll('.location-cell').forEach(cell => {
            if (cell.scrollWidth > cell.clientWidth) {
                cell.style.cursor = 'help';
            }
        });
    </script>
</body>
</html>