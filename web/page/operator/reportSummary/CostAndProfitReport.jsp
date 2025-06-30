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
        <title>Báo cáo Chi phí và Lợi nhuận Kho bãi</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            .div3{
                padding: 20px;
            }
            .div3_1{
                border: 2px solid rgb(62, 49, 49);
                box-shadow: 0 4px 16px rgba(169, 125, 125, 0.433);
                border-radius: 10px;
                padding: 20px 20px 0px 20px;
            }
            /* Cost and Profit Report Styles */
            .cost-profit-container {
                background-color: white;
                padding: 0px;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .page-header {
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                padding: 20px;
                border-radius: 15px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.1);
                margin-bottom: 25px;
                text-align: center;
            }

            .page-title {
                font-size: 32px;
                font-weight: 700;
                margin: 0;
                text-shadow: 2px 2px 4px rgba(0,0,0,0.3);
            }

            .page-subtitle {
                font-size: 16px;
                margin: 10px 0 0 0;
                opacity: 0.9;
            }

            /* Section Divider */
            .section-divider {
                background: linear-gradient(45deg, #2c3e50, #34495e);
                color: white;
                padding: 15px;
                border-radius: 10px;
                margin: 40px 0 25px 0;
                text-align: center;
                box-shadow: 0 4px 15px rgba(0,0,0,0.2);
            }

            .section-title {
                font-size: 24px;
                font-weight: 600;
                margin: 0;
                text-shadow: 1px 1px 2px rgba(0,0,0,0.3);
            }

            /* Filter Section */
            .filter-section {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                margin-bottom: 25px;
            }

            .performance-filter-section {
                background: linear-gradient(135deg, #e8f4f8 0%, #d1ecf1 100%);
                border: 2px solid #3498db;
                border-radius: 15px;
                padding: 25px;
                margin-bottom: 25px;
                box-shadow: 0 4px 15px rgba(52, 152, 219, 0.2);
            }

            .filter-title {
                font-size: 20px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 20px;
                border-bottom: 2px solid #ecf0f1;
                padding-bottom: 10px;
            }

            .performance-filter-title {
                font-size: 20px;
                font-weight: 600;
                color: #2980b9;
                margin-bottom: 20px;
                border-bottom: 2px solid #3498db;
                padding-bottom: 10px;
                display: flex;
                align-items: center;
            }

            .performance-filter-title::before {
                content: "📊";
                margin-right: 10px;
                font-size: 24px;
            }

            .filter-row {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px;
                align-items: end;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
            }

            .filter-label {
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 8px;
                font-size: 14px;
            }

            .performance-filter-label {
                font-weight: 600;
                color: #2980b9;
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

            .performance-filter-input {
                padding: 12px 15px;
                border: 2px solid #85c1e9;
                border-radius: 8px;
                font-size: 14px;
                transition: all 0.3s ease;
                background: white;
            }

            .filter-input:focus, .performance-filter-input:focus {
                border-color: #667eea;
                outline: none;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            }

            .performance-filter-input:focus {
                border-color: #3498db;
                box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            }

            .filter-btn {
                padding: 12px 25px;
                background: linear-gradient(45deg, #667eea, #764ba2);
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                font-size: 14px;
            }

            .performance-filter-btn {
                padding: 12px 25px;
                background: linear-gradient(45deg, #3498db, #2980b9);
                color: white;
                border: none;
                border-radius: 8px;
                cursor: pointer;
                font-weight: 600;
                transition: all 0.3s ease;
                font-size: 14px;
            }

            .filter-btn:hover {
                background: linear-gradient(45deg, #5a67d8, #6b46c1);
                transform: translateY(-2px);
                box-shadow: 0 4px 15px rgba(102, 126, 234, 0.3);
            }

            .performance-filter-btn:hover {
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

            .performance-clear-btn {
                background: linear-gradient(45deg, #95a5a6, #7f8c8d);
                margin-left: 10px;
            }

            .performance-clear-btn:hover {
                background: linear-gradient(45deg, #7f8c8d, #5d6d6e);
            }

            /* Statistics Cards */
            .stats-overview {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
                gap: 20px;
                margin-bottom: 30px;
            }

            .stat-card {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                text-align: center;
                transition: transform 0.3s ease;
                border-left: 5px solid;
            }

            .stat-card:hover {
                transform: translateY(-5px);
            }

            .stat-card.inbound {
                border-left-color: #27ae60;
            }

            .stat-card.outbound {
                border-left-color: #e74c3c;
            }

            .stat-card.profit {
                border-left-color: #f39c12;
            }

            .stat-value {
                font-size: 28px;
                font-weight: 700;
                margin-bottom: 8px;
            }

            .stat-label {
                font-size: 14px;
                color: #7f8c8d;
                font-weight: 500;
            }

            .stat-value.inbound {
                color: #27ae60;
            }

            .stat-value.outbound {
                color: #e74c3c;
            }

            .stat-value.profit {
                color: #f39c12;
            }

            /* Charts Grid */
            .charts-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
                gap: 25px;
                margin-bottom: 30px;
            }

            .chart-container {
                background: white;
                padding: 25px;
                border-radius: 15px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                position: relative;
            }

            .chart-title {
                font-size: 20px;
                font-weight: 600;
                color: #2c3e50;
                margin-bottom: 20px;
                text-align: center;
                border-bottom: 2px solid #ecf0f1;
                padding-bottom: 15px;
            }

            .chart-wrapper {
                position: relative;
                height: 400px;
                margin-top: 20px;
            }

            .chart-wrapper.large {
                height: 500px;
            }

            /* Info Notice */
            .info-notice {
                background: linear-gradient(135deg, #e8f6ff 0%, #d4e6f1 100%);
                border-left: 5px solid #3498db;
                padding: 15px 20px;
                margin-bottom: 25px;
                border-radius: 10px;
                color: #2c3e50;
                font-size: 14px;
                box-shadow: 0 2px 10px rgba(52, 152, 219, 0.1);
            }

            .info-notice .info-icon {
                color: #3498db;
                font-weight: bold;
                margin-right: 8px;
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .charts-grid {
                    grid-template-columns: 1fr;
                }

                .filter-row {
                    grid-template-columns: 1fr;
                }

                .stats-overview {
                    grid-template-columns: 1fr;
                }

                .chart-wrapper {
                    height: 300px;
                }

                .page-title {
                    font-size: 24px;
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
                justify-content: flex-end;
            }

            .continue-application {
                --color: #fff;
                --background: #404660;
                --background-hover: #3A4059;
                --background-left: #2B3044;
                --folder: #F3E9CB;
                --folder-inner: #BEB393;
                --paper: #FFFFFF;
                --paper-lines: #BBC1E1;
                --paper-behind: #E1E6F9;
                --pencil-cap: #fff;
                --pencil-top: #275EFE;
                --pencil-middle: #fff;
                --pencil-bottom: #5C86FF;
                --shadow: rgba(13, 15, 25, .2);
                border: none;
                outline: none;
                cursor: pointer;
                position: relative;
                border-radius: 5px;
                font-size: 14px;
                font-weight: 500;
                line-height: 19px;
                -webkit-appearance: none;
                -webkit-tap-highlight-color: transparent;
                padding: 17px 29px 17px 69px;
                transition: background 0.3s;
                color: var(--color);
                background: var(--bg, var(--background));
                transform: translateY(-47px);
            }

            .continue-application > div {
                top: 0;
                left: 0;
                bottom: 0;
                width: 53px;
                position: absolute;
                overflow: hidden;
                border-radius: 5px 0 0 5px;
                background: var(--background-left);
            }

            .continue-application > div .folder {
                width: 23px;
                height: 27px;
                position: absolute;
                left: 15px;
                top: 13px;
            }

            .continue-application > div .folder .top {
                left: 0;
                top: 0;
                z-index: 2;
                position: absolute;
                transform: translateX(var(--fx, 0));
                transition: transform 0.4s ease var(--fd, 0.3s);
            }

            .continue-application > div .folder .top svg {
                width: 24px;
                height: 27px;
                display: block;
                fill: var(--folder);
                transform-origin: 0 50%;
                transition: transform 0.3s ease var(--fds, 0.45s);
                transform: perspective(120px) rotateY(var(--fr, 0deg));
            }

            .continue-application > div .folder:before, .continue-application > div .folder:after,
            .continue-application > div .folder .paper {
                content: "";
                position: absolute;
                left: var(--l, 0);
                top: var(--t, 0);
                width: var(--w, 100%);
                height: var(--h, 100%);
                border-radius: 1px;
                background: var(--b, var(--folder-inner));
            }

            .continue-application > div .folder:before {
                box-shadow: 0 1.5px 3px var(--shadow), 0 2.5px 5px var(--shadow), 0 3.5px 7px var(--shadow);
                transform: translateX(var(--fx, 0));
                transition: transform 0.4s ease var(--fd, 0.3s);
            }

            .continue-application > div .folder:after,
            .continue-application > div .folder .paper {
                --l: 1px;
                --t: 1px;
                --w: 21px;
                --h: 25px;
                --b: var(--paper-behind);
            }

            .continue-application > div .folder:after {
                transform: translate(var(--pbx, 0), var(--pby, 0));
                transition: transform 0.4s ease var(--pbd, 0s);
            }

            .continue-application > div .folder .paper {
                z-index: 1;
                --b: var(--paper);
            }

            .continue-application > div .folder .paper:before, .continue-application > div .folder .paper:after {
                content: "";
                width: var(--wp, 14px);
                height: 2px;
                border-radius: 1px;
                transform: scaleY(0.5);
                left: 3px;
                top: var(--tp, 3px);
                position: absolute;
                background: var(--paper-lines);
                box-shadow: 0 12px 0 0 var(--paper-lines), 0 24px 0 0 var(--paper-lines);
            }

            .continue-application > div .folder .paper:after {
                --tp: 6px;
                --wp: 10px;
            }

            .continue-application > div .pencil {
                height: 2px;
                width: 3px;
                border-radius: 1px 1px 0 0;
                top: 8px;
                left: 105%;
                position: absolute;
                z-index: 3;
                transform-origin: 50% 19px;
                background: var(--pencil-cap);
                transform: translateX(var(--pex, 0)) rotate(35deg);
                transition: transform 0.4s ease var(--pbd, 0s);
            }

            .continue-application > div .pencil:before, .continue-application > div .pencil:after {
                content: "";
                position: absolute;
                display: block;
                background: var(--b, linear-gradient(var(--pencil-top) 55%, var(--pencil-middle) 55.1%, var(--pencil-middle) 60%, var(--pencil-bottom) 60.1%));
                width: var(--w, 5px);
                height: var(--h, 20px);
                border-radius: var(--br, 2px 2px 0 0);
                top: var(--t, 2px);
                left: var(--l, -1px);
            }

            .continue-application > div .pencil:before {
                -webkit-clip-path: polygon(0 5%, 5px 5%, 5px 17px, 50% 20px, 0 17px);
                clip-path: polygon(0 5%, 5px 5%, 5px 17px, 50% 20px, 0 17px);
            }

            .continue-application > div .pencil:after {
                --b: none;
                --w: 3px;
                --h: 6px;
                --br: 0 2px 1px 0;
                --t: 3px;
                --l: 3px;
                border-top: 1px solid var(--pencil-top);
                border-right: 1px solid var(--pencil-top);
            }

            .continue-application:before, .continue-application:after {
                content: "";
                position: absolute;
                width: 10px;
                height: 2px;
                border-radius: 1px;
                background: var(--color);
                transform-origin: 9px 1px;
                transform: translateX(var(--cx, 0)) scale(0.5) rotate(var(--r, -45deg));
                top: 26px;
                right: 16px;
                transition: transform 0.3s;
            }

            .continue-application:after {
                --r: 45deg;
            }

            .continue-application:hover {
                --cx: 2px;
                --bg: var(--background-hover);
                --fx: -40px;
                --fr: -60deg;
                --fd: .15s;
                --fds: 0s;
                --pbx: 3px;
                --pby: -3px;
                --pbd: .15s;
                --pex: -24px;
            }

        </style>
    </head>
    <body>
        <div class="div3_1">
            <div class="cost-profit-container">
                <!-- Page Header -->
                <div class="page-header">
                    <h1 class="page-title">📊 Báo cáo Chi phí và Lợi nhuận Kho bãi</h1>
                    <p class="page-subtitle">Phân tích chi tiết chi phí vận hành và lợi nhuận của các đơn vị kho bãi</p>
                </div>

                <!-- Filter Section for Cost and Profit -->
                <div class="filter-section">
                    <h3 class="filter-title">🔍 Bộ lọc Chi phí và Lợi nhuận</h3>
                    <form method="GET" action="StorageReportController" id="costProfitFilterForm">
                        <input type="hidden" name="service" value="filterCostAndProfit">
                        <div class="filter-row">
                            <div class="filter-group">

                                <label class="filter-label">Đơn vị kho:</label>
                                <select name="storageUnitId" class="filter-input">
                                    <option value="">-- Tất cả kho --</option>
                                    <c:forEach var="unit" items="${storageUnits}">
                                        <option value="${unit.storageUnitId}" 
                                                ${selectedStorageUnitId == unit.storageUnitId ? 'selected' : ''}>
                                            ${unit.warehouseName}
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

                            <div class="filter-group">
                                <button type="submit" class="filter-btn">
                                    🔍 Tìm kiếm
                                </button>
                                <button type="button" class="filter-btn clear-btn" onclick="clearCostProfitFilters()">
                                    🗑️ Xóa bộ lọc
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Statistics Overview -->
                <div class="stats-overview">
                    <div class="stat-card inbound">
                        <div class="stat-value inbound" id="totalInbound">
                            <fmt:formatNumber value="${overallStats[2]}" pattern="#,###"/> VNĐ
                        </div>
                        <div class="stat-label">Tổng lợi nhuận</div>
                    </div>
                </div>

                <!-- Charts Grid - Chi phí và Lợi nhuận -->
                <div class="charts-grid">
                    <!-- 1. Biểu đồ Chi phí Lưu Kho Theo Kho -->
                    <div class="chart-container">
                        <h3 class="chart-title">💰 Chi phí Lưu Kho Theo Kho</h3>
                        <div class="chart-wrapper">
                            <canvas id="storageCostChart"></canvas>
                        </div>
                    </div>

                    <!-- 2. Biểu đồ Chi phí Bảo Trì Theo Kho -->
                    <div class="chart-container">
                        <h3 class="chart-title">🔧 Chi phí Bảo Trì Theo Kho</h3>
                        <div class="chart-wrapper">
                            <canvas id="maintenanceCostChart"></canvas>
                        </div>
                    </div>

                    <!-- 3. Biểu đồ Lợi nhuận Theo Kho -->
                    <div class="chart-container">
                        <h3 class="chart-title">📈 Lợi nhuận Theo Kho</h3>
                        <div class="chart-wrapper">
                            <canvas id="profitChart"></canvas>
                        </div>
                    </div>

                    <!-- 4. Biểu đồ Chi phí Nhân Sự -->
                    <div class="chart-container">
                        <h3 class="chart-title">👥 Chi phí Nhân Sự Theo Kho</h3>
                        <div class="chart-wrapper">
                            <canvas id="personnelCostChart"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Section Divider for Performance Charts -->
                <div class="section-divider">
                    <h2 class="section-title">📊 Hiệu suất hoạt động nhập/xuất kho</h2>
                </div>

                <!-- Performance Filter Section -->
                <div class="performance-filter-section">
                    <h3 class="performance-filter-title">Bộ lọc Hiệu suất hoạt động</h3>
                    <form method="GET" action="StorageReportController" id="performanceFilterForm">
                        <input type="hidden" name="service" value="filterPerformanceActivity">
                        <div class="filter-row">
                            <div class="filter-group">
                                <label class="performance-filter-label">Đơn vị kho:</label>
                                <select name="performanceStorageUnitId" class="performance-filter-input">
                                    <option value="">-- Tất cả kho --</option>
                                    <c:forEach var="unit" items="${storageUnits}">
                                        <option value="${unit.storageUnitId}" 
                                                ${selectedPerformanceStorageUnitId == unit.storageUnitId ? 'selected' : ''}>
                                            ${unit.warehouseName}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="filter-group">
                                <label class="performance-filter-label">Từ tháng:</label>
                                <input type="month" name="performanceFromMonth" class="performance-filter-input" 
                                       value="${selectedPerformanceFromMonth}">
                            </div>

                            <div class="filter-group">
                                <label class="performance-filter-label">Đến tháng:</label>
                                <input type="month" name="performanceToMonth" class="performance-filter-input" 
                                       value="${selectedPerformanceToMonth}">
                            </div>

                            <div class="filter-group">
                                <button type="submit" class="performance-filter-btn">
                                    📊 Lọc hiệu suất
                                </button>
                                <button type="button" class="performance-filter-btn performance-clear-btn" onclick="clearPerformanceFilters()">
                                    🗑️ Xóa bộ lọc
                                </button>
                            </div>
                        </div>
                    </form>
                </div>

                <!-- Info Notice -->


                <!-- Performance Charts Grid -->
                <div class="charts-grid">
                    <!-- 5. Biểu đồ Tần Suất Nhập/Xuất Kho Theo Kho (POLAR AREA) -->
                    <div class="chart-container">
                        <h3 class="chart-title">Thời gian lưu kho trung bình theo tháng</h3>
                        <div class="chart-wrapper">
                            <canvas id="LineCharDate"></canvas>
                        </div>
                    </div>

                    <!-- 6. Biểu đồ Tỷ Lệ Đơn Hàng Trả Lại Theo Kho -->
                    <div class="chart-container">
                        <h3 class="chart-title">↩️ Tỷ Lệ Đơn Hàng Trả Lại Theo Kho</h3>
                        <div class="chart-wrapper">
                            <canvas id="returnRateChart"></canvas>
                        </div>
                    </div>

                    <!-- 7. Biểu đồ Tỷ Lệ Sử Dụng Không Gian Lưu Trữ -->
                    <div class="chart-container">
                        <h3 class="chart-title">📦 Tỷ Lệ Sử Dụng Không Gian Lưu Trữ Theo Kho</h3>
                        <div class="chart-wrapper">
                            <canvas id="spaceUtilizationChart"></canvas>
                        </div>
                    </div>

                    <!-- 8. Biểu đồ Hoạt động Nhập/Xuất Theo Tháng (PIE) -->
                    <div class="chart-container">
                        <h3 class="chart-title">📅 Hoạt động Nhập/Xuất Theo Tháng</h3>
                        <div class="chart-wrapper">
                            <canvas id="monthlyActivityChart"></canvas>
                        </div>
                    </div>
                </div>
            </div>
            <div class="butt">
                <a href="http://localhost:9999/HouseMovingSystem//StorageReportDetailController">
                    <button class="cssbuttons-io-button">
                        Chi tiết bảng
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
            <a href="#">
                <button class="continue-application">
                    <div>
                        <div class="pencil"></div>
                        <div class="folder">
                            <div class="top">
                                <svg viewBox="0 0 24 27">
                                <path d="M1,0 L23,0 C23.5522847,-1.01453063e-16 24,0.44771525 24,1 L24,8.17157288 C24,8.70200585 23.7892863,9.21071368 23.4142136,9.58578644 L20.5857864,12.4142136 C20.2107137,12.7892863 20,13.2979941 20,13.8284271 L20,26 C20,26.5522847 19.5522847,27 19,27 L1,27 C0.44771525,27 6.76353751e-17,26.5522847 0,26 L0,1 C-6.76353751e-17,0.44771525 0.44771525,1.01453063e-16 1,0 Z"></path>
                                </svg>
                            </div>
                            <div class="paper"></div>
                        </div>
                    </div>
                    tạo thông báo
                </button>
            </a>

        </div>

        <script>
            // ========== Dữ liệu từ server ==========

            // Dữ liệu theo kho từ warehouseMonthlyData
            const warehouseMonthlyData = {
            <c:forEach var="entry" items="${warehouseMonthlyData}" varStatus="status">
            "${entry.key}": {
            warehouseName: "${entry.value.warehouseName}",
                    month: "${entry.value.month}",
                    maintenanceCost: ${entry.value.maintenanceCost},
                    profit: ${entry.value.profit},
                    storageCost: ${entry.value.storageCost},
                    personnelCost: ${entry.value.personnelCost}
            }<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            };
            // Dữ liệu chi phí nhân sự theo kho
            const warehousePersonnelCosts = {
            <c:forEach var="entry" items="${warehousePersonnelCosts}" varStatus="status">
            "${entry.key}": ${entry.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            };
            // Dữ liệu tổng chi phí theo kho
            const warehouseTotalCosts = {
            <c:forEach var="entry" items="${warehouseTotalCosts}" varStatus="status">
            "${entry.key}": ${entry.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            };
            // ========== Dữ liệu mới cho hiệu suất hoạt động ==========

            // Dữ liệu tần suất nhập/xuất kho - 6 tháng gần nhất
            const inOutFrequencyData = [
            <c:choose>
                <c:when test="${not empty filteredInOutFrequencyData}">
                    <c:forEach var="data" items="${filteredInOutFrequencyData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    year: ${data[1]},
                    month: ${data[2]},
                    inbound: ${data[3]},
                    outbound: ${data[4]},
                    inboundFrequency: ${data[5]},
                    outboundFrequency: ${data[6]}
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:forEach var="data" items="${inOutFrequencyData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    year: ${data[1]},
                    month: ${data[2]},
                    inbound: ${data[3]},
                    outbound: ${data[4]},
                    inboundFrequency: ${data[5]},
                    outboundFrequency: ${data[6]}
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            ];
            // Dữ liệu tỷ lệ trả hàng
            const returnRateData = [
            <c:choose>
                <c:when test="${not empty filteredReturnRateData}">
                    <c:forEach var="data" items="${filteredReturnRateData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    totalOrders: ${data[1]},
                    totalReturned: ${data[2]},
                    returnRate: ${data[3]},
                    location: "${data[4]}"
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:forEach var="data" items="${returnRateData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    totalOrders: ${data[1]},
                    totalReturned: ${data[2]},
                    returnRate: ${data[3]},
                    location: "${data[4]}"
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            ];
            // Dữ liệu sử dụng không gian
            const spaceUtilizationData = [
            <c:choose>
                <c:when test="${not empty filteredSpaceUtilizationData}">
                    <c:forEach var="data" items="${filteredSpaceUtilizationData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    avgUsedArea: ${data[1]},
                    avgTotalArea: ${data[2]},
                    avgUtilizationRate: ${data[3]},
                    maxUtilizationRate: ${data[4]},
                    minUtilizationRate: ${data[5]},
                    location: "${data[6]}"
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:forEach var="data" items="${spaceUtilizationData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    avgUsedArea: ${data[1]},
                    avgTotalArea: ${data[2]},
                    avgUtilizationRate: ${data[3]},
                    maxUtilizationRate: ${data[4]},
                    minUtilizationRate: ${data[5]},
                    location: "${data[6]}"
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            ];
            // Dữ liệu hoạt động theo tháng được lọc
            const monthlyActivityData = [
            <c:choose>
                <c:when test="${not empty filteredMonthlyActivityData}">
                    <c:forEach var="data" items="${filteredMonthlyActivityData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    year: ${data[1]},
                    month: ${data[2]},
                    monthlyInbound: ${data[3]},
                    monthlyOutbound: ${data[4]},
                    efficiency: ${data[5]}
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
            // Fallback to frequency data if monthly activity data is not available
                    <c:forEach var="data" items="${inOutFrequencyData}" varStatus="status">
            {
            warehouseName: "${data[0]}",
                    year: ${data[1]},
                    month: ${data[2]},
                    monthlyInbound: ${data[3]},
                    monthlyOutbound: ${data[4]},
                    efficiency: ${data[4] > 0 && data[3] > 0 ? data[4] / data[3] : 0}
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            ];
            // Debug logs
            console.log('Warehouse Monthly Data:', warehouseMonthlyData);
            console.log('In/Out Frequency Data (6 months):', inOutFrequencyData);
            console.log('Return Rate Data:', returnRateData);
            console.log('Space Utilization Data:', spaceUtilizationData);
            console.log('Monthly Activity Data:', monthlyActivityData);
            // ========== Hàm xử lý dữ liệu ==========

            // Hàm nhóm dữ liệu theo kho VÀ SẮP XẾP THEO THỜI GIAN
            function groupDataByWarehouse() {
            const warehouseData = {};
            // Thu thập dữ liệu theo kho
            Object.keys(warehouseMonthlyData).forEach(key => {
            const data = warehouseMonthlyData[key];
            const warehouseName = data.warehouseName;
            if (!warehouseData[warehouseName]) {
            warehouseData[warehouseName] = [];
            }

            warehouseData[warehouseName].push({
            month: data.month,
                    maintenanceCost: data.maintenanceCost,
                    profit: data.profit,
                    storageCost: data.storageCost,
                    personnelCost: data.personnelCost
            });
            });
            // Sắp xếp dữ liệu theo thời gian cho từng kho (từ cũ đến mới)
            Object.keys(warehouseData).forEach(warehouseName => {
            warehouseData[warehouseName].sort((a, b) => {
            return new Date(a.month + '-01') - new Date(b.month + '-01');
            });
            });
            return warehouseData;
            }

            // Hàm lấy tất cả các tháng duy nhất VÀ SẮP XẾP
            function getAllUniqueMonths() {
            const allMonths = new Set();
            Object.keys(warehouseMonthlyData).forEach(key => {
            const data = warehouseMonthlyData[key];
            allMonths.add(data.month);
            });
            // Chuyển Set thành Array và sắp xếp theo thời gian (từ cũ đến mới)
            return Array.from(allMonths).sort((a, b) => {
            return new Date(a + '-01') - new Date(b + '-01');
            });
            }

            // Tạo màu sắc cho các kho
            function generateColors(count) {
            const colors = [
                    'rgba(102, 126, 234, 0.8)',
                    'rgba(231, 76, 60, 0.8)',
                    'rgba(243, 156, 18, 0.8)',
                    'rgba(39, 174, 96, 0.8)',
                    'rgba(155, 89, 182, 0.8)',
                    'rgba(52, 73, 94, 0.8)',
                    'rgba(26, 188, 156, 0.8)',
                    'rgba(230, 126, 34, 0.8)'
            ];
            const result = [];
            for (let i = 0; i < count; i++) {
            result.push(colors[i % colors.length]);
            }
            return result;
            }

            // ========== Tạo biểu đồ CHI PHÍ VÀ LỢI NHUẬN ==========

            // 1. Biểu đồ Chi phí Lưu Kho Theo Kho
            function createStorageCostChart() {
            const ctx = document.getElementById('storageCostChart').getContext('2d');
            const warehouseData = groupDataByWarehouse();
            const warehouseNames = Object.keys(warehouseData);
            const sortedMonths = getAllUniqueMonths();
            if (warehouseNames.length === 0) {
            ctx.fillText('Không có dữ liệu', 250, 200);
            return;
            }

            const datasets = [];
            const colors = generateColors(warehouseNames.length);
            warehouseNames.forEach((name, index) => {
            const warehouseMonthlyData = warehouseData[name];
            // Tạo mảng dữ liệu theo thứ tự tháng đã sắp xếp
            const data = sortedMonths.map(month => {
            const monthData = warehouseMonthlyData.find(item => item.month === month);
            return monthData ? monthData.storageCost : 0;
            });
            datasets.push({
            label: name,
                    data: data,
                    backgroundColor: colors[index],
                    borderColor: colors[index].replace('0.8', '1'),
                    borderWidth: 2,
                    borderRadius: 5
            });
            });
            new Chart(ctx, {
            type: 'bar',
                    data: {
                    labels: sortedMonths.map(month => {
                    const [year, monthNum] = month.split('-');
                    return `\${monthNum}/\${year}`;
                    }),
                            datasets: datasets
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'top',
                                    labels: {
                                    usePointStyle: true,
                                            padding: 15
                                    }
                            },
                                    tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            callbacks: {
                                            label: function(context) {
                                            return context.dataset.label + ': ' + context.parsed.y.toLocaleString() + ' VNĐ';
                                            }
                                            }
                                    }
                            },
                            scales: {
                            x: {
                            title: {
                            display: true,
                                    text: 'Thời gian'
                            },
                                    grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                    }
                            },
                                    y: {
                                    beginAtZero: true,
                                            title: {
                                            display: true,
                                                    text: 'Chi phí lưu kho (VNĐ/m²)'
                                            },
                                            ticks: {
                                            callback: function(value) {
                                            return value.toLocaleString();
                                            }
                                            },
                                            grid: {
                                            color: 'rgba(0, 0, 0, 0.1)'
                                            }
                                    }
                            }
                    }
            });
            }

            // 2. Biểu đồ Chi phí Bảo Trì Theo Kho
            function createMaintenanceCostChart() {
            const ctx = document.getElementById('maintenanceCostChart').getContext('2d');
            const warehouseData = groupDataByWarehouse();
            const warehouseNames = Object.keys(warehouseData);
            const sortedMonths = getAllUniqueMonths();
            if (warehouseNames.length === 0) {
            ctx.fillText('Không có dữ liệu', 250, 200);
            return;
            }

            const datasets = [];
            const colors = generateColors(warehouseNames.length);
            warehouseNames.forEach((name, index) => {
            const warehouseMonthlyData = warehouseData[name];
            // Tạo mảng dữ liệu theo thứ tự tháng đã sắp xếp
            const data = sortedMonths.map(month => {
            const monthData = warehouseMonthlyData.find(item => item.month === month);
            return monthData ? monthData.maintenanceCost : 0;
            });
            datasets.push({
            label: name,
                    data: data,
                    borderColor: colors[index].replace('0.8', '1'),
                    backgroundColor: colors[index].replace('0.8', '0.1'),
                    borderWidth: 3,
                    fill: false,
                    tension: 0.4,
                    pointBackgroundColor: colors[index].replace('0.8', '1'),
                    pointBorderColor: 'white',
                    pointBorderWidth: 2,
                    pointRadius: 6
            });
            });
            new Chart(ctx, {
            type: 'line',
                    data: {
                    labels: sortedMonths.map(month => {
                    const [year, monthNum] = month.split('-');
                    return `\${monthNum}/\${year}`;
                    }),
                            datasets: datasets
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'top',
                                    labels: {
                                    usePointStyle: true,
                                            padding: 15
                                    }
                            },
                                    tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            callbacks: {
                                            label: function(context) {
                                            return context.dataset.label + ': ' + context.parsed.y.toLocaleString() + ' VNĐ';
                                            }
                                            }
                                    }
                            },
                            scales: {
                            x: {
                            title: {
                            display: true,
                                    text: 'Thời gian'
                            },
                                    grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                    }
                            },
                                    y: {
                                    beginAtZero: true,
                                            title: {
                                            display: true,
                                                    text: 'Chi phí bảo trì (VNĐ/m²)'
                                            },
                                            ticks: {
                                            callback: function(value) {
                                            return value.toLocaleString();
                                            }
                                            },
                                            grid: {
                                            color: 'rgba(0, 0, 0, 0.1)'
                                            }
                                    }
                            }
                    }
            });
            }

            // 3. Biểu đồ Lợi nhuận Theo Kho
            function createProfitChart() {
            const ctx = document.getElementById('profitChart').getContext('2d');
            const warehouseData = groupDataByWarehouse();
            const warehouseNames = Object.keys(warehouseData);
            const sortedMonths = getAllUniqueMonths();
            if (warehouseNames.length === 0) {
            ctx.fillText('Không có dữ liệu', 250, 200);
            return;
            }

            const datasets = [];
            const colors = generateColors(warehouseNames.length);
            warehouseNames.forEach((name, index) => {
            const warehouseMonthlyData = warehouseData[name];
            // Tạo mảng dữ liệu theo thứ tự tháng đã sắp xếp
            const data = sortedMonths.map(month => {
            const monthData = warehouseMonthlyData.find(item => item.month === month);
            return monthData ? monthData.profit : 0;
            });
            datasets.push({
            label: name,
                    data: data,
                    borderColor: colors[index].replace('0.8', '1'),
                    backgroundColor: colors[index].replace('0.8', '0.1'),
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: colors[index].replace('0.8', '1'),
                    pointBorderColor: 'white',
                    pointBorderWidth: 2,
                    pointRadius: 6
            });
            });
            new Chart(ctx, {
            type: 'line',
                    data: {
                    labels: sortedMonths.map(month => {
                    const [year, monthNum] = month.split('-');
                    return `\${monthNum}/\${year}`;
                    }),
                            datasets: datasets
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'top',
                                    labels: {
                                    usePointStyle: true,
                                            padding: 15
                                    }
                            },
                                    tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            callbacks: {
                                            label: function(context) {
                                            return context.dataset.label + ': ' + context.parsed.y.toLocaleString() + ' VNĐ';
                                            }
                                            }
                                    }
                            },
                            scales: {
                            x: {
                            title: {
                            display: true,
                                    text: 'Thời gian'
                            },
                                    grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                    }
                            },
                                    y: {
                                    beginAtZero: true,
                                            title: {
                                            display: true,
                                                    text: 'Lợi nhuận (VNĐ)'
                                            },
                                            ticks: {
                                            callback: function(value) {
                                            return (value / 1000000).toFixed(0) + 'M';
                                            }
                                            },
                                            grid: {
                                            color: 'rgba(0, 0, 0, 0.1)'
                                            }
                                    }
                            }
                    }
            });
            }

            // 4. Biểu đồ Chi phí Nhân Sự Theo Kho
            function createPersonnelCostChart() {
            const ctx = document.getElementById('personnelCostChart').getContext('2d');
            const warehouseNames = Object.keys(warehousePersonnelCosts);
            const personnelCosts = Object.values(warehousePersonnelCosts);
            if (warehouseNames.length === 0) {
            ctx.fillText('Không có dữ liệu', 250, 200);
            return;
            }

            // Tạo màu sắc động
            const colors = generateColors(warehouseNames.length);
            new Chart(ctx, {
            type: 'doughnut',
                    data: {
                    labels: warehouseNames,
                            datasets: [{
                            data: personnelCosts,
                                    backgroundColor: colors,
                                    borderColor: colors.map(color => color.replace('0.8', '1')),
                                    borderWidth: 2,
                                    hoverOffset: 10
                            }]
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'bottom',
                                    labels: {
                                    usePointStyle: true,
                                            padding: 20,
                                            font: {
                                            size: 12
                                            }
                                    }
                            },
                                    tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            callbacks: {
                                            label: function(context) {
                                            const total = context.dataset.data.reduce((sum, value) => sum + value, 0);
                                            const percentage = ((context.parsed / total) * 100).toFixed(1);
                                            return context.label + ': ' + context.parsed.toLocaleString() + ' VNĐ (' + percentage + '%)';
                                            }
                                            }
                                    }
                            }
                    }
            });
            }

            // ========== Tạo biểu đồ HIỆU SUẤT HOẠT ĐỘNG ==========


            // 6. Biểu đồ Tỷ Lệ Đơn Hàng Trả Lại Theo Kho
            function createReturnRateChart() {
            const ctx = document.getElementById('returnRateChart').getContext('2d');
            if (returnRateData.length === 0) {
            ctx.fillText('Không có dữ liệu', 250, 200);
            return;
            }

            const warehouseNames = returnRateData.map(item => item.warehouseName);
            const returnRates = returnRateData.map(item => item.returnRate);
            const colors = generateColors(warehouseNames.length);
            new Chart(ctx, {
            type: 'pie',
                    data: {
                    labels: warehouseNames,
                            datasets: [{
                            data: returnRates,
                                    backgroundColor: colors,
                                    borderColor: colors.map(color => color.replace('0.8', '1')),
                                    borderWidth: 2,
                                    hoverOffset: 15
                            }]
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'bottom',
                                    labels: {
                                    usePointStyle: true,
                                            padding: 15,
                                            font: {
                                            size: 12
                                            }
                                    }
                            },
                                    tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            callbacks: {
                                            label: function(context) {
                                            const data = returnRateData[context.dataIndex];
                                            return context.label + ': ' +
                                                    data.totalReturned + ' đơn (' +
                                                    context.raw.toFixed(1) + '%)';
                                            }
                                            }
                                    }
                            }
                    }
            });
            }

            // 7. Biểu đồ Tỷ Lệ Sử Dụng Không Gian Lưu Trữ
            function createSpaceUtilizationChart() {
            const ctx = document.getElementById('spaceUtilizationChart').getContext('2d');
            if (spaceUtilizationData.length === 0) {
            ctx.fillText('Không có dữ liệu', 250, 200);
            return;
            }

            const warehouseNames = spaceUtilizationData.map(item => item.warehouseName);
            const avgUtilization = spaceUtilizationData.map(item => item.avgUtilizationRate);
            const maxUtilization = spaceUtilizationData.map(item => item.maxUtilizationRate);
            const minUtilization = spaceUtilizationData.map(item => item.minUtilizationRate);
            const colors = generateColors(warehouseNames.length);
            new Chart(ctx, {
            type: 'bar',
                    data: {
                    labels: warehouseNames,
                            datasets: [
                            {
                            label: 'Tỷ lệ sử dụng trung bình',
                                    data: avgUtilization,
                                    backgroundColor: colors.map(color => color.replace('0.8', '0.6')),
                                    borderColor: colors,
                                    borderWidth: 2,
                                    borderRadius: 5
                            },
                            {
                            label: 'Tỷ lệ sử dụng tối đa',
                                    data: maxUtilization,
                                    backgroundColor: colors.map(color => color.replace('0.8', '0.3')),
                                    borderColor: colors.map(color => color.replace('0.8', '0.7')),
                                    borderWidth: 2,
                                    borderRadius: 5
                            },
                            {
                            label: 'Tỷ lệ sử dụng tối thiểu',
                                    data: minUtilization,
                                    backgroundColor: colors.map(color => color.replace('0.8', '0.2')),
                                    borderColor: colors.map(color => color.replace('0.8', '0.5')),
                                    borderWidth: 2,
                                    borderRadius: 5
                            }
                            ]
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'top',
                                    labels: {
                                    usePointStyle: true,
                                            padding: 15
                                    }
                            },
                                    tooltip: {
                                    backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            callbacks: {
                                            label: function(context) {
                                            const data = spaceUtilizationData[context.dataIndex];
                                            return context.dataset.label + ': ' +
                                                    context.parsed.y.toFixed(1) + '% (' +
                                                    data.avgUsedArea.toFixed(0) + '/' +
                                                    data.avgTotalArea.toFixed(0) + ' m²)';
                                            }
                                            }
                                    }
                            },
                            scales: {
                            x: {
                            title: {
                            display: true,
                                    text: 'Kho bãi'
                            },
                                    grid: {
                                    color: 'rgba(0, 0, 0, 0.1)'
                                    }
                            },
                                    y: {
                                    beginAtZero: true,
                                            max: 100,
                                            title: {
                                            display: true,
                                                    text: 'Tỷ lệ sử dụng (%)'
                                            },
                                            ticks: {
                                            callback: function(value) {
                                            return value + '%';
                                            }
                                            },
                                            grid: {
                                            color: 'rgba(0, 0, 0, 0.1)'
                                            }
                                    }
                            }
                    }
            });
            }

            // 8. Biểu đồ Hoạt động Nhập/Xuất Theo Tháng (Doughnut Chart)
            function createMonthlyActivityChart() {
            const ctx = document.getElementById('monthlyActivityChart').getContext('2d');
            // Tính tổng nhập và xuất kho từ dữ liệu
            let totalInbound = 0;
            let totalOutbound = 0;
            monthlyActivityData.forEach(data => {
            totalInbound += data.monthlyInbound || 0;
            totalOutbound += data.monthlyOutbound || 0;
            });
            new Chart(ctx, {
            type: 'doughnut',
                    data: {
                    labels: ['Tổng nhập kho', 'Tổng xuất kho'],
                            datasets: [{
                            data: [totalInbound, totalOutbound],
                                    backgroundColor: [
                                            'rgba(39, 174, 96, 0.8)',
                                            'rgba(231, 76, 60, 0.8)'
                                    ],
                                    borderWidth: 3,
                                    borderColor: '#fff'
                            }]
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            legend: {
                            position: 'bottom',
                                    labels: {
                                    padding: 20,
                                            usePointStyle: true,
                                            font: {
                                            size: 14
                                            }
                                    }
                            },
                                    tooltip: {
                                    callbacks: {
                                    label: function(context) {
                                    const total = context.dataset.data.reduce((a, b) => a + b, 0);
                                    const percentage = ((context.parsed / total) * 100).toFixed(1);
                                    return context.label + ': ' + new Intl.NumberFormat('vi-VN').format(context.parsed) + ' (' + percentage + '%)';
                                    }
                                    }
                                    }
                            }
                    }
            });
            }

            // 5. Biểu đồ Thời gian lưu kho trung bình (CÓ HỖ TRỢ LỌC)
            function createAverageStorageDurationChart() {
            const ctx = document.getElementById('LineCharDate').getContext('2d');
            // Lấy dữ liệu từ JSP - ưu tiên dữ liệu đã lọc
            const averageStorageDurationData = [
            <c:choose>
                <c:when test="${not empty filteredAverageStorageDurationData}">
                    <c:forEach var="item" items="${filteredAverageStorageDurationData}" varStatus="status">
            {
            warehouseName: "${item[0]}",
                    year: ${item[1]},
                    month: ${item[2]},
                    averageStorageDuration: ${item[3]}
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <c:forEach var="item" items="${averageStorageDurationData}" varStatus="status">
            {
            warehouseName: "${item[0]}",
                    year: ${item[1]},
                    month: ${item[2]},
                    averageStorageDuration: ${item[3]}
            }<c:if test="${!status.last}">,</c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
            ];
            // Debug log
            console.log('Average Storage Duration Data:', averageStorageDurationData);
            // Kiểm tra nếu không có dữ liệu
            if (averageStorageDurationData.length === 0) {
            ctx.font = "16px Arial";
            ctx.fillStyle = "#666";
            ctx.textAlign = "center";
            ctx.fillText('Không có dữ liệu thời gian lưu kho', 250, 200);
            return;
            }

            // Xử lý dữ liệu để nhóm theo kho
            const warehouseData = {};
            const allMonths = new Set();
            averageStorageDurationData.forEach(item => {
            const monthKey = `\${item.year}-\${String(item.month).padStart(2, '0')}`;
            allMonths.add(monthKey);
            if (!warehouseData[item.warehouseName]) {
            warehouseData[item.warehouseName] = {};
            }
            warehouseData[item.warehouseName][monthKey] = item.averageStorageDuration;
            });
            // Sắp xếp các tháng theo thứ tự thời gian
            const sortedMonths = Array.from(allMonths).sort();
            // Tạo datasets cho từng kho
            const datasets = [];
            const colors = [
                    '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                    '#9966FF', '#FF9F40', '#E74C3C', '#2ECC71',
                    '#3498DB', '#F39C12'
            ];
            let colorIndex = 0;
            Object.keys(warehouseData).forEach(warehouseName => {
            const data = sortedMonths.map(month =>
                    warehouseData[warehouseName][month] || null
                    );
            datasets.push({
            label: warehouseName,
                    data: data,
                    borderColor: colors[colorIndex % colors.length],
                    backgroundColor: colors[colorIndex % colors.length] + '20',
                    borderWidth: 3,
                    stepped: 'middle',
                    fill: false,
                    tension: 0,
                    pointRadius: 6,
                    pointHoverRadius: 8,
                    pointBackgroundColor: colors[colorIndex % colors.length],
                    pointBorderColor: '#fff',
                    pointBorderWidth: 2,
                    spanGaps: false
            });
            colorIndex++;
            });
            // Xóa biểu đồ cũ nếu có
            if (window.averageStorageDurationChart) {
            window.averageStorageDurationChart.destroy();
            }

            // Tạo biểu đồ mới
            window.averageStorageDurationChart = new Chart(ctx, {
            type: 'line',
                    data: {
                    labels: sortedMonths.map(month => {
                    const [year, monthNum] = month.split('-');
                    return `\${monthNum}/\${year}`;
                    }),
                            datasets: datasets
                    },
                    options: {
                    responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                            title: {
                            display: false // Title đã có trong HTML
                            },
                                    legend: {
                                    display: true,
                                            position: 'top',
                                            labels: {
                                            usePointStyle: true,
                                                    padding: 15,
                                                    font: {
                                                    size: 12
                                                    }
                                            }
                                    },
                                    tooltip: {
                                    mode: 'index',
                                            intersect: false,
                                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                            titleColor: 'white',
                                            bodyColor: 'white',
                                            titleFont: {
                                            size: 14,
                                                    weight: 'bold'
                                            },
                                            bodyFont: {
                                            size: 12
                                            },
                                            callbacks: {
                                            label: function(context) {
                                            const value = context.parsed.y;
                                            if (value !== null && value !== undefined) {
                                            return `${context.dataset.label}: \${value} ngày`;
                                            }
                                            return null;
                                            }
                                            }
                                    }
                            },
                            scales: {
                            x: {
                            display: true,
                                    title: {
                                    display: true,
                                            text: 'Tháng/Năm',
                                            font: {
                                            size: 14,
                                                    weight: 'bold'
                                            }
                                    },
                                    grid: {
                                    display: true,
                                            color: 'rgba(0, 0, 0, 0.1)'
                                    },
                                    ticks: {
                                    font: {
                                    size: 11
                                    },
                                            maxRotation: 45
                                    }
                            },
                                    y: {
                                    display: true,
                                            title: {
                                            display: true,
                                                    text: 'Thời gian lưu trữ (ngày)',
                                                    font: {
                                                    size: 14,
                                                            weight: 'bold'
                                                    }
                                            },
                                            grid: {
                                            display: true,
                                                    color: 'rgba(0, 0, 0, 0.1)'
                                            },
                                            ticks: {
                                            font: {
                                            size: 11
                                            },
                                                    callback: function(value) {
                                                    return value + ' ngày';
                                                    }
                                            },
                                            beginAtZero: true
                                    }
                            },
                            interaction: {
                            mode: 'index',
                                    intersect: false,
                            },
                            hover: {
                            mode: 'index',
                                    intersect: false
                            },
                            elements: {
                            line: {
                            borderJoinStyle: 'round'
                            }
                            },
                            animation: {
                            duration: 1000,
                                    easing: 'easeInOutQuart'
                            }
                    }
            });
            }

