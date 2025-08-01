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
        <title>Chi tiết Báo cáo Hiệu suất Vận tải</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            /* Reset and Base Styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: #f5f6fa;
                color: #2c3e50;
            }

            /* Container Layout */
            .performance-container {
                padding: 20px;
                min-height: 100vh;
                animation: fadeIn 0.5s ease-in;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Header Section */
            .page-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 40px;
                border-radius: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.2);
                margin-bottom: 30px;
                position: relative;
                overflow: hidden;
            }

            .page-header::before {
                content: '';
                position: absolute;
                top: -50%;
                right: -50%;
                width: 200%;
                height: 200%;
                background: radial-gradient(circle, rgba(255,255,255,0.1) 0%, transparent 70%);
                animation: pulse 4s ease-in-out infinite;
            }

            @keyframes pulse {
                0%, 100% {
                    transform: scale(1);
                }
                50% {
                    transform: scale(1.1);
                }
            }

            .page-title {
                font-size: 36px;
                font-weight: 700;
                margin-bottom: 10px;
                position: relative;
                z-index: 1;
            }

            .page-subtitle {
                font-size: 18px;
                opacity: 0.9;
                position: relative;
                z-index: 1;
            }

            /* Statistics Cards */
            .stats-section {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 25px rgba(0,0,0,0.15);
            }

            .stat-card::after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 5px;
                height: 100%;
                background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            }

            .stat-icon {
                width: 50px;
                height: 50px;
                border-radius: 12px;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 24px;
                margin-bottom: 15px;
            }

            .stat-icon.blue {
                background: rgba(102, 126, 234, 0.1);
                color: #667eea;
            }
            .stat-icon.green {
                background: rgba(46, 213, 115, 0.1);
                color: #2ed573;
            }
            .stat-icon.orange {
                background: rgba(255, 107, 107, 0.1);
                color: #ff6b6b;
            }
            .stat-icon.purple {
                background: rgba(118, 75, 162, 0.1);
                color: #764ba2;
            }

            .stat-value {
                font-size: 32px;
                font-weight: 700;
                color: #2c3e50;
                margin-bottom: 5px;
            }

            .stat-label {
                font-size: 14px;
                color: #7f8c8d;
                text-transform: uppercase;
                letter-spacing: 1px;
            }

            /* Filter Section */
            .filter-section {
                background: white;
                padding: 30px;
                border-radius: 20px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                margin-bottom: 30px;
            }

            .filter-header {
                display: flex;
                align-items: center;
                margin-bottom: 20px;
                padding-bottom: 20px;
                border-bottom: 2px solid #ecf0f1;
            }

            .filter-title {
                font-size: 20px;
                font-weight: 600;
                color: #2c3e50;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .filter-form {
                display: flex;
                gap: 20px;
                align-items: flex-end;
                flex-wrap: wrap;
            }

            .filter-group {
                flex: 1;
                min-width: 200px;
            }

            .filter-label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #2c3e50;
                font-size: 14px;
            }

            .filter-input {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e1e8ed;
                border-radius: 10px;
                font-size: 14px;
                transition: all 0.3s ease;
                background: #f8f9fa;
            }

            .filter-input:focus {
                outline: none;
                border-color: #667eea;
                background: white;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .btn-group {
                display: flex;
                gap: 10px;
            }

            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 10px;
                font-size: 14px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 8px;
            }

            .btn-primary {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            }

            .btn-secondary {
                background: #ecf0f1;
                color: #7f8c8d;
            }

            .btn-secondary:hover {
                background: #bdc3c7;
                color: #2c3e50;
            }

            /* Table Section */
            .table-section {
                background: white;
                border-radius: 20px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                overflow: hidden;
            }

            .table-header {
                background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
                color: white;
                padding: 25px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .table-title {
                font-size: 20px;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .table-info {
                background: rgba(255,255,255,0.1);
                padding: 8px 16px;
                border-radius: 20px;
                font-size: 14px;
                color: black;
            }

            /* Modern Table Design */
            .table-wrapper {
                overflow-x: auto;
            }

            .performance-table {
                width: 100%;
                border-collapse: collapse;
            }

            .performance-table th {
                background: #f8f9fa;
                padding: 15px;
                text-align: left;
                font-weight: 600;
                color: #2c3e50;
                border-bottom: 2px solid #e1e8ed;
                white-space: nowrap;
            }

            .performance-table td {
                padding: 15px;
                border-bottom: 1px solid #ecf0f1;
                color: #2c3e50;
            }

            .performance-table tr {
                transition: all 0.3s ease;
            }

            .performance-table tr:hover {
                background: #f8f9fa;
                transform: scale(1.01);
                box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            }

            /* Data Styling */
            .company-name {
                font-weight: 600;
                color: #667eea;
            }

            .time-badge {
                background: #ecf0f1;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 13px;
                font-weight: 600;
            }

            .number-cell {
                font-family: 'Monaco', 'Courier New', monospace;
                text-align: right;
            }

            .revenue-positive {
                color: #2ed573;
                font-weight: 600;
            }

            .revenue-negative {
                color: #ff6b6b;
                font-weight: 600;
            }

            .status-badge {
                padding: 4px 12px;
                border-radius: 20px;
                font-size: 12px;
                font-weight: 600;
                display: inline-block;
            }

            .badge-success {
                background: #d5f4e6;
                color: #27ae60;
            }
            .badge-warning {
                background: #fef9e7;
                color: #f39c12;
            }
            .badge-danger {
                background: #fadbd8;
                color: #e74c3c;
            }

            /* Performance Indicator */
            .performance-bar {
                width: 100%;
                height: 8px;
                background: #ecf0f1;
                border-radius: 4px;
                overflow: hidden;
                position: relative;
            }

            .performance-fill {
                height: 100%;
                background: linear-gradient(90deg, #2ed573 0%, #26de81 100%);
                border-radius: 4px;
                transition: width 1s ease;
            }

            .performance-text {
                font-size: 12px;
                font-weight: 600;
                margin-top: 4px;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 80px 20px;
            }

            .empty-icon {
                font-size: 64px;
                margin-bottom: 20px;
                opacity: 0.5;
            }

            .empty-title {
                font-size: 24px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 10px;
            }

            .empty-text {
                color: #7f8c8d;
                font-size: 16px;
            }

            /* Debug Info */
            .debug-info {
                background: #2c3e50;
                color: white;
                padding: 15px;
                border-radius: 10px;
                margin-bottom: 20px;
                font-family: monospace;
                font-size: 12px;
                display: none; /* Ẩn trong production */
            }

            /* Loading Animation */
            .loader {
                display: inline-block;
                width: 20px;
                height: 20px;
                border: 3px solid #f3f3f3;
                border-top: 3px solid #667eea;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% {
                    transform: rotate(0deg);
                }
                100% {
                    transform: rotate(360deg);
                }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .filter-form {
                    flex-direction: column;
                }

                .filter-group {
                    width: 100%;
                }

                .stats-section {
                    grid-template-columns: 1fr;
                }

                .table-wrapper {
                    overflow-x: scroll;
                }

                .page-title {
                    font-size: 28px;
                }
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
                margin:0 0 20px 20px;
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
                    <div class="performance-container">
                        <!-- Debug Info (chỉ hiển thị khi cần debug) -->
                        <div class="debug-info" id="debugInfo">
                            <h4>🐛 Debug Information:</h4>
                            <p>Report Data Size: ${reportData != null ? reportData.size() : 'null'}</p>
                        <p>Transport Units Size: ${transportUnits != null ? transportUnits.size() : 'null'}</p>
                        <p>Statistics: ${statistics != null ? 'Available' : 'null'}</p>
                        <p>Request Parameters: transportUnitId=${param.transportUnitId}, year=${param.year}, invRTitle=${param.invRTitle}</p>
                    </div>

                    <!-- Page Header -->
                    <div class="page-header">
                        <h1 class="page-title">📊 Chi tiết Báo cáo Hiệu suất Vận tải</h1>
                        <p class="page-subtitle">Phân tích toàn diện hiệu suất của các đơn vị vận tải</p>
                    </div>

                    <!-- Statistics Section -->
                    <div class="stats-section">
                        <div class="stat-card">
                            <div class="stat-icon blue">📦</div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${statistics != null and statistics[0] != null}">
                                        <fmt:formatNumber value="${statistics[0]}" pattern="#,###"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Tổng Đơn Hàng</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon green">💰</div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${statistics != null and statistics[1] != null}">
                                        <fmt:formatNumber value="${statistics[1]/1000000}" pattern="#,###.#"/>M
                                    </c:when>
                                    <c:otherwise>0M</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Tổng Doanh Thu (VNĐ)</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon orange">⏰</div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${statistics != null and statistics[2] != null}">
                                        <fmt:formatNumber value="${statistics[2]}" pattern="#.#"/>%
                                    </c:when>
                                    <c:otherwise>0%</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Tỷ Lệ Đúng Hạn</div>
                        </div>

                        <div class="stat-card">
                            <div class="stat-icon purple">⚖️</div>
                            <div class="stat-value">
                                <c:choose>
                                    <c:when test="${statistics != null and statistics[3] != null}">
                                        <fmt:formatNumber value="${statistics[3]/1000}" pattern="#,###.#"/>
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="stat-label">Tổng Khối Lượng (Tấn)</div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <h3 class="filter-title">
                                <span>🔍</span>
                                <span>Bộ lọc tìm kiếm</span>
                            </h3>
                        </div>

                        <form method="GET" action="PerformanceTransportReport" class="filter-form">
                            <input type="hidden" name="service" value="listTransportReports">

                            <div class="filter-group">
                                <label class="filter-label">Đơn vị vận tải</label>
                                <select name="transportUnitId" class="filter-input">
                                    <option value="">-- Tất cả đơn vị --</option>
                                    <c:forEach var="unit" items="${transportUnits}">
                                        <option value="${unit.transportUnitId}" 
                                                ${param.transportUnitId == unit.transportUnitId ? 'selected' : ''}>
                                            ${unit.companyName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Năm báo cáo</label>
                                <select name="year" class="filter-input">
                                    <option value="">-- Tất cả năm --</option>
                                    <option value="2025" ${param.year == '2025' ? 'selected' : ''}>2025</option>
                                    <option value="2024" ${param.year == '2024' ? 'selected' : ''}>2024</option>
                                    <option value="2023" ${param.year == '2023' ? 'selected' : ''}>2023</option>
                                    <option value="2022" ${param.year == '2022' ? 'selected' : ''}>2022</option>
                                </select>
                            </div>

                            <div class="btn-group">
                                <button type="submit" name="submit" value="search" class="btn btn-primary">
                                    <span>🔍</span>
                                    <span>Tìm kiếm</span>
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="clearFilters()">
                                    <span>🔄</span>
                                    <span>Xóa lọc</span>
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Table Section -->
                    <div class="table-section">
                        <div class="table-header">
                            <h3 class="table-title">
                                <span>📋</span>
                                <span>Dữ liệu chi tiết</span>
                            </h3>
                            <div class="table-info">
                                Tổng: 
                                <c:choose>
                                    <c:when test="${reportData != null}">
                                        ${reportData.size()}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                                bản ghi
                            </div>
                        </div>

                        <div class="table-wrapper">
                            <c:choose>
                                <c:when test="${empty reportData}">
                                    <div class="empty-state">
                                        <div class="empty-icon">📊</div>
                                        <h3 class="empty-title">Không có dữ liệu</h3>
                                        <p class="empty-text">
                                            <c:choose>
                                                <c:when test="${param.submit == 'search'}">
                                                    Không tìm thấy báo cáo nào phù hợp với bộ lọc của bạn
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có dữ liệu báo cáo hiệu suất vận tải
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <button type="button" class="btn btn-secondary" onclick="showDebugInfo()" style="margin-top: 20px;">
                                            🐛 Hiển thị thông tin debug
                                        </button>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="performance-table">
                                        <thead>
                                            <tr>
                                                <th>STT</th>
                                                <th>Tên công ty</th>
                                                <th>Thời gian</th>
                                                <th>Tổng đơn</th>
                                                <th>Doanh thu thực</th>
                                                <th>Doanh thu KH</th>
                                                <th>Khối lượng</th>
                                                <th>Đúng hạn</th>
                                                <th>Hủy</th>
                                                <th>Trễ</th>
                                                <th>Hiệu suất</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="report" items="${reportData}" varStatus="status">
                                                <c:set var="performance" value="${report.totalShipments > 0 ? (report.onTimeCount * 100.0 / report.totalShipments) : 0}" />

                                                <tr>
                                                    <td>${status.index + 1}</td>
                                                    <td class="company-name">
                                                        <c:choose>
                                                            <c:when test="${not empty report.companyName}">
                                                                ${report.companyName}
                                                            </c:when>
                                                            <c:otherwise>
                                                                Đơn vị #${report.transportUnitId}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <span class="time-badge">${report.reportMonth}/${report.reportYear}</span>
                                                    </td>
                                                    <td class="number-cell">
                                                        <fmt:formatNumber value="${report.totalShipments}" pattern="#,###"/>
                                                    </td>
                                                    <td class="number-cell revenue-positive">
                                                        <fmt:formatNumber value="${report.totalRevenue}" pattern="#,###"/>đ
                                                    </td>
                                                    <td class="number-cell">
                                                        <fmt:formatNumber value="${report.plannedRevenue}" pattern="#,###"/>đ
                                                    </td>
                                                    <td class="number-cell">
                                                        <fmt:formatNumber value="${report.totalWeight}" pattern="#,###.#"/>kg
                                                    </td>
                                                    <td>
                                                        <span class="status-badge badge-success">${report.onTimeCount}</span>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge badge-danger">${report.cancelCount}</span>
                                                    </td>
                                                    <td>
                                                        <span class="status-badge badge-warning">${report.delayCount}</span>
                                                    </td>
                                                    <td>
                                                        <div class="performance-bar">
                                                            <div class="performance-fill" style="width: ${performance}%"></div>
                                                        </div>
                                                        <div class="performance-text
                                                             ${performance >= 90 ? 'revenue-positive' : 
                                                               performance >= 70 ? 'status-warning' : 'revenue-negative'}">
                                                             <fmt:formatNumber value="${performance}" pattern="#.#"/>%
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
                </div>
                <div class="butt">
                    <a href="http://localhost:9999/HouseMovingSystem/transportReport">
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
                                    d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z"
                                    fill="currentColor"
                                    ></path>
                                </svg>
                            </div>
                        </button>
                    </a> 
                </div>
            </div>
        </div>

        <script>
            // Debug functions
            function showDebugInfo() {
                const debugInfo = document.getElementById('debugInfo');
                if (debugInfo) {
                    debugInfo.style.display = debugInfo.style.display === 'none' ? 'block' : 'none';
                }
            }

            // Clear filters
            function clearFilters() {
                document.querySelector('select[name="transportUnitId"]').value = '';
                document.querySelector('select[name="year"]').value = '';
                document.querySelector('input[name="invRTitle"]').value = '';
                window.location.href = 'PerformanceTransportReport';
            }

            // Add loading state
            document.querySelector('form').addEventListener('submit', function (e) {
                const btn = e.target.querySelector('.btn-primary');
                const originalContent = btn.innerHTML;
                btn.innerHTML = '<span class="loader"></span> Đang tìm kiếm...';
                btn.disabled = true;

                // Khôi phục nếu có lỗi
                setTimeout(() => {
                    btn.innerHTML = originalContent;
                    btn.disabled = false;
                }, 10000);
            });

            // Animation on load
            document.addEventListener('DOMContentLoaded', function () {
                console.log('🚀 Page loaded, initializing animations...');

                // Log debug info to console
                console.log('📊 Debug Info:');
                console.log('- Report Data: ${reportData != null ? reportData.size() : "null"} records');
                console.log('- Transport Units: ${transportUnits != null ? transportUnits.size() : "null"} units');
                console.log('- Statistics available: ${statistics != null}');

                // Animate stat cards
                const statCards = document.querySelectorAll('.stat-card');
                statCards.forEach((card, index) => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    setTimeout(() => {
                        card.style.transition = 'all 0.5s ease';
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, index * 100);
                });

                // Animate table rows
                const tableRows = document.querySelectorAll('.performance-table tbody tr');
                if (tableRows.length > 0) {
                    console.log(`✅ Found ${tableRows.length} table rows, animating...`);
                    tableRows.forEach((row, index) => {
                        row.style.opacity = '0';
                        setTimeout(() => {
                            row.style.transition = 'opacity 0.3s ease';
                            row.style.opacity = '1';
                        }, index * 30);
                    });
                } else {
                    console.log('⚠️ No table rows found');
                }

                // Animate performance bars
                const performanceBars = document.querySelectorAll('.performance-fill');
                if (performanceBars.length > 0) {
                    console.log(`📊 Found ${performanceBars.length} performance bars, animating...`);
                    performanceBars.forEach(bar => {
                        const width = bar.style.width;
                        bar.style.width = '0';
                        setTimeout(() => {
                            bar.style.width = width;
                        }, 500);
                    });
                }

                // Log current URL and parameters
                console.log('🌐 Current URL:', window.location.href);
                console.log('🔍 URL Parameters:', new URLSearchParams(window.location.search).toString());
            });

            // Add keyboard shortcuts
            document.addEventListener('keydown', function (e) {
                // Ctrl + D để toggle debug info
                if (e.ctrlKey && e.key === 'd') {
                    e.preventDefault();
                    showDebugInfo();
                }

                // Ctrl + R để reset filters
                if (e.ctrlKey && e.key === 'r') {
                    e.preventDefault();
                    clearFilters();
                }
            });

            // Add tooltip for performance bars
            document.querySelectorAll('.performance-bar').forEach(bar => {
                const performanceText = bar.nextElementSibling.textContent;
                bar.title = `Hiệu suất: ${performanceText}`;
            });

            // Refresh data every 5 minutes (optional)
            // setInterval(() => {
            //     console.log('🔄 Auto-refreshing data...');
            //     location.reload();
            // }, 300000);
        </script>
    </body>
</html>