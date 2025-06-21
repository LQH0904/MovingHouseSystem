<%--
    Document   : viewOrderList
    Created on : Jun 21, 2025, 12:43:44 AM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
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
        <title>Tổng quan đơn hàng</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <link href="https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            body {
                background-color: #F7FAFC;
                font-family: 'Poppins', sans-serif;
                margin: 0;
            }
            .main-content {
                overflow-y: auto;
                padding: 10px;
                max-height: calc(100vh - 60px);
                position: relative;
                z-index: 1;
                width: 100%;
            }
            .container-fluid {
                background: white;
                padding: 15px; 
                border-radius: 12px;
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
                margin-bottom: 40px;
                position: relative;
                z-index: 1;
                clear: both;
                width: 100%; /* Giãn toàn bộ chiều rộng */
            }
            h2 {
                color: #4A00E0;
                font-weight: 700;
                margin-bottom: 25px;
                text-align: center;
            }
            .filter-form {
                background: #E6E6FA;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 25px;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
            }
            .filter-form .form-control {
                border: 2px solid #D6BCFA;
                border-radius: 8px;
                transition: border-color 0.3s ease;
            }
            .filter-form .form-control:focus {
                border-color: #4A00E0;
                box-shadow: 0 0 5px rgba(74, 0, 224, 0.3);
            }
            .filter-form label {
                font-weight: 500;
                color: #2D3748;
            }
            .filter-form .btn-primary {
                background: #4A00E0;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                transition: background 0.3s ease;
            }
            .filter-form .btn-primary:hover {
                background: #3B00B3;
            }
            .filter-form .btn-secondary {
                background: #A0AEC0;
                border: none;
                padding: 10px 20px;
                border-radius: 8px;
                font-weight: 500;
                transition: background 0.3s ease;
            }
            .filter-form .btn-secondary:hover {
                background: #718096;
            }
            .table {
                width: 100%;
                table-layout: fixed;
                border-collapse: collapse;
                margin: 0; /* Loại bỏ margin thừa */
                padding: 0; /* Loại bỏ padding thừa */
            }
            .table thead th {
                background: #4A00E0;
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 15px;
                text-align: center;
                width: 9.09%; /* 100% / 11 cột ≈ 9.09% cho mỗi cột */
                overflow: hidden; /* Ngăn tràn nội dung */
                white-space: nowrap; /* Ngăn xuống dòng */
            }
            .table tbody td {
                background: #F7FAFC;
                vertical-align: middle;
                padding: 12px;
                color: #2D3748;
                border-bottom: 1px solid #E2E8F0;
                text-align: center;
                width: 9.09%;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }
            .table tbody tr:hover {
                background: #EDF2F7;
                transition: background 0.2s ease;
            }
            .table a {
                color: #4A00E0;
                text-decoration: none;
                font-weight: 500;
            }
            .table a:hover {
                text-decoration: underline;
                color: #3B00B3;
            }
            .pagination-wrapper {
                margin-top: 30px;
                margin-bottom: 20px;
                display: flex;
                justify-content: center;
                position: relative;
                z-index: 1;
                clear: both;
            }
            .pagination-wrapper .pagination {
                margin: 0;
            }
            .pagination-wrapper .page-link {
                color: #4A00E0;
                background: #E6E6FA;
                border: 1px solid #D6BCFA;
                border-radius: 8px;
                margin: 0 5px;
                padding: 8px 16px;
                transition: all 0.3s ease;
            }
            .pagination-wrapper .page-link:hover {
                background: #4A00E0;
                color: white;
                border-color: #4A00E0;
            }
            .pagination-wrapper .page-item.active .page-link {
                background: #4A00E0;
                color: white;
                border-color: #4A00E0;
            }
            .pagination-wrapper .page-item.disabled .page-link {
                background: #EDF2F7;
                color: #A0AEC0;
                border-color: #E2E8F0;
            }
            .status-icon {
                font-size: 1.5rem;
                vertical-align: middle;
            }
            .status-pending {
                color: #FFA500;
            } /* Orange for pending */
            .status-in_progress {
                color: #1E90FF;
            } /* Blue for in_progress */
            .status-delivered {
                color: #28A745;
            } /* Green for delivered */
            .status-cancelled {
                color: #DC3545;
            } /* Red for cancelled */

            @media (max-width: 768px) {
                .table thead th, .table tbody td {
                    width: auto;
                    min-width: 80px;
                    padding: 8px;
                }
                .container-fluid {
                    padding: 10px;
                }
                .main-content {
                    padding: 5px;
                }
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <!-- Sidebar trái -->
            <div class="div1">
                <jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
                </div>

                <!-- Header phía trên -->
                <div class="div2">
                <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
                </div>

                <!-- Nội dung chính -->
                <div class="div3 main-content">
                    <div class="container-fluid">
                        <h2>Tổng quan đơn hàng</h2>

                        <!-- Form lọc -->
                        <form class="filter-form" action="${pageContext.request.contextPath}/orderList" method="get">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label>Trạng thái</label>
                                <select name="status" class="form-control">
                                    <option value="">Tất cả</option>
                                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="in_progress" ${status == 'in_progress' ? 'selected' : ''}>In Progress</option>
                                    <option value="delivered" ${status == 'delivered' ? 'selected' : ''}>Delivered</option>
                                    <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label>Từ ngày</label>
                                <input type="date" name="startDate" value="${startDate}" class="form-control">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label>Đến ngày</label>
                                <input type="date" name="endDate" value="${endDate}" class="form-control">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label>ID đơn hàng</label>
                                <input type="text" name="orderId" value="${orderId}" class="form-control" placeholder="Nhập ID đơn hàng">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label>Tên đơn vị vận chuyển</label>
                                <input type="text" name="transportUnitName" value="${transportUnitName}" class="form-control" placeholder="Nhập tên đơn vị vận chuyển">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label>Tên đơn vị kho bãi</label>
                                <input type="text" name="warehouseName" value="${warehouseName}" class="form-control" placeholder="Nhập tên kho bãi">
                            </div>
                            <div class="col-md-6 align-self-end mb-3">
                                <button type="submit" class="btn btn-primary">Lọc</button>
                                <a href="${pageContext.request.contextPath}/orderList" class="btn btn-secondary ml-2">Xóa bộ lọc</a>
                            </div>
                        </div>
                    </form>

                    <!-- Bảng đơn hàng -->
                    <table class="table table-bordered mt-4">
                        <thead>
                            <tr>
                                <th>ID Đơn hàng</th>
                                <th>Khách hàng</th>
                                <th>Đơn vị vận chuyển</th>
                                <th>Đơn vị kho bãi</th>
                                <th>Trạng thái</th>
                                <th>Ngày tạo</th>
                                <th>Ngày cập nhật</th>
                                <th>Lịch giao</th>
                                <th>Tổng phí</th>
                                <th>Ngày chấp nhận</th>
                                <th>Ngày giao</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.customerName != null ? order.customerName : 'N/A'}</td>
                                    <td>${order.transportUnitName != null && !order.transportUnitName.equals('Chưa chỉ định') ? order.transportUnitName : 'Chưa chỉ định'}</td>
                                    <td>${order.storageUnitName != null ? order.storageUnitName : 'N/A'}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${order.orderStatus == 'pending'}">
                                                <i class='bx bx-time-five status-icon status-pending' title="Pending"></i>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'in_progress'}">
                                                <i class='bx bx-loader-circle status-icon status-in_progress' title="In Progress"></i>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'delivered'}">
                                                <i class='bx bx-check-circle status-icon status-delivered' title="Delivered"></i>
                                            </c:when>
                                            <c:when test="${order.orderStatus == 'cancelled'}">
                                                <i class='bx bx-x-circle status-icon status-cancelled' title="Cancelled"></i>
                                            </c:when>
                                            <c:otherwise>
                                                ${order.orderStatus}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${order.createdAt}</td>
                                    <td>${order.updatedAt != null ? order.updatedAt : 'N/A'}</td>
                                    <td>${order.deliverySchedule != null ? order.deliverySchedule : 'N/A'}</td>
                                    <td>${order.totalFee}</td>
                                    <td>${order.acceptedAt != null ? order.acceptedAt : 'N/A'}</td>
                                    <td>${order.deliveredAt != null ? order.deliveredAt : 'N/A'}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>

                    <!-- Phân trang -->
                    <div class="pagination-wrapper">
                        <ul class="pagination">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/orderList?page=${currentPage - 1}&status=${status}&startDate=${startDate}&endDate=${endDate}&transportUnitName=${transportUnitName}&warehouseName=${warehouseName}&orderId=${orderId}&sortBy=${sortBy}&sortOrder=${sortOrder}">Previous</a>
                            </li>
                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${pageContext.request.contextPath}/orderList?page=${i}&status=${status}&startDate=${startDate}&endDate=${endDate}&transportUnitName=${transportUnitName}&warehouseName=${warehouseName}&orderId=${orderId}&sortBy=${sortBy}&sortOrder=${sortOrder}">${i}</a>
                                </li>
                            </c:forEach>
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/orderList?page=${currentPage + 1}&status=${status}&startDate=${startDate}&endDate=${endDate}&transportUnitName=${transportUnitName}&warehouseName=${warehouseName}&orderId=${orderId}&sortBy=${sortBy}&sortOrder=${sortOrder}">Next</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>