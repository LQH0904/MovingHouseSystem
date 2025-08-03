<%--
    Document   : transport
    Created on : Jul 29, 2025, 2:03:57 AM
    Author     : admin
--%>

<%@page import="model.Users"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.OrderDAO2" %>
<%@ page import="model.Service" %>
<%@ page import="model.SuggestedItem" %>
<%@ page import="model.OrderDetail" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.text.DecimalFormat" %>
<%!
    // Hàm định dạng tiền tệ VND, loại bỏ .00
    private String formatVND(BigDecimal amount) {
        DecimalFormat df = new DecimalFormat("#,###");
        return df.format(amount) + " VND";
    }

    // Hàm định dạng số thông thường (không phải tiền tệ)
    private String formatNumber(BigDecimal number) {
        DecimalFormat df = new DecimalFormat("#,###.##");
        return df.format(number);
    }

    // Hàm tính giá cho hàng hóa thủ công
    private BigDecimal calculateManualItemPrice(BigDecimal weightKg, BigDecimal volumeM3) {
        BigDecimal basePrice = new BigDecimal("2000");
        BigDecimal pricePerKg = new BigDecimal("8000");
        BigDecimal pricePerM3 = new BigDecimal("12000");
        return basePrice.add(weightKg.multiply(pricePerKg)).add(volumeM3.multiply(pricePerM3));
    }
