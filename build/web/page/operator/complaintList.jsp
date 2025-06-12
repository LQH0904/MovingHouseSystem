<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, dao.ComplaintDAO, model.Complaint" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint List</title>
    <%-- These CSS links are crucial for the styling of this specific page --%>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <%-- Assuming these CSS files are correctly located relative to your web app's context root --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    <style>
        .table {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 10px rgba(0,0,0,0.05);
        }

        .table th {
            background-color: #f8f9fa;
            color: #333;
            font-weight: 600;
        }

        .table td {
            vertical-align: middle;
        }

        .table a {
            color: #0d6efd;
            font-weight: 500;
        }

        .table a:hover {
            text-decoration: underline;
        }

        .badge {
            font-size: 0.9em;
            padding: 0.5em 0.75em;
            border-radius: 0.5rem;
            text-transform: capitalize;
        }

        .table-striped > tbody > tr:nth-of-type(odd) {
            background-color: #f2f6f9;
        }

        h3.mb-4.text-primary {
            border-bottom: 2px solid #0d6efd;
            padding-bottom: 0.5rem;
            font-weight: bold;
        }
        .filter-section {
            background-color: #ffffff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            margin-bottom: 20px;
        }
    </style>
</head>
<body class="bg-light">
<div class="parent">
    <%-- Includes your unmodified Header and SideBar. This is the source of the potential HTML structural issues. --%>
    <div class="div1"><jsp:include page="../../Layout/operator/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="../../Layout/operator/Header.jsp"/></div>
    <div class="div3 px-4 pt-4">
        <h3 class="mb-4 text-primary">Danh sách khiếu nại</h3>

        <div class="filter-section">
            <form action="${pageContext.request.contextPath}/ComplaintServlet" method="get" class="row g-3 align-items-end">
                <div class="col-md-4">
                    <label for="searchTerm" class="form-label">Tìm kiếm:</label>
                    <input type="text" class="form-control" id="searchTerm" name="searchTerm" placeholder="Tìm theo người gửi hoặc mô tả" value="${searchTerm != null ? searchTerm : ''}">
                </div>
                <div class="col-md-3">
                    <label for="statusFilter" class="form-label">Trạng thái:</label>
                    <select class="form-select" id="statusFilter" name="statusFilter">
                        <option value="">Tất cả</option>
                        <option value="open" ${statusFilter eq 'open' ? 'selected' : ''}>Mở</option>
                        <option value="in_progress" ${statusFilter eq 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
                        <option value="resolved" ${statusFilter eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                        <option value="escalated" ${statusFilter eq 'escalated' ? 'selected' : ''}>Chuyển cấp cao</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label for="priorityFilter" class="form-label">Ưu tiên:</label>
                    <select class="form-select" id="priorityFilter" name="priorityFilter">
                        <option value="">Tất cả</option>
                        <option value="low" ${priorityFilter eq 'low' ? 'selected' : ''}>Thấp</option>
                        <option value="normal" ${priorityFilter eq 'normal' ? 'selected' : ''}>Bình thường</option>
                        <option value="high" ${priorityFilter eq 'high' ? 'selected' : ''}>Cao</option>
                    </select>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-primary w-100"><i class="bi bi-filter"></i> Lọc & Tìm</button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-bordered table-hover table-striped bg-white">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>Người gửi</th>
                    <th>Mô tả</th>
                    <th>Trạng thái</th>
                    <th>Ưu tiên</th>
                    <th>Ngày tạo</th>
                    <th>Hành động</th>
                </tr>
                </thead>
                <tbody>
                <c:set var="complaintList" value="${requestScope.complaintList}"/>
                <c:if test="${not empty complaintList}">
                    <c:forEach var="c" items="${complaintList}">
                        <tr>
                            <td><a href="complaintDetail.jsp?issueId=${c.issueId}" class="text-decoration-none">${c.issueId}</a></td>
                            <td><c:out value="${c.username}"/></td>
                            <td><c:out value="${c.description}"/></td>
                            <td>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${c.status eq 'resolved'}">bg-success</c:when>
                                        <c:when test="${c.status eq 'in_progress'}">bg-warning text-dark</c:when>
                                        <c:when test="${c.status eq 'escalated'}">bg-danger</c:when>
                                        <c:when test="${c.status eq 'open'}">bg-secondary</c:when>
                                        <c:otherwise>bg-secondary</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test="${c.status eq 'resolved'}">Đã xử lý</c:when>
                                        <c:when test="${c.status eq 'in_progress'}">Đang xử lý</c:when>
                                        <c:when test="${c.status eq 'escalated'}">Chuyển cấp cao</c:when>
                                        <c:when test="${c.status eq 'open'}">Mở</c:when>
                                        <c:otherwise>${c.status}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td>
                                <span class="badge
                                    <c:choose>
                                        <c:when test="${c.priority eq 'high'}">bg-warning text-dark</c:when>
                                        <c:when test="${c.priority eq 'normal'}">bg-secondary</c:when>
                                        <c:when test="${c.priority eq 'low'}">bg-info text-dark</c:when>
                                        <c:otherwise>bg-light text-dark</c:otherwise>
                                    </c:choose>">
                                    <c:choose>
                                        <c:when test="${c.priority eq 'high'}">Cao</c:when>
                                        <c:when test="${c.priority eq 'normal'}">Bình thường</c:when>
                                        <c:when test="${c.priority eq 'low'}">Thấp</c:when>
                                        <c:otherwise>${c.priority}</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td><c:out value="${c.createdAt != null ? c.createdAt : 'N/A'}"/></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/page/operator/replyComplaint.jsp?issueId=${c.issueId}" class="btn btn-sm btn-info text-white">
                                    <i class="bi bi-info-circle"></i> Chi tiết
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </c:if>
                <c:if test="${empty complaintList}">
                    <tr>
                        <td colspan="7" class="text-center text-muted">Không có khiếu nại nào để hiển thị.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>

        <nav aria-label="Page navigation" class="mt-4">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="ComplaintServlet?page=${currentPage - 1}&searchTerm=${searchTerm != null ? searchTerm : ''}&statusFilter=${statusFilter != null ? statusFilter : ''}&priorityFilter=${priorityFilter != null ? priorityFilter : ''}">Trước</a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="ComplaintServlet?page=${i}&searchTerm=${searchTerm != null ? searchTerm : ''}&statusFilter=${statusFilter != null ? statusFilter : ''}&priorityFilter=${priorityFilter != null ? priorityFilter != null ? priorityFilter : '' : ''}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="ComplaintServlet?page=${currentPage + 1}&searchTerm=${searchTerm != null ? searchTerm : ''}&statusFilter=${statusFilter != null ? statusFilter : ''}&priorityFilter=${priorityFilter != null ? priorityFilter : ''}">Sau</a>
                </li>
            </ul>
            <div class="text-center text-muted mt-2">
                Hiển thị ${totalComplaints > 0 ? (currentPage - 1) * recordsPerPage + 1 : 0} - ${Math.min(currentPage * recordsPerPage, totalComplaints)} trên tổng số ${totalComplaints} khiếu nại.
            </div>
        </nav>
    </div>
</div>

<%-- These JS scripts are specific to this complaintList.jsp or general to the page content. --%>
<%-- If they are also present in Header/Sidebar, it's duplication. --%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>