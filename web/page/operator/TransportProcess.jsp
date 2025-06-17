<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
                    <!-- Thong tin cơ bản của đơn hàng  -->
                    <div class="card">
                        <h3><i class="bi bi-grid-1x2"></i>Thông tin đơn hàng</h3>
                        <div class="info-row">
                            <div class="info-col">
                                <label>Mã Đơn hàng:</label>
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

                    <!-- Thong tin cơ bản của đơn hàng  -->

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

                                <c:if test="${not empty tp}">
                                    <div class="row mb-4">
                                        <div class="col-md-6 mb-3">
                                            <i class="bi bi-geo-alt-fill text-info me-2"></i><strong>Địa chỉ nhận:</strong>
                                            <p><c:out value="${tp.pickupLocation}" /></p>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <i class="bi bi-calendar-event-fill text-success me-2"></i><strong>Ngày nhận:</strong>
                                            <p><c:out value="${tp.pickupDate}" /></p>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <i class="bi bi-building-fill text-warning me-2"></i><strong>Địa chỉ kho:</strong>
                                            <p><c:out value="${tp.warehouseLocation}" /></p>
                                        </div>
                                        <div class="col-md-6">
                                            <i class="bi bi-box-arrow-in-down text-danger me-2"></i><strong>Ngày nhập kho:</strong>
                                            <p><c:out value="${tp.warehouseDate}" /></p>
                                        </div>
                                    </div>

                                    <div class="map-container border rounded overflow-hidden">
                                        <iframe 
                                            src="${tp.pickupWarehouseDist}" 
                                            style="width: 100%; height: 500px; border: none;" 
                                            allowfullscreen 
                                            loading="lazy">
                                        </iframe>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Chi tiết 2: Kho → Địa chỉ trả -->
                        <div id="detail2" class="detail-box card shadow-sm border-0 mt-4" style="display: none;">
                            <div class="card-body">
                                <h5 class="card-title mb-4 text-primary">
                                    <i class="bi bi-truck-flatbed me-2"></i>Thông tin: Kho → Địa chỉ trả
                                </h5>

                                <c:if test="${not empty tp}">
                                    <div class="row mb-4">
                                        <div class="col-md-6 mb-3">
                                            <i class="bi bi-building-fill text-info me-2"></i><strong>Địa chỉ kho:</strong>
                                            <p><c:out value="${tp.warehouseLocation}" /></p>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <i class="bi bi-calendar-check-fill text-success me-2"></i><strong>Ngày nhập kho:</strong>
                                            <p><c:out value="${tp.warehouseDate}" /></p>
                                        </div>
                                        <div class="col-md-6 mb-3">
                                            <i class="bi bi-geo-alt-fill text-info me-2"></i><strong>Địa chỉ trả:</strong>
                                            <p><c:out value="${tp.shippingLocation}" /></p>
                                        </div>
                                        <div class="col-md-6">
                                            <i class="bi bi-calendar-fill text-danger me-2"></i><strong>Ngày trả:</strong>
                                            <p><c:out value="${tp.shippingDate}" /></p>
                                        </div>
                                    </div>

                                    <div class="map-container border rounded overflow-hidden">
                                        <iframe 
                                            src="${tp.warehouseShippingDist}" 
                                            style="width: 100%; height: 500px; border: none;" 
                                            allowfullscreen 
                                            loading="lazy">
                                        </iframe>
                                    </div>
                                </c:if>
                            </div>
                        </div>


                    </div>
                </div>
            </div>
        </div>
    </body>
    <script src="${pageContext.request.contextPath}/js/operator/TransportProcess.js"></script>
</html>
