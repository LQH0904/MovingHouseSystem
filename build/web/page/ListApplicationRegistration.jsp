<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Registration List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            
            .type-transport {
                color: #0066cc;
                font-weight: bold;
            }
            .type-storage {
                color: #6f42c1;
                font-weight: bold;
            }
        </style>
        <link rel="stylesheet" href="../css/HomePage.css">
    </head>
    <body class="bg-light">
        <div class="parent">
            <div class="div1"><jsp:include page="../Layout/SideBar.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="../Layout/Header.jsp"></jsp:include> </div>
                <div class="div3"> 
                    <div class="container mt-4">
                        <div class="row">
                            <div class="col-12">
                                


                                <!-- Summary Card -->
                                <div class="card mb-4">
                                    <div class="card-body">
                                        <div class="row text-center">
                                            
                                            <div class="col-md-3">
                                                <div class="bg-info text-white p-3 rounded">
                                                    <h4>2</h4>
                                                    <p class="mb-0">Total Registrations</p>
                                                </div>
                                            </div>

                                            <!-- Pending -->
                                            <div class="col-md-3">
                                                <div class="bg-warning text-dark p-3 rounded">
                                                    <h4>1</h4>
                                                    <p class="mb-0">Pending</p>
                                                </div>
                                            </div>

                                            <!-- Approved -->
                                            <div class="col-md-3">
                                                <div class="bg-success text-white p-3 rounded">
                                                    <h4>1</h4>
                                                    <p class="mb-0">Approved</p>
                                                </div>
                                            </div>

                                            <!-- Rejected -->
                                            <div class="col-md-3">
                                                <div class="bg-danger text-white p-3 rounded">
                                                    <h4>1</h4>
                                                    <p class="mb-0">Rejected</p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>


                                <!-- Main Data Card -->
                                <div class="card">
                                    <div class="card-header">
                                        <h5 class="mb-0">Registration List</h5>
                                    </div>
                                    <div class="card-body">
                                    <c:choose>
                                        <c:when test="${empty registrations}">
                                            <!-- Empty State -->
                                            <div class="text-center py-5">
                                                <div class="mb-4">
                                                    <i class="bi bi-inbox" style="font-size: 4rem; color: #6c757d;"></i>
                                                </div>
                                                <h4 class="text-muted">No Registrations Found</h4>
                                                <p class="text-muted">There are no registration records in the system.</p>


                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Data Table -->
                                            <div class="table-responsive">
                                                <table class="table table-striped table-hover">
                                                    <thead class="table-dark">
                                                        <tr>
                                                            <th scope="col" width="15%">
                                                                <i class="bi bi-hash"></i> ID
                                                            </th>
                                                            <th scope="col" width="45%">
                                                                <i class="bi bi-building"></i> Name
                                                            </th>
                                                            <th scope="col" width="20%">
                                                                <i class="bi bi-tag"></i> Type
                                                            </th>
                                                            <th scope="col" width="20%">
                                                                <i class="bi bi-check-circle"></i> Status
                                                            </th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="item" items="${registrations}" varStatus="status">
                                                            <tr>
                                                                <!-- ID Column -->
                                                                <td>
                                                                    <span class="badge bg-primary fs-6">#${item.id}</span>
                                                                </td>

                                                                <!-- Name Column -->
                                                                <td>
                                                                    <strong>${item.name}</strong>
                                                                </td>

                                                                <!-- Type Column -->
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${item.type == 'transport'}">
                                                                            <span class="type-transport">
                                                                                <i class="bi bi-truck"></i> Transport
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${item.type == 'storage'}">
                                                                            <span class="type-storage">
                                                                                <i class="bi bi-building"></i> Storage
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted">${item.type}</span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>

                                                                <!-- Status Column -->
                                                                <td>

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

                            <!-- Footer Actions -->
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
            </div>
        </div>



        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css">
    </body>
</html>