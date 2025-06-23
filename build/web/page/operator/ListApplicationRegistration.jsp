<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registration List</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ListApplication.css">
        <link rel="stylesheet" href="styles.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    </head>
    <body class="bg-light">
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp" />
            </div>

            <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp" />
            </div>

            <div class="div3">
                <div class="container mt-4">

                    <!-- Summary Cards -->
                    <div class="row text-center g-4 mb-4">
                        <div class="col-md-3">
                            <a href="listApplication?status=all&keyword=${keyword}" class="text-decoration-none">
                                <div class="card shadow-sm border-0 bg-info text-white summary-card">
                                    <div class="card-body">
                                        <h4>${total}</h4>
                                        <p class="mb-0"><i class="bi bi-people"></i> All</p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-3">
                            <a href="listApplication?status=pending&keyword=${keyword}" class="text-decoration-none">
                                <div class="card shadow-sm border-0 bg-warning text-dark summary-card">
                                    <div class="card-body">
                                        <h4>${pending}</h4>
                                        <p class="mb-0"><i class="bi bi-hourglass-split"></i> Pending</p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-3">
                            <a href="listApplication?status=approved&keyword=${keyword}" class="text-decoration-none">
                                <div class="card shadow-sm border-0 bg-success text-white summary-card">
                                    <div class="card-body">
                                        <h4>${approved}</h4>
                                        <p class="mb-0"><i class="bi bi-check-circle"></i> Approved</p>
                                    </div>
                                </div>
                            </a>
                        </div>

                        <div class="col-md-3">
                            <a href="listApplication?status=rejected&keyword=${keyword}" class="text-decoration-none">
                                <div class="card shadow-sm border-0 bg-danger text-white summary-card">
                                    <div class="card-body">
                                        <h4>${rejected}</h4>
                                        <p class="mb-0"><i class="bi bi-x-circle"></i> Rejected</p>
                                    </div>
                                </div>
                            </a>
                        </div>
                    </div>

                    <!-- Main Data Card -->
                    <div class="card shadow main-card">
                        <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                            <h5 class="mb-2 mb-md-0 card-title">
                                <i class="bi bi-list-check me-2"></i>Registration List
                            </h5>

                            <!-- Search Form -->
                            <form class="search-glass d-flex align-items-center" method="get" action="${pageContext.request.contextPath}/operator/listApplication">
                                <input type="text" name="keyword" class="glass-input" placeholder="Search by name..." value="${keyword}">
                                <button type="submit" class="glass-button">
                                    <i class="bi bi-search"></i>
                                </button>
                            </form>


                        </div>

                        <div class="card-body">
                            <c:choose>
                                <c:when test="${empty applications}">
                                    <div class="empty-state text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 mb-3"></i>
                                        <h4>No Registrations Found</h4>
                                    </div>
                                </c:when>

                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover align-middle data-table">
                                            <thead class="table-header">
                                                <tr>
                                                    <th scope="col" width="10%">ID</th>
                                                    <th scope="col" width="35%"><i class="bi bi-person-badge"></i> Name</th>
                                                    <th scope="col" width="20%"><i class="bi bi-briefcase"></i> Type</th>
                                                    <th scope="col" width="20%"><i class="bi bi-bar-chart"></i> Status</th>
                                                    <th scope="col" width="%"><i class="bi bi-tools"></i> Action</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="item" items="${applications}">
                                                    <tr>
                                                        <td><span class="badge bg-light text-dark id-badge">${item.application_id}</span></td>
                                                        <td><strong class="user-name">${item.username}</strong></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.role_id == 1}"><span class="text-dark role-badge"><i class="bi bi-person-workspace"></i> Admin</span></c:when>
                                                                <c:when test="${item.role_id == 2}"><span class="text-secondary role-badge"><i class="bi bi-hammer"></i> Operator</span></c:when>
                                                                <c:when test="${item.role_id == 3}"><span class="text-info role-badge"><i class="bi bi-person-lines-fill"></i> Staff</span></c:when>
                                                                <c:when test="${item.role_id == 4}"><span class="type-transport"><i class="bi bi-truck"></i> Transport</span></c:when>
                                                                <c:when test="${item.role_id == 5}"><span class="type-storage"><i class="bi bi-building"></i> Storage</span></c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${item.status_id == 1}"><span class="badge bg-warning text-dark status-badge"><i class="bi bi-hourglass-split"></i> Pending</span></c:when>
                                                                <c:when test="${item.status_id == 2}"><span class="badge bg-success status-badge"><i class="bi bi-check-circle"></i> Approved</span></c:when>
                                                                <c:when test="${item.status_id == 3}"><span class="badge bg-danger status-badge"><i class="bi bi-x-circle"></i> Rejected</span></c:when>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <a href="${pageContext.request.contextPath}/appli-detail?id=${item.application_id}" class="btn btn-sm btn-outline-primary action-btn">
                                                                <i class="bi bi-eye me-1"></i> View
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <div class="mt-4 text-center">
                        <div class="custom-pagination-container">
                            
                            <div class="pagination-wrapper">
                                <ul class="custom-pagination">
                                    <c:if test="${currentPage > 1}">
                                        <li>
                                            <a href="${pageContext.request.contextPath}/operator/listApplication?page=${currentPage - 1}&keyword=${keyword}">
                                                <i class="bi bi-chevron-left"></i> Previous
                                            </a>
                                        </li>
                                    </c:if>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="${i == currentPage ? 'active' : ''}">
                                            <a href="${pageContext.request.contextPath}/operator/listApplication?page=${i}&keyword=${keyword}">
                                                ${i}
                                            </a>
                                        </li>
                                    </c:forEach>

                                    <c:if test="${currentPage < totalPages}">
                                        <li>
                                            <a href="${pageContext.request.contextPath}/operator/listApplication?page=${currentPage + 1}&keyword=${keyword}">
                                                Next <i class="bi bi-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
