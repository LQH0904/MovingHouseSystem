<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Transport Process</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/TransportProcess.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">

    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
                <div class="container">
                    <div class="card">
                        <h3>Thông tin đơn hàng</h3>
                        <div class="info-row">
                            <div class="info-col">
                                <label>ID Đơn hàng:</label>
                                <p>${order.orderId}</p>
                            </div>
                            <div class="info-col">
                                <label>Đơn vị vận chuyển:</label>
                                <p>${order.transportCompanyName}</p>
                            </div>
                            <div class="info-col">
                                <label>Kho bãi:</label>
                                <p>${order.warehouseName}</p>
                            </div>
                            <div class="info-col">
                                <label>Khách hàng:</label>
                                <p>${order.customerName}</p>
                            </div>

                        </div>
                    </div>

                    <div class="card">
                        <h3 class="mb-4 text-primary"><i class="bi bi-diagram-3-fill me-2"></i>Quy trình vận chuyển</h3>

                        <div class="process-container d-flex justify-content-between align-items-center flex-wrap gap-3">

                            <!-- Bước 1 -->
                            <div class="step text-center">
                                <div class="circle bg-info text-white">
                                    <i class="bi bi-geo-alt-fill fs-4"></i>
                                </div>
                                <div class="label mt-2 text-secondary">Địa chỉ nhận</div>
                            </div>

                            <!-- Line 1 -->
                            <a href="#" class="line-clickable" data-target="detail1" title="Xem chi tiết tuyến đường 1">
                                <i></i>
                            </a>

                            <!-- Bước 2 -->
                            <div class="step text-center">
                                <div class="circle bg-warning text-white">
                                    <i class="bi bi-building-fill fs-4"></i>
                                </div>
                                <div class="label mt-2 text-secondary">Kho</div>
                            </div>

                            <!-- Line 2 -->
                            <a href="#" class="line-clickable" data-target="detail2" title="Xem chi tiết tuyến đường 2">
                                <i></i>
                            </a>

                            <!-- Bước 3 -->
                            <div class="step text-center">
                                <div class="circle bg-success text-white">
                                    <i class="bi bi-house-door-fill fs-4"></i>
                                </div>
                                <div class="label mt-2 text-secondary">Địa chỉ trả</div>
                            </div>
                        </div>


                        <!-- Chi tiết 1: Địa chỉ nhận → Kho -->
                        <div id="detail1" class="detail-box card shadow-sm border-0 mt-4" style="display: none;">
                            <div class="card-body">
                                <h5 class="card-title mb-4 text-primary">
                                    <i class="bi bi-truck-front-fill me-2"></i>Thông tin: Địa chỉ nhận → Kho
                                </h5>

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3">
                                        <i class="bi bi-geo-alt-fill text-info me-2"></i><strong>Địa chỉ nhận:</strong> 123 Láng Hạ, Hà Nội
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <i class="bi bi-calendar-event-fill text-success me-2"></i><strong>Ngày nhận:</strong> 15/06/2025
                                    </div>
                                    <div class="col-md-6">
                                        <i class="bi bi-box-arrow-in-down text-warning me-2"></i><strong>Ngày nhập kho:</strong> 16/06/2025
                                    </div>
                                </div>

                                <div class="map-container border rounded overflow-hidden">
                                    <iframe 
                                        src="https://www.google.com/maps/embed?pb=!1m28!1m12!1m3!1d14898.806800799142!2d105.51549388975474!3d21.00459132221299!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m13!3e6!4m5!1s0x31345b996e8db849%3A0xe69a2e597e2e3382!2zS2h1IHF1w6JuIHPhu7EgxJBIUUcgSG_DoCBM4bqhYyAoSG9sYSk!3m2!1d20.999808599999998!2d105.5194564!4m5!1s0x31345b12ef6dfebd%3A0xca27c2be63cf4db4!2zVHJ1bmcgVMOibSDEkOG7lWkgTeG7m2kgU8OhbmcgVOG6oW8gUXXhu5Fj4oCm!3m2!1d21.0106543!2d105.5316046!5e0!3m2!1sen!2s!4v1750173648646!5m2!1sen!2s"
                                        style="width: 100%; height: 500px; border: none;"
                                        allowfullscreen
                                        loading="lazy">
                                    </iframe>
                                </div>
                            </div>
                        </div>

                        <!-- Chi tiết 2: Kho → Địa chỉ trả -->
                        <div id="detail2" class="detail-box card shadow-sm border-0 mt-4" style="display: none;">
                            <div class="card-body">
                                <h5 class="card-title mb-4 text-primary">
                                    <i class="bi bi-truck-flatbed me-2"></i>Thông tin: Kho → Địa chỉ trả
                                </h5>

                                <div class="row mb-4">
                                    <div class="col-md-6 mb-3">
                                        <i class="bi bi-building-fill text-info me-2"></i><strong>Địa chỉ kho:</strong> Kho Hà Nội - Mỹ Đình
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <i class="bi bi-calendar-check-fill text-success me-2"></i><strong>Ngày nhập kho:</strong> 16/06/2025
                                    </div>
                                    <div class="col-md-6 mb-3">
                                        <i class="bi bi-geo-alt-fill text-info me-2"></i><strong>Địa chỉ trả:</strong> 789 Cầu Giấy, Hà Nội
                                    </div>
                                    <div class="col-md-6">
                                        <i class="bi bi-calendar-fill text-danger me-2"></i><strong>Ngày trả:</strong> 17/06/2025
                                    </div>
                                </div>

                                <div class="map-container border rounded overflow-hidden">
                                    <iframe 
                                        src="https://www.google.com/maps/embed?pb=!1m24!1m12!1m3!1d238385.53608285185!2d105.50995151955694!3d21.001694491153074!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m9!3e0!4m3!3m2!1d21.0002043!2d105.5206437!4m3!3m2!1d21.0002392!2d105.82909289999999!5e0!3m2!1sen!2s!4v1750173765352!5m2!1sen!2s"
                                        style="width: 100%; height: 500px; border: none;"
                                        allowfullscreen
                                        loading="lazy">
                                    </iframe>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </body>
    <script src="${pageContext.request.contextPath}/js/operator/TransportProcess.js"></script>
</html>
