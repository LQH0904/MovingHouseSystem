<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Biểu đồ Khảo sát Khách hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/SurveyCustomerChar.css">

        <!-- Chart Libraries -->
        <script src="https://cdn.jsdelivr.net/npm/echarts@5.5.1/dist/echarts.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

        <style>
            .chart-container {
                background: white;
                border-radius: 10px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                padding: 20px;
                margin: 20px 0;
            }

            .chart-title {
                font-size: 18px;
                font-weight: bold;
                color: #333;
                margin-bottom: 15px;
                text-align: center;
                border-bottom: 2px solid #007bff;
                padding-bottom: 10px;
            }

            .chart-grid {
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                gap: 15px;
            }

            .gauge-container {
                height: 240px;
                position: relative;
            }

            .gauge-canvas {
                width: 100%;
                height: 100%;
            }

            .gauge-value {
                position: absolute;
                bottom: -15px;
                left: 50%;
                transform: translateX(-50%);
                font-size: 24px;
                font-weight: bold;
                color: #333;
            }

            .pie-chart, .radar-chart {
                height: 400px;
            }

            .controls {
                background: white;
                padding: 20px;
                border-radius: 10px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                margin-bottom: 20px;
            }

            .filter-row {
                display: flex;
                gap: 15px;
                align-items: center;
                flex-wrap: wrap;
            }

            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 5px;
            }

            .filter-group label {
                font-weight: bold;
                color: #555;
            }

            .filter-group input {
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            .btn {
                padding: 10px 20px;
                background: #007bff;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: bold;
            }

            .btn:hover {
                background: #0056b3;
            }

            .loading {
                text-align: center;
                padding: 50px;
                color: #666;
            }

            .div3 {
                padding: 20px;
                background: #f8f9fa;
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
                    <h1 style="text-align: center; color: #333; margin-bottom: 10px;">
                        📊 Biểu đồ Khảo sát Khách hàng
                    </h1>

                    <!-- Bộ lọc thời gian -->
                    <div class="controls">
                        <div class="filter-row">
                            <div class="filter-group">
                                <label>Từ tháng:</label>
                                <input type="month" id="fromMonth" style="color: black;"/>
                            </div>
                            <div class="filter-group">
                                <label>Đến tháng:</label>
                                <input type="month" id="toMonth" style="color: black;"/>
                            </div>
                            <button class="btn" onclick="loadChartData()">Lọc dữ liệu</button>
                            <button class="btn" onclick="resetFilter()">Đặt lại</button>
                        </div>
                    </div>

                    <!-- Loading -->
                    <div id="loading" class="loading">
                        <div>⏳ Đang tải dữ liệu...</div>
                    </div>

                    <!-- Gauge Charts Section -->
                    <div class="chart-container" style="display: none;" id="gaugeSection">
                        <h2 style="text-align: center; color: #007bff; margin-bottom: 10px;">
                            🎯 Biểu đồ Đánh giá
                        </h2>
                        <div class="chart-grid">
                            <!-- Mức độ hài lòng tổng thể -->
                            <div class="chart-container">
                                <div class="chart-title">Mức độ hài lòng tổng thể</div>
                                <div class="gauge-container">
                                    <canvas id="overallSatisfactionGauge" class="gauge-canvas"></canvas>
                                    <div class="gauge-value" id="overallSatisfactionValue">0.0</div>
                                </div>
                            </div>

                            <!-- Chăm sóc vận chuyển -->
                            <div class="chart-container">
                                <div class="chart-title">Chăm sóc vận chuyển</div>
                                <div class="gauge-container">
                                    <canvas id="transportCareGauge" class="gauge-canvas"></canvas>
                                    <div class="gauge-value" id="transportCareValue">0.0</div>
                                </div>
                            </div>

                            <!-- Tính chuyên nghiệp của tư vấn -->
                            <div class="chart-container">
                                <div class="chart-title">Tính chuyên nghiệp của tư vấn</div>
                                <div class="gauge-container">
                                    <canvas id="consultantProfessionalismGauge" class="gauge-canvas"></canvas>
                                    <div class="gauge-value" id="consultantProfessionalismValue">0.0</div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pie Charts Section -->
                    <div class="chart-container" style="display: none;" id="pieSection">
                        <h2 style="text-align: center; color: #28a745; margin-bottom: 10px;">
                            🥧 Biểu đồ Tròn
                        </h2>
                        <div class="chart-grid">
                            <!-- Tình trạng đồ đạc khi nhận -->
                            <div class="chart-container">
                                <div class="chart-title">Tình trạng đồ đạc khi nhận</div>
                                <div id="itemConditionPie" class="pie-chart"></div>
                            </div>

                            <!-- Tính đúng giờ của việc giao hàng -->
                            <div class="chart-container">
                                <div class="chart-title">Tính đúng giờ của việc giao hàng</div>
                                <div id="deliveryTimelinessPie" class="pie-chart"></div>
                            </div>

                            <!-- Quy trình đặt dịch vụ -->
                            <div class="chart-container">
                                <div class="chart-title">Quy trình đặt dịch vụ</div>
                                <div id="bookingProcessPie" class="pie-chart"></div>
                            </div>
                        </div>
                    </div>

                    <!-- Radar Charts Section -->
                    <div class="chart-container" style="display: none;" id="radarSection">
                        <h2 style="text-align: center; color: #dc3545; margin-bottom: 10px;">
                            📡 Biểu đồ Radar
                        </h2>
                        <div class="chart-grid">
                            <!-- Thời gian phản hồi -->
                            <div class="chart-container">
                                <div class="chart-title">Thời gian phản hồi</div>
                                <div class="radar-chart">
                                    <canvas id="responseTimeRadar"></canvas>
                                </div>
                            </div>

                            <!-- Yếu tố quan trọng nhất -->
                            <div class="chart-container">
                                <div class="chart-title">Yếu tố quan trọng nhất</div>
                                <div class="radar-chart">
                                    <canvas id="importantFactorRadar"></canvas>
                                </div>
                            </div>

                            <!-- Tần suất sử dụng dịch vụ -->
                            <div class="chart-container">
                                <div class="chart-title">Tần suất sử dụng dịch vụ</div>
                                <div class="radar-chart">
                                    <canvas id="usageFrequencyRadar"></canvas>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="butt">
                        <a href="http://localhost:9999/HouseMovingSystem/SurveyCharDetailController">
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
                </div>
            </div>

            <script>

                let chartData = null;
                let gaugeCharts = {};
                let pieCharts = {};
                let radarCharts = {};

                // Load dữ liệu khi trang được tải
                document.addEventListener('DOMContentLoaded', function () {
                    loadChartData();
                });

                // Hàm load dữ liệu từ server
                function loadChartData() {
                    showLoading(true);

                    const fromMonth = document.getElementById('fromMonth').value;
                    const toMonth = document.getElementById('toMonth').value;

                    let url = '${pageContext.request.contextPath}/SurveyCustomerCharController';
                    const params = new URLSearchParams();

                    if (fromMonth)
                        params.append('fromMonth', fromMonth);
                    if (toMonth)
                        params.append('toMonth', toMonth);

                    if (params.toString()) {
                        url += '?' + params.toString();
                    }

                    fetch(url)
                            .then(response => response.json())
                            .then(data => {
                                chartData = data;
                                if (data.success) {
                                    renderAllCharts();
                                } else {
                                    alert('Lỗi: ' + data.message);
                                }
                            })
                            .catch(error => {
                                console.error('Error:', error);
                                alert('Lỗi khi tải dữ liệu: ' + error.message);
                            })
                            .finally(() => {
                                showLoading(false);
                            });
                }

                // Hiển thị/ẩn loading
                function showLoading(show) {
                    const loadingEl = document.getElementById('loading');
                    const gaugeSectionEl = document.getElementById('gaugeSection');
                    const pieSectionEl = document.getElementById('pieSection');
                    const radarSectionEl = document.getElementById('radarSection');

                    if (show) {
                        loadingEl.style.display = 'block';
                        gaugeSectionEl.style.display = 'none';
                        pieSectionEl.style.display = 'none';
                        radarSectionEl.style.display = 'none';
                    } else {
                        loadingEl.style.display = 'none';
                        // Delay hiển thị để đảm bảo DOM ready
                        setTimeout(() => {
                            gaugeSectionEl.style.display = 'block';
                            pieSectionEl.style.display = 'block';
                            radarSectionEl.style.display = 'block';
                        }, 100);
                    }
                }

                // Render tất cả biểu đồ
                function renderAllCharts() {
                    if (!chartData || !chartData.success)
                        return;

                    // Render Gauge Charts trước
                    renderGaugeChart('overallSatisfactionGauge', 'overallSatisfactionValue',
                            chartData.overallSatisfaction, 'Mức độ hài lòng tổng thể');
                    renderGaugeChart('transportCareGauge', 'transportCareValue',
                            chartData.transportCare, 'Chăm sóc vận chuyển');
                    renderGaugeChart('consultantProfessionalismGauge', 'consultantProfessionalismValue',
                            chartData.consultantProfessionalism, 'Tính chuyên nghiệp');

                    // Delay render Pie Charts để đảm bảo DOM đã render xong
                    setTimeout(() => {
                        renderPieChart('itemConditionPie', chartData.itemCondition, 'Tình trạng đồ đạc');
                        renderPieChart('deliveryTimelinessPie', chartData.deliveryTimeliness, 'Tính đúng giờ giao hàng');
                        renderPieChart('bookingProcessPie', chartData.bookingProcess, 'Quy trình đặt dịch vụ');
                    }, 200);

                    // Delay render Radar Charts
                    setTimeout(() => {
                        renderRadarChart('responseTimeRadar', chartData.responseTime, 'Thời gian phản hồi');
                        renderRadarChart('importantFactorRadar', chartData.importantFactor, 'Yếu tố quan trọng');
                        renderRadarChart('usageFrequencyRadar', chartData.usageFrequency, 'Tần suất sử dụng');
                    }, 300);
                }


                // Render Gauge Chart (similar to the provided HTML)
                function renderGaugeChart(canvasId, valueId, data, title) {
                    if (!data || !data.average)
                        return;

                    const canvas = document.getElementById(canvasId);

                    const ctx = canvas.getContext('2d');
                    const valueDisplay = document.getElementById(valueId);

                    // Thiết lập biểu đồ
                    const centerX = canvas.width / 2;
                    const centerY = canvas.height - 30;
                    const radius = 80;
                    const startAngle = Math.PI;
                    const endAngle = 0;

                    // Màu sắc cho 5 phần (đỏ sang xanh)
                    const colors = ['#F44336', '#FF9800', '#FFEB3B', '#8BC34A', '#4CAF50'];

                    // Xóa canvas
                    ctx.clearRect(0, 0, canvas.width, canvas.height);

                    // Vẽ nền
                    const bgGradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, radius + 10);
                    bgGradient.addColorStop(0, '#ffffff');
                    bgGradient.addColorStop(1, '#f8f9fa');

                    ctx.beginPath();
                    ctx.arc(centerX, centerY, radius + 10, startAngle, endAngle);
                    ctx.fillStyle = bgGradient;
                    ctx.fill();

                    // Vẽ 5 phần của gauge
                    for (let i = 0; i < 5; i++) {
                        const sectionStartAngle = startAngle + (i * Math.PI / 5);
                        const sectionEndAngle = startAngle + ((i + 1) * Math.PI / 5);

                        ctx.beginPath();
                        ctx.moveTo(centerX, centerY);
                        ctx.arc(centerX, centerY, radius, sectionStartAngle, sectionEndAngle);
                        ctx.closePath();
                        ctx.fillStyle = colors[i];
                        ctx.fill();

                        ctx.strokeStyle = 'rgba(255, 255, 255, 0.3)';
                        ctx.lineWidth = 1;
                        ctx.stroke();
                    }

                    // Vẽ vòng tròn bên trong
                    const innerGradient = ctx.createRadialGradient(centerX, centerY, 0, centerX, centerY, 25);
                    innerGradient.addColorStop(0, '#ffffff');
                    innerGradient.addColorStop(1, '#f0f0f0');

                    ctx.beginPath();
                    ctx.arc(centerX, centerY, 25, 0, 2 * Math.PI);
                    ctx.fillStyle = innerGradient;
                    ctx.fill();
                    ctx.strokeStyle = '#ddd';
                    ctx.lineWidth = 2;
                    ctx.stroke();

                    // Vẽ kim chỉ
                    const angle = startAngle + ((data.average - 1) / 4) * Math.PI;
                    const needleLength = radius - 10;
                    const needleEndX = centerX + Math.cos(angle) * needleLength;
                    const needleEndY = centerY + Math.sin(angle) * needleLength;

                    // Kim chỉ hình mũi tên
                    const needleWidth = 4;
                    const needleBackLength = 15;

                    const perpAngle = angle + Math.PI / 2;
                    const perpX = Math.cos(perpAngle) * needleWidth;
                    const perpY = Math.sin(perpAngle) * needleWidth;

                    const backX = centerX - Math.cos(angle) * needleBackLength;
                    const backY = centerY - Math.sin(angle) * needleBackLength;

                    ctx.beginPath();
                    ctx.moveTo(needleEndX, needleEndY);
                    ctx.lineTo(centerX + perpX, centerY + perpY);
                    ctx.lineTo(backX, backY);
                    ctx.lineTo(centerX - perpX, centerY - perpY);
                    ctx.closePath();
                    ctx.fillStyle = '#2c3e50';
                    ctx.fill();
                    ctx.strokeStyle = '#1a252f';
                    ctx.lineWidth = 1;
                    ctx.stroke();

                    // Đầu kim
                    ctx.beginPath();
                    ctx.arc(centerX, centerY, 8, 0, 2 * Math.PI);
                    ctx.fillStyle = '#2c3e50';
                    ctx.fill();
                    ctx.strokeStyle = '#1a252f';
                    ctx.lineWidth = 1;
                    ctx.stroke();

                    // Hiển thị giá trị
                    valueDisplay.textContent = data.average.toFixed(1);
                }

                // Render Pie Chart với ECharts
                function renderPieChart(containerId, data, title) {
                    if (!data || !data.data)
                        return;

                    const container = document.getElementById(containerId);
                    if (!container)
                        return;

                    // Dispose chart cũ nếu có
                    if (pieCharts[containerId]) {
                        pieCharts[containerId].dispose();
                        delete pieCharts[containerId];
                    }

                    // Đảm bảo container có kích thước trước khi khởi tạo chart
                    if (container.offsetWidth === 0 || container.offsetHeight === 0) {
                        // Retry sau khi DOM render xong
                        setTimeout(() => renderPieChart(containerId, data, title), 100);
                        return;
                    }

                    const chart = echarts.init(container);
                    pieCharts[containerId] = chart;

                    const option = {
                        tooltip: {
                            trigger: 'item',
                            formatter: '{a} <br/>{b}: {c} ({d}%)'
                        },
                        legend: {
                            orient: 'vertical',
                            left: 'left',
                            top: '15px',
                            textStyle: {
                                fontSize: 12
                            }
                        },
                        series: [{
                                name: title,
                                type: 'pie',
                                radius: ['40%', '70%'],
                                center: ['60%', '50%'],
                                padAngle: 5,
                                itemStyle: {
                                    borderRadius: 10,
                                    borderColor: '#fff',
                                    borderWidth: 2
                                },
                                data: data.data,
                                emphasis: {
                                    itemStyle: {
                                        shadowBlur: 10,
                                        shadowOffsetX: 0,
                                        shadowColor: 'rgba(0, 0, 0, 0.5)'
                                    }
                                },
                                label: {
                                    show: false
                                },
                                labelLine: {
                                    show: false  // Ẩn đường kẻ từ chart đến label
                                }
                            }]
                    };

                    chart.setOption(option);

                    // Force resize sau khi set option
                    setTimeout(() => {
                        if (chart && !chart.isDisposed()) {
                            chart.resize();
                        }
                    }, 50);
                }


                // Render Radar Chart với Chart.js
                function renderRadarChart(canvasId, data, title) {
                    if (!data || !data.labels || !data.data)
                        return;

                    const ctx = document.getElementById(canvasId).getContext('2d');

                    if (radarCharts[canvasId]) {
                        radarCharts[canvasId].destroy();
                    }

                    const chart = new Chart(ctx, {
                        type: 'radar',
                        data: {
                            labels: data.labels,
                            datasets: [{
                                    label: title,
                                    data: data.data,
                                    borderColor: 'rgb(54, 162, 235)',
                                    backgroundColor: 'rgba(54, 162, 235, 0.2)',
                                    borderWidth: 2,
                                    pointBackgroundColor: 'rgb(54, 162, 235)',
                                    pointBorderColor: '#fff',
                                    pointHoverBackgroundColor: '#fff',
                                    pointHoverBorderColor: 'rgb(54, 162, 235)',
                                    fill: true
                                }]
                        },
                        options: {
                            responsive: true,
                            maintainAspectRatio: false,
                            plugins: {
                                title: {
                                    display: true,
                                    text: title,
                                    font: {
                                        size: 16,
                                        weight: 'bold'
                                    }
                                },
                                legend: {
                                    display: false
                                }
                            },
                            scales: {
                                r: {
                                    angleLines: {
                                        display: true,
                                        color: 'rgba(0, 0, 0, 0.1)'
                                    },
                                    grid: {
                                        color: 'rgba(0, 0, 0, 0.1)'
                                    },
                                    pointLabels: {
                                        font: {
                                            size: 12
                                        }
                                    },
                                    ticks: {
                                        display: true,
                                        stepSize: 1
                                    },
                                    beginAtZero: true
                                }
                            },
                            elements: {
                                line: {
                                    borderWidth: 3
                                }
                            }
                        }
                    });

                    radarCharts[canvasId] = chart;
                }

                // Reset bộ lọc
                function resetFilter() {
                    document.getElementById('fromMonth').value = '';
                    document.getElementById('toMonth').value = '';
                    loadChartData();
                }

                // Cleanup khi trang được unload
                window.addEventListener('beforeunload', function () {
                    // Cleanup ECharts
                    Object.values(pieCharts).forEach(chart => {
                        if (chart)
                            chart.dispose();
                    });

                    // Cleanup Chart.js
                    Object.values(radarCharts).forEach(chart => {
                        if (chart)
                            chart.destroy();
                    });
                });

                // Responsive handling
                window.addEventListener('resize', function () {
                    // Debounce resize events
                    clearTimeout(window.resizeTimeout);
                    window.resizeTimeout = setTimeout(() => {
                        // Resize ECharts
                        Object.values(pieCharts).forEach(chart => {
                            if (chart && !chart.isDisposed()) {
                                chart.resize();
                            }
                        });

                        // Chart.js tự động resize với responsive: true
                    }, 100);
                });

        </script>
    </body>
</html>