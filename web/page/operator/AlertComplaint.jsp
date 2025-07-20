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
                          <div class="header-actions">
                          </div>
                      </div>
                  </div>
                  <!-- Statistics Grid -->
                  <div class="stats-grid">
                      <div class="stat-card total-units">
                          <div class="stat-icon">
                              <i class="fas fa-building"></i>
                          </div>
                          <div class="stat-content">
                              <div class="stat-number">${totalUnits}</div>
                              <div class="stat-label">Tổng Đơn Vị Có Phản Ánh</div>
                          </div>
                      </div>
                      <div class="stat-card total-complaints">
                          <div class="stat-icon">
                              <i class="fas fa-exclamation-triangle"></i>
                          </div>
                          <div class="stat-content">
                              <div class="stat-number">${totalIssues}</div>
                              <div class="stat-label">Tổng Số Phản Ánh</div>
                          </div>
                      </div>
                  </div>
                  <!-- Filter Section -->
                  <div class="filter-section">
                      <div class="filter-header">
                          <h3><i class="fas fa-filter"></i> Bộ lọc</h3>
                      </div>
                      <form method="get" class="filter-form">
                          <div class="filter-grid">
                              <div class="filter-group">
                                  <label for="search-input"><i class="fas fa-search"></i> Tìm theo tên đơn vị</label>
                                  <input type="text" id="search-input" name="search" placeholder="Nhập tên đơn vị..." value="${search}" class="form-input" />
                              </div>
                              <div class="filter-group">
                                  <label for="type-select"><i class="fas fa-truck"></i> Loại đơn vị</label>
                                  <select id="type-select" name="type" class="form-select">
                                      <option value="all" ${type == 'all' ? 'selected' : ''}>Tất cả</option>
                                      <option value="transport" ${type == 'transport' ? 'selected' : ''}>Vận chuyển</option>
                                      <option value="storage" ${type == 'storage' ? 'selected' : ''}>Kho</option>
                                  </select>
                              </div>
                          </div>
                          <div class="filter-actions">
                              <button type="submit" class="btn btn-primary"><i class="fas fa-filter"></i> Lọc</button>
                              <a href="${pageContext.request.contextPath}/operator/alert-complaint" class="btn btn-outline"><i class="fas fa-sync-alt"></i> Đặt lại</a>
                          </div>
                      </form>
                  </div>
                  <!-- Table Container -->
                  <div class="table-container">
                      <div class="table-header">
                          <h3 class="table-title"><i class="fas fa-table"></i> Danh sách Phản ánh</h3>
                          <div class="table-actions">
                          </div>
                      </div>
                      <div class="table-wrapper">
                          <table class="data-table">
                              <thead>
                                  <tr>
                                      <th>Mã đơn vị</th>
                                      <th>Tên</th>
                                      <th>Email</th>
                                      <th>Loại đơn vị</th>
                                      <th>Số phản ánh</th>
                                      <th>Chi tiết</th>
                                  </tr>
                              </thead>
                              <tbody>
                                  <c:forEach var="item" items="${data}">
                                      <tr>
                                          <td>${item.unitId}</td>
                                          <td>${item.unitName}</td>
                                          <td>${item.email}</td>
                                          <td>
                                              <c:choose>
                                                  <c:when test="${item.unitType == 'Transport'}">
                                                      <span class="type-badge type-transport">Vận chuyển</span>
                                                  </c:when>
                                                  <c:when test="${item.unitType == 'Storage'}">
                                                      <span class="type-badge type-warehouse">Kho</span>
                                                  </c:when>
                                                  <c:otherwise>
                                                      <span class="type-badge neutral">Khác (${item.unitType})</span>
                                                  </c:otherwise>
                                              </c:choose>
                                          </td>
                                          <td>${item.issueCount}</td>
                                          <td>
                                              <a href="${pageContext.request.contextPath}/operator/unit-detail/${item.unitId}" class="btn btn-sm btn-view" aria-label="Xem chi tiết">
                                                  <i class="fas fa-eye"></i>
                                              </a>
                                          </td>
                                      </tr>
                                  </c:forEach>
                                  <c:if test="${empty data}">
                                      <tr>
                                          <td colspan="6" style="text-align: center; padding: 20px; color: #64748b;">Không tìm thấy dữ liệu nào.</td>
                                      </tr>
                                  </c:if>
                              </tbody>
                          </table>
                      </div>
                  </div>
                  <!-- Pagination -->
                  <div class="pagination-container">
                      <div class="pagination-info">
                          Hiển thị ${data.size()} trên tổng số ${totalRecordsForPagination} kết quả
                      </div>
                      <div class="pagination">
                          <c:forEach begin="1" end="${totalPages}" var="i">
                              <c:choose>
                                  <c:when test="${i == currentPage}">
                                      <span class="page-link active">${i}</span>
                                  </c:when>
                                  <c:otherwise>
                                      <a href="?page=${i}&search=${search}&type=${type}" class="page-link">${i}</a>
                                  </c:otherwise>
                              </c:choose>
                          </c:forEach>
                      </div>
                  </div>
              </div>
          </div>
      </div>
  </body>
</html>
