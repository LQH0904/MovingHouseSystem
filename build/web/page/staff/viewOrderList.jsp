<%--
    Document   : viewOrderList
    Created on : Jun 21, 2025, 12:43:44 AM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.logging.Logger" %>
<%@ page import="java.util.logging.Level" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
                    
            h2 {
                color: #007bff;
                font-weight: 600;
                text-align: center;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .filter-form .form-control {
                border: 2px solid #e0e7ff;
                border-radius: 10px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            .filter-form .form-control:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            }
            .filter-form label {
                font-weight: 500;
                color: #333;
                margin-bottom: 8px;
            }
            .filter-form .btn-primary {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .filter-form .btn-primary:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.4);
            }
            .filter-form .btn-secondary {
                background: #6c757d;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .filter-form .btn-secondary:hover {
                transform: scale(1.05);
                background: #5a6268;
                box-shadow: 0 4px 12px rgba(108, 117, 125, 0.4);
            }
            .table {
                width: 100%;
                border-collapse: collapse;
                background: #f8f9fa;
                border-radius: 10px;
                overflow: hidden;
            }
            .table thead th {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 15px;
                text-align: center;
                vertical-align: middle;
            }
            .table tbody td {
                background: #ffffff;
                vertical-align: middle;
                padding: 12px;
                color: #333;
                border-bottom: 1px solid #e0e7ff;
                text-align: center;
                overflow: hidden;
                white-space: nowrap;
                text-overflow: ellipsis;
            }
            .table tbody tr:hover {
                background: #e0e7ff;
                transition: background 0.2s ease;
            }
            .table a {
                color: #007bff;
                text-decoration: none;
                font-weight: 500;
            }
            .table a:hover {
                text-decoration: underline;
                color: #0056b3;
            }
            .pagination-wrapper {
                margin: 30px 0;
                display: flex;
                justify-content: center;
            }
            .pagination {
                border-radius: 10px;
                overflow: hidden;
                background: #ffffff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            .pagination .page-link {
                color: #007bff;
                background: #f8f9fa;
                border: none;
                padding: 10px 20px;
                margin: 0 5px;
                border-radius: 8px;
                transition: background-color 0.3s, color 0.3s;
            }
            .pagination .page-link:hover {
                background: #007bff;
                color: white;
            }
            .pagination .page-item.active .page-link {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                color: white;
            }
            .pagination .page-item.disabled .page-link {
                background: #f8f9fa;
                color: #6c757d;
                cursor: not-allowed;
            }
            .status-icon {
                font-size: 1.5rem;
                vertical-align: middle;
            }
            .status-pending {
                color: #ffa500;
            }
            .status-in_progress {
                color: #007bff;
            }
            .status-delivered {
                color: #28a745;
            }
            .status-cancelled {
                color: #dc3545;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            @media (max-width: 768px) {
                .div3.main-content {
                    margin-left: 0;
                    width: 100%;
                    padding: 10px;
                }
                .container-fluid {
                    padding: 15px;
                }
                .table thead th, .table tbody td {
                    font-size: 0.9rem;
                    padding: 8px;
                }
                .filter-form .row > div {
                    margin-bottom: 15px;
                }
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <!-- Sidebar trái -->
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

                <!-- Nội dung chính -->
                <div class="div3 main-content">
                    <div class="container-fluid">
                        <h2>Đơn hàng</h2>

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
                                <th style="width:11%;">ID</th>
                                <th style="width:21%;">Khách hàng</th>
                                <th style="width:16%;">Trạng thái</th>
                                <th style="width:15%;">Ngày tạo</th>
                                <th style="width:11%;">Tổng phí</th>
                                <th style="width:10%;">Ngày giao</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="order" items="${orders}">
                                <tr>
                                    <td>${order.orderId}</td>
                                    <td>${order.customerName != null ? order.customerName : 'N/A'}</td>
                                    
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
                                    <td>${order.totalFee}</td>
                                    <td>${order.deliveredAt != null ? order.deliveredAt : 'N/A'}</td>
                                    <td> <a href="${pageContext.request.contextPath}/order/detailid/${order.orderId}">chi tiết</a> </td>
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