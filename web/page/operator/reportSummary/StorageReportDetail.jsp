<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết Báo cáo Storage</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            .storage-container {
                padding: 20px;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .page-header {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                margin-bottom: 25px;
                border-left: 5px solid #3498db;
            }

            .page-title {
                color: #2c3e50;
                font-size: 28px;
                font-weight: 600;
                margin: 0;
                display: flex;
                align-items: center;
            }

            .page-title::before {
                content: "📊";
                margin-right: 15px;
                font-size: 32px;
            }

            .page-subtitle {
                color: #7f8c8d;
                font-size: 16px;
                margin-top: 8px;
                margin-bottom: 0;
            }

            /* Stats Overview */
            .stats-overview {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                margin-bottom: 25px;
            }

            .stat-card {
                background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                text-align: center;
                border-left: 4px solid;
                transition: all 0.3s ease;
            }

            .stat-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.15);
            }

            .stat-card.inbound {
                border-left-color: #3498db;
            }

            .stat-card.outbound {
                border-left-color: #e74c3c;
            }

            .stat-card.profit {
                border-left-color: #2ecc71;
            }

            .stat-value {
                font-size: 24px;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 12px;
                color: #7f8c8d;
                font-weight: 500;
                text-transform: uppercase;
            }

            /* Filter Section */
            .filter-section {
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 25px;
            }

            .filter-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #ecf0f1;
            }

            .filter-title {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
                margin: 0;
            }

            .export-btn {
                padding: 8px 16px;
                background: linear-gradient(45deg, #27ae60, #2ecc71);
                color: white;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .export-btn:hover {
                background: linear-gradient(45deg, #219a52, #27ae60);
                transform: translateY(-1px);
                box-shadow: 0 3px 10px rgba(39, 174, 96, 0.3);
            }

            .filter-row {
                display: flex;
                gap: 20px;
                align-items: end;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                min-width: 200px;
            }

            .filter-label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                font-size: 14px;
            }

            .filter-input {
                padding: 12px 15px;
                border: 2px solid #e1e8ed;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
                background: white;
            }

            .filter-input:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .filter-btn {
                padding: 12px 25px;
                background: linear-gradient(45deg, #3498db, #2980b9);
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                margin-left: 10px;
            }

            .filter-btn:hover {
                background: linear-gradient(45deg, #2980b9, #1f5582);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3);
            }

            .clear-btn {
                background: linear-gradient(45deg, #95a5a6, #7f8c8d);
                margin-left: 10px;
            }

            .clear-btn:hover {
                background: linear-gradient(45deg, #7f8c8d, #5d6d6e);
            }

            /* Table Section */
            .table-section {
                background: white;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                overflow: hidden;
                margin-bottom: 20px;
            }

            .table-header {
                background: linear-gradient(45deg, #2c3e50, #34495e);
                color: white;
                padding: 20px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .table-title {
                font-size: 20px;
                font-weight: 600;
                margin: 0;
            }

            .table-info {
                font-size: 14px;
                opacity: 0.9;
                color: black;
                background-color: white;
                padding: 5px;
                border-radius: 10px;
            }

            .storage-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            .storage-table th {
                background: linear-gradient(45deg, #34495e, #2c3e50);
                color: white;
                padding: 15px 12px;
                text-align: center;
                font-weight: 600;
                font-size: 13px;
                border-bottom: 2px solid #2c3e50;
                position: sticky;
                top: 0;
                z-index: 10;
                white-space: nowrap;
            }

            .storage-table td {
                padding: 12px 10px;
                border-bottom: 1px solid #ecf0f1;
                font-size: 13px;
                transition: background-color 0.3s ease;
                text-align: center;
            }

            .storage-table tr:hover {
                background-color: #f8f9fa;
                transform: scale(1.01);
                box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            }

            .storage-table tr:nth-child(even) {
                background-color: #f9f9f9;
            }

            /* Number formatting */
            .number-cell {
                text-align: right;
                font-family: 'Courier New', monospace;
                font-weight: 500;
            }

            .currency-cell {
                color: #27ae60;
                font-weight: 600;
            }

            .percentage-cell {
                color: #3498db;
                font-weight: 600;
            }

            /* Warehouse name styling */
            .warehouse-name {
                font-weight: 600;
                color: #2c3e50;
                text-align: left;
            }

            /* Date cell styling */
            .date-cell {
                font-weight: 500;
                color: #7f8c8d;
            }

            /* Status indicators */
            .status-high {
                color: #e74c3c;
                font-weight: 600;
            }

            .status-medium {
                color: #f39c12;
                font-weight: 600;
            }

            .status-low {
                color: #27ae60;
                font-weight: 600;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 50px 20px;
                color: #7f8c8d;
            }

            .empty-state i {
                font-size: 48px;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            /* Loading State */
            .loading {
                display: flex;
                justify-content: center;
                align-items: center;
                height: 200px;
                font-size: 18px;
                color: #7f8c8d;
            }

            .loading::before {
                content: "";
                width: 20px;
                height: 20px;
                border: 2px solid #f3f3f3;
                border-top: 2px solid #3498db;
                border-radius: 50%;
                animation: spin 1s linear infinite;
                margin-right: 10px;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Utilization bar */
            .utilization-bar {
                width: 100px;
                height: 20px;
                background: #ecf0f1;
                border-radius: 10px;
                position: relative;
                overflow: hidden;
                margin: 0 auto 5px auto;
            }

            .utilization-fill {
                height: 100%;
                border-radius: 10px;
                transition: width 0.3s ease;
            }

            .utilization-fill.low {
                background: linear-gradient(45deg, #2ecc71, #27ae60);
            }

            .utilization-fill.medium {
                background: linear-gradient(45deg, #f39c12, #e67e22);
            }

            .utilization-fill.high {
                background: linear-gradient(45deg, #e74c3c, #c0392b);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                }

                .filter-group {
                    min-width: 100%;
                }

                .storage-table {
                    font-size: 11px;
                }

                .storage-table th,
                .storage-table td {
                    padding: 8px 6px;
                }

                .page-title {
                    font-size: 24px;
                }

                .stats-overview {
                    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
                }

                .filter-header {
                    flex-direction: column;
                    gap: 10px;
                    align-items: flex-start;
                }
            }

            /* Custom scrollbar for table */
            .table-wrapper {
                max-height: 600px;
                overflow-y: auto;
                border-radius: 0 0 15px 15px;
            }

            .table-wrapper::-webkit-scrollbar {
                width: 8px;
                height: 8px;
            }

            .table-wrapper::-webkit-scrollbar-track {
                background: #f1f1f1;
            }

            .table-wrapper::-webkit-scrollbar-thumb {
                background: #888;
                border-radius: 4px;
            }

            .table-wrapper::-webkit-scrollbar-thumb:hover {
                background: #555;
            }

            /* Message styling */
            .success-message {
                background: #d4edda;
                border: 1px solid #c3e6cb;
                color: #155724;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-weight: 500;
            }

            .error-message {
                background: #f8d7da;
                border: 1px solid #f5c6cb;
                color: #721c24;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                font-weight: 500;
            }

            /* Summary section styling */
            .summary-section {
                background: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-top: 25px;
            }

            .summary-title {
                font-size: 18px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 15px;
                display: flex;
                align-items: center;
            }

            .summary-title::before {
                content: "📈";
                margin-right: 10px;
                font-size: 20px;
            }

            .summary-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
            }

            .summary-item {
                text-align: center;
            }

            .summary-label {
                font-size: 14px;
                color: #7f8c8d;
                font-weight: 500;
                margin-bottom: 5px;
            }

            .summary-value {
                font-size: 18px;
                font-weight: 700;
                color: #2c3e50;
            }

            .summary-value.inbound {
                color: #27ae60;
            }

            .summary-value.outbound {
                color: #e74c3c;
            }

            .summary-value.profit {
                color: #9b59b6;
            }

            .summary-value.orders {
                color: #3498db;
            }

            /* Notification toast */
            .toast {
                position: fixed;
                top: 20px;
                right: 20px;
                background: #2ecc71;
                color: white;
                padding: 15px 20px;
                border-radius: 8px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                z-index: 1000;
                opacity: 0;
                transform: translateX(100%);
                transition: all 0.3s ease;
            }

            .toast.show {
                opacity: 1;
                transform: translateX(0);
            }

            .toast.error {
                background: #e74c3c;
            }

            .cssbuttons-io-button {
                background-image: linear-gradient(19deg, #21D4FD 0%, #B721FF 100%);
                color: white;
                font-family: inherit;
                padding: 0.35em;
                padding-left: 1.2em;
                font-size: 17px;
                border-radius: 10em;
                border: none;
                letter-spacing: 0.05em;
                display: flex;
                align-items: center;
                overflow: hidden;
                position: relative;
                height: 2.8em;
                padding-right: 3.3em;
                cursor: pointer;
                text-transform: uppercase;
                font-weight: 500;
                box-shadow: 0 0 1.6em rgba(183, 33, 255,0.3),0 0 1.6em hsla(191, 98%, 56%, 0.3);
                transition: all 0.6s cubic-bezier(0.23, 1, 0.320, 1);
            }

            .cssbuttons-io-button {
                background: #a370f0;
                color: white;
                font-family: inherit;
                padding: 0.35em;
                padding-left: 1.2em;
                font-size: 17px;
                font-weight: 500;
                border-radius: 0.9em;
                border: none;
                letter-spacing: 0.05em;
                display: flex;
                align-items: center;
                box-shadow: inset 0 0 1.6em -0.6em #714da6;
                overflow: hidden;
                position: relative;
                height: 2.8em;
                padding-right: 3.3em;
                cursor: pointer;
            }

            .cssbuttons-io-button .icon {
                background: white;
                margin-left: 1em;
                position: absolute;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 2.2em;
                width: 2.2em;
                border-radius: 0.7em;
                box-shadow: 0.1em 0.1em 0.6em 0.2em #7b52b9;
                right: 0.3em;
                transition: all 0.3s;
            }

            .cssbuttons-io-button:hover .icon {
                width: calc(100% - 0.6em);
            }

            .cssbuttons-io-button .icon svg {
                width: 1.1em;
                transition: transform 0.3s;
                color: #7b52b9;
            }

            .cssbuttons-io-button:hover .icon svg {
                transform: translateX(0.1em);
            }

            .cssbuttons-io-button:active .icon {
                transform: scale(0.95);
            }

            a:hover{
                text-decoration: none;
            }
            .butt{
                display: flex;
                justify-content: flex-start;
                margin: 20px;
            }
            .detail-toggle {
                background: #007bff;
                color: white;
                border: none;
                padding: 8px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 12px;
                transition: all 0.3s ease;
            }

            .detail-toggle:hover {
                background: #0056b3;
            }

            .detail-toggle.expanded {
                background: #28a745;
            }

            .detail-toggle.expanded i {
                transform: rotate(180deg);
            }

            .detail-toggle i {
                transition: transform 0.3s ease;
                margin-right: 5px;
            }

            .detail-row {
                background: #f8f9fa;
                border-top: 1px solid #dee2e6;
            }

            .detail-content {
                padding: 20px;
            }

            .detail-content h4 {
                margin: 0 0 15px 0;
                color: #495057;
                font-size: 16px;
                border-bottom: 2px solid #007bff;
                padding-bottom: 5px;
            }

            .detail-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
            }

            .detail-section h5 {
                margin: 0 0 10px 0;
                color: #6c757d;
                font-size: 14px;
                font-weight: 600;
            }

            .detail-item {
                display: flex;
                justify-content: space-between;
                padding: 8px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .detail-item:last-child {
                border-bottom: none;
            }

            .detail-item .label {
                font-weight: 500;
                color: #495057;
            }

            .detail-item .value {
                font-weight: 600;
            }

            .profit-value {
                color: #28a745;
                font-weight: bold;
            }

            .status-low {
                color: #17a2b8;
            }

            .status-medium {
                color: #ffc107;
            }

            .status-high {
                color: #dc3545;
            }

            @media (max-width: 768px) {
                .detail-grid {
                    grid-template-columns: 1fr;
                    gap: 15px;
                }
            }
            .bnt2 {
                align-items: center;
                appearance: none;
                background-color: #EEF2FF;
                border-radius: 8px;
                border-width: 2px;
                border-color: #536DFE;
                box-shadow: rgba(83, 109, 254, 0.2) 0 2px 4px, rgba(83, 109, 254, 0.15) 0 7px 13px -3px, #D6D6E7 0 -3px 0 inset;
                box-sizing: border-box;
                color: #536DFE;
                cursor: pointer;
                display: inline-flex;
                font-family: "JetBrains Mono", monospace;
                height: 56px;
                justify-content: center;
                line-height: 1;
                list-style: none;
                overflow: hidden;
                padding-left: 24px;
                padding-right: 24px;
                position: relative;
                text-align: center;
                text-decoration: none;
                transition: box-shadow 0.15s, transform 0.15s;
                user-select: none;
                -webkit-user-select: none;
                touch-action: manipulation;
                white-space: nowrap;
                will-change: box-shadow, transform;
                font-size: 20px;
            }

            .bnt2:focus {
                outline: none;
                box-shadow: #D6D6E7 0 0 0 1.5px inset, rgba(83, 109, 254, 0.4) 0 2px 4px, rgba(83, 109, 254, 0.3) 0 7px 13px -3px, #D6D6E7 0 -3px 0 inset;
            }

            .bnt2:hover {
                box-shadow: rgba(83, 109, 254, 0.3) 0 4px 8px, rgba(83, 109, 254, 0.2) 0 7px 13px -3px, #D6D6E7 0 -3px 0 inset;
                transform: translateY(-2px);
            }

            .bnt2:active {
                box-shadow: #D6D6E7 0 3px 7px inset;
                transform: translateY(2px);
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <% if (currentUserRoleId == 2) { %>
            <div class="div1">
                <jsp:include page="../../../Layout/operator/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../../Layout/operator/Header.jsp"></jsp:include>
                </div>
            <% } %>

            <% if (currentUserRoleId == 3) { %>
            <div class="div1">
                <jsp:include page="../../../Layout/staff/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../../Layout/staff/Header.jsp"></jsp:include>
                </div>
            <% }%>  
            <div class="div3">
                <div class="storage-container">
                    <!-- Page Header -->
                    <div class="page-header">
                        <h1 class="page-title">Chi tiết Báo cáo Storage</h1>
                        <p class="page-subtitle">Quản lý và theo dõi tất cả báo cáo storage với tính năng lọc</p>
                    </div>

                    <!-- Error/Success Messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="error-message">
                            <strong>Lỗi:</strong> ${errorMessage}
                        </div>
                    </c:if>

                    <c:if test="${not empty successMessage}">
                        <div class="success-message">
                            <strong>Thành công:</strong> ${successMessage}
                        </div>
                    </c:if>

                    <!-- Stats Overview -->
                    <div class="stats-overview">
                        <div class="stat-card inbound">
                            <div class="stat-value">
                                <c:if test="${not empty overallStats}">
                                    <fmt:formatNumber value="${overallStats[0]}" pattern="#,###"/>
                                </c:if>
                                <c:if test="${empty overallStats}">0</c:if>
                                </div>
                                <div class="stat-label">Tổng nhập kho</div>
                            </div>
                            <div class="stat-card outbound">
                                <div class="stat-value">
                                <c:if test="${not empty overallStats}">
                                    <fmt:formatNumber value="${overallStats[1]}" pattern="#,###"/>
                                </c:if>
                                <c:if test="${empty overallStats}">0</c:if>
                                </div>
                                <div class="stat-label">Tổng xuất kho</div>
                            </div>
                            <div class="stat-card profit">
                                <div class="stat-value">
                                <c:if test="${not empty overallStats}">
                                    <fmt:formatNumber value="${overallStats[2]}" pattern="#,###"/>
                                </c:if>
                                <c:if test="${empty overallStats}">0</c:if>
                                </div>
                                <div class="stat-label">Tổng lợi nhuận (VNĐ)</div>
                            </div>
                        </div>

                        <!-- Filter Section -->
                        <div class="filter-section">
                            <div class="filter-header">
                                <h3 class="filter-title">🔍 Bộ lọc</h3>
                                <a href="http://localhost:9999/HouseMovingSystem/exportData" style="text-decoration: none;">
                                    <!-- From Uiverse.io by adamgiebl --> 
                                    <button class="bnt2" role="button">Xuất dữ liệu</button>
                            </a>
                            </div>

                            <form method="GET" action="StorageReportDetailController" id="filterForm">
                                <input type="hidden" name="service" value="filterStorageReports">
                                <div class="filter-row">
                                    <div class="filter-group">
                                        <label class="filter-label">Kho bãi:</label>
                                        <select name="storageUnitId" class="filter-input">
                                            <option value="">-- Tất cả kho --</option>
                                        <c:forEach var="unit" items="${storageUnits}">
                                            <option value="${unit.storageUnitId}" 
                                                    ${selectedStorageUnitId == unit.storageUnitId ? 'selected' : ''}>
                                                ${unit.warehouseName} (${unit.location})
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">Từ tháng:</label>
                                    <input type="month" name="fromMonth" class="filter-input" 
                                           value="${selectedFromMonth}">
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">Đến tháng:</label>
                                    <input type="month" name="toMonth" class="filter-input" 
                                           value="${selectedToMonth}">
                                </div>

                                <div class="filter-group">
                                    <label class="filter-label">Tên kho:</label>
                                    <input type="text" name="warehouseName" class="filter-input" 
                                           placeholder="Nhập tên kho..." 
                                           value="${selectedWarehouseName}">
                                </div>

                                <div class="filter-group" style="display: flex; flex-direction: row">
                                    <button type="submit" class="filter-btn" id="filterBtn">
                                        🔍 Lọc dữ liệu
                                    </button>
                                    <button type="button" class="filter-btn clear-btn" onclick="clearFilters()">
                                        🗑️ Xóa bộ lọc
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Table Section -->
                    <div class="table-section">
                        <div class="table-header">
                            <h3 class="table-title">📋 Danh sách Báo cáo Storage</h3>
                            <div class="table-info">
                                <span>Tổng: 
                                    <c:choose>
                                        <c:when test="${not empty storageReports}">
                                            ${storageReports.size()}
                                        </c:when>
                                        <c:otherwise>0</c:otherwise>
                                    </c:choose>
                                    bản ghi
                                </span>
                            </div>
                        </div>

                        <div class="table-wrapper">
                            <c:choose>
                                <c:when test="${empty storageReports}">
                                    <div class="empty-state">
                                        <div style="font-size: 48px; margin-bottom: 20px;">📊</div>
                                        <h3>Không có dữ liệu</h3>
                                        <p>Không tìm thấy báo cáo nào phù hợp với bộ lọc của bạn.</p>
                                        <c:if test="${not empty errorMessage}">
                                            <p><strong>Chi tiết lỗi:</strong> ${errorMessage}</p>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="storage-table">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Ngày báo cáo</th>
                                                <th>Tên kho</th>
                                                <th>ID Storage Unit</th>
                                                <th>Số hàng trong kho</th>
                                                <th>Diện tích sử dụng (m²)</th>
                                                <th>Tổng diện tích (m²)</th>
                                                <th>Tỷ lệ sử dụng (%)</th>
                                                <th>Chi tiết</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="report" items="${storageReports}" varStatus="status">
                                                <tr class="main-row">
                                                    <td class="number-cell">${status.index + 1}</td>
                                                    <td class="date-cell">
                                                        <span class="date-display" data-date="${report.reportDate}"></span>
                                                    </td>
                                                    <td class="warehouse-name">${report.warehouseName}</td>
                                                    <td class="number-cell">${report.storageUnitId}</td>
                                                    <td class="number-cell">
                                                        <fmt:formatNumber value="${report.quantityOnHand}" pattern="#,###"/>
                                                    </td>
                                                    <td class="number-cell">
                                                        <fmt:formatNumber value="${report.usedArea}" pattern="#,###.##"/>
                                                    </td>
                                                    <td class="number-cell">
                                                        <fmt:formatNumber value="${report.totalArea}" pattern="#,###.##"/>
                                                    </td>
                                                    <td>
                                                        <c:set var="utilizationRate" value="${report.totalArea > 0 ? (report.usedArea / report.totalArea) * 100 : 0}" />
                                                        <div class="utilization-bar">
                                                            <div class="utilization-fill ${utilizationRate >= 80 ? 'high' : (utilizationRate >= 60 ? 'medium' : 'low')}" 
                                                                 style="width: ${utilizationRate > 100 ? 100 : utilizationRate}%"></div>
                                                        </div>
                                                        <small><fmt:formatNumber value="${utilizationRate}" pattern="#.#"/>%</small>
                                                    </td>
                                                    <td class="action-cell">
                                                        <button class="detail-toggle" onclick="toggleDetails(${status.index})">
                                                            <i class="fas fa-chevron-down"></i> Xem chi tiết
                                                        </button>
                                                    </td>
                                                </tr>
                                                <!-- Chi tiết ẩn -->
                                                <tr class="detail-row" id="detail-${status.index}" style="display: none;">
                                                    <td colspan="9">
                                                        <div class="detail-content">
                                                            <h4>Thông tin chi tiết</h4>
                                                            <div class="detail-grid">
                                                                <div class="detail-section">
                                                                    <h5>Đơn hàng & Vận chuyển</h5>
                                                                    <div class="detail-item">
                                                                        <span class="label">Số đơn hàng:</span>
                                                                        <span class="value"><fmt:formatNumber value="${report.orderCount}" pattern="#,###"/></span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label">Thời gian lưu kho trung Bình trong tháng:</span>
                                                                        <span class="value status-low"><fmt:formatNumber value="${report.averageStorageDuration}"/> Ngày</span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label">Chi phí bảo hiểm hàng hóa</span>
                                                                        <span class="value status-medium"><fmt:formatNumber value="${report.insuranceCost}" pattern="#,###"/> VNĐ</span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label">Đơn trả lại:</span>
                                                                        <span class="value status-high"><fmt:formatNumber value="${report.returnedOrders}" pattern="#,###"/></span>
                                                                    </div>
                                                                </div>

                                                                <div class="detail-section">
                                                                    <h5>Chi phí & Lợi nhuận</h5>
                                                                    <div class="detail-item">
                                                                        <span class="label">Chi phí nhân sự:</span>
                                                                        <span class="value currency-cell"><fmt:formatNumber value="${report.personnelCost}" pattern="#,###"/> VNĐ</span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label">Chi phí bảo trì:</span>
                                                                        <span class="value currency-cell"><fmt:formatNumber value="${report.maintenanceCost}" pattern="#,###"/> VNĐ</span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label">Chi phí lưu kho/đơn vị:</span>
                                                                        <span class="value currency-cell"><fmt:formatNumber value="${report.storageCostPerUnit}" pattern="#,###.##"/> VNĐ</span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label">Số tiền thu đc:</span>
                                                                        <span class="value currency-cell profit-value"><fmt:formatNumber value="${report.profit+report.storageCostPerUnit+report.maintenanceCost+report.personnelCost+report.insuranceCost}" pattern="#,###"/> VNĐ</span>
                                                                    </div>
                                                                    <div class="detail-item">
                                                                        <span class="label" style="font-size: 15px; font-weight: 700; padding: 2px;">Lợi nhuận:</span>
                                                                        <span class="value currency-cell profit-value" style="color: red"><fmt:formatNumber value="${report.profit}" pattern="#,###"/> VNĐ</span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Summary Section -->
                    <c:if test="${not empty storageReports}">
                        <div class="summary-section">
                            <h3 class="summary-title">Tổng quan thống kê bộ lọc</h3>
                            <div class="summary-grid">
                                <div class="summary-item">
                                    <div class="summary-label">Tổng số đơn hàng:</div>
                                    <div class="summary-value orders">
                                        <c:set var="totalOrders" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalOrders" value="${totalOrders + report.orderCount}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalOrders}" pattern="#,###"/>
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tổng nhập kho:</div>
                                    <div class="summary-value inbound">
                                        <c:set var="totalInbound" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalInbound" value="${totalInbound + report.inboundCount}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalInbound}" pattern="#,###"/>
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tổng xuất kho:</div>
                                    <div class="summary-value outbound">
                                        <c:set var="totalOutbound" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalOutbound" value="${totalOutbound + report.outboundCount}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalOutbound}" pattern="#,###"/>
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tổng lợi nhuận:</div>
                                    <div class="summary-value profit">
                                        <c:set var="totalProfit" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalProfit" value="${totalProfit + report.profit}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalProfit}" pattern="#,###"/> VNĐ
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tổng chi phí nhân sự:</div>
                                    <div class="summary-value">
                                        <c:set var="totalPersonnelCost" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalPersonnelCost" value="${totalPersonnelCost + report.personnelCost}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalPersonnelCost}" pattern="#,###"/> VNĐ
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tổng chi phí bảo trì:</div>
                                    <div class="summary-value">
                                        <c:set var="totalMaintenanceCost" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalMaintenanceCost" value="${totalMaintenanceCost + report.maintenanceCost}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalMaintenanceCost}" pattern="#,###"/> VNĐ
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tỷ lệ sử dụng trung bình:</div>
                                    <div class="summary-value percentage-cell">
                                        <c:set var="totalUtilization" value="0" />
                                        <c:set var="validRecords" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:if test="${report.totalArea > 0}">
                                                <c:set var="totalUtilization" value="${totalUtilization + (report.usedArea / report.totalArea * 100)}" />
                                                <c:set var="validRecords" value="${validRecords + 1}" />
                                            </c:if>
                                        </c:forEach>
                                        <c:set var="avgUtilization" value="${validRecords > 0 ? totalUtilization / validRecords : 0}" />
                                        <fmt:formatNumber value="${avgUtilization}" pattern="#.##"/>%
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <div class="summary-label">Tổng đơn trả lại:</div>
                                    <div class="summary-value status-high">
                                        <c:set var="totalReturned" value="0" />
                                        <c:forEach var="report" items="${storageReports}">
                                            <c:set var="totalReturned" value="${totalReturned + report.returnedOrders}" />
                                        </c:forEach>
                                        <fmt:formatNumber value="${totalReturned}" pattern="#,###"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>
                </div>
                <div class="butt">
                    <a href="http://localhost:9999/HouseMovingSystem/StorageReportController">
                        <button class="cssbuttons-io-button">
                            quay lại trang trước
                            <div class="icon">
                                <svg
                                    height="24"
                                    width="24"
                                    viewBox="0 0 24 24"
                                    xmlns="http://www.w3.org/2000/svg"
                                    >
                                <path d="M0 0h24v24H0z" fill="none"></path>
                                <path
                                    d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z"
                                    fill="currentColor"
                                    ></path>
                                </svg>
                            </div>
                        </button>
                    </a> 
                </div>
            </div>
        </div>

        <!-- Toast Notification -->
        <div id="toast" class="toast"></div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                document.querySelectorAll('.date-display').forEach(function (element) {
                    const dateStr = element.getAttribute('data-date');
                    const dateParts = dateStr.split('-');
                    let year = parseInt(dateParts[0]); // ← SỬA: Đổi const thành let
                    let month = parseInt(dateParts[1]) + 1;

                    // Xử lý trường hợp tháng > 12
                    if (month > 12) {
                        month = 1;
                        year = year + 1; // ← FIXED: Bây giờ có thể gán lại
                    }

                    // Format tháng với leading zero
                    const formattedMonth = month < 10 ? '0' + month : month;
                    element.textContent = formattedMonth + '/' + year;
                });
            });
        </script>
        <script>
            // Show toast notification
            function showToast(message, type = 'success') {
                const toast = document.getElementById('toast');
                toast.textContent = message;
                toast.className = `toast ${type}`;
                toast.classList.add('show');

                setTimeout(() => {
                    toast.classList.remove('show');
                }, 3000);
            }

            // Clear filters function
            function clearFilters() {
                window.location.href = 'StorageReportDetailController?service=listStorageReports';
            }

            // Export to Excel function
            function exportToExcel() {
                try {
                    // Get current filter values
                    const form = document.getElementById('filterForm');
                    const formData = new FormData(form);

                    // Build export URL with filter parameters
                    let exportUrl = 'StorageReportDetailController?service=exportExcel';
                    for (let [key, value] of formData.entries()) {
                        if (value && value.trim() !== '' && key !== 'service') {
                            exportUrl += '&' + key + '=' + encodeURIComponent(value);
                        }
                    }

                    // Show loading state
                    const exportBtn = document.getElementById('exportBtn');
                    const originalText = exportBtn.innerHTML;
                    exportBtn.innerHTML = '⏳ Đang xuất...';
                    exportBtn.style.pointerEvents = 'none';

                    // Create hidden iframe for download
                    const iframe = document.createElement('iframe');
                    iframe.style.display = 'none';
                    iframe.src = exportUrl;
                    document.body.appendChild(iframe);

                    // Show success notification
                    showToast('Đang tải file Excel, vui lòng chờ...', 'success');

                    // Restore button after 3 seconds
                    setTimeout(() => {
                        exportBtn.innerHTML = originalText;
                        exportBtn.style.pointerEvents = 'auto';
                        if (document.body.contains(iframe)) {
                            document.body.removeChild(iframe);
                        }
                        showToast('File Excel đã được tải xuống!', 'success');
                    }, 3000);

                } catch (error) {
                    console.error('Export error:', error);
                    showToast('Có lỗi xảy ra khi xuất file Excel!', 'error');

                    // Restore button
                    const exportBtn = document.getElementById('exportBtn');
                    exportBtn.innerHTML = '📊 Xuất Excel';
                    exportBtn.style.pointerEvents = 'auto';
                }
            }

            // Form submission with loading state
            document.addEventListener('DOMContentLoaded', function () {
                const form = document.getElementById('filterForm');
                if (form) {
                    form.addEventListener('submit', function (e) {
                        const submitBtn = document.getElementById('filterBtn');
                        if (submitBtn) {
                            submitBtn.innerHTML = '⏳ Đang lọc...';
                            submitBtn.disabled = true;
                        }

                        // Show loading notification
                        showToast('Đang áp dụng bộ lọc...', 'success');
                    });
                }

                // Add animation for table rows
                const rows = document.querySelectorAll('.storage-table tbody tr');
                rows.forEach((row, index) => {
                    row.style.opacity = '0';
                    row.style.transform = 'translateY(20px)';
                    row.style.transition = 'all 0.3s ease';

                    setTimeout(() => {
                        row.style.opacity = '1';
                        row.style.transform = 'translateY(0)';
                    }, index * 50);
                });

                // Add hover effects to stat cards
                document.querySelectorAll('.stat-card').forEach(card => {
                    card.addEventListener('mouseenter', function () {
                        this.style.transform = 'translateY(-3px) scale(1.02)';
                    });
                    card.addEventListener('mouseleave', function () {
                        this.style.transform = 'translateY(-3px)';
                    });
                });

                // Auto-hide messages after 5 seconds
                const messages = document.querySelectorAll('.success-message, .error-message');
                messages.forEach(message => {
                    setTimeout(() => {
                        message.style.opacity = '0';
                        message.style.transform = 'translateY(-20px)';
                        setTimeout(() => {
                            if (message.parentNode) {
                                message.parentNode.removeChild(message);
                            }
                        }, 300);
                    }, 5000);
                });

                // Initialize tooltips for utilization bars
                document.querySelectorAll('.utilization-bar').forEach(bar => {
                    bar.addEventListener('mouseenter', function () {
                        const percentage = this.nextElementSibling.textContent;
                        this.title = `Tỷ lệ sử dụng: ${percentage}`;
                    });
                });

                // Add click handlers for table rows
                document.querySelectorAll('.storage-table tbody tr').forEach(row => {
                    row.style.cursor = 'pointer';
                    row.addEventListener('click', function () {
                        // Highlight selected row
                        document.querySelectorAll('.storage-table tbody tr').forEach(r => {
                            r.style.backgroundColor = '';
                        });
                        this.style.backgroundColor = '#e3f2fd';

                        // Get report details (optional - for future use)
                        const reportId = this.cells[0].textContent;
                        console.log('Selected report:', reportId);
                    });
                });
            });

            // Keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                // Ctrl+Enter to submit filter form
                if (e.ctrlKey && e.key === 'Enter') {
                    e.preventDefault();
                    const form = document.getElementById('filterForm');
                    if (form) {
                        form.submit();
                    }
                }

                // Ctrl+E to export Excel
                if (e.ctrlKey && e.key === 'e') {
                    e.preventDefault();
                    exportToExcel();
                }

                // Ctrl+R to reset filters
                if (e.ctrlKey && e.key === 'r') {
                    e.preventDefault();
                    clearFilters();
                }

                // Escape to clear selection
                if (e.key === 'Escape') {
                    document.querySelectorAll('.storage-table tbody tr').forEach(r => {
                        r.style.backgroundColor = '';
                    });
                }
            });

            // Print functionality
            function printTable() {
                window.print();
            }

            // Search within table (optional enhancement)
            function searchTable() {
                const input = document.getElementById('tableSearch');
                if (!input)
                    return;

                const filter = input.value.toUpperCase();
                const table = document.querySelector('.storage-table');
                const rows = table.getElementsByTagName('tr');

                for (let i = 1; i < rows.length; i++) { // Skip header
                    const cells = rows[i].getElementsByTagName('td');
                    let found = false;

                    for (let j = 0; j < cells.length; j++) {
                        if (cells[j].textContent.toUpperCase().indexOf(filter) > -1) {
                            found = true;
                            break;
                        }
                    }

                    rows[i].style.display = found ? '' : 'none';
                }
            }

            // Auto-refresh functionality (commented out by default)
            function enableAutoRefresh(intervalMinutes = 5) {
                setInterval(function () {
                    if (!document.hidden) {
                        console.log('Auto-refreshing data...');
                        // Uncomment below to enable auto-refresh
                        // location.reload();
                    }
                }, intervalMinutes * 60 * 1000);
            }

            // Table sorting functionality
            function sortTable(columnIndex, dataType = 'string') {
                const table = document.querySelector('.storage-table');
                const tbody = table.querySelector('tbody');
                const rows = Array.from(tbody.querySelectorAll('tr'));

                // Determine sort direction
                const isAscending = table.getAttribute('data-sort-dir') !== 'asc';
                table.setAttribute('data-sort-dir', isAscending ? 'asc' : 'desc');

                // Sort rows
                rows.sort((a, b) => {
                    const aVal = a.cells[columnIndex].textContent.trim();
                    const bVal = b.cells[columnIndex].textContent.trim();

                    let result = 0;
                    if (dataType === 'number') {
                        const aNum = parseFloat(aVal.replace(/[,\s]/g, '')) || 0;
                        const bNum = parseFloat(bVal.replace(/[,\s]/g, '')) || 0;
                        result = aNum - bNum;
                    } else if (dataType === 'date') {
                        result = new Date(aVal) - new Date(bVal);
                    } else {
                        result = aVal.localeCompare(bVal);
                    }

                    return isAscending ? result : -result;
                });

                // Re-append sorted rows
                rows.forEach(row => tbody.appendChild(row));

                // Update row numbers
                rows.forEach((row, index) => {
                    row.cells[0].textContent = index + 1;
                });

                showToast(`Đã sắp xếp theo cột ${columnIndex + 1} (${isAscending ? 'tăng dần' : 'giảm dần'})`, 'success');
            }

            // Add sorting to table headers (optional enhancement)
            document.addEventListener('DOMContentLoaded', function () {
                const headers = document.querySelectorAll('.storage-table th');
                headers.forEach((header, index) => {
                    if (index > 0) { // Skip STT column
                        header.style.cursor = 'pointer';
                        header.addEventListener('click', function () {
                            let dataType = 'string';
                            if (index >= 4 && index <= 15) { // Numeric columns
                                dataType = 'number';
                            } else if (index === 1) { // Date column
                                dataType = 'date';
                            }
                            sortTable(index, dataType);
                        });

                        // Add sort indicator
                        header.innerHTML += ' <span style="font-size: 10px; opacity: 0.7;">↕</span>';
                    }
                });
            });

            // Performance monitoring
            function trackPerformance() {
                if ('performance' in window) {
                    window.addEventListener('load', function () {
                        const loadTime = performance.timing.loadEventEnd - performance.timing.navigationStart;
                        console.log(`Page load time: ${loadTime}ms`);

                        if (loadTime > 3000) {
                            console.warn('Page load time is slow. Consider optimizing.');
                        }
                    });
                }
            }

            // Initialize performance tracking
            trackPerformance();

            // Responsive table handling
            function handleResponsiveTable() {
                const table = document.querySelector('.storage-table');
                const wrapper = document.querySelector('.table-wrapper');

                if (window.innerWidth < 768) {
                    table.style.fontSize = '11px';
                    wrapper.style.maxHeight = '400px';
                } else {
                    table.style.fontSize = '13px';
                    wrapper.style.maxHeight = '600px';
                }
            }

            function toggleDetails(index) {
                const detailRow = document.getElementById('detail-' + index);
                const toggleButton = event.target.closest('.detail-toggle');
                const icon = toggleButton.querySelector('i');

                if (detailRow.style.display === 'none') {
                    detailRow.style.display = 'table-row';
                    toggleButton.classList.add('expanded');
                    toggleButton.innerHTML = '<i class="fas fa-chevron-up"></i> Ẩn chi tiết';
                } else {
                    detailRow.style.display = 'none';
                    toggleButton.classList.remove('expanded');
                    toggleButton.innerHTML = '<i class="fas fa-chevron-down"></i> Xem chi tiết';
                }
            }

            // Handle window resize
            window.addEventListener('resize', handleResponsiveTable);

            // Initialize responsive handling
            handleResponsiveTable();

            // Debug information (remove in production)
            console.log('Storage Report Detail Page Loaded');
            console.log('Total reports:', document.querySelectorAll('.storage-table tbody tr').length);
            console.log('Filter form:', document.getElementById('filterForm') ? 'Found' : 'Not found');
            console.log('Export button:', document.getElementById('exportBtn') ? 'Found' : 'Not found');
        </script>
    </body>
</html>