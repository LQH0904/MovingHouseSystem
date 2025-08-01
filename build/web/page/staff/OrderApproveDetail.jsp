<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xét duyệt đơn hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* Chỉ styling cho phần content trong div3 */
        .div3 {
            padding: 2rem !important;
            background-color: #f8fafc !important;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif !important;
        }

        /* Page header */
        .approval-page-header {
            background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            color: white;
            padding: 2rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .approval-page-header h2 {
            font-size: 1.875rem;
            font-weight: 700;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

/*        .approval-page-header .breadcrumb {
            margin-top: 0.5rem;
            opacity: 0.9;
            font-size: 0.875rem;
        }

        .approval-page-header .breadcrumb a {
            color: white;
            text-decoration: none;
            opacity: 0.8;
        }

        .approval-page-header .breadcrumb a:hover {
            opacity: 1;
            text-decoration: underline;
        }*/

        /* Content grid */
        .approval-content-grid {
            display: grid;
            grid-template-columns: 1fr 400px;
            gap: 2rem;
            margin-bottom: 2rem;
        }

        /* Info cards */
        .info-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            overflow: hidden;
            border: 1px solid #e2e8f0;
        }

        .info-card-header {
            background: #f8fafc;
            padding: 1.5rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .info-card-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
            color: #1e293b;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card-body {
            padding: 0;
        }

        /* Modern info table */
        .modern-info-table {
            width: 100%;
            border-collapse: collapse;
        }

        .modern-info-table tr {
            border-bottom: 1px solid #f1f5f9;
        }

        .modern-info-table tr:last-child {
            border-bottom: none;
        }

        .modern-info-table th {
            background: #f8fafc;
            padding: 1rem 1.5rem;
            text-align: left;
            font-weight: 600;
            color: #475569;
            font-size: 0.875rem;
            width: 35%;
            border-right: 1px solid #e2e8f0;
        }

        .modern-info-table td {
            padding: 1rem 1.5rem;
            color: #1e293b;
            font-weight: 500;
        }

        /* Special styling for specific data */
        .order-id-value {
            font-family: 'Courier New', monospace;
            color: #3b82f6;
            font-weight: 700;
            font-size: 1.1em;
        }

        .customer-name-value {
            color: #059669;
            font-weight: 600;
        }

        .distance-value {
            color: #dc2626;
            font-weight: 600;
        }

        .date-value {
            color: #7c2d12;
            font-weight: 500;
        }

        /* Status indicators */
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-approved {
            background: #d1fae5;
            color: #065f46;
        }

        /* Shipping unit card */
        .shipping-unit-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
            overflow: hidden;
        }

        .shipping-unit-header {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: white;
            padding: 1.5rem;
        }

        .shipping-unit-header h3 {
            font-size: 1.25rem;
            font-weight: 600;
            margin: 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .shipping-unit-body {
            padding: 1.5rem;
        }

        .unit-info-grid {
            display: grid;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }

        .unit-info-item {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.75rem;
            background: #f8fafc;
            border-radius: 8px;
            border-left: 4px solid #10b981;
        }

        .unit-info-item .icon {
            color: #10b981;
            font-size: 1.125rem;
        }

        .unit-info-item .label {
            font-weight: 600;
            color: #374151;
            min-width: 60px;
        }

        .unit-info-item .value {
            color: #1f2937;
            font-weight: 500;
        }

        /* Action buttons */
        .action-section {
            margin-top: 2rem;
            padding: 1.5rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }

        .assign-btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 2rem;
            background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 6px rgba(59, 130, 246, 0.2);
            width: 100%;
            justify-content: center;
        }

        .assign-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(59, 130, 246, 0.3);
        }

        .assign-btn:active {
            transform: translateY(0);
        }

        .assign-btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* No unit found state */
        .no-unit-state {
            text-align: center;
            padding: 3rem;
            color: #64748b;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            border: 1px solid #e2e8f0;
        }

        .no-unit-state i {
            font-size: 3rem;
            margin-bottom: 1rem;
            opacity: 0.5;
            color: #f59e0b;
        }

        .no-unit-state h3 {
            margin: 1rem 0 0.5rem 0;
            color: #374151;
            font-size: 1.25rem;
        }

        .no-unit-state p {
            margin: 0;
            font-size: 0.875rem;
        }

        /* Alert messages */
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-weight: 500;
        }

        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        .alert-error {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fca5a5;
        }

        .alert i {
            font-size: 1.125rem;
        }

        /* Loading state */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.5);
            display: none;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }

        .loading-content {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0 10px 25px rgba(0,0,0,0.2);
        }

        .spinner {
            border: 3px solid #f3f4f6;
            border-top: 3px solid #3b82f6;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            animation: spin 1s linear infinite;
            margin: 0 auto 1rem;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
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
        @media (max-width: 1024px) {
            .approval-content-grid {
                grid-template-columns: 1fr;
                gap: 1.5rem;
            }
        }

        @media (max-width: 768px) {
            .div3 {
                padding: 1rem !important;
            }
            
            .modern-info-table th {
                width: 40%;
                font-size: 0.75rem;
            }
            
            .modern-info-table th,
            .modern-info-table td {
                padding: 0.75rem;
            }
        }
    </style>
</head>
<body>
    <div class="parent">
        <div class="div1">
            <jsp:include page="../../Layout/staff/SideBar.jsp"/>
        </div>
        <div class="div2">
            <jsp:include page="../../Layout/staff/Header.jsp"/>
        </div>
        <div class="div3">
            <!-- Page Header -->
            <div class="approval-page-header fade-in">
                <h2>
                    <i class="fas fa-clipboard-check"></i>
                    Xét duyệt đơn hàng
                </h2>
                <div class="breadcrumb">
                    <a href="${pageContext.request.contextPath}/staff/order-approve">Danh sách đơn hàng</a>
                    <span> / </span>
                    <span>Chi tiết đơn hàng #${order.orderId}</span>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty message}">
                <div class="alert alert-success fade-in">
                    <i class="fas fa-check-circle"></i>
                    ${message}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-error fade-in">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Content Grid -->
            <div class="approval-content-grid">
                <!-- Order Information -->
                <div class="info-card fade-in">
                    <div class="info-card-header">
                        <h3>
                            <i class="fas fa-file-invoice"></i>
                            Thông tin đơn hàng
                        </h3>
                    </div>
                    <div class="info-card-body">
                        <table class="modern-info-table">
                            <tr>
                                <th><i class="fas fa-hashtag"></i> Mã đơn</th>
                                <td class="order-id-value">#${order.orderId}</td>
                            </tr>
                            <tr>
                                <th><i class="fas fa-user"></i> Khách hàng</th>
                                <td class="customer-name-value">${order.fullName}</td>
                            </tr>
                            <tr>
                                <th><i class="fas fa-calendar-plus"></i> Ngày tạo</th>
                                <td class="date-value">${order.createdAt}</td>
                            </tr>
                            <tr>
                                <th><i class="fas fa-calendar-check"></i> Lịch giao</th>
                                <td class="date-value">${order.deliverySchedule}</td>
                            </tr>
                            <tr>
                                <th><i class="fas fa-map-marker-alt"></i> Địa chỉ lấy</th>
                                <td>${order.pickupLocation}</td>
                            </tr>
                            <tr>
                                <th><i class="fas fa-shipping-fast"></i> Địa chỉ giao</th>
                                <td>${order.shippingLocation}</td>
                            </tr>
                            <tr>
                                <th><i class="fas fa-route"></i> Khoảng cách</th>
                                <td class="distance-value">${order.totalDistanceKm} km</td>
                            </tr>
                        </table>
                    </div>
                </div>

                <!-- Shipping Unit Information -->
                <div class="fade-in">
                    <c:choose>
                        <c:when test="${nearestUnit != null}">
                            <div class="shipping-unit-card">
                                <div class="shipping-unit-header">
                                    <h3>
                                        <i class="fas fa-truck"></i>
                                        Đơn vị vận chuyển gần nhất
                                    </h3>
                                </div>
                                <div class="shipping-unit-body">
                                    <div class="unit-info-grid">
                                        <div class="unit-info-item">
                                            <i class="fas fa-id-badge icon"></i>
                                            <span class="label">ID:</span>
                                            <span class="value">${nearestUnit.id}</span>
                                        </div>
                                        <div class="unit-info-item">
                                            <i class="fas fa-building icon"></i>
                                            <span class="label">Tên:</span>
                                            <span class="value">${nearestUnit.companyName}</span>
                                        </div>
                                        <div class="unit-info-item">
                                            <i class="fas fa-map-marker-alt icon"></i>
                                            <span class="label">Địa chỉ:</span>
                                            <span class="value">${nearestUnit.location}</span>
                                        </div>
                                    </div>
                                    
                                    <div class="action-section">
                                        <form method="post" action="${pageContext.request.contextPath}/staff/order-approve" onsubmit="showLoading()">
                                            <input type="hidden" name="orderId" value="${order.orderId}" />
                                            <button type="submit" class="assign-btn" id="assignBtn">
                                                <i class="fas fa-check"></i>
                                                Gán đơn vị vận chuyển
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="no-unit-state">
                                <i class="fas fa-exclamation-triangle"></i>
                                <h3>Không tìm thấy đơn vị phù hợp</h3>
                                <p>Hiện tại không có đơn vị vận chuyển nào phù hợp với đơn hàng này.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="loading-content">
            <div class="spinner"></div>
            <p>Đang xử lý yêu cầu...</p>
        </div>
    </div>

    <script>
        // Show loading overlay when form is submitted
        function showLoading() {
            const overlay = document.getElementById('loadingOverlay');
            const btn = document.getElementById('assignBtn');
            
            if (overlay) {
                overlay.style.display = 'flex';
            }
            
            if (btn) {
                btn.disabled = true;
                btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            }
        }

        // Add fade-in animation on page load
        document.addEventListener('DOMContentLoaded', function() {
            const elements = document.querySelectorAll('.fade-in');
            elements.forEach((element, index) => {
                element.style.opacity = '0';
                element.style.transform = 'translateY(20px)';
                
                setTimeout(() => {
                    element.style.transition = 'all 0.5s ease';
                    element.style.opacity = '1';
                    element.style.transform = 'translateY(0)';
                }, index * 150);
            });
        });

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.transition = 'all 0.5s ease';
                    alert.style.opacity = '0';
                    alert.style.transform = 'translateY(-20px)';
                    setTimeout(() => {
                        alert.remove();
                    }, 500);
                }, 5000);
            });
        });
    </script>
</body>
</html>