// ========== CẬP NHẬT hàm khởi tạo chính ==========

// THÊM vào phần khởi tạo biểu đồ hiệu suất hoạt động (trong document.addEventListener):

            try {
            createAverageStorageDurationChart();
            console.log('✓ Average Storage Duration chart created with filtering support');
            } catch (e) {
            console.error('Lỗi tạo average storage duration chart:', e);
            }


            // ========== Các hàm tiện ích ==========

            // Hàm xóa bộ lọc chi phí và lợi nhuận
            function clearCostProfitFilters() {
            window.location.href = 'StorageReportController?service=viewCostAndProfit';
            }

            // Hàm xóa bộ lọc hiệu suất hoạt động
            function clearPerformanceFilters() {
            // Xóa các giá trị trong form performance
            document.querySelector('select[name="performanceStorageUnitId"]').value = '';
            document.querySelector('input[name="performanceFromMonth"]').value = '';
            document.querySelector('input[name="performanceToMonth"]').value = '';
            // Submit form để reload data
            document.getElementById('performanceFilterForm').submit();
            }

            // ========== Khởi tạo ==========

            // Khởi tạo biểu đồ khi trang load
            document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded, khởi tạo biểu đồ...');
            // Kiểm tra Chart.js đã load chưa
            if (typeof Chart === 'undefined') {
            console.error('Chart.js chưa được load');
            return;
            }

            // Tạo biểu đồ chi phí và lợi nhuận
            try {
            createStorageCostChart();
            console.log('✓ Storage Cost chart created');
            } catch (e) {
            console.error('Lỗi tạo storage cost chart:', e);
            }

            try {
            createMaintenanceCostChart();
            console.log('✓ Maintenance Cost chart created');
            } catch (e) {
            console.error('Lỗi tạo maintenance cost chart:', e);
            }

            try {
            createProfitChart();
            console.log('✓ Profit chart created');
            } catch (e) {
            console.error('Lỗi tạo profit chart:', e);
            }

            try {
            createPersonnelCostChart();
            console.log('✓ Personnel Cost chart created');
            } catch (e) {
            console.error('Lỗi tạo personnel cost chart:', e);
            }

            // Tạo biểu đồ hiệu suất hoạt động
            try {
            createFrequencyChart();
            console.log('✓ Frequency chart created (Polar Area)');
            } catch (e) {
            console.error('Lỗi tạo frequency chart:', e);
            }

            try {
            createReturnRateChart();
            console.log('✓ Return Rate chart created');
            } catch (e) {
            console.error('Lỗi tạo return rate chart:', e);
            }

            try {
            createSpaceUtilizationChart();
            console.log('✓ Space Utilization chart created');
            } catch (e) {
            console.error('Lỗi tạo space utilization chart:', e);
            }

            try {
            createMonthlyActivityChart();
            console.log('✓ Monthly Activity chart created (Pie)');
            } catch (e) {
            console.error('Lỗi tạo monthly activity chart:', e);
            }
            });
            // Thêm hiệu ứng hover cho các thẻ thống kê
            document.querySelectorAll('.stat-card').forEach(card => {
            card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-8px)';
            this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.15)';
            });
            card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 4px 15px rgba(0,0,0,0.1)';
            });
            });
            // Thêm hiệu ứng loading cho form submit
            document.querySelectorAll('form').forEach(form => {
            form.addEventListener('submit', function() {
            const btns = this.querySelectorAll('.filter-btn, .performance-filter-btn');
            btns.forEach(btn => {
            if (btn.type === 'submit') {
            btn.innerHTML = '<div style="width: 20px; height: 20px; border: 2px solid #f3f3f3; border-top: 2px solid #667eea; border-radius: 50%; animation: spin 1s linear infinite; display: inline-block; margin-right: 10px;"></div>Đang tải...';
            btn.disabled = true;
            }
            });
            });
            });
            // CSS animation for loading spinner
            const style = document.createElement('style');
            style.textContent = `
                @keyframes spin {
                    0% { transform: rotate(0deg); }
                    100% { transform: rotate(360deg); }
                }
            `;
            document.head.appendChild(style);
            // Responsive chart resize
            window.addEventListener('resize', function() {
            Chart.helpers.each(Chart.instances, function(instance) {
            instance.resize();
            });
            });
        </script>



    </body>
</html> 