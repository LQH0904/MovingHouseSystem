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
        <title>Báo cáo Hiệu suất Vận tải</title>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/3.9.1/chart.min.js"></script>
        <link href="css/performChar.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
    </head>
    <body>
        <div class="header">
            <h1>📊 Báo cáo Hiệu suất Vận tải</h1>
            <p>Phân tích chi tiết hiệu suất hoạt động của các đơn vị vận tải - 6 tháng gần đây</p>
        </div>

        <div class="filters">
            <form method="get" action="transportReport">
                <div class="filter-row">
                    <div class="filter-group">
                        <label for="transportUnitId">Đơn vị vận tải:</label>
                        <select name="transportUnitId" id="transportUnitId">
                            <option value="">Tất cả đơn vị</option>
                            <c:forEach var="unit" items="${transportUnitData}">
                                <option value="${unit.transportUnitId}" 
                                        ${param.transportUnitId == unit.transportUnitId ? 'selected' : ''}>
                                    ${unit.companyName}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="filter-group">
                        <label>&nbsp;</label>
                        <button type="submit" name="submit" value="filter" class="btn btn-primary">
                            🔍 Lọc dữ liệu
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <div class="div3">
            <!-- Thống kê tổng quan -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value" id="totalShipments">-</div>
                    <div class="stat-label">Tổng số lô hàng</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="totalRevenue">-</div>
                    <div class="stat-label">Tổng doanh thu (VNĐ)</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="onTimeRate">-</div>
                    <div class="stat-label">Tỷ lệ đúng hạn (%)</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="avgWeight">-</div>
                    <div class="stat-label">Trọng lượng TB (kg)</div>
                </div>
            </div>

            <!-- Grid biểu đồ -->
            <div class="charts-grid">
                <!-- 1. Biểu đồ Doanh thu Thực tế vs Kế hoạch -->
                <div class="chart-container">
                    <h3 class="chart-title">📈 Doanh thu Thực tế vs Kế hoạch</h3>
                    <div class="chart-wrapper">
                        <canvas id="revenueChart"></canvas>
                    </div>
                </div>

                <!-- 2. Biểu đồ Tỷ lệ Giao hàng Đúng hạn -->
                <div class="chart-container">
                    <h3 class="chart-title">⏰ Tỷ lệ Giao hàng Đúng hạn</h3>
                    <div class="chart-wrapper">
                        <canvas id="onTimeChart"></canvas>
                    </div>
                </div>

                <!-- 3. Biểu đồ Tỷ lệ Hủy và Trì hoãn -->
                <div class="chart-container">
                    <h3 class="chart-title">⚠️ Phân tích Hủy bỏ và Trì hoãn</h3>
                    <div class="chart-wrapper">
                        <canvas id="cancelDelayChart"></canvas>
                    </div>
                </div>

                <!-- 4. Biểu đồ Hiệu suất Theo Đơn vị -->
                <div class="chart-container">
                    <h3 class="chart-title">🏆 Hiệu suất Theo Đơn vị Vận tải</h3>
                    <div class="chart-wrapper">
                        <canvas id="performanceChart"></canvas>
                    </div>
                </div>
            </div>
            <div class="butt">
                <a href="http://localhost:9999/HouseMovingSystem/PerformanceTransportReport">
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
                                d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z"
                                fill="currentColor"
                                ></path>
                            </svg>
                        </div>
                    </button>
                </a> 
            </div>
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
                Tạo thông báo
            </button>
        </div>

        <script>
            // Dữ liệu từ server (JSP) với kiểm tra null/undefined
            const transportReports = [
            <c:if test="${not empty transportReportsData}">
                <c:forEach var="report" items="${transportReportsData}" varStatus="status">
            {
            reportId: ${report.reportId != null ? report.reportId : 0},
                    transportUnitId: ${report.transportUnitId != null ? report.transportUnitId : 0},
                    reportYear: ${report.reportYear != null ? report.reportYear : 2025},
                    reportMonth: ${report.reportMonth != null ? report.reportMonth : 1},
                    totalShipments: ${report.totalShipments != null ? report.totalShipments : 0},
                    totalRevenue: ${report.totalRevenue != null ? report.totalRevenue : 0},
                    plannedRevenue: ${report.plannedRevenue != null ? report.plannedRevenue : 0},
                    totalWeight: ${report.totalWeight != null ? report.totalWeight : 0},
                    onTimeCount: ${report.onTimeCount != null ? report.onTimeCount : 0},
                    cancelCount: ${report.cancelCount != null ? report.cancelCount : 0},
                    delayCount: ${report.delayCount != null ? report.delayCount : 0},
                    createdAt: "${report.createdAt != null ? report.createdAt : ''}"
            }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            </c:if>
            ];
            const transportUnits = [
            <c:if test="${not empty transportUnitData}">
                <c:forEach var="unit" items="${transportUnitData}" varStatus="status">
            {
            transportUnitId: ${unit.transportUnitId != null ? unit.transportUnitId : 0},
                    companyName: "${unit.companyName != null ? unit.companyName : 'N/A'}",
                    location: "${unit.location != null ? unit.location : 'N/A'}"
            }<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            </c:if>
            ];
            // Debug: In ra console để kiểm tra dữ liệu
            console.log('Transport Reports:', transportReports);
            console.log('Transport Units:', transportUnits);
            // Hàm lấy dữ liệu 6 tháng gần đây (cải thiện)
            function getRecentMonthsData() {
            const now = new Date();
            const recentData = [];
            // Tạo danh sách 6 tháng gần đây
            for (let i = 5; i >= 0; i--) {
            const date = new Date(now.getFullYear(), now.getMonth() - i, 1);
            const year = date.getFullYear();
            const month = date.getMonth() + 1;
            const monthData = transportReports.filter(report =>
                    report.reportYear === year && report.reportMonth === month
                    );
            recentData.push({
            year,
                    month,
                    label: `\${month}/\${year}`,
                                data: monthData
                        });
                        }

                        console.log('Recent months data:', recentData);
                        return recentData;
                        }

                        // Cập nhật thống kê tổng quan
                        function updateStatistics() {
                        const totalShipments = transportReports.reduce((sum, report) => sum + report.totalShipments, 0);
                        const totalRevenue = transportReports.reduce((sum, report) => sum + report.totalRevenue, 0);
                        const totalOnTime = transportReports.reduce((sum, report) => sum + report.onTimeCount, 0);
                        const totalWeight = transportReports.reduce((sum, report) => sum + report.totalWeight, 0);
                        const onTimeRate = totalShipments > 0 ? ((totalOnTime / totalShipments) * 100).toFixed(1) : 0;
                        const avgWeight = transportReports.length > 0 ? (totalWeight / transportReports.length).toFixed(1) : 0;
                        document.getElementById('totalShipments').textContent = totalShipments.toLocaleString();
                        document.getElementById('totalRevenue').textContent = (totalRevenue / 1000000).toFixed(1) + 'M';
                        document.getElementById('onTimeRate').textContent = onTimeRate;
                        document.getElementById('avgWeight').textContent = avgWeight;
                        }

                        // 1. Biểu đồ Doanh thu Thực tế vs Kế hoạch
                        function createRevenueChart() {
                        const ctx = document.getElementById('revenueChart').getContext('2d');
                        const monthsData = getRecentMonthsData();
                        const actualRevenue = monthsData.map(month => {
                        return month.data.reduce((sum, report) => sum + report.totalRevenue, 0);
                        });
                        const plannedRevenue = monthsData.map(month => {
                        return month.data.reduce((sum, report) => sum + report.plannedRevenue, 0);
                        });
                        new Chart(ctx, {
                        type: 'line',
                                data: {
                                labels: monthsData.map(m => m.label),
                                        datasets: [{
                                        label: 'Doanh thu thực tế',
                                                data: actualRevenue,
                                                borderColor: '#667eea',
                                                backgroundColor: 'rgba(102, 126, 234, 0.1)',
                                                borderWidth: 3,
                                                fill: true,
                                                tension: 0.4
                                        }, {
                                        label: 'Doanh thu kế hoạch',
                                                data: plannedRevenue,
                                                borderColor: '#764ba2',
                                                backgroundColor: 'rgba(118, 75, 162, 0.1)',
                                                borderWidth: 3,
                                                fill: true,
                                                tension: 0.4,
                                                borderDash: [5, 5]
                                        }]
                                },
                                options: {
                                responsive: true,
                                        maintainAspectRatio: false,
                                        plugins: {
                                        legend: {
                                        position: 'top',
                                                labels: {
                                                usePointStyle: true,
                                                        padding: 20
                                                }
                                        },
                                                tooltip: {
                                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                                        titleColor: 'white',
                                                        bodyColor: 'white',
                                                        callbacks: {
                                                        label: function(context) {
                                                        return context.dataset.label + ': ' +
                                                                (context.parsed.y / 1000000).toFixed(1) + 'M VNĐ';
                                                        }
                                                        }
                                                }
                                        },
                                        scales: {
                                        y: {
                                        beginAtZero: true,
                                                ticks: {
                                                callback: function(value) {
                                                return (value / 1000000).toFixed(0) + 'M';
                                                }
                                                },
                                                grid: {
                                                color: 'rgba(0, 0, 0, 0.1)'
                                                }
                                        },
                                                x: {
                                                grid: {
                                                color: 'rgba(0, 0, 0, 0.1)'
                                                }
                                                }
                                        }
                                }
                        });
                        }

                        // 2. Biểu đồ Tỷ lệ Giao hàng Đúng hạn
                        function createOnTimeChart() {
                        const ctx = document.getElementById('onTimeChart').getContext('2d');
                        const totalShipments = transportReports.reduce((sum, report) => sum + report.totalShipments, 0);
                        const totalOnTime = transportReports.reduce((sum, report) => sum + report.onTimeCount, 0);
                        const totalDelay = transportReports.reduce((sum, report) => sum + report.delayCount, 0);
                        const totalCancel = transportReports.reduce((sum, report) => sum + report.cancelCount, 0);
                        new Chart(ctx, {
                        type: 'doughnut',
                                data: {
                                labels: ['Đúng hạn', 'Trì hoãn', 'Hủy bỏ'],
                                        datasets: [{
                                        data: [totalOnTime, totalDelay, totalCancel],
                                                backgroundColor: [
                                                        '#28a745',
                                                        '#ffc107',
                                                        '#dc3545'
                                                ],
                                                borderWidth: 0,
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
                                                        const percentage = totalShipments > 0 ?
                                                                ((context.parsed / totalShipments) * 100).toFixed(1) : 0;
                                                        return context.label + ': ' + context.parsed +
                                                                ' (' + percentage + '%)';
                                                        }
                                                        }
                                                }
                                        }
                                }
                        });
                        }

                        // 3. Biểu đồ Tỷ lệ Hủy và Trì hoãn
                        function createCancelDelayChart() {
                        const ctx = document.getElementById('cancelDelayChart').getContext('2d');
                        const monthsData = getRecentMonthsData();
                        const cancelData = monthsData.map(month => {
                        return month.data.reduce((sum, report) => sum + report.cancelCount, 0);
                        });
                        const delayData = monthsData.map(month => {
                        return month.data.reduce((sum, report) => sum + report.delayCount, 0);
                        });
                        new Chart(ctx, {
                        type: 'bar',
                                data: {
                                labels: monthsData.map(m => m.label),
                                        datasets: [{
                                        label: 'Hủy bỏ',
                                                data: cancelData,
                                                backgroundColor: '#dc3545',
                                                borderRadius: 5
                                        }, {
                                        label: 'Trì hoãn',
                                                data: delayData,
                                                backgroundColor: '#ffc107',
                                                borderRadius: 5
                                        }]
                                },
                                options: {
                                responsive: true,
                                        maintainAspectRatio: false,
                                        scales: {
                                        x: {
                                        stacked: true,
                                                grid: {
                                                color: 'rgba(0, 0, 0, 0.1)'
                                                }
                                        },
                                                y: {
                                                stacked: true,
                                                        beginAtZero: true,
                                                        grid: {
                                                        color: 'rgba(0, 0, 0, 0.1)'
                                                        }
                                                }
                                        },
                                        plugins: {
                                        legend: {
                                        position: 'top',
                                                labels: {
                                                usePointStyle: true,
                                                        padding: 20
                                                }
                                        },
                                                tooltip: {
                                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                                        titleColor: 'white',
                                                        bodyColor: 'white'
                                                }
                                        }
                                }
                        });
                        }

                        // 4. Biểu đồ Hiệu suất Theo Đơn vị
                        function createPerformanceChart() {
                        const ctx = document.getElementById('performanceChart').getContext('2d');
                        // Tổng hợp dữ liệu theo đơn vị vận tải
                        const unitPerformance = {};
                        transportReports.forEach(report => {
                        const unitId = report.transportUnitId;
                        if (!unitPerformance[unitId]) {
                        const unit = transportUnits.find(u => u.transportUnitId === unitId);
                        unitPerformance[unitId] = {
                        name: unit ? unit.companyName : `Đơn vị ${unitId}`,
                                totalShipments: 0,
                                totalRevenue: 0,
                                onTimeCount: 0
                        };
                        }

                        unitPerformance[unitId].totalShipments += report.totalShipments;
                        unitPerformance[unitId].totalRevenue += report.totalRevenue;
                        unitPerformance[unitId].onTimeCount += report.onTimeCount;
                        });
                        const units = Object.values(unitPerformance);
                        const unitNames = units.map(u => u.name.length > 15 ? u.name.substring(0, 15) + '...' : u.name);
                        const revenues = units.map(u => u.totalRevenue);
                        const shipments = units.map(u => u.totalShipments);
                        new Chart(ctx, {
                        type: 'bar',
                                data: {
                                labels: unitNames,
                                        datasets: [{
                                        label: 'Doanh thu (triệu VNĐ)',
                                                data: revenues.map(r => r / 1000000),
                                                backgroundColor: '#667eea',
                                                borderRadius: 5,
                                                yAxisID: 'y'
                                        }, {
                                        label: 'Số lô hàng',
                                                data: shipments,
                                                backgroundColor: '#764ba2',
                                                borderRadius: 5,
                                                yAxisID: 'y1'
                                        }]
                                },
                                options: {
                                responsive: true,
                                        maintainAspectRatio: false,
                                        plugins: {
                                        legend: {
                                        position: 'top',
                                                labels: {
                                                usePointStyle: true,
                                                        padding: 20
                                                }
                                        },
                                                tooltip: {
                                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                                        titleColor: 'white',
                                                        bodyColor: 'white',
                                                        callbacks: {
                                                        label: function(context) {
                                                        if (context.datasetIndex === 0) {
                                                        return 'Doanh thu: ' + context.parsed.y.toFixed(1) + 'M VNĐ';
                                                        } else {
                                                        return 'Số lô hàng: ' + context.parsed.y;
                                                        }
                                                        }
                                                        }
                                                }
                                        },
                                        scales: {
                                        x: {
                                        grid: {
                                        color: 'rgba(0, 0, 0, 0.1)'
                                        }
                                        },
                                                y: {
                                                type: 'linear',
                                                        display: true,
                                                        position: 'left',
                                                        beginAtZero: true,
                                                        title: {
                                                        display: true,
                                                                text: 'Doanh thu (triệu VNĐ)'
                                                        },
                                                        grid: {
                                                        color: 'rgba(0, 0, 0, 0.1)'
                                                        }
                                                },
                                                y1: {
                                                type: 'linear',
                                                        display: true,
                                                        position: 'right',
                                                        beginAtZero: true,
                                                        title: {
                                                        display: true,
                                                                text: 'Số lô hàng'
                                                        },
                                                        grid: {
                                                        drawOnChartArea: false,
                                                        }
                                                }
                                        }
                                }
                        });
                        }

                        // Hàm đặt lại bộ lọc
                        function resetFilters() {
                        document.getElementById('transportUnitId').value = '';
                        document.getElementById('year').value = '';
                        document.getElementById('invRTitle').value = '';
                        window.location.href = 'transportReport';
                        }

                        // Khởi tạo biểu đồ khi trang load
                        document.addEventListener('DOMContentLoaded', function() {
                        console.log('DOM loaded, khởi tạo biểu đồ...');
                        // Kiểm tra Chart.js đã load chưa
                        if (typeof Chart === 'undefined') {
                        console.error('Chart.js chưa được load');
                        return;
                        }

                        // Cập nhật thống kê ngay lập tức
                        updateStatistics();
                        // Tạo các biểu đồ ngay lập tức
                        try {
                        createRevenueChart();
                        console.log('✓ Revenue chart created');
                        } catch (e) {
                        console.error('Lỗi tạo revenue chart:', e);
                        }

                        try {
                        createOnTimeChart();
                        console.log('✓ OnTime chart created');
                        } catch (e) {
                        console.error('Lỗi tạo ontime chart:', e);
                        }

                        try {
                        createCancelDelayChart();
                        console.log('✓ Cancel/Delay chart created');
                        } catch (e) {
                        console.error('Lỗi tạo cancel/delay chart:', e);
                        }

                        try {
                        createPerformanceChart();
                        console.log('✓ Performance chart created');
                        } catch (e) {
                        console.error('Lỗi tạo performance chart:', e);
                        }
                        });
                        // Thêm hiệu ứng hover cho các thẻ thống kê
                        document.querySelectorAll('.stat-card').forEach(card => {
                        card.addEventListener('mouseenter', function() {
                        this.style.transform = 'translateY(-3px) scale(1.02)';
                        });
                        card.addEventListener('mouseleave', function() {
                        this.style.transform = 'translateY(-3px)';
                        });
                        });
                        // Thêm hiệu ứng loading cho form submit
                        document.querySelector('form').addEventListener('submit', function() {
                        const btn = this.querySelector('.btn-primary');
                        btn.innerHTML = '<div class="spinner" style="width: 20px; height: 20px; margin-right: 10px;"></div>Đang tải...';
                        btn.disabled = true;
                        });
                        // Format số tiền
                        function formatCurrency(amount) {
                        if (amount >= 1000000000) {
                        return (amount / 1000000000).toFixed(1) + 'B';
                        } else if (amount >= 1000000) {
                        return (amount / 1000000).toFixed(1) + 'M';
                        } else if (amount >= 1000) {
                        return (amount / 1000).toFixed(1) + 'K';
                        }
                        return amount.toString();
                        }

                        // Xuất báo cáo
                        function exportReport() {
                        const reportData = {
                        totalReports: transportReports.length,
                                totalShipments: transportReports.reduce((sum, r) => sum + r.totalShipments, 0),
                                totalRevenue: transportReports.reduce((sum, r) => sum + r.totalRevenue, 0),
                                averageOnTimeRate: (transportReports.reduce((sum, r) => sum + (r.onTimeCount / r.totalShipments), 0) / transportReports.length * 100).toFixed(2)
                        };
                        console.log('Báo cáo hiệu suất vận tải:', reportData);
                        alert('Chức năng xuất báo cáo đang được phát triển');
                        }

                        // Thêm event listener cho phím tắt
                        document.addEventListener('keydown', function(e) {
                        if (e.ctrlKey && e.key === 'r') {
                        e.preventDefault();
                        resetFilters();
                        }
                        if (e.ctrlKey && e.key === 'e') {
                        e.preventDefault();
                        exportReport();
                        }
                        });
                        // Tooltip cho các biểu đồ
                        Chart.defaults.plugins.tooltip.backgroundColor = 'rgba(0, 0, 0, 0.8)';
                        Chart.defaults.plugins.tooltip.titleColor = 'white';
                        Chart.defaults.plugins.tooltip.bodyColor = 'white';
                        Chart.defaults.plugins.tooltip.borderColor = '#667eea';
                        Chart.defaults.plugins.tooltip.borderWidth = 1;
                        Chart.defaults.plugins.tooltip.cornerRadius = 8;
                        // Responsive handling
                        window.addEventListener('resize', function() {
                        Chart.helpers.each(Chart.instances, function(instance) {
                        instance.resize();
                        });
                        });
                        console.log('transportData =', transportData); // Xem toàn bộ mảng
                        console.table(transportData); // Hiển thị dạng bảng
                        // Giả sử bạn vừa tạo xong mảng labels:
                        console.log('🟢 Labels array:', labels); // Hiển thị chuỗi dài
                        console.table(labels); // Dạng bảng gọn mắt hơn

        </script>
    </body>
</html>