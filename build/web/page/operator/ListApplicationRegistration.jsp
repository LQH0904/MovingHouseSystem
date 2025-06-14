<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registration List</title>
        <!--        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">-->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ListApplication.css">
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
                        <div class="card shadow-sm border-0 bg-info text-white">
                            <div class="card-body">
                                <h4>${total}</h4>
                                <p class="mb-0"><i class="bi bi-people"></i> Total Registrations</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card shadow-sm border-0 bg-warning text-dark">
                            <div class="card-body">
                                <h4>${pending}</h4>
                                <p class="mb-0"><i class="bi bi-hourglass-split"></i> Pending</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card shadow-sm border-0 bg-success text-white">
                            <div class="card-body">
                                <h4>${approved}</h4>
                                <p class="mb-0"><i class="bi bi-check-circle"></i> Approved</p>
                            </div>
                        </div>
                    </div>

                    <div class="col-md-3">
                        <div class="card shadow-sm border-0 bg-danger text-white">
                            <div class="card-body">
                                <h4>${rejected}</h4>
                                <p class="mb-0"><i class="bi bi-x-circle"></i> Rejected</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Main Data Card -->
                <div class="card shadow">
                    <div class="card-header d-flex justify-content-between align-items-center flex-wrap">
                        <h5 class="mb-2 mb-md-0"><i class="bi bi-list-check me-2"></i>Registration List</h5>

                        <!-- Search Form -->
                        <form class="d-flex" method="get" action="${pageContext.request.contextPath}/registration-list">
                            <input type="text" name="keyword" class="form-control me-2" placeholder="Search by name..." value="${param.keyword}">
                            <button class="btn btn-outline-primary" type="submit">
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
                                    <table class="table table-hover align-middle">
                                        <thead class="table-light">
                                            <tr>
                                                <th scope="col" width="10%">ID</th>
                                                <th scope="col" width="40%"><i class="bi bi-person-badge"></i> Name</th>
                                                <th scope="col" width="15%"><i class="bi bi-briefcase"></i> Type</th>
                                                <th scope="col" width="15%"><i class="bi bi-bar-chart"></i> Status</th>
                                                <th scope="col" width="20%"><i class="bi bi-tools"></i> Action</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="item" items="${applications}">
                                                <tr>
                                                    <td><span class="badge bg-primary fs-6">${item.application_id}</span></td>
                                                    <td><strong>${item.username}</strong></td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.role_id == 1}"><span class="text-dark"><i class="bi bi-person-workspace"></i> Admin</span></c:when>
                                                            <c:when test="${item.role_id == 2}"><span class="text-secondary"><i class="bi bi-hammer"></i> Operator</span></c:when>
                                                            <c:when test="${item.role_id == 3}"><span class="text-info"><i class="bi bi-person-lines-fill"></i> Staff</span></c:when>
                                                            <c:when test="${item.role_id == 4}"><span class="text-warning"><i class="bi bi-truck"></i> Transport</span></c:when>
                                                            <c:when test="${item.role_id == 5}"><span class="text-success"><i class="bi bi-building"></i> Storage</span></c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${item.status_id == 1}"><span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Pending</span></c:when>
                                                            <c:when test="${item.status_id == 2}"><span class="badge bg-success"><i class="bi bi-check-circle"></i> Approved</span></c:when>
                                                            <c:when test="${item.status_id == 3}"><span class="badge bg-danger"><i class="bi bi-x-circle"></i> Rejected</span></c:when>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="${pageContext.request.contextPath}/appli-detail?id=${item.application_id}" class="btn btn-sm btn-outline-secondary">
                                                            <i class="bi bi-pencil-square me-1"></i> View
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

                <!-- Footer Buttons -->
                <div class="mt-4 text-center">
                    <button class="btn btn-primary me-2" onclick="window.location.reload()">
                        <i class="bi bi-arrow-clockwise"></i> Refresh
                    </button>
                    <button class="btn btn-outline-secondary" onclick="window.history.back()">
                        <i class="bi bi-arrow-left"></i> Back
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    
<!--    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
</body>

</html>