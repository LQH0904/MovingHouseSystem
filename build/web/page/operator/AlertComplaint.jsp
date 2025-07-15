<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo Cáo Phản Ánh Đơn Vị Vận Chuyển</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/AlertComplaint.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        .status-normal { color: #10b981; background-color: #d1fae5; }
        .status-warning { color: #f59e0b; background-color: #fef3c7; }
        .status-danger { color: #ef4444; background-color: #fee2e2; }
        .status-badge { padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 500; }
        .action-processed { color: #10b981; font-size: 18px; }
        .action-pending { color: #6b7280; font-size: 18px; }
        .btn-send-mail { background-color: #3b82f6; color: white; border: none; padding: 6px 12px; border-radius: 6px; font-size: 12px; }
        .btn-send-mail:hover { background-color: #2563eb; }
        .btn-send-mail:disabled { background-color: #9ca3af; cursor: not-allowed; }
    </style>
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
            <div class="page-header">
                <div class="header-content">
                    <div class="header-text">
                        <h1 class="page-title">
                            <i class="fas fa-chart-line"></i>
                            Báo Cáo Phản Ánh Đơn Vị Vận Chuyển
                        </h1>
                        <p class="page-subtitle">Theo dõi và quản lý chất lượng dịch vụ các đơn vị vận chuyển và kho bãi</p>
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
                        <div class="stat-number">${totalUnitsWithComplaints}</div>
                        <div class="stat-label">Tổng Đơn Vị Có Phản Ánh</div>
                    </div>
                </div>

                <div class="stat-card total-complaints">
                    <div class="stat-icon">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${totalComplaints}</div>
                        <div class="stat-label">Tổng Số Phản Ánh</div>
                    </div>
                </div>

                <div class="stat-card warning-units">
                    <div class="stat-icon">
                        <i class="fas fa-bell"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${sentWarnings}</div>
                        <div class="stat-label">Đã Cảnh Báo</div>
                    </div>
                </div>

                <div class="stat-card normal-units">
                    <div class="stat-icon">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-content">
                        <div class="stat-number">${notSentWarnings}</div>
                        <div class="stat-label">Chưa Cảnh Báo</div>
                    </div>
                </div>
            </div>

            <div class="filter-section">
                <div class="filter-header">
                    <h3><i class="fas fa-filter"></i> Bộ lọc</h3>
                </div>
                <form method="GET" action="${pageContext.request.contextPath}/operator/alert-complaint" class="filter-form">
                    <div class="filter-grid">
                        <div class="filter-group">
                            <label><i class="fas fa-truck"></i> Loại Đơn Vị</label>
                            <select name="unitType" class="form-select">
                                <option value="" ${empty unitType ? 'selected' : ''}>Tất cả</option>
                                <option value="TRANSPORT" ${unitType == 'TRANSPORT' ? 'selected' : ''}>Vận chuyển</option>
                                <option value="WAREHOUSE" ${unitType == 'WAREHOUSE' ? 'selected' : ''}>Kho bãi</option>
                            </select>
                        </div>
                        <div class="filter-group">
                            <label><i class="fas fa-traffic-light"></i> Trạng thái</label>
                            <select name="status" class="form-select">
                                <option value="" ${empty status ? 'selected' : ''}>Tất cả</option>
                                <option value="NORMAL" ${status == 'NORMAL' ? 'selected' : ''}>Bình thường</option>
                                <option value="WARNING" ${status == 'WARNING' ? 'selected' : ''}>Cảnh báo</option>
                                <option value="DANGER" ${status == 'DANGER' ? 'selected' : ''}>Nguy hiểm</option>
                            </select>
                        </div>
                    </div>
                    <div class="filter-actions">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-search"></i> Lọc dữ liệu
                        </button>
                    </div>
                </form>
            </div>

            <div class="table-container">
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
                        <tbody>
                        <c:forEach var="item" items="${complaints}" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * 10 + loop.index + 1}</td>
                                <td>${item.unitName}</td>
                                <td>${item.email}</td>
                                <td>${item.address}</td>
                                <td>${item.unitType == 'TRANSPORT' ? 'Vận chuyển' : 'Kho bãi'}</td>
                                <td>${item.issueCount}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.issueStatus == 'NORMAL'}">
                                            <span class="status-badge status-normal">Bình thường</span>
                                        </c:when>
                                        <c:when test="${item.issueStatus == 'WARNING'}">
                                            <span class="status-badge status-warning">Cảnh báo</span>
                                        </c:when>
                                        <c:when test="${item.issueStatus == 'DANGER'}">
                                            <span class="status-badge status-danger">Nguy hiểm</span>
                                        </c:when>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.warningSent}">
                                            <i class="fas fa-check-circle action-processed" title="Đã xử lý"></i>
                                        </c:when>
                                        <c:otherwise>
                                            <i class="fas fa-clock action-pending" title="Chưa xử lý"></i>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.warningSent}">
                                            <button class="btn-send-mail" disabled>
                                                <i class="fas fa-envelope"></i> Đã gửi
                                            </button>
                                        </c:when>
                                        <c:otherwise>
                                            <form method="POST" action="${pageContext.request.contextPath}/operator/alert-complaint" style="display: inline;">
                                                <input type="hidden" name="action" value="sendWarning" />
                                                <input type="hidden" name="unitId" value="${item.unitId}" />
                                                <input type="hidden" name="unitType" value="${item.unitType}" />
                                                <input type="hidden" name="page" value="${currentPage}" />
                                                <input type="hidden" name="unitTypeFilter" value="${unitType}" />
                                                <input type="hidden" name="statusFilter" value="${status}" />
                                                <button type="submit" class="btn-send-mail" onclick="return confirm('Bạn có chắc chắn muốn gửi mail cảnh báo cho đơn vị này?')">
                                                    <i class="fas fa-envelope"></i> Gửi mail
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <div class="pagination-container">
                    <c:if test="${totalPages > 1}">
                        <div class="pagination">
                            <c:if test="${currentPage > 1}">
                                <a class="page-link" href="${pageContext.request.contextPath}/operator/alert-complaint?page=${currentPage - 1}&unitType=${unitType}&status=${status}">
                                    <i class="fas fa-chevron-left"></i>
                                </a>
                            </c:if>
                            
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <c:if test="${p <= 3 || p >= totalPages - 2 || (p >= currentPage - 1 && p <= currentPage + 1)}">
                                    <a class="page-link ${p == currentPage ? 'active' : ''}" 
                                       href="${pageContext.request.contextPath}/operator/alert-complaint?page=${p}&unitType=${unitType}&status=${status}">
                                        ${p}
                                    </a>
                                </c:if>
                                <c:if test="${p == 4 && currentPage > 5}">
                                    <span class="page-link">...</span>
                                </c:if>
                                <c:if test="${p == totalPages - 3 && currentPage < totalPages - 4}">
                                    <span class="page-link">...</span>
                                </c:if>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages}">
                                <a class="page-link" href="${pageContext.request.contextPath}/operator/alert-complaint?page=${currentPage + 1}&unitType=${unitType}&status=${status}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </c:if>
                        </div>
                        
                        <div class="pagination-info">
                            Hiển thị ${(currentPage - 1) * 10 + 1} - ${currentPage * 10 > totalRecords ? totalRecords : currentPage * 10} 
                            trong tổng số ${totalRecords} bản ghi
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
