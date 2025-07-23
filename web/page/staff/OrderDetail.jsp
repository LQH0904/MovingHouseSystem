<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <div class="container-fluid">
                    <!-- Page Header -->
                    <div class="page-header">
                        <div class="container">
                            <div class="row">
                                <div class="col-12 d-flex justify-content-between align-items-center">
                                    <h1 class="page-title">
                                        <i class="fas fa-receipt me-2"></i>
                                        Chi tiết đơn hàng
                                    </h1>
                                    <!-- New button added in the header area -->
                                    <a href="${pageContext.request.contextPath}/order/detail/item/${orderDetail.orderId}" class="item-button management-btn">
                                        <i class="fas fa-cog"></i>
                                        Thông tin đồ vật
                                    </a>
                                    
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
                                    <div class="card-header-custom ">
                                        <i class="fas fa-info-circle me-2"></i>Thông tin đơn hàng  
                                        <a href="${pageContext.request.contextPath}/order/process/${orderDetail.orderId}" class="tracking-button">
                                            <i class="fas fa-route"></i>
                                            Quá Trình vận chuyển
                                        </a>
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

                                                <!-- Status display with dynamic colors -->
                                                <div class="info-item">
                                                    <div class="info-icon icon-success">
                                                        <i class="fas fa-check-circle"></i>
                                                    </div>
                                                    <div class="info-content">
                                                        <div class="info-label">Trạng thái</div>
                                                        <div class="info-value">
                                                            <!-- Dynamic status badge -->
                                                            <c:choose>
                                                                <c:when test="${orderDetail.orderStatus == 'delivered'}">
                                                                    <span class="status-badge status-delivered">
                                                                        <i class="fas fa-check"></i>
                                                                        Đã giao
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${orderDetail.orderStatus == 'in_progress'}">
                                                                    <span class="status-badge status-in-progress">
                                                                        <i class="fas fa-truck"></i>
                                                                        Đang giao hàng
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${orderDetail.orderStatus == 'pending'}">
                                                                    <span class="status-badge status-pending">
                                                                        <i class="fas fa-clock"></i>
                                                                        Chờ xử lý
                                                                    </span>
                                                                </c:when>
                                                                <c:when test="${orderDetail.orderStatus == 'cancelled'}">
                                                                    <span class="status-badge status-cancelled">
                                                                        <i class="fas fa-times"></i>
                                                                        Đã hủy
                                                                    </span>
                                                                </c:when>

                                                            </c:choose>
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

                                <!-- Thông tin khách hàng  -->
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

                            <!-- Thông tin Kho & Vận Chuyển  -->
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
                        </div> 

                        <!-- Lịch sử giao hàng  -->
                        <div class="row mt-3">
                            <div class="col-12">
                                <div class="info-card">
                                    <div class="card-header-custom">
                                        <i class="fas fa-history me-2"></i>
                                        Lịch sử giao hàng
                                    </div>
                                    <div class="card-body-custom">
                                        <c:choose>
                                            <%-- Trạng Thái Delivered --%>
                                            <c:when test="${orderDetail.orderStatus == 'delivered'}">
                                                <div class="timeline-horizontal status-delivered">
                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-plus"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đơn hàng được tạo</h6>
                                                            <small>${orderDetail.createdAt}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check-circle"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đã xác nhận</h6>
                                                            <small>${orderDetail.acceptedAt}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-truck"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đang giao hàng</h6>
                                                            <small>${orderDetail.deliverySchedule}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đã giao hàng</h6>
                                                            <small>${orderDetail.deliveredAt}</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>

                                            <%-- Trạng Thái Inprocess --%>
                                            <c:when test="${orderDetail.orderStatus == 'in_progress'}">
                                                <div class="timeline-horizontal status-in-progress">
                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-plus"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đơn hàng được tạo</h6>
                                                            <small>${orderDetail.createdAt}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check-circle"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đã xác nhận</h6>
                                                            <small>${orderDetail.acceptedAt}</small>
                                                        </div>
                                                    </div>                                                    

                                                    <div class="timeline-item-horizontal active">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-truck"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đang giao hàng</h6>
                                                            <small>Đang thực hiện...</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đã giao hàng </h6>
                                                            <small>Chờ thực hiện</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>

                                            <%-- Trạng Thái Pending --%>
                                            <c:when test="${orderDetail.orderStatus == 'pending'}">
                                                <div class="timeline-horizontal status-pending">
                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-plus"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đơn hàng được tạo</h6>
                                                            <small>${orderDetail.createdAt}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal active">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-clock"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Chờ xác nhận</h6>
                                                            <small>Đang xử lý...</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-truck"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Giao hàng</h6>
                                                            <small>Chờ thực hiện</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Hoàn thành</h6>
                                                            <small>Chờ thực hiện</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:when>

                                            <%-- Trạng Thái CANCELLED  --%>
                                            <c:when test="${orderDetail.orderStatus == 'cancelled'}">
                                                <div class="timeline-horizontal status-cancelled">
                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-plus"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đơn hàng được tạo</h6>
                                                            <small>${orderDetail.createdAt}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal completed">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check-circle"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đã xác nhận</h6>
                                                            <small></small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal cancelled">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-times"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đã hủy</h6>
                                                            <small></small>
                                                        </div>
                                                    </div>


                                                </div>
                                            </c:when>

                                            <%-- DEFAULT/ORDER_STATUS TIMELINE --%>
                                            <c:otherwise>
                                                <div class="timeline-horizontal status-order-status">
                                                    <div class="timeline-item-horizontal active">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-plus"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đơn hàng được tạo</h6>
                                                            <small>${orderDetail.createdAt}</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-clock"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Chờ xử lý</h6>
                                                            <small>Sẽ được xử lý sớm</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-box"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Đóng gói</h6>
                                                            <small>Chờ thực hiện</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-truck"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Giao hàng</h6>
                                                            <small>Chờ thực hiện</small>
                                                        </div>
                                                    </div>

                                                    <div class="timeline-item-horizontal pending">
                                                        <div class="timeline-icon">
                                                            <i class="fas fa-check"></i>
                                                        </div>
                                                        <div class="timeline-content">
                                                            <h6>Hoàn thành</h6>
                                                            <small>Chờ thực hiện</small>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>
                            </div>
                        </div>                     
                    </div>
                </div>
            </div>
        </div>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/order-detail.js"></script>
    </body>
</html>