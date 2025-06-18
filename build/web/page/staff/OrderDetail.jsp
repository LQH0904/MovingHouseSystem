<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Order Detail</title>        
        <!-- Font Awesome Icons -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <!-- Google Fonts -->
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/OrderDetail.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
                <div class="container-fluid">
                    <!-- Page Header -->
                    <div class="page-header">
                        <div class="container">
                            <div class="row">
                                <div class="col-12">
                                    <h1 class="page-title">
                                        <i class="fas fa-receipt me-2"></i>
                                        Chi tiết đơn hàng
                                    </h1>                                    
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Main Content -->
                    <div class="container main-container">
    <div class="row">
        <!-- Left Column - Order & Customer Info -->
        <div class="col-lg-8">
            <!-- Order Information -->
            <div class="info-card">
                <div class="card-header-custom">
                    <i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng
                </div>
                <div class="card-body-custom">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-icon icon-primary">
                                    <i class="fas fa-hashtag"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Mã đơn hàng</div>
                                    <div class="info-value">${orderDetail.orderId}</div>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-icon icon-success">
                                    <i class="fas fa-check-circle"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Trạng thái</div>
                                    <div class="info-value">
                                        <span class="status-badge status-delivered">
                                            <i class="fas fa-check"></i> Đã giao
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-icon icon-info">
                                    <i class="fas fa-calendar-plus"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Ngày tạo</div>
                                    <div class="info-value">${orderDetail.createdAt}</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-icon icon-warning">
                                    <i class="fas fa-clock"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Ngày cập nhật</div>
                                    <div class="info-value">${orderDetail.updatedAt}</div>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-icon icon-purple">
                                    <i class="fas fa-truck"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Lịch giao hàng</div>
                                    <div class="info-value">${orderDetail.deliverySchedule}</div>
                                </div>
                            </div>

                            <div class="info-item">
                                <div class="info-icon icon-success">
                                    <i class="fas fa-dollar-sign"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Tổng tiền</div>
                                    <div class="info-value total-amount">
                                        <fmt:formatNumber value="${orderDetail.totalFee}" type="currency" currencySymbol="₫" groupingUsed="true"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Customer Information -->
            <div class="info-card">
                <div class="card-header-custom">
                    <i class="fas fa-user me-2"></i>Thông tin khách hàng
                </div>
                <div class="card-body-custom">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-icon icon-info">
                                    <i class="fas fa-user-circle"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Họ và tên</div>
                                    <div class="info-value">${orderDetail.customerName}</div>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="info-item">
                                <div class="info-icon icon-success">
                                    <i class="fas fa-phone"></i>
                                </div>
                                <div class="info-content">
                                    <div class="info-label">Số điện thoại</div>
                                    <div class="info-value">${orderDetail.customerPhone}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Right Column - Shipping & Warehouse -->
        <div class="col-lg-4">
            <div class="info-card">
                <div class="card-header-custom">
                    <i class="fas fa-shipping-fast me-2"></i>Vận chuyển & Kho
                </div>
                <div class="card-body-custom">
                    <!-- Shipping Information -->
                    <div class="mb-3">
                        <h6 class="section-title text-primary">
                            <i class="fas fa-truck me-2"></i>Thông tin vận chuyển
                        </h6>

                        <div class="info-item">
                            <div class="info-icon icon-primary">
                                <i class="fas fa-id-badge"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Mã đơn vị</div>
                                <div class="info-value">${orderDetail.transportUnitId}</div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon icon-success">
                                <i class="fas fa-building"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Tên công ty</div>
                                <div class="info-value">${orderDetail.transportCompanyName}</div>
                            </div>
                        </div>
                    </div>

                    <hr class="section-divider">

                    <!-- Warehouse Information -->
                    <div>
                        <h6 class="section-title text-info">
                            <i class="fas fa-warehouse me-2"></i>Thông tin kho hàng
                        </h6>

                        <div class="info-item">
                            <div class="info-icon icon-info">
                                <i class="fas fa-hashtag"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Mã kho</div>
                                <div class="info-value">${orderDetail.storageUnitId}</div>
                            </div>
                        </div>

                        <div class="info-item">
                            <div class="info-icon icon-success">
                                <i class="fas fa-store"></i>
                            </div>
                            <div class="info-content">
                                <div class="info-label">Tên kho</div>
                                <div class="info-value">${orderDetail.warehouseName}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div> <!-- end row -->
</div>
                </div>
            </div>
        </div>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/order-detail.js"></script>
    </body>
</html>