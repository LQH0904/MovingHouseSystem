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
        <title>Chi tiết Quy mô & Năng lực Vận tải</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            /* Reset và Base Styles */
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                color: #333;
            }

            .container {
                max-width: 1400px;
                margin: 0 auto;
                padding: 20px;
            }

            /* Header Section */
            .header {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .header h1 {
                font-size: 2.5rem;
                background: linear-gradient(45deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                margin-bottom: 10px;
                text-align: center;
            }

            .header p {
                text-align: center;
                color: #666;
                font-size: 1.1rem;
                line-height: 1.6;
            }

            /* Filter Section */
            .filter-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 25px;
                margin-bottom: 30px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .filter-form {
                display: flex;
                gap: 17%;
                align-items: center;
                flex-wrap: wrap;
                justify-content: center;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                min-width: 200px;
            }

            .filter-label {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
                font-size: 0.95rem;
            }

            .filter-select {
                padding: 10px 15px;
                border: 2px solid #e1e8ed;
                border-radius: 10px;
                font-size: 0.95rem;
                background: white;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .filter-select:focus {
                border-color: #667eea;
                outline: none;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .filter-btn {
                padding: 12px 25px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 10px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .filter-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            .reset-btn {
                background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%);
                margin-left: 10px;
            }

            .reset-btn:hover {
                box-shadow: 0 6px 20px rgba(149, 165, 166, 0.4);
            }

            /* Summary Cards */
            .summary-section {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .summary-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 15px;
                padding: 25px;
                text-align: center;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .summary-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.15);
            }

            .summary-card .icon {
                font-size: 3rem;
                margin-bottom: 15px;
            }

            .summary-card .value {
                font-size: 2.2rem;
                font-weight: bold;
                margin-bottom: 8px;
                background: linear-gradient(45deg, #667eea, #764ba2);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .summary-card .label {
                color: #666;
                font-size: 1rem;
                font-weight: 500;
            }

            /* Analysis Section */
            .analysis-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                padding: 30px;
                margin-bottom: 30px;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
            }

            .analysis-title {
                font-size: 1.8rem;
                margin-bottom: 20px;
                color: #333;
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .analysis-content {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 20px;
            }

            .insight-card {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                border-radius: 12px;
                padding: 20px;
                border-left: 4px solid #667eea;
            }

            .insight-title {
                font-weight: 600;
                color: #333;
                margin-bottom: 10px;
                font-size: 1.1rem;
            }

            .insight-text {
                color: #666;
                line-height: 1.6;
            }

            /* Table Section */
            .table-section {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                overflow: hidden;
                box-shadow: 0 8px 32px rgba(0, 0, 0, 0.1);
                border: 1px solid rgba(255, 255, 255, 0.2);
                margin-bottom: 30px;
            }

            .table-header {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 25px 30px;
            }

            .table-title {
                font-size: 1.6rem;
                font-weight: 600;
                margin-bottom: 5px;
            }

            .table-subtitle {
                opacity: 0.9;
                font-size: 1rem;
            }

            .detail-table {
                width: 100%;
                border-collapse: collapse;
                background: white;
            }

            .detail-table th {
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                color: #333;
                padding: 18px 15px;
                text-align: left;
                font-weight: 600;
                font-size: 0.95rem;
                border-bottom: 2px solid #dee2e6;
                position: sticky;
                top: 0;
                z-index: 10;
            }

            .detail-table td {
                padding: 15px;
                border-bottom: 1px solid #f1f3f4;
                font-size: 0.95rem;
                transition: background-color 0.3s ease;
            }

            .detail-table tr:hover {
                background: linear-gradient(135deg, #f8f9ff 0%, #f0f4ff 100%);
                transform: scale(1.001);
            }

            .detail-table tr:nth-child(even) {
                background: rgba(248, 249, 250, 0.5);
            }

            /* Status Badges */
            .status-badge {
                display: inline-block;
                padding: 6px 12px;
                border-radius: 20px;
                font-size: 0.85rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .status-excellent {
                background: linear-gradient(135deg, #d4edda 0%, #c3e6cb 100%);
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .status-good {
                background: linear-gradient(135deg, #fff3cd 0%, #ffeaa7 100%);
                color: #856404;
                border: 1px solid #ffeaa7;
            }

            .status-average {
                background: linear-gradient(135deg, #f8d7da 0%, #f5c6cb 100%);
                color: #721c24;
                border: 1px solid #f5c6cb;
            }

            /* Progress Bars */
            .progress-bar {
                width: 100%;
                height: 8px;
                background: #e9ecef;
                border-radius: 10px;
                overflow: hidden;
                margin-top: 5px;
            }

            .progress-fill {
                height: 100%;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 10px;
                transition: width 0.8s ease;
            }

            /* Number Formatting */
            .number-cell {
                text-align: right;
                font-family: 'Courier New', monospace;
                font-weight: 500;
            }

            .highlight-number {
                color: #667eea;
                font-weight: 600;
            }

            /* Location Distribution */
            .location-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 15px;
                margin-top: 20px;
            }

            .location-item {
                background: white;
                border-radius: 10px;
                padding: 15px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                border-left: 4px solid #667eea;
            }

            .location-name {
                font-weight: 600;
                color: #333;
                margin-bottom: 8px;
            }

            .location-count {
                font-size: 1.5rem;
                color: #667eea;
                font-weight: bold;
            }

            .location-percentage {
                font-size: 0.9rem;
                color: #666;
                margin-top: 5px;
            }

            /* Empty State */
            .empty-state {
                text-align: center;
                padding: 50px 20px;
                color: #7f8c8d;
            }

            .empty-state h3 {
                margin-top: 20px;
                font-size: 1.5rem;
                color: #666;
            }

            .empty-state p {
                margin-top: 10px;
                color: #999;
            }

            /* Export Button */
            .export-section {
                text-align: center;
                margin-top: 30px;
            }

            .export-btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                padding: 15px 30px;
                border-radius: 25px;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .export-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
            }

            /* Animation */
            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .animate-in {
                animation: fadeInUp 0.6s ease forwards;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .container {
                    padding: 15px;
                }

                .header h1 {
                    font-size: 2rem;
                }

                .summary-section {
                    grid-template-columns: 1fr;
                }

                .analysis-content {
                    grid-template-columns: 1fr;
                }

                .detail-table {
                    font-size: 0.9rem;
                }

                .detail-table th,
                .detail-table td {
                    padding: 12px 8px;
                }

                .filter-form {
                    flex-direction: column;
                }

                .filter-group {
                    width: 100%;
                }

                .location-grid {
                    grid-template-columns: 1fr;
                }
            }

            /* Loading Animation */
            /* Prior to using this loader, please ensure that you have set a background image or background color, as the text is transparent and not designed with a solid color. */
            .loader {
                --ANIMATION-DELAY-MULTIPLIER: 70ms;
                padding: 0;
                margin: 0;
                display: flex;
                flex-direction: row;
                justify-content: center;
                align-items: center;
                overflow: hidden;
            }
            .loader span {
                padding: 0;
                margin: 0;
                letter-spacing: -5rem;
                animation-delay: 0s;
                transform: translateY(4rem);
                animation: hideAndSeek 1s alternate infinite cubic-bezier(0.86, 0, 0.07, 1);
            }
            .loader .l {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 0);
            }
            .loader .o {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 1);
            }
            .loader .a {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 2);
            }
            .loader .d {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 3);
            }
            .loader .ispan {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 4);
            }
            .loader .n {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 5);
            }
            .loader .g {
                animation-delay: calc(var(--ANIMATION-DELAY-MULTIPLIER) * 6);
            }
            .letter {
                width: fit-content;
                height: 3rem;
            }
            .i {
                margin-inline: 5px;
            }
            @keyframes hideAndSeek {
                0% {
                    transform: translateY(4rem);
                }
                100% {
                    transform: translateY(0rem);
                }
            }


            /* Tooltips */
            .tooltip {
                position: relative;
                display: inline-block;
            }

            .tooltip .tooltiptext {
                visibility: hidden;
                width: 200px;
                background-color: #333;
                color: #fff;
                text-align: center;
                border-radius: 6px;
                padding: 8px;
                position: absolute;
                z-index: 1;
                bottom: 125%;
                left: 50%;
                margin-left: -100px;
                opacity: 0;
                transition: opacity 0.3s;
                font-size: 0.85rem;
            }

            .tooltip:hover .tooltiptext {
                visibility: visible;
                opacity: 1;
            }

            /* Print Styles */
            @media print {
                body {
                    background: white;
                }

                .filter-section,
                .export-section {
                    display: none;
                }

                .container {
                    max-width: 100%;
                }

                .summary-card,
                .analysis-section,
                .table-section {
                    box-shadow: none;
                    break-inside: avoid;
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
                <div class="container">
                    <!-- Header -->
                    <div class="header animate-in">
                        <h1>📊 Chi tiết Quy mô & Năng lực Vận tải</h1>
                        <p>Phân tích toàn diện về quy mô hoạt động, năng lực vận chuyển và phân bố địa lý của các đơn vị vận tải</p>
                    </div>

                    <!-- Error Message -->
                    <c:if test="${not empty errorMessage}">
                        <div style="background: #f8d7da; color: #721c24; padding: 20px; border-radius: 10px; margin: 20px 0; border: 1px solid #f5c6cb; text-align: center; font-weight: 600;">
                            ⚠️ ${errorMessage}
                        </div>
                    </c:if>

                    <!-- Filter Section -->
                    <div class="filter-section animate-in">
                        <form class="filter-form" method="GET" action="ScaleAndCapacityReport">
                            <input type="hidden" name="service" value="filterByLocation">

                            <div class="filter-group">
                                <label class="filter-label">Lọc theo địa điểm:</label>
                                <select name="location" class="filter-select">
                                    <option value="all">-- Tất cả địa điểm --</option>
                                    <c:forEach var="unit" items="${transportUnitData}">
                                        <c:if test="${not empty unit.location}">
                                            <option value="${unit.location}" 
                                                    ${selectedLocation == unit.location ? 'selected' : ''}>
                                                ${unit.location}
                                            </option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="filter-label">Lọc theo quy mô:</label>
                                <select name="scale" class="filter-select" 
                                        onchange="this.form.action = 'ScaleAndCapacityReport?service=filterByScale'; this.form.submit();">
                                    <option value="all">-- Tất cả quy mô --</option>
                                    <option value="large" ${selectedScale == 'large' ? 'selected' : ''}>Lớn (≥20 xe)</option>
                                    <option value="medium" ${selectedScale == 'medium' ? 'selected' : ''}>Trung bình (15-19 xe)</option>
                                    <option value="small" ${selectedScale == 'small' ? 'selected' : ''}>Nhỏ (<15 xe)</option>
                                </select>
                            </div>

                            <div class="filter-group">
                                <button type="submit" class="filter-btn">🔍 Lọc dữ liệu</button>
                                <button type="button" class="filter-btn reset-btn" 
                                        onclick="window.location.href = 'ScaleAndCapacityReport'">
                                    🔄 Đặt lại
                                </button>
                            </div>
                        </form>
                    </div>

                    <!-- Summary Statistics -->
                    <div class="summary-section">
                        <div class="summary-card animate-in">
                            <div class="icon">🚚</div>
                            <div class="value" id="totalUnits">
                                <c:choose>
                                    <c:when test="${not empty transportUnitData}">
                                        ${transportUnitData.size()}
                                    </c:when>
                                    <c:otherwise>0</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="label">Tổng đơn vị vận tải</div>
                        </div>
                        <div class="summary-card animate-in">
                            <div class="icon">🚛</div>
                            <div class="value" id="totalVehicles">
                                <c:set var="totalVehicles" value="0" />
                                <c:forEach var="unit" items="${transportUnitData}">
                                    <c:set var="totalVehicles" value="${totalVehicles + unit.vehicleCount}" />
                                </c:forEach>
                                ${totalVehicles}
                            </div>
                            <div class="label">Tổng số xe</div>
                        </div>
                        <div class="summary-card animate-in">
                            <div class="icon">📦</div>
                            <div class="value" id="totalCapacity">
                                <c:set var="totalCapacity" value="0" />
                                <c:forEach var="unit" items="${transportUnitData}">
                                    <c:set var="totalCapacity" value="${totalCapacity + unit.capacity}" />
                                </c:forEach>
                                <fmt:formatNumber value="${totalCapacity}" pattern="#,###.#"/>
                            </div>
                            <div class="label">Tổng năng lực (tấn)</div>
                        </div>
                        <div class="summary-card animate-in">
                            <div class="icon">📍</div>
                            <div class="value" id="totalLocations">
                                <c:set var="locationCount" value="0" />
                                <c:set var="processedLocations" value="" />
                                <c:forEach var="unit" items="${transportUnitData}">
                                    <c:if test="${not empty unit.location && !processedLocations.contains(unit.location)}">
                                        <c:set var="locationCount" value="${locationCount + 1}" />
                                        <c:set var="processedLocations" value="${processedLocations},${unit.location}" />
                                    </c:if>
                                </c:forEach>
                                ${locationCount}
                            </div>
                            <div class="label">Số tỉnh/thành phố</div>
                        </div>
                    </div>

                    <!-- Analysis and Insights -->
                    <div class="analysis-section animate-in">
                        <h3 class="analysis-title">🔍 Phân tích & Nhận xét</h3>
                        <div class="analysis-content">
                            <c:if test="${not empty transportUnitData}">
                                <c:set var="avgVehicles" value="${totalVehicles / transportUnitData.size()}" />
                                <c:set var="avgCapacity" value="${totalCapacity / transportUnitData.size()}" />

                                <div class="insight-card">
                                    <div class="insight-title">Quy mô Hoạt động</div>
                                    <div class="insight-text">
                                        Hệ thống có ${transportUnitData.size()} đơn vị vận tải với tổng cộng ${totalVehicles} xe. 
                                        Trung bình mỗi đơn vị có <fmt:formatNumber value="${avgVehicles}" pattern="#.#"/> xe 
                                        với năng lực <fmt:formatNumber value="${avgCapacity}" pattern="#.#"/> tấn.
                                    </div>
                                </div>

                                <!-- Tìm đơn vị lớn nhất -->
                                <c:set var="largestUnit" value="${transportUnitData[0]}" />
                                <c:forEach var="unit" items="${transportUnitData}">
                                    <c:if test="${unit.vehicleCount > largestUnit.vehicleCount}">
                                        <c:set var="largestUnit" value="${unit}" />
                                    </c:if>
                                </c:forEach>

                                <div class="insight-card">
                                    <div class="insight-title">Đơn vị Lớn nhất</div>
                                    <div class="insight-text">
                                        "${largestUnit.companyName}" dẫn đầu về số lượng xe (${largestUnit.vehicleCount} xe) 
                                        với năng lực vận chuyển ${largestUnit.capacity} tấn.
                                    </div>
                                </div>

                                <div class="insight-card">
                                    <div class="insight-title">Hiệu quả Vận tải</div>
                                    <div class="insight-text">
                                        <c:set var="avgCapacityPerVehicle" value="${totalCapacity / totalVehicles}" />
                                        Trung bình mỗi xe có năng lực <fmt:formatNumber value="${avgCapacityPerVehicle}" pattern="#.#"/> tấn. 
                                        Các đơn vị có hiệu quả cao sẽ được ưu tiên trong việc phân bổ đơn hàng.
                                    </div>
                                </div>

                                <div class="insight-card">
                                    <div class="insight-title">Phân bố Địa lý</div>
                                    <div class="insight-text">
                                        Dịch vụ phủ sóng ${uniqueLocations.size()} tỉnh/thành phố, đảm bảo khả năng phục vụ 
                                        rộng khắp với thời gian vận chuyển tối ưu.
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Detailed Table -->
                    <div class="table-section animate-in">
                        <div class="table-header">
                            <h3 class="table-title">📋 Bảng Chi tiết Đơn vị Vận tải</h3>
                            <p class="table-subtitle">Thông tin chi tiết về quy mô và năng lực của từng đơn vị</p>
                        </div>

                        <c:choose>
                            <c:when test="${empty transportUnitData}">
                                <div class="empty-state">
                                    <div style="font-size: 3rem; margin-bottom: 15px;">📊</div>
                                    <h3>Không có dữ liệu</h3>
                                    <p>Không tìm thấy đơn vị vận tải nào trong hệ thống.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="detail-table">
                                    <thead>
                                        <tr>
                                            <th>STT</th>
                                            <th>Tên công ty</th>
                                            <th>Địa điểm</th>
                                            <th>Số lượng xe</th>
                                            <th>Năng lực vận tải (tấn)</th>
                                            <th>Năng lực/xe (tấn)</th>
                                            <th>Đánh giá quy mô</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="unit" items="${transportUnitData}" varStatus="status">
                                            <tr>
                                                <td class="number-cell">${status.index + 1}</td>
                                                <td><strong>${unit.companyName}</strong></td>
                                                <td>📍 ${unit.location}</td>
                                                <td class="number-cell highlight-number">${unit.vehicleCount}</td>
                                                <td class="number-cell highlight-number">
                                                    <fmt:formatNumber value="${unit.capacity}" pattern="#,###.#"/>
                                                </td>
                                                <td class="number-cell">
                                                    <fmt:formatNumber value="${unit.capacity / unit.vehicleCount}" pattern="#.##"/>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${unit.vehicleCount >= 20 && unit.capacity >= 20}">
                                                            <span class="status-badge status-excellent">Lớn</span>
                                                        </c:when>
                                                        <c:when test="${unit.vehicleCount >= 15 && unit.capacity >= 15}">
                                                            <span class="status-badge status-good">Trung bình</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-average">Nhỏ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div</div>

                <!-- Location Distribution -->
                <div class="analysis-section animate-in">
                    <h3 class="analysis-title">🗺️ Phân bố theo Địa lý</h3>
                    <div class="location-grid">
                        <c:forEach var="location" items="${uniqueLocations}">
                            <c:set var="locationCount" value="0" />
                            <c:forEach var="unit" items="${transportUnitData}">
                                <c:if test="${unit.location == location}">
                                    <c:set var="locationCount" value="${locationCount + 1}" />
                                </c:if>
                            </c:forEach>

                            <div class="location-item">
                                <div class="location-name">${location}</div>
                                <div class="location-count">${locationCount} đơn vị</div>
                                <div class="location-percentage">
                                    <fmt:formatNumber value="${(locationCount / transportUnitData.size()) * 100}" pattern="#.#"/>% tổng số
                                </div>
                            </div>
                        </c:forEach>
                    </div>
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
                            d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z"
                            fill="currentColor"
                            ></path>
                        </svg>
                    </div>
                </button>
            </a> 
        </div>
    </div>


    <script>
        // Show loading overlay


        // Hide loading overlay
        function hideLoading() {
            document.getElementById('loadingOverlay').style.display = 'none';
        }

        // Export to CSV function
        function exportToCSV() {
            showLoading();

            try {
                const table = document.querySelector('.detail-table');
                const rows = table.querySelectorAll('tr');
                let csvContent = [];

                // Add BOM for UTF-8
                const BOM = '\uFEFF';

                rows.forEach(row => {
                    const cols = row.querySelectorAll('td, th');
                    const rowData = [];
                    cols.forEach(col => {
                        let text = col.innerText.replace(/[\n\r]+/g, ' ').trim();
                        // Remove percentage symbols and clean up text
                        text = text.replace(/\s*\([^)]*\)/g, ''); // Remove parentheses content
                        text = text.replace(/"/g, '""'); // Escape quotes
                        rowData.push('"' + text + '"');
                    });
                    csvContent.push(rowData.join(','));
                });

                const blob = new Blob([BOM + csvContent.join('\n')], {type: 'text/csv;charset=utf-8;'});
                const link = document.createElement('a');
                link.href = URL.createObjectURL(blob);
                link.download = 'Bao_cao_Quy_mo_Van_tai_' + new Date().toISOString().split('T')[0] + '.csv';
                link.click();

                hideLoading();

                // Show success message
                showNotification('Xuất báo cáo thành công!', 'success');
            } catch (error) {
                hideLoading();
                showNotification('Có lỗi xảy ra khi xuất báo cáo!', 'error');
                console.error('Export error:', error);
            }
        }

        // Show notification
        function showNotification(message, type) {
            const notification = document.createElement('div');
            notification.style.cssText = `
                position: fixed;
                top: 20px;
                right: 20px;
                padding: 15px 25px;
                border-radius: 10px;
                font-weight: 600;
                z-index: 10000;
                animation: slideIn 0.3s ease;
                ` + (type === 'success' ?
                    'background: #d4edda; color: #155724; border: 1px solid #c3e6cb;' :
                    'background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb;') + `
            `;
            notification.textContent = message;
            document.body.appendChild(notification);

            setTimeout(() => {
                notification.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => notification.remove(), 300);
            }, 3000);
        }

        // Add keyboard shortcuts
        document.addEventListener('keydown', function (e) {
            // Ctrl/Cmd + E for Export
            if ((e.ctrlKey || e.metaKey) && e.key === 'e') {
                e.preventDefault();
                exportToCSV();
            }
            // Ctrl/Cmd + R for Reset filters
            if ((e.ctrlKey || e.metaKey) && e.key === 'r') {
                e.preventDefault();
                window.location.href = 'ScaleAndCapacityReport';
            }
        });

        // Add animation on load
        document.addEventListener('DOMContentLoaded', function () {
            // Remove duplicate options in select
            const locationSelect = document.querySelector('select[name="location"]');
            if (locationSelect) {
                const seen = {};
                const options = locationSelect.querySelectorAll('option');
                options.forEach(option => {
                    const value = option.value;
                    if (value !== 'all' && seen[value]) {
                        option.remove();
                    } else {
                        seen[value] = true;
                    }
                });
            }

            // Animate elements
            const animatedElements = document.querySelectorAll('.animate-in');
            animatedElements.forEach((el, index) => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                setTimeout(() => {
                    el.style.transition = 'all 0.6s ease';
                    el.style.opacity = '1';
                    el.style.transform = 'translateY(0)';
                }, index * 100);
            });

            // Add hover effect to table rows
            const tableRows = document.querySelectorAll('.detail-table tbody tr');
            tableRows.forEach(row => {
                row.addEventListener('mouseenter', function () {
                    this.style.transform = 'scale(1.01)';
                    this.style.boxShadow = '0 2px 10px rgba(0,0,0,0.1)';
                });
                row.addEventListener('mouseleave', function () {
                    this.style.transform = 'scale(1)';
                    this.style.boxShadow = 'none';
                });
            });

            // Progress bar animation
            const progressBars = document.querySelectorAll('.progress-fill');
            progressBars.forEach(bar => {
                const width = bar.style.width;
                bar.style.width = '0';
                setTimeout(() => {
                    bar.style.width = width;
                }, 500);
            });
        });

        // Add form submit loading
        const forms = document.querySelectorAll('form');
        forms.forEach(form => {
            form.addEventListener('submit', function () {
                showLoading();
            });
        });

        // Print function
        function printReport() {
            window.print();
        }

        // Filter form enhancements
        const filterSelects = document.querySelectorAll('.filter-select');
        filterSelects.forEach(select => {
            select.addEventListener('change', function () {
                if (this.value && this.value !== 'all') {
                    this.style.borderColor = '#667eea';
                    this.style.backgroundColor = '#f0f4ff';
                } else {
                    this.style.borderColor = '#e1e8ed';
                    this.style.backgroundColor = 'white';
                }
            });
        });

        // Add chart visualization (optional)
        function showChartView() {
            // Navigate to chart view
            window.location.href = 'ScaleAndCapacityReport?view=chart';
        }

        // Auto-refresh data every 5 minutes (optional)
        let refreshInterval;
        function enableAutoRefresh() {
            refreshInterval = setInterval(() => {
                window.location.reload();
            }, 300000); // 5 minutes
        }

        function disableAutoRefresh() {
            if (refreshInterval) {
                clearInterval(refreshInterval);
            }
        }

        // Add styles for animations
        const style = document.createElement('style');
        style.textContent = `
            @keyframes slideIn {
                from {
                    transform: translateX(100%);
                    opacity: 0;
                }
                to {
                    transform: translateX(0);
                    opacity: 1;
                }
            }
           
            @keyframes slideOut {
                from {
                    transform: translateX(0);
                    opacity: 1;
                }
                to {
                    transform: translateX(100%);
                    opacity: 0;
                }
            }
        `;
        document.head.appendChild(style);

        // Check for URL parameters and show appropriate messages
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('success') === 'true') {
            showNotification('Dữ liệu đã được cập nhật thành công!', 'success');
        }
        if (urlParams.get('error') === 'true') {
            showNotification('Có lỗi xảy ra khi tải dữ liệu!', 'error');
        }
    </script>
</body>
</html>