%>
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
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <title>Đặt Hàng Vận Chuyển</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY=" crossorigin="" />
        <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js" integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo=" crossorigin=""></script>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js" integrity="sha256-/xUj+3OJU5yExlq6GSYGSHk7tPXikynS7ogEvDej/m4=" crossorigin=""></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/big.js/6.2.1/big.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;600;700&display=swap');
            body {
                background-color: #EDF2F7;
                font-family: 'Roboto', sans-serif;
                margin: 0;
                padding: 0;
                line-height: 1.6;
                display: flex;
            }
            .container {
                max-width: 1280px;
                margin: 0 auto;
                padding: 1.5rem;
                flex-grow: 1;
            }
            h2 {
                color: #6B46C1;
                font-weight: 700;
                text-align: center;
                text-transform: uppercase;
                letter-spacing: 1.2px;
                margin-bottom: 2rem;
                font-size: 1.75rem;
                display: flex;
                align-items: center;
                justify-content: center;
            }
            h2 i {
                margin-right: 0.75rem;
            }
            #map {
                height: 400px;
                width: 100%;
                border-radius: 10px;
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
                transition: box-shadow 0.3s ease;
            }
            .autocomplete-items {
                position: absolute;
                border: 1px solid #E2E8F0;
                border-top: none;
                z-index: 99;
                top: 100%;
                left: 0;
                right: 0;
                background-color: #fff;
                max-height: 200px;
                overflow-y: auto;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                border-radius: 0 0 10px 10px;
            }
            .autocomplete-items div {
                padding: 12px 16px;
                cursor: pointer;
                background-color: #fff;
                border-bottom: 1px solid #E2E8F0;
                transition: background-color 0.3s ease;
            }
            .autocomplete-items div:hover {
                background-color: #F7FAFC;
            }
            .filter-form .form-control {
                border: 2px solid #E2E8F0;
                border-radius: 10px;
                padding: 0.5rem; /* Reduced padding */
                font-size: 0.85rem; /* Reduced font size */
                width: 100%;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
                background-color: #F9FAFB;
            }
            .filter-form .form-control:focus {
                border-color: #6B46C1;
                box-shadow: 0 0 8px rgba(107, 70, 193, 0.2);
                outline: none;
            }
            .filter-form label {
                font-weight: 600;
                color: #2D3748;
                margin-bottom: 0.5rem;
                font-size: 0.85rem; /* Reduced font size */
            }
            .filter-form textarea.form-control {
                resize: vertical;
                min-height: 50px; /* Reduced height */
            }
            button, .btn-primary, .btn-secondary, .submit-btn {
                padding: 0.625rem 1.25rem; /* Reduced padding */
                border-radius: 10px;
                border: none;
                cursor: pointer;
                font-weight: 600;
                font-size: 0.85rem; /* Reduced font size */
                transition: transform 0.2s ease, box-shadow 0.3s ease;
            }
            .btn-primary {
                background: linear-gradient(90deg, #6B46C1 0%, #A78BFA 100%);
                color: white;
            }
            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(107, 70, 193, 0.3);
            }
            .btn-secondary {
                background: #718096;
                color: white;
            }
            .btn-secondary:hover {
                background: #4A5568;
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(113, 128, 150, 0.3);
            }
            .submit-btn {
                background: linear-gradient(90deg, #48BB78 0%, #81E6D9 100%);
                color: white;
            }
            .submit-btn:hover {
                transform: translateY(-2px);
                background: linear-gradient(90deg, #2F855A 0%, #4FD1C5 100%);
                box-shadow: 0 4px 12px rgba(72, 187, 120, 0.3);
            }
            .remove-item {
                background: #E53E3E;
                color: white;
                padding: 0.375rem 0.75rem; /* Reduced padding */
                border-radius: 6px;
                font-size: 0.8rem; /* Reduced font size */
            }
            .remove-item:hover {
                background: #C53030;
                transform: translateY(-2px);
            }
            .section {
                background-color: #fff;
                border-radius: 10px;
                padding: 1rem; /* Reduced padding */
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                margin-bottom: 1rem; /* Reduced margin */
            }
            .section-header {
                background: linear-gradient(90deg, #6B46C1 0%, #A78BFA 100%);
                color: white;
                padding: 0.5rem; /* Reduced padding */
                border-radius: 10px 10px 0 0;
                font-weight: 700;
                margin: -1rem -1rem 1rem -1rem; /* Reduced margin */
                text-transform: uppercase;
                letter-spacing: 0.5px;
                display: flex;
                justify-content: center;
                align-items: center;
                font-size: 0.9rem; /* Reduced font size */
            }
            .section-header.flex {
                justify-content: space-between;
            }
            .section-header i {
                font-size: 1rem; /* Adjusted for consistency */
            }
            .suggested-items-section {
                padding-right: 0.5rem; /* Reduced padding */
            }
            .manual-item-section {
                padding-left: 0.5rem; /* Reduced padding */
            }
            .table, .fee-table, #itemTable {
                width: 100%;
                border-collapse: collapse;
                background: #F9FAFB;
                border-radius: 8px;
                overflow: hidden;
            }
            .table thead th, .fee-table thead th, #itemTable thead th {
                background: #fff;
                color: #2D3748;
                font-weight: 600;
                padding: 8px; /* Reduced padding */
                text-align: center;
                text-transform: uppercase;
                font-size: 0.85rem; /* Reduced font size */
            }
            .table tbody td, .fee-table td, #itemTable tbody td {
                background: #fff;
                padding: 8px; /* Reduced padding */
                color: #2D3748;
                border-bottom: 1px solid #E2E8F0;
                text-align: center;
                font-size: 0.8rem; /* Reduced font size */
            }
            .table tbody tr:hover, #itemTable tbody tr:hover {
                background: #EDF2F7;
                transition: background 0.3s ease;
            }
            .fee-table td:first-child {
                font-weight: 600;
                color: #2D3748;
            }
            .error {
                color: #E53E3E;
                font-size: 0.8rem; /* Reduced font size */
                margin-top: 0.5rem;
                text-align: center;
            }
            .success {
                color: #48BB78;
                font-size: 0.8rem; /* Reduced font size */
                margin-top: 0.5rem;
                text-align: center;
            }
            .info-box {
                background: #FAF5FF;
                padding: 0.75rem; /* Reduced padding */
                border-radius: 8px;
                margin-top: 1rem; /* Reduced margin */
                text-align: center;
                color: #6B46C1;
                font-weight: 600;
                font-size: 0.85rem; /* Reduced font size */
            }
            .sidebar {
                width: 250px;
                background: linear-gradient(to bottom, #B794F4, #C9A7F4);
                color: white;
                height: 100vh;
                position: fixed;
                padding-top: 10px; /* Reduced padding */
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }
            .sidebar .sidebar-item {
                padding: 6px 12px; /* Reduced padding */
                font-size: 0.85rem; /* Reduced font size */
                color: #fff;
                text-decoration: none;
                display: flex;
                align-items: center;
            }
            .sidebar .sidebar-item:hover {
                background-color: rgba(255, 255, 255, 0.2);
            }
            .sidebar .sidebar-item.active {
                background-color: rgba(255, 255, 255, 0.3);
            }
            .main-content {
                margin-left: 250px;
                width: calc(100% - 250px);
            }
            .suggested-items {
                font-size: 0.85rem; /* Reduced font size */
                padding: 0.25rem; /* Reduced padding */
            }
            @media (max-width: 768px) {
                .grid-cols-2 {
                    grid-template-columns: 1fr;
                }
                .section {
                    margin-bottom: 1rem; /* Reduced margin */
                }
                .table thead th, .table tbody td, .fee-table td, #itemTable thead th, #itemTable tbody td {
                    font-size: 0.75rem; /* Reduced font size */
                    padding: 6px; /* Reduced padding */
                }
                .button-group {
                    flex-direction: column;
                    gap: 0.5rem;
                }
                button, .btn-primary, .btn-secondary, .submit-btn {
                    width: 100%;
                    padding: 0.5rem;
                    font-size: 0.8rem; /* Reduced font size */
                }
                #map {
                    height: 300px;
                }
                .section-header i {
                    font-size: 0.9rem;
                }
                .success, .error {
                    max-width: 100%;
                    margin: 0.75rem auto; /* Reduced margin */
                    padding: 0.5rem; /* Reduced padding */
                    border-radius: 6px; /* Reduced radius */
                    font-size: 0.8rem; /* Reduced font size */
                    font-weight: 500;
                    text-align: center;
                    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1); /* Reduced shadow */
                    transition: all 0.3s ease;
                }
                .success {
                    background-color: #e6ffed;
                    color: #207d3c;
                    border: 1px solid #a2f5c1;
                }
                .error {
                    background-color: #ffecec;
                    color: #c0392b;
                    border: 1px solid #f5a2a2;
                }
                .sidebar {
                    width: 200px;
                }
                .main-content {
                    margin-left: 200px;
                    width: calc(100% - 200px);
                }
            }
        </style>
    </head>
    <body class="bg-gray-100 h-screen overflow-y-auto">
        <div class="sidebar">
            <div class="sidebar-item">Customer</div>
            <a href="${pageContext.request.contextPath}/transport" class="sidebar-item">Dashboard</a>
            <a href="${pageContext.request.contextPath}/orderHistory" class="sidebar-item">Đơn hàng vận chuyển</a>
            <a href="${pageContext.request.contextPath}/logout" class="sidebar-item active">Đăng xuất</a>
        </div>
        <div class="main-content">
            <div class="container mx-auto px-4 py-4 max-w-7xl">
                <a href="${pageContext.request.contextPath}/notifications" title="Thông báo" aria-label="Xem thông báo">
                    <i class="fas fa-bell notification-icon" style="font-size: 40px;"></i> 
                </a>
                <h2 class="text-2xl font-bold text-gray-800 mb-4 flex items-center">
                    <i class="fas fa-shopping-cart mr-2"></i>Dịch Vụ Vận Chuyển
                </h2>
                <div class="success" id="successMessage">${successMessage}</div>
                <div class="error" id="errorMessage">${errorMessage}</div>
                <form id="transportForm" action="transport" method="post" class="filter-form grid grid-cols-2 gap-6 ">
                    <!-- Phần 1: Tuyến Đường và Địa Chỉ (Cột 1) -->
                    <div class="section col-span-1">
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-map-marker-alt mr-2"></i> Tuyến Đường & Địa Chỉ
                        </div>
                        <div class="grid grid-cols-2 gap-6">
                            <div class="col-span-1">
                                <div class="mb-6">
                                    <label id="pickup_address_label" class="block text-gray-700 font-semibold">Địa chỉ lấy hàng:</label>
                                    <input type="text" name="pickup_address" id="pickup_address" value="" required class="form-control mt-2 p-3 w-full border rounded-lg" placeholder="Nhập địa chỉ..." aria-labelledby="pickup_address_label">
                                    <input type="hidden" name="pickup_lat" id="pickup_lat">
                                    <input type="hidden" name="pickup_lng" id="pickup_lng">
                                    <div class="button-group mt-3">
                                        <button type="button" id="selectPickupOnMap" class="btn-primary">Chọn trên bản đồ</button>
                                    </div>
                                    <div id="pickup_autocomplete" class="autocomplete-items"></div>
                                </div>
                                <div class="mb-6">
                                    <label id="shipping_address_label" class="block text-gray-700 font-semibold">Địa chỉ giao hàng:</label>
                                    <input type="text" name="shipping_address" id="shipping_address" value="" required class="form-control mt-2 p-3 w-full border rounded-lg" placeholder="Nhập địa chỉ..." aria-labelledby="shipping_address_label">
                                    <input type="hidden" name="shipping_lat" id="shipping_lat">
                                    <input type="hidden" name="shipping_lng" id="shipping_lng">
                                    <div class="button-group mt-3">
                                        <button type="button" id="selectShippingOnMap" class="btn-primary">Chọn trên bản đồ</button>
                                    </div>
                                    <div id="shipping_autocomplete" class="autocomplete-items"></div>
                                </div>
                                <div class="mb-6">
                                    <label id="distance_km_label" class="block text-gray-700 font-semibold">Quãng đường dự tính (km):</label>
                                    <input type="text" name="distance_km" id="distance_km" value="${distanceKm != null ? distanceKm : 0}" readonly class="form-control mt-2 p-3 w-full border rounded-lg bg-gray-100" aria-labelledby="distance_km_label">
                                </div>
                            </div>
                            <div class="col-span-1 flex items-center">
                                <div id="map" class="w-full"></div>
                            </div>
                        </div>
                    </div>
                    <!-- Phần 2: Thông tin dịch vụ và Bảng tính tiền (Cột 2) -->
                    <div class="section col-span-1 space-y-6">
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-info-circle mr-2"></i> Thông tin dịch vụ
                        </div>
                        <div class="mb-6">
                            <label id="service_type_label" class="block text-gray-700 font-semibold">Loại dịch vụ:</label>
                            <select name="service_type" id="service_type" required class="form-control mt-2 p-3 w-full border rounded-lg" aria-labelledby="service_type_label">
                                <option value="">-- Chọn dịch vụ --</option>
                                <%
                                    OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
                                    List<Service> services = orderDAO.getAllServices();
                                    for (Service service : services) {
                                        String escapedName = service.getName().replace("\"", "&quot;").replace("'", "&apos;");
                                %>
                                <option value="<%= escapedName%>" data-price="<%= service.getBasePrice().setScale(2, BigDecimal.ROUND_HALF_UP)%>" data-rate="<%= service.getRatePerKm() != null ? service.getRatePerKm().setScale(2, BigDecimal.ROUND_HALF_UP) : 0%>">
                                    <%= service.getName()%> (Giá cơ bản: <%= formatVND(service.getBasePrice())%>, Giá/km: <%= formatVND(service.getRatePerKm())%>)
                                </option>
                                <%
                                    }
                                %>
                            </select>
                            <div id="serviceDetails" class="mt-3 p-3 bg-gray-100 rounded-lg">
                                <p>Giá cơ bản: <span id="serviceBasePrice">0</span></p>
                                <p>Phí theo km: <span id="serviceDistance">0</span> km x <span id="serviceRatePerKm">0</span> VND/km = <span id="serviceKmFee">0</span></p>
                                <p>Tổng phí dịch vụ: <span id="serviceTotalFee">0</span></p>
                            </div>
                        </div>
                        <div class="mb-6">
                            <label id="pickup_time_desired_label" class="block text-gray-700 font-semibold">Thời gian lấy hàng mong muốn:</label>
                            <input type="datetime-local" name="pickup_time_desired" step="1" required class="form-control mt-2 p-3 w-full border rounded-lg" aria-labelledby="pickup_time_desired_label">
                        </div>
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-info-circle mr-2"></i> Bảng tính tiền
                        </div>
                        <table class="fee-table w-full">
                            <tr><td class="p-3 font-semibold text-gray-700">Phí tháo dỡ và lắp đặt:</td><td class="p-3"><span id="transportFee"><%= formatVND(new BigDecimal(request.getAttribute("transportFee") != null ? request.getAttribute("transportFee").toString() : "0"))%></span></td></tr>
                            <tr><td class="p-3 font-semibold text-gray-700">Phí dịch vụ:</td><td class="p-3"><span id="serviceFee"><%= formatVND(new BigDecimal(request.getAttribute("serviceFee") != null ? request.getAttribute("serviceFee").toString() : "0"))%></span></td></tr>
                            <tr><td class="p-3 font-semibold text-gray-700">VAT (10%):</td><td class="p-3"><span id="vatAmount"><%= formatVND(new BigDecimal(request.getAttribute("vatAmount") != null ? request.getAttribute("vatAmount").toString() : "0"))%></span></td></tr>
                            <tr><td class="p-3 font-semibold text-gray-700">Tổng cộng:</td><td class="p-3"><span id="totalFee"><%= formatVND(new BigDecimal(request.getAttribute("totalFee") != null ? request.getAttribute("totalFee").toString() : "0"))%></span></td></tr>
                        </table>
                        <div class="mt-4">
                            <button type="submit" class="submit-btn w-full">Đặt hàng</button>
                        </div>
                    </div>
                    <!-- Phần 3: Thông tin hàng hóa (Cột 1) -->
                    <div class="section col-span-1">
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-box mr-2"></i> Thông tin hàng hóa
                        </div>
                        <div class="mb-6">
                            <label id="description_label" class="block text-gray-700 font-semibold">Mô tả hàng hóa:</label>
                            <textarea name="description" rows="2" class="form-control mt-2 p-3 w-full border rounded-lg" placeholder="Mô tả chi tiết hàng hóa cần vận chuyển(có thể bỏ qua)" aria-labelledby="description_label"></textarea>
                        </div>
                        <div class="mb-6">
                            <label id="special_note_label" class="block text-gray-700 font-semibold">Ghi chú đặc biệt:</label>
                            <textarea name="special_note" rows="1" class="form-control mt-2 p-3 w-full border rounded-lg" placeholder="Nhập hướng dẫn đặc biệt (ví dụ: xử lý cẩn thận, giao vào buổi sáng),(có thể bỏ qua)" aria-labelledby="special_note_label"></textarea>
                        </div>
                    </div>
                    <!-- Phần 4: Hàng hóa đề xuất (Cột 2, dưới Bảng tính tiền) -->
                    <div class="section col-span-1">
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-lightbulb mr-2"></i> Hàng hóa đề xuất
                        </div>
                        <div class="suggested-items flex flex-col space-y-2">
                            <label id="suggestedItems_label" class="block text-gray-700 font-semibold">Hàng hóa đề xuất:</label>
                            <select id="suggestedItems" class="form-control mt-2 p-2 w-full border rounded-lg" aria-labelledby="suggestedItems_label">
                                <option value="">-- Chọn hàng hóa --</option>
                                <%
                                    List<SuggestedItem> suggestedItems = orderDAO.getSuggestedItems();
                                    for (SuggestedItem item : suggestedItems) {
                                        String escapedName = item.getName().replace("\"", "&quot;").replace("'", "&apos;");
                                %>
                                <option value='{"name":"<%= escapedName%>","defaultQuantity":<%= item.getDefaultQuantity()%>,"defaultWeightKg":<%= item.getDefaultWeightKg()%>,"defaultVolumeM3":<%= item.getDefaultVolumeM3()%>,"defaultPrice":<%= item.getDefaultPrice().setScale(2, BigDecimal.ROUND_HALF_UP)%>}'>
                                    <%= item.getName()%> (Khối lượng: <%= formatNumber(item.getDefaultWeightKg())%>kg, Thể tích: <%= formatNumber(item.getDefaultVolumeM3())%>m³, Giá: <%= formatVND(item.getDefaultPrice())%>)
                                </option>
                                <%
                                    }
                                %>
                            </select>
                            <div class="button-group mt-2">
                                <button type="button" id="addSuggestedItem" class="btn-primary">Thêm</button>
                            </div>
                        </div>
                    </div>
                    <!-- Phần 5: Thêm hàng hóa thủ công (Cột 1 và 2, ngang các cột) -->
                    <div class="section col-span-2">
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-plus mr-2"></i> Thêm hàng hóa thủ công
                        </div>
                        <div class="grid grid-cols-5 gap-2"> <!-- Increased to 5 columns for even distribution -->
                            <div>
                                <label id="manual_item_name_label" class="block text-gray-700 font-semibold">Tên:</label>
                                <input type="text" name="manual_item_name" id="manual_item_name" class="form-control mt-1 p-1 w-full border rounded-lg" aria-labelledby="manual_item_name_label">
                            </div>
                            <div>
                                <label id="manual_quantity_label" class="block text-gray-700 font-semibold">Số lượng:</label>
                                <input type="number" name="manual_quantity" id="manual_quantity" value="1" min="1" class="form-control mt-1 p-1 w-full border rounded-lg" aria-labelledby="manual_quantity_label">
                            </div>
                            <div>
                                <label id="manual_weight_kg_label" class="block text-gray-700 font-semibold">Khối lượng (kg):</label>
                                <input type="number" name="manual_weight_kg" id="manual_weight_kg" step="0.01" class="form-control mt-1 p-1 w-full border rounded-lg" aria-labelledby="manual_weight_kg_label">
                            </div>
                            <div>
                                <label id="manual_volume_m3_label" class="block text-gray-700 font-semibold">Thể tích (m³):</label>
                                <input type="number" name="manual_volume_m3" id="manual_volume_m3" step="0.01" class="form-control mt-1 p-1 w-full border rounded-lg" aria-labelledby="manual_volume_m3_label">
                            </div>
                            <div class="col-span-1">
                                <label id="manual_item_note_label" class="block text-gray-700 font-semibold">Ghi chú:</label>
                                <input type="text" name="manual_item_note" id="manual_item_note" class="form-control mt-1 p-1 w-full border rounded-lg" aria-labelledby="manual_item_note_label">
                            </div>
                            <div class="col-span-5 mt-2 text-center"> <!-- Button centered across all columns -->
                                <div class="button-group">
                                    <button type="button" id="addManualItem" class="btn-primary">Thêm</button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Phần 6: Hàng hóa đã thêm (Cột 1 và 2) -->
                    <div class="section col-span-2">
                        <div class="section-header flex items-center justify-center">
                            <i class="fas fa-check mr-2"></i> Hàng hóa đã thêm
                        </div>
                        <table id="itemTable" class="table w-full">
                            <thead>
                                <tr>
                                    <th class="p-3 text-gray-700 font-semibold">Tên hàng hóa</th>
                                    <th class="p-3 text-gray-700 font-semibold">Số lượng</th>
                                    <th class="p-3 text-gray-700 font-semibold">Khối lượng (kg)</th>
                                    <th class="p-3 text-gray-700 font-semibold">Thể tích (m³)</th>
                                    <th class="p-3 text-gray-700 font-semibold">Giá (VND)</th>
                                    <th class="p-3 text-gray-700 font-semibold">Ghi chú</th>
                                    <th class="p-3 text-gray-700 font-semibold">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody id="itemTableBody">
                                <%
                                    List<OrderDetail> orderDetails = (List<OrderDetail>) session.getAttribute("orderDetails");
                                    if (orderDetails != null && !orderDetails.isEmpty()) {
                                        for (OrderDetail detail : orderDetails) {
                                            String itemName = detail.getItemName() != null ? detail.getItemName().replace("\"", "&quot;").replace("'", "&apos;") : "";
                                            int quantity = detail.getQuantity();
                                            BigDecimal weightKg = detail.getWeightKg() != null ? detail.getWeightKg() : BigDecimal.ZERO;
                                            BigDecimal volumeM3 = detail.getVolumeM3() != null ? detail.getVolumeM3() : BigDecimal.ZERO;
                                            BigDecimal itemPrice = detail.getItemPrice() != null ? detail.getItemPrice() : BigDecimal.ZERO;
                                            String note = detail.getNote() != null ? detail.getNote().replace("\"", "&quot;").replace("'", "&apos;") : "";
                                %>
                                <tr>
                                    <td class="p-3"><%= itemName%><input type="hidden" name="item_name" value="<%= itemName%>"></td>
                                    <td class="p-3"><%= quantity%><input type="hidden" name="quantity" value="<%= quantity%>"></td>
                                    <td class="p-3"><%= formatNumber(weightKg)%> kg<input type="hidden" name="weight_kg" value="<%= weightKg.toString()%>"></td>
                                    <td class="p-3"><%= formatNumber(volumeM3)%> m³<input type="hidden" name="volume_m3" value="<%= volumeM3.toString()%>"></td>
                                    <td class="p-3"><%= formatVND(itemPrice)%><input type="hidden" name="item_price" value="<%= itemPrice.toString()%>"></td>
                                    <td class="p-3"><input type="text" name="item_note" value="<%= note%>" class="w-full p-2 border rounded" aria-label="Ghi chú cho hàng hóa"></td>
                                    <td class="p-3"><button type="button" class="remove-item bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button></td>
                                </tr>
                                <%
                                    }
                                } else {
                                %>
                                <tr><td colspan="7" class="p-3 text-center text-gray-500">Không có hàng hóa nào được thêm.</td></tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        <div class="mt-4 flex justify-between items-center">
                            <div>
                                <p class="text-gray-700 font-medium">Tổng khối lượng: <span id="totalWeight"><%= formatNumber(new BigDecimal(session.getAttribute("totalWeight") != null ? session.getAttribute("totalWeight").toString() : "0"))%> kg</span></p>
                                <p class="text-gray-700 font-medium">Tổng thể tích: <span id="totalVolume"><%= formatNumber(new BigDecimal(session.getAttribute("totalVolume") != null ? session.getAttribute("totalVolume").toString() : "0"))%> m³</span></p>
                                <p class="text-gray-700 font-medium">Phí tháo dỡ và lắp đặt: <a href="#serviceDetails" id="totalItemPriceLink" class="text-blue-600 hover:underline"><span id="totalItemPrice"><%= formatVND(new BigDecimal(session.getAttribute("totalItemPrice") != null ? session.getAttribute("totalItemPrice").toString() : "0"))%></span></a></p>                            </div>
                        </div>
                        <div class="info-box mt-4">
                            Bạn hãy thêm ít nhất 1 hàng hóa trước khi tạo đơn hàng!
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <script>
            let isUpdatingDistance = false;
            let routeLayer = null;
            let map = null;

            // Định dạng tiền tệ VND
            function formatVND(amount) {
                return new Big(amount).toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ".") + " VND";
            }


            // Định dạng số thông thường 
            function formatNumber(number) {
                return new Big(number).toFixed(2).replace(/\B(?=(\d{3})+(?!\d))/g, ".");
            }

            // Vẽ tuyến đường từ GeoJSON
            function drawRoute(geometry) {
                if (!map) {
                    console.error("Map is not initialized");
                    $('#errorMessage').text('Lỗi: Bản đồ chưa được khởi tạo.');
                    $('#successMessage').text('');
                    return;
                }
                if (!geometry) {
                    console.error("No route geometry provided");
                    $('#errorMessage').text('Lỗi: Không có dữ liệu tuyến đường.');
                    $('#successMessage').text('');
                    return;
                }

                if (routeLayer && map) {
                    map.removeLayer(routeLayer);
                    routeLayer = null;
                }

                try {
                    routeLayer = L.geoJSON(geometry, {
                        style: {
                            color: '#0078A8',
                            weight: 5,
                            opacity: 0.7
                        }
                    }).addTo(map);
                    map.fitBounds(routeLayer.getBounds());
                    $('#errorMessage').text('');
                    $('#successMessage').text('Tuyến đường đã được vẽ thành công.');
                } catch (e) {
                    console.error("Error drawing route:", e);
                    $('#errorMessage').text('Lỗi khi vẽ tuyến đường: ' + e.message);
                    $('#successMessage').text('');
                }
            }

            document.addEventListener('DOMContentLoaded', function () {
                try {
                    console.log("Initializing map at " + new Date().toLocaleString());
                    if (!document.getElementById('map')) {
                        console.error("Map container not found!");
                        $('#errorMessage').text('Lỗi: Không tìm thấy container bản đồ.');
                        return;
                    }

                    map = L.map('map').setView([20.9816, 105.5231], 12);
                    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
                        attribution: '© OpenStreetMap contributors'
                    }).addTo(map);

                    var selectMode = null;
                    var pickupMarker, shippingMarker;

                    $('#selectPickupOnMap').click(function () {
                        selectMode = 'pickup';
                        $('#errorMessage').text('Vui lòng nhấp vào bản đồ để chọn địa chỉ lấy hàng.');
                        $('#successMessage').text('');
                    });

                    $('#selectShippingOnMap').click(function () {
                        selectMode = 'shipping';
                        $('#errorMessage').text('Vui lòng nhấp vào bản đồ để chọn địa chỉ giao hàng.');
                        $('#successMessage').text('');
                    });

                    map.on('click', function (e) {
                        if (selectMode) {
                            try {
                                if (!e.latlng) {
                                    throw new Error("No latlng data in click event");
                                }
                                if (selectMode === 'pickup') {
                                    if (pickupMarker)
                                        map.removeLayer(pickupMarker);
                                    pickupMarker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(map).bindPopup("Điểm lấy hàng").openPopup();
                                    $('#pickup_lat').val(e.latlng.lat.toFixed(6));
                                    $('#pickup_lng').val(e.latlng.lng.toFixed(6));
                                    console.log("Pickup coordinates set:", {lat: e.latlng.lat, lng: e.latlng.lng});
                                    reverseGeocode(e.latlng.lat, e.latlng.lng, 'pickup');
                                } else if (selectMode === 'shipping') {
                                    if (shippingMarker)
                                        map.removeLayer(shippingMarker);
                                    shippingMarker = L.marker([e.latlng.lat, e.latlng.lng]).addTo(map).bindPopup("Điểm giao hàng").openPopup();
                                    $('#shipping_lat').val(e.latlng.lat.toFixed(6));
                                    $('#shipping_lng').val(e.latlng.lng.toFixed(6));
                                    console.log("Shipping coordinates set:", {lat: e.latlng.lat, lng: e.latlng.lng});
                                    reverseGeocode(e.latlng.lat, e.latlng.lng, 'shipping');
                                }
                                if ($('#pickup_lat').val() && $('#pickup_lng').val() && $('#shipping_lat').val() && $('#shipping_lng').val()) {
                                    updateDistance();
                                }
                                selectMode = null;
                                $('#errorMessage').text('');
                                $('#successMessage').text('');
                            } catch (e) {
                                console.error("Map click error: ", e);
                                $('#errorMessage').text('Lỗi khi chọn điểm trên bản đồ: ' + e.message);
                            }
                        }
                    });

                    function reverseGeocode(lat, lng, type) {
                        $.ajax({
                            url: 'https://nominatim.openstreetmap.org/reverse?format=json&lat=' + lat + '&lon=' + lng + '&addressdetails=1',
                            type: 'GET',
                            success: function (data) {
                                console.log("Reverse Geocode Response: ", data);
                                if (data && data.display_name) {
                                    $('#' + type + '_address').val(data.display_name);
                                    $('#' + type + '_lat').val(parseFloat(data.lat).toFixed(6));
                                    $('#' + type + '_lng').val(parseFloat(data.lon).toFixed(6));
                                    console.log(type + " address set:", data.display_name);
                                    if ($('#pickup_lat').val() && $('#pickup_lng').val() && $('#shipping_lat').val() && $('#shipping_lng').val()) {
                                        updateDistance();
                                    }
                                } else {
                                    console.warn("No display_name in reverse geocode response");
                                    $('#errorMessage').text('Không thể lấy địa chỉ từ tọa độ.');
                                }
                            },
                            error: function (xhr) {
                                console.error("Reverse geocoding error: ", xhr.status, xhr.responseText);
                                $('#errorMessage').text('Lỗi khi lấy địa chỉ: ' + xhr.statusText);
                            }
                        });
                    }

                    function autocomplete(type) {
                        var input = $('#' + type + '_address');
                        var autocompleteDiv = $('#' + type + '_autocomplete');
                        autocompleteDiv.empty();

                        if (input.val().length > 0) {
                            console.log("Autocomplete triggered for input: ", input.attr('id'), "Value: ", input.val());
                            $.ajax({
                                url: 'https://nominatim.openstreetmap.org/search?format=json&q=' + encodeURIComponent(input.val()) + '&addressdetails=1&limit=5&email=your_actual_email@example.com&countrycodes=vn',
                                type: 'GET',
                                dataType: 'json',
                                success: function (data) {
                                    console.log("Autocomplete API Response: ", data);
                                    if (data && Array.isArray(data) && data.length > 0) {
                                        console.log("Found " + data.length + " suggestions for: ", input.val());
                                        autocompleteDiv.show();
                                        data.sort(function (a, b) {
                                            return a.display_name.length - b.display_name.length;
                                        });
                                        data.forEach(function (item) {
                                            console.log("Suggestion: ", item.display_name, "Lat: ", item.lat, "Lon: ", item.lon);
                                            var div = $('<div>').text(item.display_name);
                                            div.click(function () {
                                                input.val(item.display_name);
                                                $('#' + type + '_lat').val(parseFloat(item.lat).toFixed(6));
                                                $('#' + type + '_lng').val(parseFloat(item.lon).toFixed(6));
                                                console.log(type + " coordinates set:", {lat: item.lat, lng: item.lon});
                                                if (type === 'pickup') {
                                                    if (pickupMarker)
                                                        map.removeLayer(pickupMarker);
                                                    pickupMarker = L.marker([item.lat, item.lon]).addTo(map).bindPopup("Điểm lấy hàng").openPopup();
                                                } else {
                                                    if (shippingMarker)
                                                        map.removeLayer(shippingMarker);
                                                    shippingMarker = L.marker([item.lat, item.lon]).addTo(map).bindPopup("Điểm giao hàng").openPopup();
                                                }
                                                map.setView([item.lat, item.lon], 12);
                                                if ($('#pickup_lat').val() && $('#pickup_lng').val() && $('#shipping_lat').val() && $('#shipping_lng').val()) {
                                                    updateDistance();
                                                }
                                                autocompleteDiv.hide();
                                            });
                                            div.hover(
                                                    function () {
                                                        $(this).css('background-color', '#f3f4f6');
                                                    },
                                                    function () {
                                                        $(this).css('background-color', '#fff');
                                                    }
                                            );
                                            autocompleteDiv.append(div);
                                        });
                                    } else {
                                        console.log("No suggestions found for input: ", input.val());
                                        autocompleteDiv.hide();
                                    }
                                },
                                error: function (xhr) {
                                    console.error("Autocomplete error: Status ", xhr.status, "Response: ", xhr.responseText);
                                    autocompleteDiv.hide();
                                    $('#errorMessage').text('Lỗi khi tìm kiếm địa chỉ: ' + xhr.statusText);
                                }
                            });
                        } else {
                            autocompleteDiv.hide();
                            console.log("Input is empty, hiding autocomplete for: ", input.attr('id'));
                        }
                    }

                    function updateDistance() {
                        if (isUpdatingDistance) {
                            console.log("Skipping updateDistance, already in progress");
                            return;
                        }
                        isUpdatingDistance = true;

                        try {
                            const pickupLat = $('#pickup_lat').val()?.trim();
                            const pickupLng = $('#pickup_lng').val()?.trim();
                            const shippingLat = $('#shipping_lat').val()?.trim();
                            const shippingLng = $('#shipping_lng').val()?.trim();

                            console.log("Raw input coordinates:", {
                                pickupLat,
                                pickupLng,
                                shippingLat,
                                shippingLng
                            });

                            if (!pickupLat || !pickupLng || !shippingLat || !shippingLng) {
                                console.warn("Missing coordinates in updateDistance");
                                $('#distance_km').val(0);
                                $('#errorMessage').text('Vui lòng chọn địa chỉ lấy và giao hàng hợp lệ.');
                                $('#successMessage').text('');
                                updateServiceAndFee();
                                updateTotals();
                                if (routeLayer && map) {
                                    map.removeLayer(routeLayer);
                                    routeLayer = null;
                                }
                                isUpdatingDistance = false;
                                return;
                            }

                            const parsedPickupLat = parseFloat(pickupLat);
                            const parsedPickupLng = parseFloat(pickupLng);
                            const parsedShippingLat = parseFloat(shippingLat);
                            const parsedShippingLng = parseFloat(shippingLng);

                            if (isNaN(parsedPickupLat) || isNaN(parsedPickupLng) ||
                                    isNaN(parsedShippingLat) || isNaN(parsedShippingLng)) {
                                console.warn("Invalid coordinates in updateDistance:", {
                                    parsedPickupLat,
                                    parsedPickupLng,
                                    parsedShippingLat,
                                    parsedShippingLng
                                });
                                $('#distance_km').val(0);
                                $('#errorMessage').text('Tọa độ không hợp lệ. Vui lòng chọn lại địa chỉ.');
                                $('#successMessage').text('');
                                updateServiceAndFee();
                                updateTotals();
                                if (routeLayer && map) {
                                    map.removeLayer(routeLayer);
                                    routeLayer = null;
                                }
                                isUpdatingDistance = false;
                                return;
                            }

                            if (parsedPickupLat < -90 || parsedPickupLat > 90 ||
                                    parsedShippingLat < -90 || parsedShippingLat > 90 ||
                                    parsedPickupLng < -180 || parsedPickupLng > 180 ||
                                    parsedShippingLng < -180 || parsedShippingLng > 180) {
                                console.warn("Coordinates out of range in updateDistance:", {
                                    parsedPickupLat,
                                    parsedPickupLng,
                                    parsedShippingLat,
                                    parsedShippingLng
                                });
                                $('#distance_km').val(0);
                                $('#errorMessage').text('Tọa độ ngoài phạm vi hợp lệ.');
                                $('#successMessage').text('');
                                updateServiceAndFee();
                                updateTotals();
                                if (routeLayer && map) {
                                    map.removeLayer(routeLayer);
                                    routeLayer = null;
                                }
                                isUpdatingDistance = false;
                                return;
                            }

                            console.log("Sending AJAX for route calculation with coordinates:", {
                                parsedPickupLat,
                                parsedPickupLng,
                                parsedShippingLat,
                                parsedShippingLng
                            });

                            $.ajax({
                                url: 'transport',
                                type: 'POST',
                                headers: {'X-Requested-With': 'XMLHttpRequest'},
                                data: {
                                    action: 'calculateRoute',
                                    pickup_lat: parsedPickupLat,
                                    pickup_lng: parsedPickupLng,
                                    shipping_lat: parsedShippingLat,
                                    shipping_lng: parsedShippingLng,
                                    service_type: $('#service_type').val() || ''
                                },
                                success: function (response) {
                                    console.log("calculateRoute response:", response);
                                    $('#distance_km').val(response.distanceKm || 0);
                                    updateServiceAndFee();
                                    updateTotals();
                                    if (response.routeGeometry) {
                                        drawRoute(response.routeGeometry);
                                    } else {
                                        console.warn("No route geometry in response");
                                        $('#errorMessage').text('Không thể vẽ tuyến đường: Không có dữ liệu tuyến đường.');
                                        $('#successMessage').text('');
                                    }
                                },
                                error: function (xhr) {
                                    console.error("Route calculation error:", xhr.responseText);
                                    $('#errorMessage').text(xhr.responseText || 'Lỗi khi tính khoảng cách hoặc vẽ tuyến đường.');
                                    $('#successMessage').text('');
                                    $('#distance_km').val(0);
                                    updateServiceAndFee();
                                    updateTotals();
                                    if (routeLayer && map) {
                                        map.removeLayer(routeLayer);
                                        routeLayer = null;
                                    }
                                },
                                complete: function () {
                                    isUpdatingDistance = false;
                                }
                            });
                        } catch (e) {
                            console.error("Update distance error:", e);
                            $('#errorMessage').text('Lỗi khi tính khoảng cách: ' + e.message);
                            $('#successMessage').text('');
                            $('#distance_km').val(0);
                            updateServiceAndFee();
                            updateTotals();
                            if (routeLayer && map) {
                                map.removeLayer(routeLayer);
                                routeLayer = null;
                            }
                            isUpdatingDistance = false;
                        }
                    }

                    function updateServiceAndFee() {
                        try {
                            var selected = $('#service_type').find(':selected');
                            var basePrice = new Big(selected.data('price') || 0);
                            var ratePerKm = new Big(selected.data('rate') || 0);
                            var distance = new Big($('#distance_km').val() || 0);
                            var kmFee = ratePerKm.mul(distance).toFixed(2);
                            var serviceFee = basePrice.add(new Big(kmFee)).toFixed(2);
                            console.log("Updating service details:", {
                                basePrice: formatVND(basePrice.toFixed(2)),
                                ratePerKm: formatVND(ratePerKm.toFixed(2)),
                                kmFee: formatVND(kmFee),
                                serviceFee: formatVND(serviceFee),
                                distance: distance.toFixed(2)
                            });
                            $('#serviceBasePrice').text(formatVND(basePrice.toFixed(2)));
                            $('#serviceRatePerKm').text(formatVND(ratePerKm.toFixed(2)));
                            $('#serviceKmFee').text(formatVND(kmFee));
                            $('#serviceTotalFee').text(formatVND(serviceFee));
                            $('#serviceDistance').text(distance.toFixed(2));
                            $('#serviceFee').text(formatVND(serviceFee));
                            updateFees();
                        } catch (e) {
                            console.error("Update service and fee error: ", e);
                            $('#errorMessage').text('Lỗi khi cập nhật phí dịch vụ: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function updateFees() {
                        try {
                            var totalItemPriceText = $('#totalItemPrice').text().replace(" VND", "").replace(/\./g, "") || "0";
                            var totalItemPrice = parseFloat(totalItemPriceText) || 0;
                            var distanceKm = $('#distance_km').val() || '0';
                            var serviceType = $('#service_type').val() || '';

                            if (!serviceType) {
                                $('#errorMessage').text('Vui lòng chọn loại dịch vụ.');
                                $('#successMessage').text('');
                                console.log("Skipping updateFees: missing serviceType");
                                return;
                            }
                            if (!distanceKm || parseFloat(distanceKm) <= 0) {
                                $('#errorMessage').text('Khoảng cách không hợp lệ. Vui lòng chọn địa chỉ.');
                                $('#successMessage').text('');
                                console.log("Skipping updateFees: invalid distanceKm");
                                return;
                            }

                            console.log("Sending updateFees AJAX with:", {
                                action: 'updateFees',
                                totalItemPrice: totalItemPrice,
                                distanceKm: distanceKm,
                                serviceType: serviceType
                            });

                            $.ajax({
                                url: 'transport',
                                type: 'POST',
                                headers: {'X-Requested-With': 'XMLHttpRequest'},
                                data: {
                                    action: 'updateFees',
                                    totalItemPrice: totalItemPrice,
                                    distanceKm: distanceKm,
                                    serviceType: serviceType
                                },
                                success: function (response) {
                                    console.log("updateFees response:", response);
                                    if (response.transportFee !== undefined && response.serviceFee !== undefined && response.vatAmount !== undefined && response.totalFee !== undefined) {
                                        $('#transportFee').text(formatVND(new Big(response.transportFee || 0).toFixed(2)));
                                        $('#serviceFee').text(formatVND(new Big(response.serviceFee || 0).toFixed(2)));
                                        $('#vatAmount').text(formatVND(new Big(response.vatAmount || 0).toFixed(2)));
                                        $('#totalFee').text(formatVND(new Big(response.totalFee || 0).toFixed(2)));
                                        $('#successMessage').text('');
                                    } else {
                                        console.warn("Invalid response from updateFees:", response);
                                        $('#errorMessage').text('Phản hồi từ server không hợp lệ khi cập nhật phí.');
                                        $('#successMessage').text('');
                                    }
                                },
                                error: function (xhr) {
                                    console.error("Failed to update fees: ", xhr.responseText);
                                    $('#errorMessage').text('Lỗi khi cập nhật phí: ' + (xhr.responseText || 'Không nhận được phản hồi từ server'));
                                    $('#successMessage').text('');
                                }
                            });
                        } catch (e) {
                            console.error("Update fees error: ", e);
                            $('#errorMessage').text('Lỗi khi cập nhật phí: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function addSuggestedItem() {
                        try {
                            var selected = JSON.parse($('#suggestedItems').val() || '{}');
                            console.log("Adding suggested item:", selected);

                            if (!selected.name) {
                                $('#errorMessage').text('Vui lòng chọn hàng hóa.');
                                $('#successMessage').text('');
                                console.warn("No item selected in suggestedItems");
                                return;
                            }

                            var quantity = parseInt(selected.defaultQuantity) || 1;
                            var weight = parseFloat(selected.defaultWeightKg) || 0;
                            var volume = parseFloat(selected.defaultVolumeM3) || 0;
                            var price = parseFloat(selected.defaultPrice) || 0;

                            if (weight < 0 || volume < 0 || price < 0) {
                                $('#errorMessage').text('Khối lượng, thể tích và giá không được âm.');
                                $('#successMessage').text('');
                                console.warn("Invalid values:", {weight, volume, price});
                                return;
                            }

                            var currentDetails = getOrderDetailsFromSession() || [];
                            $('#itemTableBody').find('tr:contains("Không có hàng hóa nào được thêm")').remove();

                            var $row = $('<tr>');
                            $row.append($('<td class="p-2">').text(selected.name).append($('<input type="hidden" name="item_name">').val(selected.name)));
                            $row.append($('<td class="p-2">').text(quantity).append($('<input type="hidden" name="quantity">').val(quantity)));
                            $row.append($('<td class="p-2">').text(formatNumber(new Big(weight).toFixed(2)) + ' kg').append($('<input type="hidden" name="weight_kg">').val(weight.toString())));
                            $row.append($('<td class="p-2">').text(formatNumber(new Big(volume).toFixed(2)) + ' m³').append($('<input type="hidden" name="volume_m3">').val(volume.toString())));
                            $row.append($('<td class="p-2">').text(formatVND(new Big(price * quantity).toFixed(0))).append($('<input type="hidden" name="item_price">').val((price * quantity).toString())));
                            $row.append($('<td class="p-2">').append($('<input type="text" name="item_note" class="w-full p-1 border rounded" aria-label="Ghi chú cho hàng hóa">')));
                            $row.append($('<td class="p-2">').append($('<button type="button" class="remove-item bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>')));
                            $('#itemTableBody').append($row);

                            currentDetails.push({
                                itemName: selected.name,
                                quantity: quantity,
                                weightKg: weight.toString(),
                                volumeM3: volume.toString(),
                                itemPrice: (price * quantity).toString(),
                                note: ''
                            });
                            updateSessionOrderDetails(currentDetails);
                            updateTotals();
                            $('#successMessage').text('');
                        } catch (e) {
                            console.error("Add suggested item error: ", e);
                            $('#errorMessage').text('Lỗi khi thêm hàng hóa đề xuất: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function addManualItem() {
                        try {
                            var name = $('#manual_item_name').val().trim();
                            var quantity = parseInt($('#manual_quantity').val()) || 1;
                            var weight = parseFloat($('#manual_weight_kg').val()) || 0;
                            var volume = parseFloat($('#manual_volume_m3').val()) || 0;
                            var note = $('#manual_item_note').val().trim();

                            if (!name) {
                                $('#errorMessage').text('Vui lòng nhập tên hàng hóa.');
                                $('#successMessage').text('');
                                console.warn("No item name provided");
                                return;
                            }
                            if (weight < 0 || volume < 0) {
                                $('#errorMessage').text('Khối lượng và thể tích không được âm.');
                                $('#successMessage').text('');
                                console.warn("Invalid values:", {weight, volume});
                                return;
                            }

                            var currentDetails = getOrderDetailsFromSession() || [];
                            $('#itemTableBody').find('tr:contains("Không có hàng hóa nào được thêm")').remove();

                            var basePrice = new Big(2000);
                            var pricePerKg = new Big(8000);
                            var pricePerM3 = new Big(12000);
                            var calculatedPrice = basePrice.plus(new Big(weight).times(pricePerKg)).plus(new Big(volume).times(pricePerM3)).times(quantity);

                            var $row = $('<tr>');
                            $row.append($('<td class="p-2">').text(name).append($('<input type="hidden" name="item_name">').val(name)));
                            $row.append($('<td class="p-2">').text(quantity).append($('<input type="hidden" name="quantity">').val(quantity)));
                            $row.append($('<td class="p-2">').text(formatNumber(new Big(weight).toFixed(2)) + ' kg').append($('<input type="hidden" name="weight_kg">').val(weight.toString())));
                            $row.append($('<td class="p-2">').text(formatNumber(new Big(volume).toFixed(2)) + ' m³').append($('<input type="hidden" name="volume_m3">').val(volume.toString())));
                            $row.append($('<td class="p-2">').text(formatVND(calculatedPrice.toFixed(0))).append($('<input type="hidden" name="item_price">').val(calculatedPrice.toFixed(0))));
                            $row.append($('<td class="p-2">').append($('<input type="text" name="item_note" class="w-full p-1 border rounded" aria-label="Ghi chú cho hàng hóa">').val(note)));
                            $row.append($('<td class="p-2">').append($('<button type="button" class="remove-item bg-red-500 text-white px-2 py-1 rounded hover:bg-red-600">Xóa</button>')));
                            $('#itemTableBody').append($row);

                            currentDetails.push({
                                itemName: name,
                                quantity: quantity,
                                weightKg: weight.toString(),
                                volumeM3: volume.toString(),
                                itemPrice: calculatedPrice.toFixed(0),
                                note: note
                            });
                            updateSessionOrderDetails(currentDetails);
                            updateTotals();
                            $('#successMessage').text('');
                        } catch (e) {
                            console.error("Add manual item error: ", e);
                            $('#errorMessage').text('Lỗi khi thêm hàng hóa thủ công: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function removeItem(btn) {
                        try {
                            var $row = $(btn).closest('tr');
                            var itemName = $row.find('input[name="item_name"]').val();
                            var currentDetails = getOrderDetailsFromSession() || [];
                            currentDetails = currentDetails.filter(detail => detail.itemName !== itemName);
                            updateSessionOrderDetails(currentDetails);

                            $row.remove();
                            updateTotals();
                            $('#successMessage').text('');

                            if ($('#itemTableBody tr').length === 0) {
                                $('#itemTableBody').html('<tr><td colspan="7" class="p-2 text-center text-gray-500">Không có hàng hóa nào được thêm.</td></tr>');
                            }
                        } catch (e) {
                            console.error("Remove item error: ", e);
                            $('#errorMessage').text('Lỗi khi xóa hàng hóa: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function updateTotals() {
                        try {
                            var totalWeight = new Big(0), totalVolume = new Big(0), totalPrice = new Big(0);
                            $('#itemTableBody tr').each(function () {
                                var $row = $(this);
                                if ($row.find('td').length > 1 && $row.find('input[name="item_name"]').length) {
                                    var itemName = $row.find('input[name="item_name"]').val();
                                    var quantity = parseInt($row.find('input[name="quantity"]').val()) || 1;
                                    var weight = parseFloat($row.find('input[name="weight_kg"]').val()) || 0;
                                    var volume = parseFloat($row.find('input[name="volume_m3"]').val()) || 0;
                                    var price = parseFloat($row.find('input[name="item_price"]').val()) || 0;
                                    totalWeight = totalWeight.plus(new Big(weight).times(quantity));
                                    totalVolume = totalVolume.plus(new Big(volume).times(quantity));
                                    totalPrice = totalPrice.plus(new Big(price));
                                    console.log("Processing row:", {itemName, quantity, weight: weight.toString(), volume: volume.toString(), price: price.toString(), rowHtml: $row.html()});
                                }
                            });
                            console.log("Updating totals:", {totalWeight: totalWeight.toString(), totalVolume: totalVolume.toString(), totalPrice: totalPrice.toString()});
                            $('#totalWeight').text(formatNumber(totalWeight.toFixed(2)) + " kg");
                            $('#totalVolume').text(formatNumber(totalVolume.toFixed(2)) + " m³");
                            $('#totalItemPrice').text(formatVND(totalPrice.toFixed(0)));

                            sessionStorage.setItem('totalWeight', totalWeight.toFixed(2));
                            sessionStorage.setItem('totalVolume', totalVolume.toFixed(2));
                            sessionStorage.setItem('totalItemPrice', totalPrice.toFixed(0));

                            if ($('#service_type').val() && $('#distance_km').val() && parseFloat($('#distance_km').val()) > 0) {
                                updateFees();
                            } else {
                                console.log("Skipping updateFees due to missing service or distance");
                                var transportFee = totalPrice;
                                var serviceFeeText = $('#serviceTotalFee').text().replace(" VND", "").replace(/\./g, "") || "0";
                                var serviceFee = new Big(serviceFeeText);
                                var taxableAmount = transportFee.add(serviceFee);
                                var vatAmount = taxableAmount.times(0.1).toFixed(0);
                                var totalFee = transportFee.add(serviceFee).add(new Big(vatAmount));
                                $('#transportFee').text(formatVND(transportFee.toFixed(0)));
                                $('#serviceFee').text(formatVND(serviceFee.toFixed(0)));
                                $('#vatAmount').text(formatVND(vatAmount));
                                $('#totalFee').text(formatVND(totalFee.toFixed(0)));
                            }
                        } catch (e) {
                            console.error("Update totals error: ", e);
                            $('#errorMessage').text('Lỗi khi tính tổng: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function updateSessionOrderDetails(details) {
                        try {
                            if (!details || details.length === 0) {
                                console.log("No valid items to update session");
                                return;
                            }
                            console.log("Sending session update with details:", details);

                            var cleanedDetails = details.map(function (detail) {
                                return {
                                    itemName: detail.itemName,
                                    quantity: detail.quantity,
                                    weightKg: parseFloat(detail.weightKg).toString(),
                                    volumeM3: parseFloat(detail.volumeM3).toString(),
                                    itemPrice: parseFloat(detail.itemPrice).toString(),
                                    note: detail.note
                                };
                            });

                            $.ajax({
                                url: 'transport',
                                type: 'POST',
                                data: {action: 'updateOrderDetails', orderDetails: JSON.stringify(cleanedDetails)},
                                success: function (response) {
                                    console.log("Session updated successfully:", response);
                                },
                                error: function (xhr, status, error) {
                                    console.error("Failed to update session: ", error, xhr.responseText);
                                    $('#errorMessage').text('Lỗi khi cập nhật session: ' + (xhr.responseText || error));
                                    $('#successMessage').text('');
                                }
                            });
                        } catch (e) {
                            console.error("Update session order details error: ", e);
                            $('#errorMessage').text('Lỗi khi cập nhật session: ' + e.message);
                            $('#successMessage').text('');
                        }
                    }

                    function getOrderDetailsFromSession() {
                        var details = [];
                        $('#itemTableBody tr').each(function () {
                            var $row = $(this);
                            if ($row.find('td').length > 1 && $row.find('input[name="item_name"]').length) {
                                var itemName = $row.find('input[name="item_name"]').val();
                                var quantity = parseInt($row.find('input[name="quantity"]').val()) || 1;
                                var weightKg = parseFloat($row.find('input[name="weight_kg"]').val()) || 0;
                                var volumeM3 = parseFloat($row.find('input[name="volume_m3"]').val()) || 0;
                                var itemPrice = parseFloat($row.find('input[name="item_price"]').val()) || 0;
                                var note = $row.find('input[name="item_note"]').val() || '';

                                if (itemName && (weightKg >= 0 && volumeM3 >= 0 && itemPrice >= 0)) {
                                    details.push({
                                        itemName: itemName,
                                        quantity: quantity,
                                        weightKg: weightKg.toString(),
                                        volumeM3: volumeM3.toString(),
                                        itemPrice: itemPrice.toString(),
                                        note: note
                                    });
                                }
                            }
                        });
                        return details.length > 0 ? details : null;
                    }

                    $('#transportForm').on('submit', function (e) {
                        try {
                            if (!$('#service_type').val()) {
                                $('#errorMessage').text('Vui lòng chọn loại dịch vụ.');
                                $('#successMessage').text('');
                                e.preventDefault();
                                return;
                            }
                            if (!$('#distance_km').val() || parseFloat($('#distance_km').val()) <= 0) {
                                $('#errorMessage').text('Vui lòng chọn địa chỉ lấy và giao hàng hợp lệ để tính khoảng cách.');
                                $('#successMessage').text('');
                                e.preventDefault();
                                return;
                            }
                            var pickupTime = $('#pickup_time_desired').val();
                            if (pickupTime && !pickupTime.includes(':')) {
                                $('#pickup_time_desired').val(pickupTime + ':00');
                            }
                            var hasItems = false;
                            $('#itemTableBody tr').each(function () {
                                var $row = $(this);
                                if ($row.find('td').length > 1 && $row.find('input[name="item_name"]').length) {
                                    var weight = parseFloat($row.find('input[name="weight_kg"]').val()) || 0;
                                    var volume = parseFloat($row.find('input[name="volume_m3"]').val()) || 0;
                                    var price = parseFloat($row.find('input[name="item_price"]').val()) || 0;
                                    if (isNaN(weight) || isNaN(volume) || isNaN(price) || weight < 0 || volume < 0 || price < 0) {
                                        $('#errorMessage').text('Khối lượng, thể tích hoặc giá không hợp lệ.');
                                        $('#successMessage').text('');
                                        e.preventDefault();
                                        return false;
                                    }
                                    hasItems = true;
                                }
                            });
                            if (!hasItems) {
                                $('#errorMessage').text('Vui lòng thêm ít nhất một mặt hàng.');
                                $('#successMessage').text('');
                                e.preventDefault();
                                return;
                            }
                        } catch (err) {
                            console.error("Error validating form:", err);
                            $('#errorMessage').text('Lỗi khi kiểm tra dữ liệu: ' + err.message);
                            $('#successMessage').text('');
                            e.preventDefault();
                        }
                    });

                    $(document).ready(function () {
                        try {
                            console.log("Document ready, initializing event listeners at " + new Date().toLocaleString());
                            $('#itemTableBody tr').each(function () {
                                if ($(this).find('td').length <= 1 || !$(this).find('input[name="item_name"]').val()) {
                                    $(this).remove();
                                }
                            });
                            if ($('#itemTableBody tr').length === 0) {
                                $('#itemTableBody').html('<tr><td colspan="7" class="p-2 text-center text-gray-500">Không có hàng hóa nào được thêm.</td></tr>');
                            }
                            updateTotals();

                            $('#pickup_address').on('input', function () {
                                console.log("Input event fired for pickup_address");
                                $('#successMessage').text('');
                                autocomplete('pickup');
                            }).on('focusout', function () {
                                setTimeout(function () {
                                    $('#pickup_autocomplete').hide();
                                }, 200);
                            });

                            $('#shipping_address').on('input', function () {
                                console.log("Input event fired for shipping_address");
                                $('#successMessage').text('');
                                autocomplete('shipping');
                            }).on('focusout', function () {
                                setTimeout(function () {
                                    $('#shipping_autocomplete').hide();
                                }, 200);
                            });

                            $(document).on('click', function (e) {
                                if (!$(e.target).closest('#pickup_address, #pickup_autocomplete, #shipping_address, #shipping_autocomplete').length) {
                                    $('#pickup_autocomplete, #shipping_autocomplete').hide();
                                }
                            });
                            $('#totalItemPriceLink').on('click', function (e) {
                                e.preventDefault();
                                $('html, body').animate({
                                    scrollTop: $('#serviceDetails').offset().top
                                }, 500);
                            });

                            $('#service_type').on('change', function () {
                                console.log("Service type changed");
                                $('#successMessage').text('');
                                updateServiceAndFee();
                            });
                            $('#addSuggestedItem').on('click', function () {
                                $('#successMessage').text('');
                                addSuggestedItem();
                            });
                            $('#addManualItem').on('click', function () {
                                $('#successMessage').text('');
                                addManualItem();
                            });
                            $(document).on('click', '.remove-item', function () {
                                $('#successMessage').text('');
                                removeItem(this);
                            });
                            $(document).on('input', 'input[name="item_note"]', function () {
                                $('#successMessage').text('');
                                var currentDetails = getOrderDetailsFromSession() || [];
                                updateSessionOrderDetails(currentDetails);
                            });

                            if ($('#pickup_lat').val() && $('#pickup_lng').val() && $('#shipping_lat').val() && $('#shipping_lng').val()) {
                                const pickupLat = parseFloat($('#pickup_lat').val());
                                const pickupLng = parseFloat($('#pickup_lng').val());
                                const shippingLat = parseFloat($('#shipping_lat').val());
                                const shippingLng = parseFloat($('#shipping_lng').val());
                                if (!isNaN(pickupLat) && !isNaN(pickupLng) && !isNaN(shippingLat) && !isNaN(shippingLng)) {
                                    console.log("Initial route calculation with coordinates:", {pickupLat, pickupLng, shippingLat, shippingLng});
                                    updateDistance();
                                } else {
                                    console.warn("Skipping initial route draw due to invalid coordinates");
                                }
                            }
                        } catch (e) {
                            console.error("Error in document ready: ", e);
                            $('#errorMessage').text('Lỗi khởi tạo: ' + e.message);
                            $('#successMessage').text('');
                        }
                    });
                } catch (e) {
                    console.error("Map initialization error: ", e);
                    $('#errorMessage').text('Lỗi khởi tạo bản đồ: ' + e.message);
                    $('#successMessage').text('');
                }
            });
        </script>
    </body>
</html>