<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
    int currentUserId = userAccount.getUserId();
    String currentUsername = userAccount.getUsername();
    int currentUserRoleId = userAccount.getRoleId(); // Thêm dòng này để lấy role_id
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Xuất dữ liệu</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet" onerror="this.onerror=null; this.href='${pageContext.request.contextPath}/css/bootstrap.min.css';">
        <!-- Boxicons CSS -->
        <link href="https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css" rel="stylesheet">
        <!-- Poppins Font -->
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            .div1 {
                position: fixed;
                top: 60px;
                left: 0;
                height: 100vh;
                z-index: 1000;
                background-color: #E6F0FA;
                margin-right: 100px;
            }
            .div2 {
                position: fixed;
                top: 0;
                left: 0;
                right: 0;
                z-index: 1001;
            }
            .div3.main-content {
                margin-left: 280px;
                margin-top: 70px;
                padding: 20px;
                max-height: calc(100vh - 70px);
                overflow-y: auto;
                width: calc(100% - 250px);
                animation: fadeIn 0.8s ease-in-out;
                z-index: 0;
            }
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
            .filter-form .btn {
                margin-right: 10px;
                margin-bottom: 10px;
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
            .filter-form .btn-success {
                background-color: #28a745;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .filter-form .btn-success:hover {
                transform: scale(1.05);
                background-color: #218838;
                box-shadow: 0 4px 12px rgba(40, 167, 69, 0.4);
            }
            .filter-form .btn-info {
                background-color: #17a2b8;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .filter-form .btn-info:hover {
                transform: scale(1.05);
                background-color: #138496;
                box-shadow: 0 4px 12px rgba(23, 162, 184, 0.4);
            }
            .filter-form .btn-warning {
                background-color: #ffc107;
                border: none;
                padding: 12px 24px;
                border-radius: 10px;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .filter-form .btn-warning:hover {
                transform: scale(1.05);
                background-color: #e0a800;
                box-shadow: 0 4px 12px rgba(255, 193, 7, 0.4);
            }
            .form-check-inline {
                margin-right: 15px;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
            }
            .form-check-label {
                font-size: 1rem;
                margin-left: 8px;
                color: #333;
                vertical-align: middle;
                display: inline-block;
                font-family: 'Poppins', sans-serif;
            }
            .form-check-input {
                transform: scale(1.2);
                margin-top: 2px;
            }
            #columns-checkboxes {
                padding: 10px;
                background-color: #f8f9fa;
                border-radius: 8px;
                min-height: 50px;
                display: flex;
                flex-wrap: wrap;
            }
            .column-group {
                display: none;
            }
            .column-group.active {
                display: flex;
            }
            #loadingOverlay {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                z-index: 2000;
            }
            #loadingOverlay div {
                position: absolute;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                color: white;
            }
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
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
                .form-check-inline {
                    display: block;
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
            <div class="div3 main-content">
                <div class="container-fluid">
                    <h2>Xuất dữ liệu</h2>
                    <p class="text-muted">Chọn bảng, định dạng, và các cột cần xuất. Bạn có thể lọc dữ liệu bằng trạng thái, ngày, hoặc từ khóa.</p>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger">${error}</div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/exportData" method="post" class="filter-form">
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label for="table">Chọn bảng</label>
                                <select name="table" id="table" class="form-control" onchange="updateColumns(); updateRecordCount()">
                                    <option value="orders">Đơn hàng</option>
                                    <option value="customerSurvey">Phản hồi khách hàng</option>
                                    <option value="transportReport">Báo cáo vận chuyển</option>
                                    <option value="storageReport">Báo cáo kho bãi</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="format">Định dạng file</label>
                                <select name="format" id="format" class="form-control">
                                    <option value="excel">Excel (.xlsx)</option>
                                    <option value="pdf">PDF (.pdf)</option>
                                    <option value="word">Word (.docx)</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="email">Gửi qua email</label>
                                <input type="email" name="email" id="email" class="form-control" placeholder="Nhập email">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12 mb-3">
                                <label>Chọn cột hiển thị <small class="text-muted">(Chọn các cột bạn muốn xuất trong file)</small></label>
                                <input type="text" id="columnSearch" class="form-control mb-2" placeholder="Tìm cột...">
                                <div id="columns-checkboxes" class="d-flex flex-wrap">
                                    <div class="column-group" data-table="orders">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="order_id" id="col_orders_0">
                                            <label class="form-check-label" for="col_orders_0">ID Đơn hàng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="customer_id" id="col_orders_1">
                                            <label class="form-check-label" for="col_orders_1">ID Khách hàng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="customer_name" id="col_orders_2">
                                            <label class="form-check-label" for="col_orders_2">Tên Khách hàng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="transport_unit_name" id="col_orders_3">
                                            <label class="form-check-label" for="col_orders_3">Đơn vị vận chuyển</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="storage_unit_name" id="col_orders_4">
                                            <label class="form-check-label" for="col_orders_4">Tên kho bãi</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="order_status" id="col_orders_5">
                                            <label class="form-check-label" for="col_orders_5">Trạng thái</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="created_at" id="col_orders_6">
                                            <label class="form-check-label" for="col_orders_6">Ngày tạo</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="total_fee" id="col_orders_7">
                                            <label class="form-check-label" for="col_orders_7">Tổng phí</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="delivered_at" id="col_orders_8">
                                            <label class="form-check-label" for="col_orders_8">Ngày giao</label>
                                        </div>
                                    </div>
                                    <div class="column-group" data-table="customerSurvey">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="survey_id" id="col_survey_0">
                                            <label class="form-check-label" for="col_survey_0">ID Khảo sát</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="survey_date" id="col_survey_1">
                                            <label class="form-check-label" for="col_survey_1">Ngày khảo sát</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="user_id" id="col_survey_2">
                                            <label class="form-check-label" for="col_survey_2">ID Người dùng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="overall_satisfaction" id="col_survey_3">
                                            <label class="form-check-label" for="col_survey_3">Mức độ hài lòng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="feedback" id="col_survey_4">
                                            <label class="form-check-label" for="col_survey_4">Phản hồi</label>
                                        </div>
                                    </div>
                                    <div class="column-group" data-table="transportReport">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="report_id" id="col_transport_0">
                                            <label class="form-check-label" for="col_transport_0">ID Báo cáo</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="transport_unit_id" id="col_transport_1">
                                            <label class="form-check-label" for="col_transport_1">ID Đơn vị vận chuyển</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="company_name" id="col_transport_2">
                                            <label class="form-check-label" for="col_transport_2">Tên công ty</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="report_year" id="col_transport_3">
                                            <label class="form-check-label" for="col_transport_3">Năm</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="report_month" id="col_transport_4">
                                            <label class="form-check-label" for="col_transport_4">Tháng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="total_shipments" id="col_transport_5">
                                            <label class="form-check-label" for="col_transport_5">Tổng số chuyến</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="total_revenue" id="col_transport_6">
                                            <label class="form-check-label" for="col_transport_6">Tổng doanh thu</label>
                                        </div>
                                    </div>
                                    <div class="column-group" data-table="storageReport">
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="report_date" id="col_storage_0">
                                            <label class="form-check-label" for="col_storage_0">Ngày báo cáo</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="storage_unit_id" id="col_storage_1">
                                            <label class="form-check-label" for="col_storage_1">ID Kho bãi</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="warehouse_name" id="col_storage_2">
                                            <label class="form-check-label" for="col_storage_2">Tên kho bãi</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="quantity_on_hand" id="col_storage_3">
                                            <label class="form-check-label" for="col_storage_3">Số lượng tồn kho</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="used_area" id="col_storage_4">
                                            <label class="form-check-label" for="col_storage_4">Diện tích sử dụng</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="total_area" id="col_storage_5">
                                            <label class="form-check-label" for="col_storage_5">Tổng diện tích</label>
                                        </div>
                                        <div class="form-check form-check-inline">
                                            <input class="form-check-input" type="checkbox" name="columns" value="profit" id="col_storage_6">
                                            <label class="form-check-label" for="col_storage_6">Lợi nhuận</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3 mb-3">
                                <label for="status">Trạng thái</label>
                                <select name="status" id="status" class="form-control">
                                    <option value="">Tất cả</option>
                                    <option value="pending">Pending</option>
                                    <option value="in_progress">In Progress</option>
                                    <option value="delivered">Delivered</option>
                                    <option value="cancelled">Cancelled</option>
                                </select>
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="startDate">Từ ngày</label>
                                <input type="date" name="startDate" id="startDate" class="form-control" value="">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="endDate">Đến ngày</label>
                                <input type="date" name="endDate" id="endDate" class="form-control" value="">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="keyword">Từ khóa</label>
                                <input type="text" name="keyword" id="keyword" class="form-control" placeholder="Nhập từ khóa" value="">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="transportUnitName">Đơn vị vận chuyển</label>
                                <input type="text" name="transportUnitName" id="transportUnitName" class="form-control" placeholder="Nhập tên đơn vị vận chuyển" value="">
                            </div>
                            <div class="col-md-3 mb-3">
                                <label for="warehouseName">Tên kho bãi</label>
                                <input type="text" name="warehouseName" id="warehouseName" class="form-control" placeholder="Nhập tên kho bãi" value="">
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <button type="submit" class="btn btn-primary">Xuất dữ liệu</button>
                                <button type="button" class="btn btn-secondary ms-2" onclick="selectAllColumns()">Chọn tất cả</button>
                                <button type="button" class="btn btn-secondary ms-2" onclick="deselectAllColumns()">Bỏ chọn tất cả</button>
                                <button type="button" class="btn btn-success ms-2" id="saveConfig">Lưu Cấu Hình</button>
                                <button type="button" class="btn btn-info ms-2" id="loadConfig">Tải Cấu Hình</button>
                                <button type="button" class="btn btn-warning ms-2" id="previewData">Xem trước</button>
                            </div>
                            <div class="col-md-6 mb-3">
                                <p id="recordCount" class="text-info"></p>
                            </div>
                        </div>
                    </form>
                    <div id="previewContainer" class="mt-3" style="display: none;">
                        <h4>Kết quả xem trước</h4>
                        <table class="table table-striped" id="previewTable"></table>
                        <button type="button" class="btn btn-secondary mt-2" onclick="document.getElementById('previewContainer').style.display = 'none'">Đóng</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="loadingOverlay" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 2000;">
            <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); color: white;">Đang xử lý...</div>
        </div>
        <!-- jQuery and Bootstrap JS -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-3.6.0.min.js" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/js/jquery-3.6.0.min.js';"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/js/bootstrap.bundle.min.js';"></script>
        <script>
                            function updateColumns() {
                                const table = document.getElementById('table').value;
                                const columnGroups = document.querySelectorAll('.column-group');
                                document.querySelectorAll('.column-group input[type="checkbox"]').forEach(checkbox => {
                                    checkbox.checked = false;
                                });
                                columnGroups.forEach(group => {
                                    if (group.getAttribute('data-table') === table) {
                                        group.classList.add('active');
                                    } else {
                                        group.classList.remove('active');
                                    }
                                });
                                updateRecordCount();
                                document.getElementById('columnSearch').value = '';
                            }

                            function selectAllColumns() {
                                const activeGroup = document.querySelector('.column-group.active');
                                if (activeGroup) {
                                    activeGroup.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
                                        checkbox.checked = true;
                                    });
                                }
                            }

                            function deselectAllColumns() {
                                const activeGroup = document.querySelector('.column-group.active');
                                if (activeGroup) {
                                    activeGroup.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
                                        checkbox.checked = false;
                                    });
                                }
                            }

                            document.getElementById('columnSearch').addEventListener('input', function () {
                                const searchTerm = this.value.toLowerCase();
                                const activeGroup = document.querySelector('.column-group.active');
                                if (activeGroup) {
                                    activeGroup.querySelectorAll('.form-check-inline').forEach(item => {
                                        const label = item.querySelector('.form-check-label').textContent.toLowerCase();
                                        item.style.display = label.includes(searchTerm) ? 'flex' : 'none';
                                    });
                                }
                            });

                            document.getElementById('saveConfig').addEventListener('click', function () {
                                const config = {
                                    table: document.getElementById('table').value,
                                    format: document.getElementById('format').value,
                                    email: document.getElementById('email').value,
                                    columns: Array.from(document.querySelectorAll('.column-group.active input[type="checkbox"]:checked'))
                                            .map(cb => cb.value),
                                    status: document.getElementById('status').value,
                                    startDate: document.getElementById('startDate').value,
                                    endDate: document.getElementById('endDate').value,
                                    keyword: document.getElementById('keyword').value,
                                    transportUnitName: document.getElementById('transportUnitName').value,
                                    warehouseName: document.getElementById('warehouseName').value
                                };
                                localStorage.setItem('exportConfig', JSON.stringify(config));
                                alert('Cấu hình đã được lưu!');
                            });

                            document.getElementById('loadConfig').addEventListener('click', function () {
                                const config = JSON.parse(localStorage.getItem('exportConfig'));
                                if (config) {
                                    document.getElementById('table').value = config.table;
                                    document.getElementById('format').value = config.format;
                                    document.getElementById('email').value = config.email;
                                    document.getElementById('status').value = config.status;
                                    document.getElementById('startDate').value = config.startDate;
                                    document.getElementById('endDate').value = config.endDate;
                                    document.getElementById('keyword').value = config.keyword;
                                    document.getElementById('transportUnitName').value = config.transportUnitName;
                                    document.getElementById('warehouseName').value = config.warehouseName;
                                    updateColumns();
                                    const activeGroup = document.querySelector('.column-group.active');
                                    if (activeGroup) {
                                        activeGroup.querySelectorAll('input[type="checkbox"]').forEach(cb => {
                                            cb.checked = config.columns.includes(cb.value);
                                        });
                                    }
                                    if (config.table !== 'orders') {
                                        document.getElementById('status').disabled = true;
                                        document.getElementById('transportUnitName').disabled = true;
                                        document.getElementById('warehouseName').disabled = true;
                                    } else {
                                        document.getElementById('status').disabled = false;
                                        document.getElementById('transportUnitName').disabled = false;
                                        document.getElementById('warehouseName').disabled = false;
                                    }
                                    alert('Cấu hình đã được tải!');
                                } else {
                                    alert('Không có cấu hình nào được lưu!');
                                }
                            });

                            document.getElementById('previewData').addEventListener('click', function () {
                                const table = document.getElementById('table').value;
                                const columns = Array.from(document.querySelectorAll('.column-group.active input[type="checkbox"]:checked'))
                                        .map(cb => cb.value);
                                const status = document.getElementById('status').value;
                                const startDate = document.getElementById('startDate').value;
                                const endDate = document.getElementById('endDate').value;
                                const keyword = document.getElementById('keyword').value;
                                const transportUnitName = document.getElementById('transportUnitName').value;
                                const warehouseName = document.getElementById('warehouseName').value;
                                const format = document.getElementById('format').value;

                                if (columns.length === 0) {
                                    alert('Vui lòng chọn ít nhất một cột để xem trước.');
                                    return;
                                }

                                $.ajax({
                                    url: '${pageContext.request.contextPath}/exportData',
                                    type: 'POST',
                                    data: {
                                        table: table,
                                        columns: columns,
                                        status: status,
                                        startDate: startDate,
                                        endDate: endDate,
                                        keyword: keyword,
                                        transportUnitName: transportUnitName,
                                        warehouseName: warehouseName,
                                        format: format,
                                        action: 'preview'
                                    },
                                    dataType: 'json',
                                    success: function (response) {
                                        console.log('AJAX Response:', response);
                                        const data = Array.isArray(response) ? response : [];
                                        if (data.length === 0) {
                                            alert('Không có dữ liệu để hiển thị.');
                                            return;
                                        }
                                        const previewTable = document.getElementById('previewTable');
                                        previewTable.innerHTML = '<thead><tr></tr></thead><tbody></tbody>';
                                        const headerRow = previewTable.querySelector('thead tr');
                                        columns.forEach(col => {
                                            const th = document.createElement('th');
                                            th.textContent = col.replace(/_/g, ' ').replace(/\b\w/g, l => l.toUpperCase());
                                            headerRow.appendChild(th);
                                        });

                                        data.forEach(row => {
                                            console.log('Row data:', row);
                                            const tr = document.createElement('tr');
                                            columns.forEach(col => {
                                                const td = document.createElement('td');
                                                let value = row[col] || (typeof row === 'object' && row['get' + col.charAt(0).toUpperCase() + col.slice(1)]?.());
                                                td.textContent = value !== undefined && value !== null ? value.toString() : 'N/A';
                                                tr.appendChild(td);
                                            });
                                            previewTable.querySelector('tbody').appendChild(tr);
                                        });

                                        document.getElementById('previewContainer').style.display = 'block';
                                    },
                                    error: function (xhr, status, error) {
                                        console.error('AJAX Error:', xhr.responseText);
                                        alert('Lỗi khi lấy dữ liệu xem trước: ' + error);
                                    }
                                });
                            });

                            function updateRecordCount() {
                                const table = document.getElementById('table').value;
                                let count = 0;
                                if (table === 'orders')
                                    count = 50;
                                else if (table === 'customerSurvey')
                                    count = 30;
                                else if (table === 'transportReport')
                                    count = 20;
                                else if (table === 'storageReport')
                                    count = 25;
                                document.getElementById('recordCount').textContent = ``;
                            }

                            document.querySelector('form').addEventListener('submit', function (e) {
                                const columns = Array.from(document.querySelectorAll('.column-group.active input[type="checkbox"]:checked'));
                                if (columns.length === 0) {
                                    e.preventDefault();
                                    alert('Vui lòng chọn ít nhất một cột để xuất.');
                                    return;
                                }
                                document.getElementById('loadingOverlay').style.display = 'block';
                                setTimeout(() => document.getElementById('loadingOverlay').style.display = 'none', 2000);
                            });

                            document.addEventListener('DOMContentLoaded', function () {
                                const tableElement = document.getElementById('table');
                                if (tableElement) {
                                    updateColumns();
                                    updateRecordCount();
                                }
                            });

                            document.getElementById('table').addEventListener('change', function () {
                                if (this.value !== 'orders') {
                                    document.getElementById('status').disabled = true;
                                    document.getElementById('status').value = '';
                                    document.getElementById('transportUnitName').disabled = true;
                                    document.getElementById('transportUnitName').value = '';
                                    document.getElementById('warehouseName').disabled = true;
                                    document.getElementById('warehouseName').value = '';
                                } else {
                                    document.getElementById('status').disabled = false;
                                    document.getElementById('transportUnitName').disabled = false;
                                    document.getElementById('warehouseName').disabled = false;
                                }
                            });
        </script>
    </body>
</html>