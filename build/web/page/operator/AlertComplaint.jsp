<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Phản Ánh Đơn Vị Vận Chuyển</title>
    
    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/AlertComplaint.css">
    
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
    <div class="parent">
        <div class="div1">
            <jsp:include page="/Layout/operator/SideBar.jsp"/>
        </div>
        <div class="div2">
            <jsp:include page="/Layout/operator/Header.jsp"/>
        </div>
        <div class="div3">
            <div class="content-container">
                <!-- Page Header -->
                <div class="page-header">
                    <div class="header-content">
                        <div class="header-text">
                            <h1 class="page-title">
                                <i class="fas fa-chart-line"></i>
                                Báo Cáo Phản Ánh Đơn Vị Vận Chuyển
                            </h1>
                            <p class="page-subtitle">Theo dõi và quản lý chất lượng dịch vụ các đơn vị vận chuyển và kho bãi</p>
                        </div>
                        <div class="header-actions">
                            <button class="btn btn-export" onclick="exportReport()">
                                <i class="fas fa-download"></i> Xuất báo cáo
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="stats-grid">
                    <div class="stat-card total-units">
                        <div class="stat-icon">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-number">24</div>
                            <div class="stat-label">Tổng Đơn Vị</div>
                            <div class="stat-change positive">+2 so với tháng trước</div>
                        </div>
                    </div>
                    
                    <div class="stat-card total-complaints">
                        <div class="stat-icon">
                            <i class="fas fa-exclamation-triangle"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-number">156</div>
                            <div class="stat-label">Tổng Phản Ánh</div>
                            <div class="stat-change negative">+12% so với tháng trước</div>
                        </div>
                    </div>
                    
                    <div class="stat-card warning-units">
                        <div class="stat-icon">
                            <i class="fas fa-bell"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-number">8</div>
                            <div class="stat-label">Đã Cảnh Báo</div>
                            <div class="stat-change neutral">Không thay đổi</div>
                        </div>
                    </div>
                    
                    <div class="stat-card normal-units">
                        <div class="stat-icon">
                            <i class="fas fa-check-circle"></i>
                        </div>
                        <div class="stat-content">
                            <div class="stat-number">16</div>
                            <div class="stat-label">Chưa Cảnh Báo</div>
                            <div class="stat-change positive">-3 so với tháng trước</div>
                        </div>
                    </div>
                </div>

                <!-- Alert Messages -->
                <div class="alert alert-warning">
                    <i class="fas fa-exclamation-triangle"></i>
                    <div class="alert-content">
                        <strong>Cảnh báo:</strong> Có 8 đơn vị vượt ngưỡng phản ánh cho phép. 
                        Vui lòng kiểm tra và thực hiện các biện pháp cải thiện chất lượng dịch vụ.
                    </div>
                </div>

                <!-- Filter Section -->
                <div class="filter-section">
                    <div class="filter-header">
                        <h3><i class="fas fa-filter"></i> Bộ lọc</h3>
                    </div>
                    <form method="GET" action="transport-complaint-report" class="filter-form">
                        <div class="filter-grid">
                            <div class="filter-group">
                                <label><i class="fas fa-truck"></i> Loại Đơn Vị</label>
                                <select name="unitType" class="form-select">
                                    <option value="">Tất cả</option>
                                    <option value="TRANSPORT">Vận chuyển</option>
                                    <option value="WAREHOUSE">Kho bãi</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label><i class="fas fa-traffic-light"></i> Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="">Tất cả</option>
                                    <option value="NORMAL">Bình thường</option>
                                    <option value="WARNING">Cảnh báo</option>
                                    <option value="DANGER">Nguy hiểm</option>
                                </select>
                            </div>
                            
                            <div class="filter-group">
                                <label><i class="fas fa-calendar"></i> Từ ngày</label>
                                <input type="date" name="fromDate" class="form-input" value="2024-01-01">
                            </div>
                            
                            <div class="filter-group">
                                <label><i class="fas fa-calendar"></i> Đến ngày</label>
                                <input type="date" name="toDate" class="form-input" value="2024-12-31">
                            </div>
                        </div>
                        
                        <div class="filter-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-search"></i> Lọc dữ liệu
                            </button>
                            <button type="button" class="btn btn-warning" onclick="sendWarningEmails()">
                                <i class="fas fa-envelope"></i> Gửi Email Cảnh Báo
                            </button>
                            <button type="reset" class="btn btn-secondary">
                                <i class="fas fa-undo"></i> Đặt lại
                            </button>
                        </div>
                    </form>
                </div>

                <!-- Data Table -->
                <div class="table-container">
                    <div class="table-header">
                        <h3 class="table-title">
                            <i class="fas fa-table"></i> Thống Kê Phản Ánh Chi Tiết
                        </h3>
                        <div class="table-actions">
                            <button class="btn btn-sm btn-outline" onclick="refreshData()">
                                <i class="fas fa-sync-alt"></i> Làm mới
                            </button>
                        </div>
                    </div>
                    
                    <div class="table-wrapper">
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên Đơn Vị</th>
                                    <th>Email</th>
                                    <th>Địa Chỉ</th>
                                    <th>Loại</th>
                                    <th>Số Phản Ánh</th>
                                    <th>Trạng Thái</th>
                                    <th>Xử Lý</th>
                                    <th>Thao Tác</th>
                                </tr>
                            </thead>
                            <tbody id="dataTableBody">
                                <!-- Data will be populated by JavaScript -->
                            </tbody>
                        </table>
                    </div>
                    
                    <!-- Pagination -->
                    <div class="pagination-container">
                        <div class="pagination-info">
                            Hiển thị <strong>1-10</strong> trong tổng số <strong>24</strong> kết quả
                        </div>
                        <div class="pagination">
                            <a href="#" class="page-link disabled">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                            <a href="#" class="page-link active">1</a>
                            <a href="#" class="page-link">2</a>
                            <a href="#" class="page-link">3</a>
                            <a href="#" class="page-link">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div id="loadingOverlay" class="loading-overlay">
        <div class="loading-spinner">
            <i class="fas fa-spinner fa-spin"></i>
            <p>Đang xử lý...</p>
        </div>
    </div>

    <!-- JavaScript Files -->
    <script src="${pageContext.request.contextPath}/js/transport-complaint-report.js"></script>
</body>
</html>