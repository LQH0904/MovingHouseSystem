<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
<html>
    <head>
        <meta charset="UTF-8">
        <title>Transport Process</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/TransportProcess.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        
        <!-- Leaflet CSS và JS cho bản đồ -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        
        <style>
            /* CSS cho bản đồ */
            .custom-div-icon {
                background: none;
                border: none;
            }

            .popup-content h6 {
                margin-bottom: 8px;
                color: #333;
            }

            .popup-content p {
                margin-bottom: 4px;
            }

            .map-info .info-item {
                padding: 8px;
                background-color: #f8f9fa;
                border-radius: 4px;
                margin-bottom: 8px;
            }

            .leaflet-popup-content-wrapper {
                border-radius: 8px;
            }

            .leaflet-popup-content {
                margin: 12px 16px;
            }

            .map-container {
                position: relative;
                margin-top: 15px;
            }

            #map {
                height: 400px; 
                width: 100%; 
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }

            .map-loading {
                display: flex;
                align-items: center;
                justify-content: center;
                height: 400px;
                background-color: #f8f9fa;
                border-radius: 8px;
                border: 1px solid #dee2e6;
            }

            /* Responsive cho mobile */
            @media (max-width: 768px) {
                #map {
                    height: 300px;
                }
                
                .map-info .col-md-6 {
                    margin-bottom: 10px;
                }
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <% if (currentUserRoleId == 2) { %>
            <div class="div1">
                <jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include>
            </div>
            <div class="div2">
                <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include>
            </div>
            <% } %>
            
            <% if (currentUserRoleId == 3) { %>
            <div class="div1">
                <jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
            </div>
            <div class="div2">
                <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
            </div>
            <% }%>
            
            <div class="div3">
                <div class="container">
                    <!-- Thông tin cơ bản của đơn hàng -->
                    <div class="card">
                        <h3><i class="bi bi-grid-1x2"></i>Thông tin lộ trình</h3>
                        <div class="info-row">
                            <div class="info-col">
                                <label><i class="bi bi-file-code-fill"></i>Mã Đơn hàng</label>
                                <p>${process.orderId}</p>
                            </div>
                            
                            <div class="info-col">
                                <label><i class="bi bi-box-seam-fill"></i>Điểm lấy hàng</label>
                                <p>${process.pickupLocation}</p>
                            </div>
                            
                            <div class="info-col">
                                <label><i class="bi bi-file-person"></i>Điểm trả hàng</label>
                                <p>${process.shippingLocation}</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Bản đồ -->
                    <div class="card">
                        <h3 class="mb-4 text-primary"><i class="bi bi-diagram-3-fill me-2"></i>Bản đồ</h3>
                        
                        <!-- Container cho bản đồ -->
                        <div class="map-container">
                            <div id="map-loading" class="map-loading">
                                <div class="text-center">
                                    <div class="spinner-border text-primary" role="status">
                                        <span class="visually-hidden">Đang tải bản đồ...</span>
                                    </div>
                                    <p class="mt-2 text-muted">Đang tải bản đồ...</p>
                                </div>
                            </div>
                            <div id="map" style="display: none;"></div>
                        </div>
                        
                        <!-- Thông tin tọa độ -->
                        <div class="map-info mt-3" id="map-info" style="display: none;">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <i class="bi bi-geo-alt-fill text-success"></i>
                                        <span class="ms-2">Điểm lấy hàng: <strong id="pickup-coords"></strong></span>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-item">
                                        <i class="bi bi-geo-alt-fill text-danger"></i>
                                        <span class="ms-2">Điểm giao hàng: <strong id="delivery-coords"></strong></span>
                                    </div>
                                </div>
                            </div>
                            <div class="row mt-2">
                                <div class="col-12">
                                    <div class="info-item text-center">
                                        <i class="bi bi-arrow-left-right text-primary"></i>
                                        <span class="ms-2">Khoảng cách ước tính: <strong id="distance-info">Đang tính toán...</strong></span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/staff/TransportProcess.js"></script>
        
        <script>
            // Khởi tạo bản đồ
            function initializeMap() {
                // Lấy dữ liệu từ server (từ JSP)
                const pickupLat = parseFloat('${process.pickupLat}') || null;
                const pickupLng = parseFloat('${process.pickupLng}') || null;
                const shippingLat = parseFloat('${process.shippingLat}') || null;
                const shippingLng = parseFloat('${process.shippingLng}') || null;
                
                // Ẩn loading và hiển thị thông báo lỗi nếu không có dữ liệu
                document.getElementById('map-loading').style.display = 'none';
                
                if (!pickupLat || !pickupLng || !shippingLat || !shippingLng) {
                    document.getElementById('map').style.display = 'block';
                    document.getElementById('map').innerHTML = 
                        '<div class="alert alert-warning text-center p-4">' +
                        '<i class="bi bi-exclamation-triangle-fill"></i> ' +
                        'Không có dữ liệu tọa độ để hiển thị bản đồ.<br>' +
                        '<small class="text-muted">Vui lòng kiểm tra dữ liệu pickup_lat, pickup_lng, shipping_lat, shipping_lng</small>' +
                        '</div>';
                    return;
                }
                
                // Hiển thị bản đồ và thông tin
                document.getElementById('map').style.display = 'block';
                document.getElementById('map-info').style.display = 'block';
                
                // Tính toán trung tâm bản đồ
                const centerLat = (pickupLat + shippingLat) / 2;
                const centerLng = (pickupLng + shippingLng) / 2;
                
                // Khởi tạo bản đồ Leaflet
                const map = L.map('map').setView([centerLat, centerLng], 12);
                
                // Thêm tile layer từ OpenStreetMap
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                    maxZoom: 19
                }).addTo(map);
                
                // Icon tùy chỉnh cho điểm lấy hàng
                const pickupIcon = L.divIcon({
                    html: '<i class="bi bi-geo-alt-fill" style="color: #28a745; font-size: 24px;"></i>',
                    iconSize: [24, 24],
                    iconAnchor: [12, 24],
                    popupAnchor: [0, -24],
                    className: 'custom-div-icon'
                });
                
                // Icon tùy chỉnh cho điểm giao hàng
                const deliveryIcon = L.divIcon({
                    html: '<i class="bi bi-geo-alt-fill" style="color: #dc3545; font-size: 24px;"></i>',
                    iconSize: [24, 24],
                    iconAnchor: [12, 24],
                    popupAnchor: [0, -24],
                    className: 'custom-div-icon'
                });
                
                // Thêm marker cho điểm lấy hàng
                const pickupMarker = L.marker([pickupLat, pickupLng], {icon: pickupIcon})
                    .addTo(map)
                    .bindPopup(`
                        <div class="popup-content">
                            <h6><i class="bi bi-box-seam-fill text-success"></i> Điểm lấy hàng</h6>
                            <p class="mb-1"><strong>${process.pickupLocation || 'Không xác định'}</strong></p>
                            <small class="text-muted">Tọa độ: ` + pickupLat.toFixed(6) + `, ` + pickupLng.toFixed(6) + `</small>
                        </div>
                    `);
                
                // Thêm marker cho điểm giao hàng
                const deliveryMarker = L.marker([shippingLat, shippingLng], {icon: deliveryIcon})
                    .addTo(map)
                    .bindPopup(`
                        <div class="popup-content">
                            <h6><i class="bi bi-geo-alt-fill text-danger"></i> Điểm giao hàng</h6>
                            <p class="mb-1"><strong>${process.shippingLocation || 'Không xác định'}</strong></p>
                            <small class="text-muted">Tọa độ: ` + shippingLat.toFixed(6) + `, ` + shippingLng.toFixed(6) + `</small>
                        </div>
                    `);
                
                // Vẽ đường thẳng giữa 2 điểm
                const routeLine = L.polyline([
                    [pickupLat, pickupLng],
                    [shippingLat, shippingLng]
                ], {
                    color: '#007bff',
                    weight: 3,
                    opacity: 0.7,
                    dashArray: '10, 5'
                }).addTo(map);
                
                // Fit bản đồ để hiển thị tất cả markers
                const group = new L.featureGroup([pickupMarker, deliveryMarker]);
                map.fitBounds(group.getBounds().pad(0.1));
                
                // Tính khoảng cách
                const distance = calculateDistance(pickupLat, pickupLng, shippingLat, shippingLng);
                
                // Cập nhật thông tin tọa độ và khoảng cách
                document.getElementById('pickup-coords').textContent = 
                    pickupLat.toFixed(4) + ', ' + pickupLng.toFixed(4);
                document.getElementById('delivery-coords').textContent = 
                    shippingLat.toFixed(4) + ', ' + shippingLng.toFixed(4);
                document.getElementById('distance-info').textContent = 
                    distance.toFixed(2) + ' km';
                
                // Thêm thông tin khoảng cách vào popup của đường
                routeLine.bindPopup(`
                    <div class="popup-content text-center">
                        <h6><i class="bi bi-arrow-left-right"></i> Thông tin lộ trình</h6>
                        <p class="mb-1">Khoảng cách (đường chim bay): <strong>` + distance.toFixed(2) + ` km</strong></p>
                        <small class="text-muted">Đây là khoảng cách ước tính</small>
                    </div>
                `);
            }

            // Hàm tính khoảng cách giữa 2 điểm (công thức Haversine)
            function calculateDistance(lat1, lon1, lat2, lon2) {
                const R = 6371; // Bán kính Trái Đất (km)
                const dLat = (lat2 - lat1) * Math.PI / 180;
                const dLon = (lon2 - lon1) * Math.PI / 180;
                const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                          Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
                          Math.sin(dLon/2) * Math.sin(dLon/2);
                const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
                return R * c;
            }

            // Khởi tạo bản đồ khi trang đã load
            document.addEventListener('DOMContentLoaded', function() {
                // Delay một chút để đảm bảo DOM đã render hoàn toàn
                setTimeout(function() {
                    initializeMap();
                }, 500);
            });
        </script>
    </body>
</html>