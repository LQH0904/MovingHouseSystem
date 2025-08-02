<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Users" %>
<%
// Session checking code (same as before)
String redirectURL = null;    
if (session.getAttribute("acc") == null) {        
    redirectURL = "/login";        
    response.sendRedirect(request.getContextPath() + redirectURL);        
    return;    
}

Users userAccount = (Users) session.getAttribute("acc");    
int currentUserId = userAccount.getUserId();
String currentUsername = userAccount.getUsername();
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
        
        <!-- Leaflet CSS và JS -->
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
        
        <style>
            .map-container {
                margin-top: 15px;
                position: relative;
            }

            #map {
                height: 500px;
                width: 100%;
                border: 1px solid #dee2e6;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .route-info {
                background-color: #f8f9fa;
                padding: 15px;
                border-radius: 8px;
                margin-top: 15px;
                border-left: 4px solid #007bff;
            }

            .route-step {
                padding: 8px 0;
                border-bottom: 1px solid #e9ecef;
            }

            .route-step:last-child {
                border-bottom: none;
            }

            .route-step i {
                width: 20px;
                text-align: center;
                margin-right: 8px;
            }

            .external-link {
                text-align: center;
                margin-top: 15px;
                padding: 10px;
                background-color: #e3f2fd;
                border-radius: 8px;
            }

            .external-link a {
                color: #1976d2;
                text-decoration: none;
                font-weight: 500;
            }

            .external-link a:hover {
                text-decoration: underline;
            }

            .custom-div-icon {
                background: none;
                border: none;
            }

            .popup-content h6 {
                margin-bottom: 8px;
                color: #333;
            }

            @media (max-width: 768px) {
                #map {
                    height: 400px;
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
                        <h3 class="mb-4 text-primary"><i class="bi bi-diagram-3-fill me-2"></i>Bản đồ lộ trình</h3>
                        
                        <div class="map-container">
                            <div id="map"></div>
                        </div>
                        
                        <!-- Thông tin lộ trình -->
                        <div class="route-info" id="route-info" style="display: none;">
                            <h6><i class="bi bi-route"></i> Thông tin lộ trình</h6>
                            <div id="route-summary"></div>
                            <div id="route-instructions"></div>
                        </div>
                        
                        <!-- Link mở OpenStreetMap -->
                        <div class="external-link">
                            <a href="${process.mapUrl}" target="_blank">
                                <i class="bi bi-box-arrow-up-right"></i> 
                                Xem chi tiết trên OpenStreetMap
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/staff/TransportProcess.js"></script>
        
        <script>
            let map;

            document.addEventListener('DOMContentLoaded', function() {
                initializeMap();
            });

            function initializeMap() {
                // Lấy dữ liệu từ JSP
                const pickupLat = parseFloat('${process.pickupLat}') || null;
                const pickupLng = parseFloat('${process.pickupLng}') || null;
                const shippingLat = parseFloat('${process.shippingLat}') || null;
                const shippingLng = parseFloat('${process.shippingLng}') || null;
                
                if (!pickupLat || !pickupLng || !shippingLat || !shippingLng) {
                    document.getElementById('map').innerHTML = 
                        '<div class="alert alert-warning text-center p-4">' +
                        '<i class="bi bi-exclamation-triangle-fill"></i> ' +
                        'Không có dữ liệu tọa độ để hiển thị bản đồ' +
                        '</div>';
                    return;
                }

                // Khởi tạo bản đồ
                const centerLat = (pickupLat + shippingLat) / 2;
                const centerLng = (pickupLng + shippingLng) / 2;
                
                map = L.map('map').setView([centerLat, centerLng], 12);
                
                // Thêm tile layer
                L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                    attribution: '© <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors',
                    maxZoom: 19
                }).addTo(map);
                
                // Tạo icons
                const pickupIcon = L.divIcon({
                    html: '<i class="bi bi-geo-alt-fill" style="color: #28a745; font-size: 24px;"></i>',
                    iconSize: [24, 24],
                    iconAnchor: [12, 24],
                    popupAnchor: [0, -24],
                    className: 'custom-div-icon'
                });
                
                const deliveryIcon = L.divIcon({
                    html: '<i class="bi bi-geo-alt-fill" style="color: #dc3545; font-size: 24px;"></i>',
                    iconSize: [24, 24],
                    iconAnchor: [12, 24],
                    popupAnchor: [0, -24],
                    className: 'custom-div-icon'
                });
                
                // Thêm markers
                const pickupMarker = L.marker([pickupLat, pickupLng], {icon: pickupIcon})
                    .addTo(map)
                    .bindPopup(`
                        <div class="popup-content">
                            <h6><i class="bi bi-box-seam-fill text-success"></i> Điểm lấy hàng</h6>
                            <p class="mb-1"><strong>${process.pickupLocation || 'Không xác định'}</strong></p>
                            <small class="text-muted">Tọa độ: ` + pickupLat.toFixed(6) + `, ` + pickupLng.toFixed(6) + `</small>
                        </div>
                    `);
                
                const deliveryMarker = L.marker([shippingLat, shippingLng], {icon: deliveryIcon})
                    .addTo(map)
                    .bindPopup(`
                        <div class="popup-content">
                            <h6><i class="bi bi-geo-alt-fill text-danger"></i> Điểm giao hàng</h6>
                            <p class="mb-1"><strong>${process.shippingLocation || 'Không xác định'}</strong></p>
                            <small class="text-muted">Tọa độ: ` + shippingLat.toFixed(6) + `, ` + shippingLng.toFixed(6) + `</small>
                        </div>
                    `);

                // Lấy lộ trình thực tế
                getRoute(pickupLat, pickupLng, shippingLat, shippingLng);
                
                // Fit bounds
                const group = new L.featureGroup([pickupMarker, deliveryMarker]);
                map.fitBounds(group.getBounds().pad(0.1));
            }

            async function getRoute(startLat, startLng, endLat, endLng) {
                try {
                    // Sử dụng OSRM API (miễn phí)
                    const url = `https://router.project-osrm.org/route/v1/driving/${startLng},${startLat};${endLng},${endLat}?overview=full&geometries=geojson&steps=true`;
                    
                    const response = await fetch(url);
                    const data = await response.json();
                    
                    if (data.routes && data.routes.length > 0) {
                        const route = data.routes[0];
                        const coordinates = route.geometry.coordinates.map(coord => [coord[1], coord[0]]);
                        
                        // Vẽ lộ trình
                        const routeLine = L.polyline(coordinates, {
                            color: '#007bff',
                            weight: 4,
                            opacity: 0.8
                        }).addTo(map);
                        
                        // Hiển thị thông tin lộ trình
                        displayRouteInfo(route);
                        
                        // Fit bounds cho lộ trình
                        map.fitBounds(routeLine.getBounds().pad(0.05));
                    }
                } catch (error) {
                    console.error('Không thể lấy lộ trình:', error);
                    // Fallback: vẽ đường thẳng
                    const routeLine = L.polyline([
                        [startLat, startLng],
                        [endLat, endLng]
                    ], {
                        color: '#007bff',
                        weight: 3,
                        opacity: 0.7,
                        dashArray: '10, 5'
                    }).addTo(map);
                }
            }

            function displayRouteInfo(route) {
                const distance = (route.distance / 1000).toFixed(2);
                const duration = Math.round(route.duration / 60);
                
                const summaryHtml = `
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <strong><i class="bi bi-arrow-left-right"></i> Khoảng cách:</strong> ${distance} km
                        </div>
                        <div class="col-md-6">
                            <strong><i class="bi bi-clock"></i> Thời gian:</strong> ${duration} phút
                        </div>
                    </div>
                `;
                
                document.getElementById('route-summary').innerHTML = summaryHtml;
                document.getElementById('route-info').style.display = 'block';
            }
        </script>
    </body>
</html>
