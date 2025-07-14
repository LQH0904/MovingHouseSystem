<%-- 
    Document   : analyzeReport
    Created on : Jul 7, 2025, 11:08:11 PM
    Author     : admin
--%>


<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Phân tích Báo cáo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f6f8;
                padding: 30px;
            }
            .form-container {
                max-width: 800px;
                margin: auto;
            }
            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                background-color: #ffffff;
            }
            .card-header {
                background-color: #0d6efd;
                color: white;
                font-weight: bold;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 20px;
            }
            .nav-links {
                margin: 15px 0;
            }
            .nav-links a {
                text-decoration: none;
                color: #0d6efd;
                font-weight: 500;
                display: inline-block;
                margin-right: 15px;
            }
            .nav-links a:hover {
                text-decoration: underline;
            }
            .form-select, .form-control {
                border-radius: 8px;
            }
            .btn-analyze, .btn-search {
                background-color: #0d6efd;
                border: none;
                border-radius: 8px;
                color: white;
            }
            .btn-analyze:hover, .btn-search:hover {
                background-color: #0b5ed7;
            }
            .form-label i {
                margin-right: 6px;
                color: #0d6efd;
            }
            .table th, .table td {
                vertical-align: middle;
            }
            .alert {
                border-radius: 8px;
            }
            .pagination {
                justify-content: center;
                margin-top: 20px;
                display: flex !important;
                min-height: 40px !important;
                border: 1px solid #ddd !important;
                padding: 5px !important;
                background-color: #fff !important;
                visibility: visible !important;
            }
            .pagination .page-item.disabled .page-link {
                cursor: not-allowed;
                opacity: 0.6;
            }
            .pagination .page-item.active .page-link {
                background-color: #0d6efd;
                border-color: #0d6efd;
            }
            .disabled-checkbox {
                cursor: not-allowed;
                opacity: 0.5;
            }
        </style>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <div class="form-container">
            <div class="card">
                <div class="card-header">
                    <i class="fas fa-chart-line"></i> Tạo Phân tích & Báo cáo Thống kê
                </div>
                <div class="card-body">
                    <c:if test="${sessionScope.acc == null}">
                        <div class="alert alert-danger" role="alert">
                            <i class="fas fa-exclamation-triangle"></i> Vui lòng đăng nhập để sử dụng chức năng này.
                            <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a>
                        </div>
                    </c:if>
                    <c:if test="${sessionScope.acc != null}">
                        <c:if test="${sessionScope.acc.roleId != 1 && sessionScope.acc.roleId != 2}">
                            <div class="alert alert-warning" role="alert">
                                <i class="fas fa-user-lock"></i> Bạn không có quyền phân tích báo cáo.
                            </div>
                        </c:if>
                        <c:if test="${sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2}">
                            <div class="nav-links">
                                <a href="${pageContext.request.contextPath}/sendNotification"><i class="fas fa-paper-plane"></i> Gửi Thông báo</a>
                                <a href="${pageContext.request.contextPath}/login"><i class="fas fa-home"></i> Về Trang chủ</a>
                            </div>
                            <form id="analyzeForm" action="${pageContext.request.contextPath}/analyz" method="post">
                                <div class="mb-3">
                                    <label for="reportType" class="form-label"><i class="fas fa-file-alt"></i>Loại báo cáo:</label>
                                    <select class="form-select" name="reportType" id="reportType" onchange="loadReports(1)">
                                        <option value="inventory">📦 Báo cáo Tồn kho</option>
                                        <option value="transport">🚚 Báo cáo Vận chuyển</option>
                                        <option value="orders">🛒 Báo cáo Đơn hàng</option>
                                    </select>
                                </div>
                                <div class="mb-3" id="searchContainer">
                                    <label for="unitName" class="form-label"><i class="fas fa-search"></i>Tìm kiếm theo tên đơn vị:</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="unitName" placeholder="Nhập tên kho hoặc công ty vận chuyển">
                                        <button type="button" class="btn btn-search" onclick="loadReports(1)"><i class="fas fa-search"></i> Tìm</button>
                                    </div>
                                </div>
                                <div class="mb-3" id="reportListContainer">
                                    <label class="form-label"><i class="fas fa-file-earmark-text"></i>Danh sách báo cáo:</label>
                                    <table class="table table-bordered">
                                        <thead>
                                            <tr>
                                                <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"></th>
                                                <th>ID Báo cáo</th>
                                                <th>Đơn vị</th>
                                                <th>Ngày tạo</th>
                                                <th>Trạng thái</th>
                                            </tr>
                                        </thead>
                                        <tbody id="reportList">
                                            <!-- Danh sách báo cáo sẽ được tải bằng AJAX -->
                                        </tbody>
                                    </table>
                                </div>
                                <nav>
                                    <ul class="pagination" id="pagination">
                                        <li class="page-item"><span class="page-link">Đang tải phân trang...</span></li>
                                    </ul>
                                </nav>
                                <input type="hidden" name="userId" value="${sessionScope.acc.userId}">
                                <input type="hidden" name="roleId" value="${sessionScope.acc.roleId}">
                                <button type="submit" class="btn btn-analyze w-100"><i class="fas fa-play-circle"></i> Phân tích</button>
                            </form>
                            <c:if test="${not empty requestScope.message}">
                                <div id="success-alert" class="alert alert-success mt-3" role="alert">
                                    <i class="fas fa-check-circle"></i> ${requestScope.message}
                                </div>
                            </c:if>
                            <c:if test="${not empty requestScope.error}">
                                <div class="alert alert-danger mt-3" role="alert">
                                    <i class="fas fa-times-circle"></i> ${requestScope.error}
                                </div>
                            </c:if>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>
        <script>
            var currentPage = 1;
            var pageSize = 10;

            $(document).ready(function () {
                console.log('Page loaded, calling loadReports for page 1');
                loadReports(currentPage);
                setTimeout(function () {
                    const alertBox = document.getElementById("success-alert");
                    if (alertBox) {
                        alertBox.style.transition = "opacity 0.5s ease-out";
                        alertBox.style.opacity = "0";
                        setTimeout(() => alertBox.remove(), 500);
                    }
                }, 3000);
            });

            function loadReports(page) {
                currentPage = page;
                var reportType = $('#reportType').val();
                var unitName = $('#unitName').val();

                console.log('Loading reports for page:', page, 'reportType:', reportType, 'unitName:', unitName);

                if (reportType === 'orders') {
                    $('#reportListContainer').hide();
                    $('#searchContainer').hide();
                    $('#pagination').hide();
                    console.log('Hiding pagination for orders report');
                    return;
                }
                $('#reportListContainer').show();
                $('#searchContainer').show();
                $('#pagination').show();

                $.ajax({
                    url: '${pageContext.request.contextPath}/analyz',
                    type: 'GET',
                    data: {
                        reportType: reportType,
                        action: 'getReports',
                        page: page,
                        pageSize: pageSize,
                        unitName: unitName
                    },
                    dataType: 'json',
                    success: function (reportData) {
                        console.log('Reports Response:', JSON.stringify(reportData, null, 2));

                        $.ajax({
                            url: '${pageContext.request.contextPath}/analyz',
                            type: 'GET',
                            data: {
                                reportType: reportType,
                                action: 'getUnanalyzedIds',
                                unitName: unitName
                            },
                            dataType: 'json',
                            success: function (unanalyzedData) {
                                console.log('Unanalyzed IDs Response:', JSON.stringify(unanalyzedData, null, 2));
                                var unanalyzedIds = unanalyzedData.unanalyzedIds || [];

                                $('#reportList').empty();
                                if (reportData.reports && reportData.reports.length > 0) {
                                    $.each(reportData.reports, function (index, report) {
                                        // Sử dụng storage_unit từ inventory_details cho báo cáo tồn kho
                                        var unitName = reportType === 'inventory' ? 
                                            (report.inventoryDetails ? JSON.parse(report.inventoryDetails).storage_unit : 'Chưa xác định') : 
                                            (report.companyName || 'Chưa xác định');
                                        var isAnalyzed = !unanalyzedIds.includes(report.reportId);
                                        var checkboxDisabled = isAnalyzed ? 'disabled class="disabled-checkbox" title="Báo cáo đã được phân tích"' : '';
                                        var statusText = isAnalyzed ? 
                                            '<span class="text-success"><i class="fas fa-check-circle"></i> Đã phân tích</span>' : 
                                            '<span class="text-warning"><i class="fas fa-exclamation-circle"></i> Chưa phân tích</span>';
                                        console.log('Report ID:', report.reportId, 'isAnalyzed:', isAnalyzed, 'unitName:', unitName);
                                        var row = '<tr>' +
                                                '<td><input type="checkbox" name="reportIds" value="' + report.reportId + '" ' + checkboxDisabled + '></td>' +
                                                '<td>' + report.reportId + '</td>' +
                                                '<td>' + unitName + '</td>' +
                                                '<td>' + new Date(report.createdAt).toLocaleString('vi-VN') + '</td>' +
                                                '<td>' + statusText + '</td>' +
                                                '</tr>';
                                        $('#reportList').append(row);
                                    });
                                } else {
                                    $('#reportList').html('<tr><td colspan="5">Không có báo cáo nào để hiển thị.</td></tr>');
                                }

                                // Xử lý phân trang
                                var totalReports = Number(reportData.totalReports) || 0;
                                var totalPages = Math.max(Math.ceil(totalReports / pageSize), 1);
                                console.log('Total Reports:', totalReports, 'Total Pages:', totalPages);
                                renderPagination(totalPages);
                            },
                            error: function (xhr, status, error) {
                                console.error('Error fetching unanalyzed IDs:', status, error, 'Response:', xhr.responseText);
                                $('#reportList').html('<tr><td colspan="5">Lỗi khi tải trạng thái báo cáo: ' + xhr.responseText + '</td></tr>');
                            }
                        });
                    },
                    error: function (xhr, status, error) {
                        console.error('Error fetching reports:', status, error, 'Response:', xhr.responseText);
                        $('#reportList').html('<tr><td colspan="5">Lỗi khi tải danh sách báo cáo: ' + xhr.responseText + '</td></tr>');
                        $('#pagination').html('<li class="page-item"><span class="page-link">Lỗi tải phân trang</span></li>');
                    }
                });
            }

            function renderPagination(totalPages) {
                console.log('Rendering pagination with', totalPages, 'pages');
                $('#pagination').empty();

                if (totalPages <= 1) {
                    $('#pagination').append('<li class="page-item"><span class="page-link">Chỉ có 1 trang</span></li>');
                    console.log('Pagination HTML (single page):', $('#pagination').html());
                    return;
                }

                $('#pagination').append(
                        '<li class="page-item ' + (currentPage === 1 ? 'disabled' : '') + '">' +
                        '<a class="page-link" href="#" onclick="loadReports(' + (currentPage - 1) + ')">Trước</a>' +
                        '</li>'
                );

                for (var i = 1; i <= totalPages; i++) {
                    $('#pagination').append(
                            '<li class="page-item ' + (i === currentPage ? 'active' : '') + '">' +
                            '<a class="page-link" href="#" onclick="loadReports(' + i + ')">' + i + '</a>' +
                            '</li>'
                    );
                }

                $('#pagination').append(
                        '<li class="page-item ' + (currentPage === totalPages ? 'disabled' : '') + '">' +
                        '<a class="page-link" href="#" onclick="loadReports(' + (currentPage + 1) + ')">Sau</a>' +
                        '</li>'
                );

                console.log('Pagination HTML:', $('#pagination').html());
            }

            function toggleSelectAll() {
                var selectAll = $('#selectAll').prop('checked');
                $('input[name="reportIds"]:not(:disabled)').prop('checked', selectAll);
            }
        </script>
    </body>
</html>