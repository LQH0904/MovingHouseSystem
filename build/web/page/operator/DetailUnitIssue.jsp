<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Đơn Vị: ${unitDetails.unitName}</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/UnitDetail.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <!-- Chart.js CDN -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.3/dist/chart.umd.min.js"></script>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp"/>
            </div>
            <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp"/>
            </div>
            <div class="div3">
                <div class="content-container">
                    <div class="page-header">
                        <div class="header-content">
                            <div class="header-text">
                                <h1 class="page-title">
                                    <i class="fas fa-info-circle"></i>
                                    Chi Tiết Đơn Vị: ${unitDetails.unitName}
                                </h1>
                                <p class="page-subtitle">Thông tin chi tiết và báo cáo phản ánh của đơn vị</p>
                            </div>
                            <div class="header-actions">
                                <a href="${pageContext.request.contextPath}/operator/alert-complaint" class="btn btn-outline"><i class="fas fa-arrow-left"></i> Quay lại</a>
                            </div>
                        </div>
                    </div>

                    <div class="unit-detail-content">
                        <!-- Unit Information Card -->
                        <div class="unit-info-card">
                            <h3><i class="fas fa-building"></i> Thông tin đơn vị</h3>
                            <ul>
                                <li><strong>Mã đơn vị:</strong> ${unitDetails.unitId}</li>
                                <li><strong>Tên đơn vị:</strong> ${unitDetails.unitName}</li>
                                <li><strong>Email:</strong> ${unitDetails.email}</li>
                                <li><strong>Loại đơn vị:</strong>
                                    <c:choose>
                                        <c:when test="${unitDetails.unitType == 'Transport'}">Vận chuyển</c:when>
                                        <c:when test="${unitDetails.unitType == 'Storage'}">Kho</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </li>
                                <li><strong>Số phản ánh:</strong> ${unitDetails.issueCount}</li>
                                <li><strong>Mức độ cảnh báo:</strong>
                                    <c:choose>
                                        <c:when test="${unitDetails.warningLevel == 'Normal'}">
                                            <span class="status-badge status-normal">Bình thường</span>
                                        </c:when>
                                        <c:when test="${unitDetails.warningLevel == 'Warning'}">
                                            <span class="status-badge status-warning">Cảnh Báo</span>
                                        </c:when>
                                        <c:when test="${unitDetails.warningLevel == 'Danger'}">
                                            <span class="status-badge status-danger">Nguy hiểm</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge neutral">Không xác định</span>
                                        </c:otherwise>
                                    </c:choose>
                                </li>
                            </ul>
                            <div class="action-buttons detail-actions">
                                <button type="button" class="btn btn-primary btn-mail" aria-label="Gửi mail cảnh báo" onclick="alert('Chức năng gửi mail chưa được triển khai cho đơn vị ${unitDetails.unitName} - ${unitDetails.email}')">
                                    <i class="fas fa-envelope"></i> Gửi Mail
                                </button>
                            </div>
                        </div>

                        <!-- Chart Card -->
                        <div class="chart-card">
                            <h3 id="chartTitle"><i class="fas fa-chart-bar"></i> Biểu đồ phản ánh</h3>
                            <div class="chart-filters">
                                <select id="yearSelect" class="form-select">
                                    <c:forEach begin="2015" end="2025" var="y">
                                        <option value="${y}" ${y == initialChartYear ? 'selected' : ''}>Năm ${y}</option>
                                    </c:forEach>
                                </select>
                                <select id="monthSelect" class="form-select">
                                    <option value="0" ${0 == initialChartMonth ? 'selected' : ''}>Không chọn</option>
                                    <c:forEach begin="1" end="12" var="m">
                                        <option value="${m}" ${m == initialChartMonth ? 'selected' : ''}>Tháng ${m}</option>
                                    </c:forEach>
                                </select>
                                <select id="weekSelect" class="form-select">
                                    <option value="0" ${0 == initialChartWeek ? 'selected' : ''}>Không chọn</option>
                                    <c:forEach begin="1" end="4" var="w">
                                        <option value="${w}" ${w == initialChartWeek ? 'selected' : ''}>Tuần ${w}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="chart-canvas-container">
                                <canvas id="complaintsChart"></canvas>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            let currentChart;
            const initialChartDataJson = '${chartDataJson}';
            const initialChartYear = ${initialChartYear};
            const initialChartMonth = ${initialChartMonth};
            const initialChartWeek = ${initialChartWeek};
            const unitId = ${unitDetails.unitId};

            const yearSelect = document.getElementById('yearSelect');
            const monthSelect = document.getElementById('monthSelect');
            const weekSelect = document.getElementById('weekSelect');
            const chartTitleElement = document.getElementById('chartTitle');

            // Function to infer the chart period based on dropdown selections
            function getInferredPeriod() {
                const monthValue = parseInt(monthSelect.value);
                const weekValue = parseInt(weekSelect.value);

                if (weekValue === 0 && monthValue === 0) {
                    return 'year';
                } else if (weekValue === 0 && monthValue !== 0) {
                    return 'month';
                } else { // weekValue !== 0
                    return 'week';
                }
            }

            function mapLabels(period, dataPoints) {
                const labels = [];
                const data = [];
                const dayNamesMap = {
                    1: 'CN', 2: 'T2', 3: 'T3', 4: 'T4', 5: 'T5', 6: 'T6', 7: 'T7'
                };
                const monthNames = ['Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8', 'Tháng 9', 'Tháng 10', 'Tháng 11', 'Tháng 12'];
                const weekNames = ['Tuần 1', 'Tuần 2', 'Tuần 3', 'Tuần 4', 'Tuần 5']; // Max 5 weeks in a month for display

                const dataMap = new Map();
                dataPoints.forEach(point => {
                    dataMap.set(parseInt(point.label), point.count);
                });

                if (period === 'week') {
                    const orderedWeekdays = [2, 3, 4, 5, 6, 7, 1]; // Monday to Sunday
                    orderedWeekdays.forEach(dayKey => {
                        labels.push(dayNamesMap[dayKey]);
                        data.push(dataMap.get(dayKey) || 0);
                    });
                } else if (period === 'month') {
                    // For month period, labels are weeks within the month (1-5)
                    for (let i = 1; i <= 5; i++) {
                        labels.push(weekNames[i - 1]);
                        data.push(dataMap.get(i) || 0);
                    }
                } else if (period === 'year') {
                    // For year period, labels are months (1-12)
                    for (let i = 1; i <= 12; i++) {
                        labels.push(monthNames[i - 1]);
                        data.push(dataMap.get(i) || 0);
                    }
                }
                return { labels, data };
            }

            function updateChartTitle(period, year, month, week) {
                let title = '<i class="fas fa-chart-bar"></i> Biểu đồ phản ánh';
                if (period === 'week') {
                    title += ` (Tuần \${week} tháng \${month} năm \${year})`;
                } else if (period === 'month') {
                    title += ` (Tháng \${month} năm \${year})`;
                } else if (period === 'year') {
                    title += ` (Năm \${year})`;
                }
                chartTitleElement.innerHTML = title;
            }

            function renderChart(period, chartData, year, month, week) {
                if (currentChart) {
                    currentChart.destroy();
                }

                const { labels, data } = mapLabels(period, chartData);
                const ctx = document.getElementById('complaintsChart').getContext('2d');

                currentChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: labels,
                        datasets: [{
                            label: 'Số lượng phản ánh',
                            data: data,
                            backgroundColor: 'rgba(79, 70, 229, 0.7)',
                            borderColor: 'rgba(79, 70, 229, 1)',
                            borderWidth: 1,
                            borderRadius: 5
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: false },
                            tooltip: {
                                backgroundColor: 'rgba(0, 0, 0, 0.8)',
                                titleColor: '#fff', bodyColor: '#fff',
                                borderColor: 'rgba(255, 255, 255, 0.2)',
                                borderWidth: 1, displayColors: false, padding: 10
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true,
                                grid: { color: 'rgba(0, 0, 0, 0.05)' },
                                ticks: { color: 'var(--text-color-medium)' }
                            },
                            x: {
                                grid: { display: false },
                                ticks: { color: 'var(--text-color-medium)' }
                            }
                        }
                    }
                });
                updateChartTitle(period, year, month, week);
            }

            function fetchAndRenderChart(year, month, week) {
                const period = getInferredPeriod(); // Determine period based on current dropdown values
                let url = `${pageContext.request.contextPath}/operator/unit-detail/${unitId}?chartPeriodAjax=\${period}`;
                url += `&selectedYear=\${year}`;
                url += `&selectedMonth=\${month}`;
                url += `&selectedWeek=\${week}`;

                fetch(url)
                    .then(response => {
                        if (!response.ok) {
                            return response.text().then(text => {
                                console.error('Server response was not OK:', response.status, response.statusText, text);
                                throw new Error('Network response was not ok. Check console for details.');
                            });
                        }
                        return response.json();
                    })
                    .then(data => {
                        renderChart(period, data, year, month, week);
                    })
                    .catch(error => {
                        console.error('Error fetching chart data:', error);
                        alert('Không thể tải dữ liệu biểu đồ. Vui lòng kiểm tra console để biết chi tiết.');
                    });
            }

            // Khởi tạo khi tải trang
            document.addEventListener('DOMContentLoaded', () => {
                const parsedInitialData = JSON.parse(initialChartDataJson);
                // Use the initialChartPeriod passed from the controller for the first render
                renderChart('${initialChartPeriod}', parsedInitialData, initialChartYear, initialChartMonth, initialChartWeek);

                // Set initial values for dropdowns
                yearSelect.value = initialChartYear;
                monthSelect.value = initialChartMonth;
                weekSelect.value = initialChartWeek;
            });

            // Xử lý sự kiện thay đổi trên dropdowns
            yearSelect.addEventListener('change', () => {
                fetchAndRenderChart(parseInt(yearSelect.value), parseInt(monthSelect.value), parseInt(weekSelect.value));
            });

            monthSelect.addEventListener('change', () => {
                fetchAndRenderChart(parseInt(yearSelect.value), parseInt(monthSelect.value), parseInt(weekSelect.value));
            });

            weekSelect.addEventListener('change', () => {
                fetchAndRenderChart(parseInt(yearSelect.value), parseInt(monthSelect.value), parseInt(weekSelect.value));
            });
        </script>
    </body>
</html>
