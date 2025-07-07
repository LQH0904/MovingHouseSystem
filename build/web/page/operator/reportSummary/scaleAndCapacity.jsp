<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        <title>Báo cáo Quy mô & Năng lực Vận tải</title>
        <!-- Chart.js -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <link href="css/scaleChar.css" rel="stylesheet">
        <!-- gọn nhất -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

    </head>
    <body>
        <div class="header">
            <h1>📊 Báo cáo quy mô và năng lực vận tải</h1>
            <p>Phân tích chi tiết quy mô và năng lực vận tải của các đơn vị vận tải</p>
        </div>
        <div class="div3">
            <!-- Thống kê tổng quan -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value" id="vehicleCout">-</div>
                    <div class="stat-labe">Số lượng xe</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value" id="capacity">-</div>
                    <div class="stat-labe">Dung lượng vận tải (kg)</div>
                </div>
            </div>

            <!-- Grid biểu đồ -->
            <div class="charts-grid">
                <!-- 1. Biểu đồ Doanh thu Thực tế vs Kế hoạch -->
                <div class="chart-container">
                    <h3 class="chart-title">🚚 Số lượng Xe theo Đơn vị Vận tải</h3>
                    <div class="chart-wrapper">
                        <canvas id="vehicleCoutChar" width="600px" height="600px"></canvas>
                    </div>
                </div>

                <!-- 2. Biểu đồ Tỷ lệ Giao hàng Đúng hạn -->
                <div class="chart-container">
                    <h3 class="chart-title">📦 Dung lượng Vận tải</h3>
                    <div class="chart-wrapper">
                        <canvas id="capacityChar" width="600px" height="500px"></canvas>
                    </div>
                </div>

                <!-- 3. Biểu đồ Tỷ lệ Hủy và Trì hoãn -->
                <div class="chart-container">
                    <h3 class="chart-title">🗺️ Phân bố Địa lý của Đơn vị Vận tải</h3>
                    <div class="chart-wrapper">
                        <canvas id="locationChar"></canvas>
                    </div>
                </div>
            </div>
            <div class="butt">
                <a href="http://localhost:9999/HouseMovingSystem/ScaleAndCapacityReport">
                    <button class="cssbuttons-io-button">
                        chi tiết bảng
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
                tạo thông báo
            </button>
        </div>
        <script>
            // Dữ liệu từ ảnh: các đơn vị vận tải và số lượng xe
            const labels = [
            <c:forEach var="unit" items="${transportUnitData}">
                "${unit.companyName}",
            </c:forEach>
            ];
            // số xe
            const data = [
            <c:forEach var="unit" items="${transportUnitData}">
                ${unit.vehicleCount},
            </c:forEach>
            ];
            // vị trí
            const rawLocations = [
            <c:forEach var="unit" items="${transportUnitData}">
                "${unit.location}",
            </c:forEach>
            ];
            //dung lượng vận tải
            const capacity = [
            <c:forEach var="unit" items="${transportUnitData}">
                "${unit.capacity}",
            </c:forEach>
            ];
            // Tạo biểu đồ Polar Area Chart
            const ctx1 = document.getElementById('vehicleCoutChar').getContext('2d');
            const polarAreaChart = new Chart(ctx1, {
                type: 'polarArea',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Số lượng xe',
                            data: data,
                            backgroundColor: [
                                'rgba(255, 99, 132, 0.5)',
                                'rgba(54, 162, 235, 0.5)',
                                'rgba(255, 206, 86, 0.5)',
                                'rgba(75, 192, 192, 0.5)',
                                'rgba(153, 102, 255, 0.5)',
                                'rgba(255, 159, 64, 0.5)',
                                'rgba(99, 255, 132, 0.5)'
                            ],
                            borderWidth: 1
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
            // Màu sắc định sẵn
            const predefinedColors = [
                'rgba(255, 99, 132, 0.8)', // Đỏ
                'rgba(54, 162, 235, 0.8)', // Xanh dương  
                'rgba(255, 206, 86, 0.8)', // Vàng
                'rgba(75, 192, 192, 0.8)', // Xanh lục
                'rgba(153, 102, 255, 0.8)', // Tím
                'rgba(255, 159, 64, 0.8)' // Cam
            ];

            const predefinedBorders = [
                'rgba(255, 99, 132, 1)',
                'rgba(54, 162, 235, 1)',
                'rgba(255, 206, 86, 1)',
                'rgba(75, 192, 192, 1)',
                'rgba(153, 102, 255, 1)',
                'rgba(255, 159, 64, 1)'
            ];

            // Tạo màu cho từng label
            const bgColors = [];
            const borderColors = [];

            for (let i = 0; i < labels.length; i++) {
                bgColors.push(predefinedColors[i % predefinedColors.length]);
                borderColors.push(predefinedBorders[i % predefinedBorders.length]);
            }
            // tạo biểu đồ capacityChar
            const ctx2 = document.getElementById('capacityChar').getContext('2d');
            const capacityChar = new Chart(ctx2, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [{
                            label: 'Dung lượng vận tải',
                            data: capacity,
                            backgroundColor: bgColors,
                            borderColor: borderColors,
                            borderWidth: 2,
                            borderRadius: 5,
                            borderSkipped: false
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: false
                        }
                    }
                }
            });

            // ✅ Đếm số lượng đơn vị vận tải theo vị trí
            const locationMap = {};
            for (let i = 0; i < rawLocations.length; i++) {
                const location = rawLocations[i];

                // Đếm số lượng công ty (đơn vị vận tải) tại mỗi vị trí
                locationMap[location] = (locationMap[location] || 0) + 1;
            }

            // Chuyển đổi thành arrays cho biểu đồ
            const locationLabels = Object.keys(locationMap);
            const locationData = Object.values(locationMap);

            // Debug để kiểm tra
            console.log('Số lượng đơn vị vận tải theo vị trí:', locationMap);
            console.log('Labels:', locationLabels);
            console.log('Data:', locationData);

            // Màu sắc
            const doughnutColors = [
                '#FF6384', '#36A2EB', '#FFCE56', '#4BC0C0',
                '#9966FF', '#FF9F40', '#E74C3C', '#2ECC71',
                '#3498DB', '#F39C12', '#8E44AD', '#1ABC9C'
            ];

            const locationBgColors = locationLabels.map((_, i) =>
                doughnutColors[i % doughnutColors.length]
            );

            // Tạo biểu đồ Doughnut
            const ctx3 = document.getElementById('locationChar').getContext('2d');
            const locationDoughnutChart = new Chart(ctx3, {
                type: 'doughnut',
                data: {
                    labels: locationLabels,
                    datasets: [{
                            data: locationData,
                            backgroundColor: locationBgColors,
                            borderColor: '#ffffff',
                            borderWidth: 3,
                            hoverOffset: 6
                        }]
                },
                options: {
                    responsive: true,
                    plugins: {
                        legend: {
                            display: true,
                            position: 'bottom',
                            labels: {
                                padding: 15,
                                usePointStyle: true,
                                font: {
                                    size: 12
                                }
                            }
                        },
                        label: function (context) {
                            const value = context.dataset.data[context.dataIndex];
                            return value + ' đơn vị';
                        }
                    },
                    cutout: '55%',
                    animation: {
                        animateRotate: true,
                        duration: 1000
                    }
                }
            });
            // Tính tổng số lượng xe
            const totalVehicles = data.reduce((sum, count) => sum + count, 0);

            // Tính tổng dung lượng vận tải (chuyển string thành number)
            const totalCapacity = capacity.reduce((sum, cap) => sum + parseInt(cap || 0), 0);

            // Cập nhật vào HTML
            document.getElementById('vehicleCout').textContent = totalVehicles;
            document.getElementById('capacity').textContent = totalCapacity.toLocaleString();
        </script>
    </body>
</html>
