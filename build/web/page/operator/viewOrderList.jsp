<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Tổng quan đơn hàng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: linear-gradient(135deg, #e0e7ff 0%, #ffffff 100%);
                min-height: 100vh;
                margin: 0;
                overflow-x: hidden;
            }
            .parent {
                display: flex;
                flex-wrap: wrap;
                position: relative;
            }
            .div1 {
                position: fixed;
                top: 0;
                left: 0;
                height: 100vh;
                z-index: 1000;
            }
            .div2 {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1001;
            }
            .div3.main-content {
                margin-left: 250px; /* Adjust based on sidebar width */
                margin-top: 70px; /* Adjust based on header height */
                padding: 20px;
                max-height: calc(100vh - 70px);
                overflow-y: auto;
                width: calc(100% - 250px);
                animation: fadeIn 0.8s ease-in-out;
            }
            .container-fluid {
                background: #ffffff;
                padding: 20px;
                border-radius: 20px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
                margin-bottom: 40px;
                width: 100%;
                transition: transform 0.3s ease;
            }
            .container-fluid:hover {
                transform: translateY(-5px);
            }
            h2 {
                color: #007bff;
                font-weight: 600;
                margin-bottom: 30px;
                text-align: center;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .filter-form {
                background: #f8f9fa;
                padding: 20px;
                border-radius: 10px;
                margin-bottom: 30px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            .filter-form .form-control {
                border: 2px solid #e0e7ff;
                border-radius: 10px;
                padding: 12px;
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
            <div class="div1">
                <jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include>
            </div>

            <!-- Header phía trên -->
            <div class="div2">
            <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include>
            </div>

            <!-- Nội dung chính -->
            <div class="div3 main-content">
                <div class="container-fluid">
                    <h2>Tổng quan đơn hàng</h2>

                    <!-- Form lọc -->
                    <form class="filter-form" action="${pageContext.request.contextPath}/orderList" method="get">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label for="status">Trạng thái</label>
                                <select name="status" id="status" class="form-control">
                                    <option value="">Tất cả</option>
                                    <option value="pending" ${status == 'pending' ? 'selected' : ''}>Pending</option>
                                    <option value="in_progress" ${status == 'in_progress' ? 'selected' : ''}>In Progress</option>
                                    <option value="delivered" ${status == 'delivered' ? 'selected' : ''}>Delivered</option>
                                    <option value="cancelled" ${status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="startDate">Từ ngày</label>
                                <input type="date" name="startDate" id="startDate" value="${startDate}" class="form-control">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="endDate">Đến ngày</label>
                                <input type="date" name="endDate" id="endDate" value="${endDate}" class="form-control">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="orderId">ID đơn hàng</label>
                                <input type="text" name="orderId" id="orderId" value="${orderId}" class="form-control" placeholder="Nhập ID đơn hàng">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="transportUnitName">Tên đơn vị vận chuyển</label>
                                <input type="text" name="transportUnitName" id="transportUnitName" value="${transportUnitName}" class="form-control" placeholder="Nhập tên đơn vị vận chuyển">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="warehouseName">Tên đơn vị kho bãi</label>
                                <input type="text" name="warehouseName" id="warehouseName" value="${warehouseName}" class="form-control" placeholder="Nhập tên kho bãi">
                            </div>
                            <div class="col-md-6 align-self-end mb-3">
                                <button type="submit" class="btn btn-primary">Lọc</button>
                                <a href="${pageContext.request.contextPath}/orderList" class="btn btn-secondary ms-2">Xóa bộ lọc</a>
                            </div>
                        </div>
                    </form>

                    <!-- Bảng đơn hàng -->
                    <table class="table table-bordered mt-4">
                        <thead>
                            <tr>
                                <th>ID</th>
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