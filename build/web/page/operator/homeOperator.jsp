<%-- 
    Document   : homeOperator
    Created on : Jun 3, 2025, 8:16:35 AM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/homeOperator.css">
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js"></script>
        <script src="js/Calander.js"></script>

    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include>
                </div>

                <div class="div3">
                    <div class="content-part">
                        <div class="user">
                            <div>
                                <div class="title_form_1">Về người dùng</div>
                            </div>
                            
                            <div class="user-char">
                                <div class="title-user">
                                    <div class="title1">Tổng quan người dung</div>
                                    <p class="title2">Tổng số lượng người dùng trong hệ thống, đại diện cho cộng đồng đa dạng các cá nhân đã đăng ký, bao gồm nhiều vai trò và 
                                        cấp độ truy cập khác nhau.</p>                              
                                </div>
                                <div class="char-use">
                                    <ul class="stats-list">
                                    <c:forEach var="role" items="${usersByRole}" varStatus="status">
                                        <li class="stats-item">
                                            <span class="stats-label">${role.key}</span>
                                            <div class="stats-bar">
                                                <div class="stats-progress
                                                     <c:choose>
                                                         <c:when test="${status.index % 10 == 0}">progress-purple</c:when>
                                                         <c:when test="${status.index % 10 == 1}">progress-yellow</c:when>
                                                         <c:when test="${status.index % 10 == 2}">progress-red</c:when>
                                                         <c:when test="${status.index % 10 == 3}">progress-blue</c:when>
                                                         <c:when test="${status.index % 10 == 4}">progress-4</c:when>
                                                         <c:when test="${status.index % 10 == 5}">progress-5</c:when>
                                                         <c:when test="${status.index % 10 == 6}">progress-6</c:when>
                                                         <c:when test="${status.index % 10 == 7}">progress-7</c:when>
                                                         <c:when test="${status.index % 10 == 8}">progress-8</c:when>
                                                         <c:otherwise>progress-indigo</c:otherwise>
                                                     </c:choose>" 
                                                     style="width: ${(role.value * 100.0 / totalUsers)}%">
                                                </div>
                                            </div>
                                            <span class="stats-value">${role.value}</span>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                        </div>
                        <div class="char-doughnut">
                            <div class="chart-wrapper">
                                <canvas id="doughnutChart"></canvas>
                                <div class="center-text">
                                    <h2>100%</h2>
                                </div>
                            </div>

                            <div class="legend" id="legend"></div>
                        </div>
                    </div>

                    <div class="title_form_1">
                        Các vấn đề
                    </div>
                    <div class="title3">
                        <div class="intro-text">
                            Các vấn đề được phân loại theo trạng thái xử lý:
                        </div>

                        <span class="status-highlight status-open">"open" (mở)</span>,
                        <span class="status-highlight status-progress">"in progress" (đang xử lý)</span>,
                        <span class="status-highlight status-resolved">"resolved" (đã giải quyết)</span>, và
                        <span class="status-highlight status-escalated">"escalated" (leo thang)</span>.

                        <div class="description-text">
                            Đây là cách trực quan giúp theo dõi tiến độ và quản lý hiệu quả các vấn đề trong hệ thống.
                        </div>
                    </div>
                    <div id="chartTreeMap"></div>
                </div>
                 
                <dix class="content-table">
                    <!-- Lịch bên phải trong div3 -->
                    <div class="calendar-widget">
                        <div class="calendar-header">
                            <div class="current-time" id="currentTime"></div>
                            <div class="current-date" id="currentDate"></div>
                        </div>

                        <div class="calendar-nav">
                            <button class="nav-btn" id="prevMonth">‹</button>
                            <div class="month-year" id="monthYear"></div>
                            <button class="nav-btn" id="nextMonth">›</button>
                        </div>

                        <div class="calendar-grid" id="calendarGrid"></div>

                        <div class="time-zones">
                            <div class="timezone-card">
                                <div class="timezone-name">Hà Nội</div>
                                <div class="timezone-time" id="vietnamTime"></div>
                            </div>
                            <div class="timezone-card">
                                <div class="timezone-name">Tokyo</div>
                                <div class="timezone-time" id="tokyoTime"></div>
                            </div>
                        </div>
                    </div>
                    
                    <img src="img/Lukasz Buda.gif" alt="test ảnh" style="width: 375px; padding: 10px; margin: 15px 0; border-radius: 22px;">
                    
                    <div class="table-issue" style="width: 100%">
                        <table border="1">
                            <thead>
                                <tr>
                                    <th>người gửi vấn đề</th>
                                    <th>trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="user" items="${topUsers}" varStatus="status">
                                <tr>
                                    <td>${user.key}</td>
                                    <td>${user.value}</td>
                                </tr>
                                </c:forEach>
                                <tr>
                                    <td>...</td>
                                    <td>...</td>
                                </tr>
                            </tbody>
                        </table>
                        <a href="http://localhost:9999/HouseMovingSystem/ComplaintServlet" style="padding: 7%;">Xem thêm</a>
                    </div>
                </dix>



                
            </div>
        </div>

        <script>//cho biểu đồ tròn

            // Tạo dữ liệu cho biểu đồ
            const userLabels = [
            <c:forEach var="role" items="${usersByRole}" varStatus="status">
            "${role.key}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            const userPercentages = [
            <c:forEach var="role" items="${usersByRole}" varStatus="status">
                ${(role.value * 100.0 / totalUsers)}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            const userCounts = [
            <c:forEach var="role" items="${usersByRole}" varStatus="status">
                ${role.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            // Dữ liệu cho biểu đồ
            const chartData = {
                labels: userLabels,
                datasets: [{
                        data: userPercentages,
                        backgroundColor: [
                            'rgba(255, 99, 132, 0.8)', // Đỏ
                            'rgba(54, 162, 235, 0.8)', // Xanh dương
                            'rgba(255, 206, 86, 0.8)', // Vàng
                            'rgba(75, 192, 192, 0.8)', // Xanh lá
                            'rgba(153, 102, 255, 0.8)', // Tím
                            'rgba(255, 159, 64, 0.8)', // Cam
                            'rgba(99, 255, 132, 0.8)', // Xanh lá nhạt
                            'rgba(255, 99, 255, 0.8)', // Hồng
                            'rgba(99, 199, 255, 0.8)', // Xanh da trời
                            'rgba(199, 99, 132, 0.8)'    // Đỏ đậm
                        ],
                        borderColor: '#fff',
                        borderWidth: 3,
                        hoverOffset: 8
                    }]
            };
            // Tạo biểu đồ
            const ctx1 = document.getElementById('doughnutChart').getContext('2d');
            const doughnutChart = new Chart(ctx1, {
                type: 'doughnut', // Sửa lỗi: 'doughnutChart' thành 'doughnut'
                data: chartData, // Sửa lỗi: thêm dấu ':'
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false // Ẩn legend mặc định
                        },
                        tooltip: {
                            backgroundColor: 'rgba(0, 0, 0, 0.8)',
                            titleColor: '#fff',
                            bodyColor: '#fff',
                            cornerRadius: 8,
                            displayColors: true,
                            callbacks: {
                                label: function (context) {
                                    return context.label + ': ' + context.parsed.toFixed(1) + '%';
                                }
                            }
                        }
                    },
                    cutout: '60%',
                    animation: {
                        animateRotate: true,
                        animateScale: true,
                        duration: 1500,
                        easing: 'easeOutBounce'
                    },
                    hover: {
                        animationDuration: 200
                    }
                }
            });
            // Tạo custom legend - PHẦN ĐÃ SỬA
            function createCustomLegend() {
                const legendContainer = document.getElementById('legend');
                console.log('legendContainer:', legendContainer);
                console.log('chartData.labels:', chartData.labels);
                console.log('userCounts:', userCounts);
                // Xóa legend cũ nếu có
                legendContainer.innerHTML = '';
                chartData.labels.forEach((label, index) => {
                    const percentage = chartData.datasets[0].data[index];
                    const count = userCounts[index];
                    const color = chartData.datasets[0].backgroundColor[index];
                    console.log(`Item ${index}:`, {label, percentage, count, color});
                    const legendItem = document.createElement('div');
                    legendItem.className = 'legend-item';
                    legendItem.style.borderLeftColor = color;
                    legendItem.innerHTML = `
                <div class="legend-color" style="background-color: \${color}"></div>
                <div class="legend-text">\${label}</div>
                <div class="legend-value">\${percentage.toFixed(1)}% (\${count})</div>
            `;
                    console.log('Creating legend with data:', {
                        labels: chartData.labels,
                        ata: chartData.datasets[0].data,
                        userCounts: userCounts
                    });
                    console.log(legendItem.innerHTML);
                    // Thêm hiệu ứng hover
                    legendItem.addEventListener('mouseenter', () => {
                        doughnutChart.setActiveElements([{datasetIndex: 0, index: index}]);
                        doughnutChart.update('none');
                    });
                    legendItem.addEventListener('mouseleave', () => {
                        doughnutChart.setActiveElements([]);
                        doughnutChart.update('none');
                    });
                    legendContainer.appendChild(legendItem);
                });
            }

            // Khởi tạo custom legend
            createCustomLegend();
            // Hiệu ứng xuất hiện - SỬA LẠI SELECTOR
            window.addEventListener('load', () => {
                const chartWrapper = document.querySelector('.char-doughnut'); // Sửa selector
                const legendItems = document.querySelectorAll('.legend-item');
                if (chartWrapper) {
                    // Ẩn chart wrapper ban đầu
                    chartWrapper.style.opacity = '0';
                    chartWrapper.style.transform = 'scale(0.3) rotate(-15deg)';
                    chartWrapper.style.filter = 'blur(10px)';
                    chartWrapper.style.transition = 'all 1.2s cubic-bezier(0.175, 0.885, 0.32, 1.275)';
                    // Hiện chart wrapper với hiệu ứng bounce
                    setTimeout(() => {
                        chartWrapper.style.opacity = '1';
                        chartWrapper.style.transform = 'scale(1) rotate(0deg)';
                        chartWrapper.style.filter = 'blur(0px)';
                        // Tạo hiệu ứng rung nhẹ
                        setTimeout(() => {
                            chartWrapper.style.animation = 'subtle-bounce 0.6s ease-out';
                        }, 800);
                    }, 200);
                }

                // Ẩn legend items ban đầu và hiện tuần tự
                legendItems.forEach((item, index) => {
                    item.style.opacity = '0';
                    item.style.transform = 'translateX(-50px) rotateY(90deg)';
                    item.style.transition = 'all 0.8s cubic-bezier(0.68, -0.55, 0.265, 1.55)';
                    setTimeout(() => {
                        item.style.opacity = '1';
                        item.style.transform = 'translateX(0) rotateY(0deg)';
                        // Thêm hiệu ứng nhấp nháy
                        setTimeout(() => {
                            item.style.animation = 'glow-pulse 0.5s ease-out';
                        }, 300);
                    }, 1000 + (index * 150));
                });
            });
            // Thêm CSS animations
            const style = document.createElement('style');
            style.textContent = `
        @keyframes subtle-bounce {
            0%, 100% { transform: scale(1) rotate(0deg); }
            25% { transform: scale(1.02) rotate(1deg); }
            50% { transform: scale(0.98) rotate(-0.5deg); }
            75% { transform: scale(1.01) rotate(0.5deg); }
        }
        
        @keyframes glow-pulse {
            0% { box-shadow: 0 0 5px rgba(102, 126, 234, 0.3); }
            50% { box-shadow: 0 0 20px rgba(102, 126, 234, 0.6), 0 0 30px rgba(102, 126, 234, 0.4); }
            100% { box-shadow: 0 0 5px rgba(102, 126, 234, 0.3); }
        }
        
        .legend-item:hover {
            transform: translateX(5px) scale(1.05);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .legend-item {
            transition: all 0.3s ease;
            cursor: pointer;
        }
    `;
            document.head.appendChild(style);
        </script>

        <script>//cho biểu đồ treemap
            //Hiển thị thống kê issue
            const issueStatusLabels = [
            <c:forEach var="stat" items="${issueStats}" varStatus="status">
            "${stat.key}"<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            const issueStatusValues = [
            <c:forEach var="stat" items="${issueStats}" varStatus="status">
                ${stat.value}<c:if test="${!status.last}">,</c:if>
            </c:forEach>
            ];
            const itemStyles = [
                {color: '#e9822ee8'}, // Cam - đang sử lí 
                {color: '#e9312ee8'}, // đỏ - Chuyển lên cấp cao 
                {color: '#2196f3'}, // Xanh dương - Mở 
                {color: '#4caf50'}, // Xanh lá - đã giải quyết
                {color: '#9c27b0'}, // Tím - Pending Review 
                {color: '#ff5722'}, // Đỏ cam - Urgent 
                {color: '#795548'}, // Nâu - Archived
                {color: '#607d8b'}, // Xanh xám - On Hold
                {color: '#e91e63'}, // Hồng - Rejected
                {color: '#00bcd4'}, // Cyan - In Progress
                {color: '#8bc34a'}, // Xanh nhạt - Approved
                {color: '#ffeb3b'}, // Vàng - Warning
                {color: '#9e9e9e'}, // Xám - Inactive
                {color: '#3f51b5'}, // Indigo - Priority
                {color: '#cddc39'}, // Lime - New
                {color: '#ff9800'}  // Cam đậm - Review
            ];

// Chuẩn bị dữ liệu cho ECharts Treemap
            function prepareTreemapData() {
                const data = [];
                const totalIssues = issueStatusValues.reduce((sum, value) => sum + value, 0);
                for (let i = 0; i < issueStatusLabels.length; i++) {
                    const value = issueStatusValues[i];
                    const percentage = totalIssues > 0 ? ((value / totalIssues) * 100).toFixed(1) : 0;
                    data.push({
                        name: issueStatusLabels[i],
                        value: value,
                        percentage: percentage,
                        itemStyle: itemStyles[i % itemStyles.length]
                    });
                }

                return data.sort((a, b) => b.value - a.value); // Sắp xếp theo giá trị giảm dần
            }

// Khởi tạo biểu đồ Treemap
            function initializeTreemap() {
                const chartTreeMap = document.getElementById('chartTreeMap');
                if (!chartTreeMap) {
                    console.error('Chart container not found');
                    return;
                }

                // Khởi tạo ECharts
                const myChart = echarts.init(chartTreeMap);
                const treemapData = prepareTreemapData();
                const option = {
                    tooltip: {
                        trigger: 'item',
                        backgroundColor: 'rgba(0, 0, 0, 0.8)',
                        borderColor: 'transparent',
                        textStyle: {
                            color: '#fff',
                            fontSize: 12
                        },
                        formatter: function (params) {
                            const data = params.data;
                            return `
                    <div style="padding: 8px;">
                        <div style="font-weight: bold; margin-bottom: 6px;">\${data.name}</div>
                        <div>Số lượng: <span style="color: #ffd700;">\${data.value}</span></div>
                        <div>Tỷ lệ: <span style="color: #87ceeb;">\${data.percentage}%</span></div>
                    </div>
                `;
                        }
                    },
                    series: [
                        {
                            name: 'Issues',
                            type: 'treemap',
                            width: '90%',
                            height: '75%',
                            left: 'center',
                            top: 80,
                            roam: false, // Tắt zoom và pan
                            nodeClick: false, // Tắt click vào node
                            sort: 'desc', // Sắp xếp theo giá trị giảm dần
                            squareRatio: 0.6, // Điều chỉnh tỷ lệ để tạo layout 2 cột
                            breadcrumb: {
                                show: false // Ẩn breadcrumb
                            },
                            label: {
                                show: true,
                                fontSize: 12,
                                fontWeight: 'bold',
                                color: '#fff',
                                formatter: function (params) {
                                    const data = params.data;
                                    if (data.value > 0) {
                                        return `Loại: \${data.name}\n\n Số lượng: \${data.value}\n\n Tỉ lệ: (\${data.percentage}%)`;
                                    }
                                    return '';
                                }
                            },
                            upperLabel: {
                                show: false
                            },
                            itemStyle: {
                                borderColor: '#fff',
                                borderWidth: 3,
                                borderRadius: 8,
                                shadowColor: 'rgba(0, 0, 0, 0.1)',
                                shadowBlur: 10,
                                shadowOffsetX: 2,
                                shadowOffsetY: 2,
                                gapWidth: 4             // Khoảng cách giữa các ô
                            },
                            emphasis: {
                                itemStyle: {
                                    borderColor: '#333',
                                    borderWidth: 3,
                                    shadowColor: 'rgba(0, 0, 0, 0.2)',
                                    shadowBlur: 15,
                                    shadowOffsetX: 3,
                                    shadowOffsetY: 3
                                },
                                label: {
                                    fontSize: 16,
                                    fontWeight: 'bold'
                                }
                            },
                            data: treemapData,
                            animationDuration: 2000,
                            animationEasing: 'cubicOut'
                        }
                    ]
                };
                // Thiết lập option và render biểu đồ
                myChart.setOption(option);
                // Responsive - tự động resize khi window thay đổi kích thước
                window.addEventListener('resize', function () {
                    myChart.resize();
                });
                // Thêm hiệu ứng hover cho từng ô
                myChart.on('mouseover', function (params) {
                    if (params.componentType === 'series') {
                        // Tạo hiệu ứng ripple khi hover
                        console.log('Hovering over:', params.data.name, 'Value:', params.data.value);
                    }
                });
                // Animation khi load
                setTimeout(() => {
                    chartTreeMap.style.opacity = '1';
                    chartTreeMap.style.transform = 'translateY(0)';
                }, 300);
            }

// Khởi tạo treemap khi DOM đã sẵn sàng
            document.addEventListener('DOMContentLoaded', function () {
                // Đảm bảo ECharts đã được load
                if (typeof echarts !== 'undefined') {
                    initializeTreemap();
                } else {
                    console.error('ECharts library not loaded');
                }
            });
// Thêm CSS cho container nếu chưa có
            const treemapStyle = document.createElement('style');
            treemapStyle.textContent = `
    #chartTreeMap {
        width: 100%;
        height: 500px;
        opacity: 0;
        transform: translateY(20px);
        transition: all 0.6s ease-out;
        border-radius: 15px;
    }
`;
            document.head.appendChild(treemapStyle);
        </script>
    </body>
</html>