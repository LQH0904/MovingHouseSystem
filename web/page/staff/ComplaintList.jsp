<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.UserAdmin"%>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Complaint List</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/complaintList.css">
    </head>
    <body class="bg-light">
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp"></jsp:include>
                </div>
                <div class="div3 p-4">
                    <h3 class="mb-4 text-primary border-bottom pb-2">Complaint List</h3>

                <c:if test="${not empty updateMessage}">
                    <div class="alert alert-${updateMessageType} alert-dismissible fade show" role="alert">
                        <c:out value="${updateMessage}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/ComplaintServlet" method="get" class="mb-4">
                    <div class="row g-3">
                        <div class="col-md-2">
                            <input type="number" name="minId" class="form-control" placeholder="From ID" 
                                   value="${param.minId}" min="1">
                        </div>
                        <div class="col-md-2">
                            <input type="number" name="maxId" class="form-control" placeholder="To ID" 
                                   value="${param.maxId}" min="1">
                        </div>
                        <div class="col-md-3">
                            <input type="text" name="search" class="form-control" placeholder="Search by name or description"
                                   value="${searchTerm != null ? searchTerm : ''}">
                        </div>
                        <div class="col-md-2">
                            <select name="statusFilter" class="form-select">
                                <option value="">-- Status --</option>
                                <option value="open" ${statusFilter eq 'open' ? 'selected' : ''}>Open</option>
                                <option value="in_progress" ${statusFilter eq 'in_progress' ? 'selected' : ''}>In Progress</option>
                                <option value="resolved" ${statusFilter eq 'resolved' ? 'selected' : ''}>Resolved</option>
                                <option value="escalated" ${statusFilter eq 'escalated' ? 'selected' : ''}>Escalated</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <select name="priorityFilter" class="form-select">
                                <option value="">-- Priority --</option>
                                <option value="low" ${priorityFilter eq 'low' ? 'selected' : ''}>Low</option>
                                <option value="normal" ${priorityFilter eq 'normal' ? 'selected' : ''}>Normal</option>
                                <option value="high" ${priorityFilter eq 'high' ? 'selected' : ''}>High</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <input type="date" name="startDate" class="form-control" value="${startDate}">
                        </div>
                        <div class="col-md-2">
                            <input type="date" name="endDate" class="form-control" value="${endDate}">
                        </div>
                        <div class="col-md-1 d-grid">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i></button>
                        </div>
                    </div>
                </form>

                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead class="table-primary">
                            <tr>
                                <th>ID</th>
                                <th>Sender</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Priority</th>
                                <th>Created At</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty complaints}">
                                    <c:forEach var="complaint" items="${complaints}">
                                        <tr>
                                            <td>${complaint.issueId}</td>
                                            <td>${complaint.username}</td>
                                            <td>${complaint.description}</td>
                                            <td>${complaint.status}</td>
                                            <td>${complaint.priority}</td>
                                            <td><fmt:formatDate value="${complaint.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                            <td>
                                                <a href="${pageContext.request.contextPath}/ComplaintServlet?action=view&issueId=${complaint.issueId}"
                                                   class="btn btn-sm btn-info">Details / Reply</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center">No complaints found.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-center mt-3">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" 
                               href="${pageContext.request.contextPath}/ComplaintServlet?page=${currentPage - 1}&search=${searchTerm}&statusFilter=${statusFilter}&priorityFilter=${priorityFilter}&startDate=${startDate}&endDate=${endDate}&minId=${param.minId}&maxId=${param.maxId}">&laquo;</a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" 
                                   href="${pageContext.request.contextPath}/ComplaintServlet?page=${i}&search=${searchTerm}&statusFilter=${statusFilter}&priorityFilter=${priorityFilter}&startDate=${startDate}&endDate=${endDate}&minId=${param.minId}&maxId=${param.maxId}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" 
                               href="${pageContext.request.contextPath}/ComplaintServlet?page=${currentPage + 1}&search=${searchTerm}&statusFilter=${statusFilter}&priorityFilter=${priorityFilter}&startDate=${startDate}&endDate=${endDate}&minId=${param.minId}&maxId=${param.maxId}">&raquo;</a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>