<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Thông tin các đồ vật </title>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/ItemDetail.css">
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
            <div class="div3">
                <div class="container-fluid">
                    <!-- Page Header -->
                    <div class="page-header">
                        <div class="container">
                            <div class="row">
                                <div class="col-12 d-flex justify-content-between align-items-center">
                                    <h1 class="page-title">
                                        <i class="fas fa-boxes"></i>
                                        Thông Tin Các Đồ Vật - Đơn hàng : ${orderId}
                                    </h1>
                                    <div class="header-actions">
                                        <a href="${pageContext.request.contextPath}/order/detailid/${orderId}" class="btn-back">
                                            <i class="fas fa-arrow-left"></i>
                                            Quay lại
                                        </a>                                      
                                    </div>                                    
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search Section -->
                    <div class="search-section">
                        <div class="container">
                            <form method="GET" action="${pageContext.request.contextPath}/order/detail/item/${orderId}" class="search-form">
                                <input type="hidden" name="orderId" value="${orderId}">
                                <div class="search-container">
                                    <div class="search-box">
                                        <input type="text" name="keyword" value="${keyword}" 
                                               placeholder="Tìm kiếm theo tên ...">
                                        <i class="fas fa-search"></i>
                                    </div>
                                    <div class="filter-controls">
                                        <button type="submit" class="btn-search">
                                            <i class="fas fa-search"></i>
                                            Tìm kiếm
                                        </button>
                                        <c:if test="${not empty keyword}">
                                            <a href="${pageContext.request.contextPath}/order/detail/item/${orderId}" class="btn-clear">
                                                <i class="fas fa-times"></i>
                                                Xóa 
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Statistics Section -->
                    <div class="stats-section">
                        <div class="container">
                            <div class="stats-grid">
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-boxes"></i>
                                    </div>
                                    <div class="stat-content">
                                        <div class="stat-number">
                                            <c:set var="totalItems" value="0" />
                                            <c:forEach var="item" items="${orderDetails}">
                                                <c:set var="totalItems" value="${totalItems + 1}" />
                                            </c:forEach>
                                            ${totalItems}
                                        </div>
                                        <div class="stat-label">Đồ vật hiện tại </div>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-weight"></i>
                                    </div>
                                    <div class="stat-content">
                                        <div class="stat-number">
                                            <c:set var="totalWeight" value="0" />
                                            <c:forEach var="item" items="${orderDetails}">
                                                <c:set var="totalWeight" value="${totalWeight + (item.weightKg * item.quantity)}" />
                                            </c:forEach>
                                            <fmt:formatNumber value="${totalWeight}" pattern="#,##0.0"/>
                                        </div>
                                        <div class="stat-label">Tổng trọng lượng (kg)</div>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-sort-numeric-up"></i>
                                    </div>
                                    <div class="stat-content">
                                        <div class="stat-number">
                                            <c:set var="totalQuantity" value="0" />
                                            <c:forEach var="item" items="${orderDetails}">
                                                <c:set var="totalQuantity" value="${totalQuantity + item.quantity}" />
                                            </c:forEach>
                                            ${totalQuantity}
                                        </div>
                                        <div class="stat-label">Tổng số lượng</div>
                                    </div>
                                </div>
                                <div class="stat-card">
                                    <div class="stat-icon">
                                        <i class="fas fa-cube"></i>
                                    </div>
                                    <div class="stat-content">
                                        <div class="stat-number">
                                            <c:set var="totalVolume" value="0" />
                                            <c:forEach var="item" items="${orderDetails}">
                                                <c:set var="volume" value="${(item.lengthCm * item.widthCm * item.heightCm) / 1000000}" />
                                                <c:set var="totalVolume" value="${totalVolume + (volume * item.quantity)}" />
                                            </c:forEach>
                                            <fmt:formatNumber value="${totalVolume}" pattern="#,##0.00"/>
                                        </div>
                                        <div class="stat-label">Tổng thể tích (m³)</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Items Table Section -->
                    <div class="table-section">
                        <div class="container">
                            <div class="table-header">
                                <h3><i class="fas fa-list"></i> Danh sách đồ vật</h3>
                                <c:if test="${not empty keyword}">
                                    <div class="search-info">
                                        <span class="search-keyword">Kết quả tìm kiếm cho: "<strong>${keyword}</strong>"</span>
                                    </div>
                                </c:if>
                            </div>
                            <div class="table-container" style="overflow-x: auto;">
                                <table class="items-table">
                                    <thead>
                                        <tr>
                                            <th><i class="fas fa-hashtag"></i> No</th>
                                            <th><i class="fas fa-image"></i> Hình ảnh</th>
                                            <th><i class="fas fa-tag"></i> Tên đồ vật</th>
                                            <th><i class="fas fa-sort-numeric-up"></i> Số lượng</th>
                                            <th><i class="fas fa-weight"></i> Trọng lượng (kg)</th>
                                            <th><i class="fas fa-ruler"></i> Kích thước (cm)</th>
                                            <th><i class="fas fa-cube"></i> Thể tích (m³)</th>
                                            <th><i class="fas fa-sticky-note"></i> Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${not empty orderDetails}">
                                                <c:forEach var="item" items="${orderDetails}" varStatus="status">
                                                    <tr>
                                                        <td>
                                                            <span class="row-number">${(currentPage - 1) * 5 + status.index + 1}</span>
                                                        </td>
                                                        <td>
                                                            <div class="image-container">
                                                                <c:choose>
                                                                    <c:when test="${not empty item.imageUrl}">
                                                                        <img src="${item.imageUrl}" alt="${item.itemName}" 
                                                                             class="item-image" 
                                                                             onerror="this.src='${pageContext.request.contextPath}/images/no-image.png'">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="/placeholder.svg?height=60&width=60" alt="${item.itemName}" class="item-image">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="item-name">
                                                                <c:choose>
                                                                    <c:when test="${not empty keyword}">
                                                                        ${item.itemName.replaceAll("(?i)(" += keyword += ")", "<mark>$1</mark>")}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${item.itemName}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <span class="quantity-badge">${item.quantity}</span>
                                                        </td>
                                                        <td>
                                                            <div class="weight-info">
                                                                <span class="weight-unit">
                                                                    <fmt:formatNumber value="${item.weightKg}" pattern="#,##0.00"/>
                                                                </span>
                                                                <small class="weight-total">
                                                                    (Tổng: <fmt:formatNumber value="${item.weightKg * item.quantity}" pattern="#,##0.00"/> kg)
                                                                </small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="dimensions">
                                                                <span class="dimension-item">D: ${item.lengthCm}</span>
                                                                <span class="dimension-item">R: ${item.widthCm}</span>
                                                                <span class="dimension-item">C: ${item.heightCm}</span>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="volume-info">
                                                                <c:set var="unitVolume" value="${(item.lengthCm * item.widthCm * item.heightCm) / 1000000}" />
                                                                <span class="volume-unit">
                                                                    <fmt:formatNumber value="${unitVolume}" pattern="#,##0.000"/>
                                                                </span>
                                                                <small class="volume-total">
                                                                    (Tổng: <fmt:formatNumber value="${unitVolume * item.quantity}" pattern="#,##0.000"/> m³)
                                                                </small>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="note-cell">
                                                                <c:choose>
                                                                    <c:when test="${not empty item.note}">
                                                                        ${item.note}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="no-note">Không có ghi chú</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <tr>
                                                    <td colspan="8" class="no-results">
                                                        <c:choose>
                                                            <c:when test="${not empty keyword}">
                                                                <i class="fas fa-search"></i>
                                                                <h3>Không tìm thấy kết quả</h3>
                                                                <p>Không có mặt hàng nào phù hợp với từ khóa "<strong>${keyword}</strong>"</p>
                                                                <a href="${pageContext.request.contextPath}/order/detail/item/?orderId=${orderId}" class="btn-clear-inline">
                                                                    <i class="fas fa-times"></i> Xóa bộ lọc
                                                                </a>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-box-open"></i>
                                                                <h3>Không có mặt hàng nào</h3>
                                                                <p>Đơn hàng này chưa có mặt hàng nào được thêm vào.</p>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                </tr>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>                      
                        </div>
                    </div>

                    <!-- Pagination Section -->
                    <c:if test="${totalPages > 1}">
                        <div class="pagination-section">
                            <div class="container">
                                <div class="pagination-container">
                                    <div class="pagination-info">
                                        <span>Trang ${currentPage} / ${totalPages}</span>
                                        <span class="separator">•</span>
                                        <span>Hiển thị ${(currentPage - 1) * 5 + 1}-${currentPage * 5 > totalPages * 5 ? totalPages * 5 : currentPage * 5} mục</span>
                                    </div>
                                    <div class="pagination-controls">
                                        <!-- Previous Button -->
                                        <c:if test="${currentPage > 1}">
                                            <a href="?orderId=${orderId}&page=${currentPage - 1}&keyword=${keyword}" 
                                               class="pagination-btn">
                                                <i class="fas fa-chevron-left"></i> Trước
                                            </a>
                                        </c:if>

                                        <!-- Page Numbers -->
                                        <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                            <c:choose>
                                                <c:when test="${pageNum == currentPage}">
                                                    <span class="pagination-btn active">${pageNum}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="?orderId=${orderId}&page=${pageNum}&keyword=${keyword}" 
                                                       class="pagination-btn">${pageNum}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>

                                        <!-- Next Button -->
                                        <c:if test="${currentPage < totalPages}">
                                            <a href="?orderId=${orderId}&page=${currentPage + 1}&keyword=${keyword}" 
                                               class="pagination-btn">
                                                Sau <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:if>

                
                </div>
            </div>
        </div>
    </body>
</html>