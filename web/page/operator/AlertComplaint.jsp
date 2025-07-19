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
            .status-normal {
                color: #10b981;
                background-color: #d1fae5;
            }
            .status-warning {
                color: #f59e0b;
                background-color: #fef3c7;
            }
            .status-danger {
                color: #ef4444;
                background-color: #fee2e2;
            }
            .status-badge {
                padding: 4px 12px;
                border-radius: 12px;
                font-size: 12px;
                font-weight: 500;
            }
            .action-processed {
                color: #10b981;
                font-size: 18px;
            }
            .action-pending {
                color: #6b7280;
                font-size: 18px;
            }
            .btn-send-mail {
                background-color: #3b82f6;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 6px;
                font-size: 12px;
                cursor: pointer;
            }
            .btn-send-mail:hover {
                background-color: #2563eb;
            }
            .btn-send-mail:disabled {
                background-color: #9ca3af;
                cursor: not-allowed;
            }
            .alert {
                padding: 10px 15px;
                margin: 15px 0;
                border-radius: 5px;
                font-weight: bold;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-error {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
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
                                        <th>Loại đơn vị</th>
                                        <th>Số phản ánh</th>
                                        <th>Hành động</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="item" items="${summaryList}" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td>${item.unitId}</td>
                                            <td>${item.unitType}</td>
                                            <td>${item.issueCount}</td>
                                            <td>
                                                <form action="alert-complaint-detail" method="get" style="display:inline;">
                                                    <input type="hidden" name="unitId" value="${item.unitId}" />
                                                    <button type="submit">Xem chi tiết</button>
                                                </form>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>

    </body>
</html>
