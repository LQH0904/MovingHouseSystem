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
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: linear-gradient(135deg, #e0e7ff 0%, #ffffff 100%);
                min-height: 100vh;
                padding: 40px 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                overflow-x: hidden;
            }
            .form-container {
                max-width: 900px;
                width: 100%;
                animation: fadeIn 0.8s ease-in-out;
            }
            .card {
                border: none;
                border-radius: 20px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
                background: #ffffff;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .card-header {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                color: white;
                font-weight: 600;
                font-size: 1.5rem;
                padding: 20px;
                border-top-left-radius: 20px;
                border-top-right-radius: 20px;
                display: flex;
                align-items: center;
                gap: 12px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .nav-links {
                margin: 20px 0;
                display: flex;
                gap: 20px;
            }
            .nav-links a {
                text-decoration: none;
                color: #007bff;
                font-weight: 500;
                font-size: 1rem;
                padding: 8px 16px;
                border-radius: 8px;
                transition: background-color 0.3s, color 0.3s;
            }
            .nav-links a:hover {
                background-color: #007bff;
                color: white;
            }
            .form-select, .form-control {
                border-radius: 10px;
                border: 2px solid #e0e7ff;
                padding: 12px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            .form-select:focus, .form-control:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            }
            .btn-analyze, .btn-search {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                border: none;
                border-radius: 10px;
                padding: 12px 24px;
                color: white;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .btn-analyze:hover, .btn-search:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.4);
            }
            .form-label {
                font-weight: 500;
                color: #333;
                margin-bottom: 8px;
            }
            .form-label i {
                margin-right: 8px;
                color: #007bff;
            }
            .table {
                border-radius: 10px;
                overflow: hidden;
                background: #f8f9fa;
            }
            .table th, .table td {
                vertical-align: middle;
                padding: 15px;
                transition: background-color 0.3s;
            }
            .table tr:hover {
                background-color: #e0e7ff;
                cursor: pointer;
            }
            .alert {
                border-radius: 10px;
                padding: 15px;
                font-size: 0.9rem;
                animation: slideIn 0.5s ease-in-out;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            .pagination {
                justify-content: center;
                margin-top: 25px;
                display: flex;
                border-radius: 10px;
                overflow: hidden;
                background: #ffffff;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            .pagination .page-item .page-link {
                border: none;
                padding: 10px 20px;
                font-weight: 500;
                color: #007bff;
                transition: background-color 0.3s, color 0.3s;
            }
            .pagination .page-item.active .page-link {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                color: white;
            }
            .pagination .page-item.disabled .page-link {
                cursor: not-allowed;
                opacity: 0.5;
                background: #f8f9fa;
            }
            .pagination .page-item .page-link:hover {
                background-color: #e0e7ff;
                color: #0056b3;
            }
            .disabled-checkbox {
                cursor: not-allowed;
                opacity: 0.5;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            @keyframes slideIn {
                from { opacity: 0; transform: translateX(-20px); }
                to { opacity: 1; transform: translateX(0); }
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
                <div class="card-body p-4">
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
                                <div class="mb-4">
                                    <label for="reportType" class="form-label"><i class="fas fa-file-alt"></i>Loại báo cáo:</label>
                                    <select class="form-select" name="reportType" id="reportType" onchange="loadReports(1)">
                                        <option value="inventory">📦 Báo cáo Tồn kho</option>
                                        <option value="transport">🚚 Báo cáo Vận chuyển</option>
                                        <option value="orders">🛒 Báo cáo Đơn hàng</option>
                                    </select>
                                </div>
                                <div class="mb-4" id="searchContainer">
                                    <label for="unitName" class="form-label"><i class="fas fa-search"></i>Tìm kiếm theo tên đơn vị:</label>
                                    <div class="input-group">
                                        <input type="text" class="form-control" id="unitName" name="unitName" placeholder="Nhập tên kho hoặc công ty vận chuyển">
                                        <button type="button" class="btn btn-search" onclick="loadReports(1)"><i class="fas fa-search"></i> Tìm</button>
                                    </div>
                                </div>
                                <div class="mb-4" id="reportListContainer">
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
                                <div id="success-alert" class="alert alert-success mt-4" role="alert">
                                    <i class="fas fa-check-circle"></i> ${requestScope.message}
                                </div>
                            </c:if>
                            <c:if test="${not empty requestScope.error}">
                                <div class="alert alert-danger mt-4" role="alert">
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

                // Bind search button click event
                $('.btn-search').click(function () {
                    loadReports(1);
                });

                // Bind Enter key press for search input
                $('#unitName').keypress(function (e) {
                    if (e.which === 13) { // Enter key
                        e.preventDefault();
                        loadReports(1);
                    }
                });

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
                                        var unitName = reportType === 'inventory' ?
                                            (report.warehouseName || 'Chưa xác định') :
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