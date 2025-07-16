<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
// Kiểm tra session
String redirectURL = null;
if (session.getAttribute("acc") == null) {
    redirectURL = "/login";
    response.sendRedirect(request.getContextPath() + redirectURL);
    return;
}
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
            <div class="div1">
                <jsp:include page="../../../Layout/operator/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../../Layout/operator/Header.jsp"></jsp:include>
                </div>
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

                <!-- Export Section -->
                <div class="export-section">
                    <button class="export-btn" onclick="exportToCSV()">
                        📥 Xuất báo cáo CSV
                    </button>
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

    <!-- Loading overlay -->
    <div class="loader">
        <span class="l">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 11 18"
                height="18"
                width="11"
                class="letter"
                >
            <path
                fill="black"
                d="M0.28 16.14V0.94L3.7 0.64L5.7 1.64V12.3L8.5 12.06L10.5 13.06V16.44L2.28 17.14L0.28 16.14ZM3.5 12.7V0.859999L0.48 1.12V15.94L8.3 15.26V12.28L3.5 12.7Z"
                ></path>
            </svg>
        </span>
        <span class="o">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 16 18"
                height="18"
                width="16"
                class="letter"
                >
            <path
                fill="black"
                d="M8.94 17.24C8.84667 17.2533 8.74667 17.26 8.64 17.26C8.54667 17.26 8.45333 17.26 8.36 17.26C7.66667 17.26 7.02667 17.16 6.44 16.96C5.86667 16.7733 5.30667 16.5533 4.76 16.3C3.33333 15.5933 2.28667 14.6 1.62 13.32C0.966667 12.0267 0.64 10.4933 0.64 8.72C0.64 7.68 0.766667 6.67333 1.02 5.7C1.28667 4.71333 1.68 3.82667 2.2 3.04C2.72 2.24 3.36667 1.58667 4.14 1.08C4.92667 0.573332 5.84667 0.273333 6.9 0.18C7.00667 0.166666 7.10667 0.159999 7.2 0.159999C7.29333 0.159999 7.38667 0.159999 7.48 0.159999C8.14667 0.159999 8.74 0.246666 9.26 0.419999C9.78 0.579999 10.3067 0.766666 10.84 0.979999C11.8 1.36667 12.6 1.94 13.24 2.7C13.88 3.46 14.36 4.35333 14.68 5.38C15 6.39333 15.16 7.48 15.16 8.64C15.16 9.72 15.0333 10.7533 14.78 11.74C14.5267 12.7267 14.14 13.62 13.62 14.42C13.1133 15.2067 12.4667 15.8467 11.68 16.34C10.9067 16.8467 9.99333 17.1467 8.94 17.24ZM6.92 16.04C7.94667 15.96 8.84 15.68 9.6 15.2C10.36 14.7067 10.9867 14.0733 11.48 13.3C11.9733 12.5133 12.34 11.64 12.58 10.68C12.8333 9.70667 12.96 8.69333 12.96 7.64C12.96 6.68 12.8467 5.76667 12.62 4.9C12.4067 4.02 12.0733 3.24 11.62 2.56C11.1667 1.88 10.5933 1.34667 9.9 0.959999C9.22 0.559999 8.41333 0.359999 7.48 0.359999C7.38667 0.359999 7.29333 0.359999 7.2 0.359999C7.12 0.359999 7.02667 0.366666 6.92 0.38C5.89333 0.473333 5 0.766666 4.24 1.26C3.48 1.74 2.84667 2.37333 2.34 3.16C1.83333 3.93333 1.45333 4.8 1.2 5.76C0.96 6.70667 0.84 7.69333 0.84 8.72C0.84 9.72 0.953333 10.6667 1.18 11.56C1.40667 12.44 1.74667 13.22 2.2 13.9C2.65333 14.5667 3.22667 15.0933 3.92 15.48C4.61333 15.8667 5.42 16.06 6.34 16.06C6.44667 16.06 6.54667 16.06 6.64 16.06C6.73333 16.06 6.82667 16.0533 6.92 16.04ZM6.92 12.94C6.86667 12.94 6.81333 12.9467 6.76 12.96C6.72 12.96 6.67333 12.96 6.62 12.96C5.82 12.96 5.18667 12.6133 4.72 11.92C4.26667 11.2267 4.04 10.0667 4.04 8.44C4.04 7.28 4.16667 6.34667 4.42 5.64C4.67333 4.93333 5.02 4.41333 5.46 4.08C5.9 3.73333 6.38667 3.54 6.92 3.5C6.97333 3.5 7.02667 3.5 7.08 3.5C7.13333 3.48667 7.18667 3.48 7.24 3.48C8.02667 3.48 8.64 3.82 9.08 4.5C9.52 5.16667 9.74 6.31333 9.74 7.94C9.74 9.67333 9.47333 10.9267 8.94 11.7C8.42 12.46 7.74667 12.8733 6.92 12.94ZM6.86 12.74C7.64667 12.6733 8.28667 12.2733 8.78 11.54C9.28667 10.8067 9.54 9.60667 9.54 7.94C9.54 7.18 9.49333 6.53333 9.4 6C9.30667 5.46667 9.16667 5.03333 8.98 4.7C8.91333 4.68667 8.84667 4.68 8.78 4.68C8.71333 4.66667 8.64667 4.66 8.58 4.66C7.79333 4.66 7.20667 5.07333 6.82 5.9C6.43333 6.71333 6.24 7.89333 6.24 9.44C6.24 10.2133 6.29333 10.8733 6.4 11.42C6.50667 11.9533 6.66 12.3933 6.86 12.74Z"
                ></path>
            </svg>
        </span>
        <span class="a">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 15 18"
                height="18"
                width="15"
                class="letter"
                >
            <path
                fill="black"
                d="M9.28 15.76L8.54 13.38L6.96 13.52L5.98 17.02L2.58 17.32L0.58 16.32L4.96 0.699999L8.26 0.419999L10.26 1.42L14.72 16.48L11.28 16.76L9.28 15.76ZM5.12 0.899999L0.88 16.08L3.8 15.84L4.8 12.34L8.36 12.02L9.42 15.56L12.44 15.3L8.1 0.64L5.12 0.899999ZM5.5 9.42C5.75333 8.59333 5.96 7.80667 6.12 7.06C6.29333 6.31333 6.44 5.56667 6.56 4.82H6.64C6.74667 5.55333 6.88 6.27333 7.04 6.98C7.21333 7.67333 7.42 8.42 7.66 9.22L5.5 9.42Z"
                ></path>
            </svg>
        </span>
        <span class="d">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 14 18"
                height="18"
                width="14"
                class="letter"
                >
            <path
                fill="black"
                d="M0.28 16.24V1.04L4.44 0.679999C4.61333 0.666666 4.78 0.66 4.94 0.66C5.1 0.646666 5.24667 0.64 5.38 0.64C6.11333 0.64 6.76667 0.726666 7.34 0.899999C7.92667 1.07333 8.56667 1.32667 9.26 1.66C10.1933 2.08667 10.9533 2.61333 11.54 3.24C12.1267 3.85333 12.56 4.61333 12.84 5.52C13.12 6.41333 13.26 7.50667 13.26 8.8C13.26 10.4933 12.9733 11.92 12.4 13.08C11.84 14.24 11.0667 15.1333 10.08 15.76C9.09333 16.3733 7.95333 16.74 6.66 16.86L2.28 17.24L0.28 16.24ZM4.64 15.68C5.89333 15.5733 7 15.2133 7.96 14.6C8.93333 13.9867 9.69333 13.1133 10.24 11.98C10.7867 10.8467 11.06 9.45333 11.06 7.8C11.06 5.53333 10.5733 3.80667 9.6 2.62C8.64 1.43333 7.21333 0.84 5.32 0.84C5.18667 0.84 5.04667 0.846666 4.9 0.859999C4.75333 0.859999 4.60667 0.866666 4.46 0.879999L0.48 1.22V16.02L4.64 15.68ZM3.5 3.9L4.08 3.86C4.22667 3.84667 4.36 3.84 4.48 3.84C4.61333 3.82667 4.74667 3.82 4.88 3.82C5.57333 3.82 6.14 3.94667 6.58 4.2C7.03333 4.45333 7.36667 4.88667 7.58 5.5C7.80667 6.11333 7.92 6.97333 7.92 8.08C7.92 9.65333 7.59333 10.8067 6.94 11.54C6.28667 12.26 5.4 12.6667 4.28 12.76L3.5 12.82V3.9ZM5.7 12.2C6.38 11.9067 6.88667 11.4333 7.22 10.78C7.55333 10.1133 7.72 9.21333 7.72 8.08C7.72 6.66667 7.52 5.65333 7.12 5.04C7.06667 5.02667 7.01333 5.02 6.96 5.02C6.90667 5.02 6.85333 5.02 6.8 5.02C6.68 5.02 6.56 5.02667 6.44 5.04C6.33333 5.04 6.22 5.04667 6.1 5.06L5.7 5.08V12.2Z"
                ></path>
            </svg>
        </span>
        <span class="ispan">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 6 17"
                height="18"
                width="6"
                class="letter i"
                >
            <path
                fill="black"
                d="M0.38 15.96V0.76L3.86 0.439999L5.86 1.44V16.64L2.38 16.94L0.38 15.96ZM0.58 0.94V15.74L3.66 15.46V0.66L0.58 0.94Z"
                ></path>
            </svg>
        </span>
        <span class="n">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 13 18"
                height="18"
                width="13"
                class="letter"
                >
            <path
                fill="black"
                d="M7.22 15.82L5.72 12.44V16.92L2.28 17.22L0.28 16.22V1.02L3.52 0.74L5.52 1.74L7 4.94V0.64L10.48 0.319999L12.48 1.32V16.54L9.22 16.82L7.22 15.82ZM7.2 0.819999V6.42C7.2 6.56667 7.20667 6.80667 7.22 7.14C7.23333 7.46 7.24667 7.8 7.26 8.16C7.28667 8.50667 7.30667 8.80667 7.32 9.06C7.33333 9.3 7.34 9.42 7.34 9.42L7.28 9.46C7.28 9.46 7.26 9.38667 7.22 9.24C7.19333 9.09333 7.14667 8.92 7.08 8.72C7.01333 8.50667 6.94 8.31333 6.86 8.14L3.4 0.959999L0.48 1.2V16L3.52 15.76V10.52C3.52 10.36 3.51333 10.0867 3.5 9.7C3.48667 9.31333 3.47333 8.90667 3.46 8.48C3.46 8.05333 3.45333 7.69333 3.44 7.4C3.42667 7.09333 3.42 6.94 3.42 6.94L3.48 6.92C3.48 6.92 3.51333 7.05333 3.58 7.32C3.66 7.57333 3.76667 7.84 3.9 8.12L7.4 15.62L10.28 15.36V0.539999L7.2 0.819999Z"
                ></path>
            </svg>
        </span>
        <span class="g">
            <svg
                xmlns="http://www.w3.org/2000/svg"
                fill="none"
                viewBox="0 0 15 18"
                height="18"
                width="15"
                class="letter"
                >
            <path
                fill="black"
                d="M14.04 13.72C13.64 14.6533 12.9933 15.44 12.1 16.08C11.22 16.72 10.1333 17.0933 8.84 17.2C8.72 17.2133 8.6 17.22 8.48 17.22C8.36 17.22 8.24 17.22 8.12 17.22C7.12 17.22 6.16667 17.0467 5.26 16.7C4.36667 16.3533 3.57333 15.8333 2.88 15.14C2.18667 14.4333 1.64 13.54 1.24 12.46C0.84 11.38 0.64 10.1 0.64 8.62C0.64 7.48667 0.78 6.42667 1.06 5.44C1.34 4.44 1.74667 3.55333 2.28 2.78C2.82667 2.00667 3.48667 1.38667 4.26 0.92C5.03333 0.453333 5.90667 0.179999 6.88 0.0999997C6.96 0.0866657 7.04 0.0799987 7.12 0.0799987C7.2 0.0799987 7.28 0.0799987 7.36 0.0799987C8.33333 0.0799987 9.28 0.299999 10.2 0.74C11.1333 1.18 11.9467 1.78 12.64 2.54C13.3467 3.3 13.8467 4.16 14.14 5.12L11.76 6.46L12.04 6.44L14.04 7.44V13.72ZM5.9 7.16V10L8.98 9.74V11.46C8.80667 11.8067 8.52667 12.1067 8.14 12.36C7.76667 12.6 7.37333 12.7333 6.96 12.76C6.90667 12.7733 6.84667 12.78 6.78 12.78C6.72667 12.78 6.66667 12.78 6.6 12.78C5.73333 12.78 5.08 12.4333 4.64 11.74C4.2 11.0467 3.98 9.92 3.98 8.36C3.98 6.94667 4.20667 5.82 4.66 4.98C5.11333 4.14 5.84 3.68 6.84 3.6H7.06C7.60667 3.6 8.07333 3.76 8.46 4.08C8.86 4.4 9.14667 4.86667 9.32 5.48L11.9 4.02C11.6733 3.38 11.36 2.78 10.96 2.22C10.5733 1.64667 10.0867 1.18 9.5 0.819999C8.91333 0.459999 8.2 0.28 7.36 0.28C7.29333 0.28 7.22 0.28 7.14 0.28C7.06 0.28 6.98 0.286666 6.9 0.299999C5.63333 0.406666 4.54667 0.846666 3.64 1.62C2.73333 2.38 2.04 3.37333 1.56 4.6C1.08 5.81333 0.84 7.15333 0.84 8.62C0.84 10.14 1.06 11.4533 1.5 12.56C1.94 13.6667 2.56667 14.52 3.38 15.12C4.19333 15.72 5.16 16.02 6.28 16.02C6.37333 16.02 6.46 16.02 6.54 16.02C6.63333 16.02 6.72667 16.0133 6.82 16C8.07333 15.8933 9.12667 15.54 9.98 14.94C10.8467 14.3267 11.4733 13.5733 11.86 12.68V6.66L5.9 7.16ZM9.2 5.78C9.14667 5.59333 9.08667 5.42 9.02 5.26C8.95333 5.08667 8.88 4.93333 8.8 4.8C8.2 4.85333 7.70667 5.06667 7.32 5.44C6.94667 5.8 6.66667 6.29333 6.48 6.92L10.8 6.56L9.2 5.78ZM7.8 11.26L6.24 10.46C6.26667 10.9933 6.32 11.4133 6.4 11.72C6.49333 12.0133 6.62667 12.3 6.8 12.58C6.84 12.5667 6.88667 12.56 6.94 12.56C7.28667 12.5333 7.63333 12.4267 7.98 12.24C8.32667 12.04 8.59333 11.8067 8.78 11.54V11.14L7.8 11.26Z"
                ></path>
            </svg>
        </span>
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