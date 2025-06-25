<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Khiếu nại Chuyển Cấp cao</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
        }
        .container {
            margin-top: 30px;
        }
        h2 {
            color: #007bff;
            margin-bottom: 20px;
        }
        .filter-form {
            margin-bottom: 20px;
            padding: 15px;
            background-color: #e9ecef;
            border-radius: 5px;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .table th {
            background-color: #d6e0e7;
        }
        .alert {
            margin-bottom: 20px;
        }
        .pagination-container {
            display: flex;
            justify-content: center;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Danh sách Khiếu nại Chuyển Cấp cao</h2>

        <c:if test="${not empty successMessage}">
            <div class="alert alert-success" role="alert">
                ${successMessage}
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger" role="alert">
                ${errorMessage}
            </div>
        </c:if>

        <div class="filter-form">
            <form action="${pageContext.request.contextPath}/operatorComplaintList" method="get" class="form-inline justify-content-center">
                <div class="form-group mx-sm-3 mb-2">
                    <label for="searchTerm" class="sr-only">Tìm kiếm</label>
                    <input type="text" class="form-control" id="searchTerm" name="searchTerm"
                           placeholder="Tên, ID hoặc Mô tả" value="${searchTerm}">
                </div>
                <div class="form-group mx-sm-3 mb-2">
                    <label for="priorityFilter" class="mr-2">Mức độ ưu tiên:</label>
                    <select class="form-control" id="priorityFilter" name="priorityFilter">
                        <option value="">Tất cả</option>
                        <option value="low" <c:if test="${priorityFilter eq 'low'}">selected</c:if>>Thấp</option>
                        <option value="normal" <c:if test="${priorityFilter eq 'normal'}">selected</c:if>>Bình thường</option>
                        <option value="high" <c:if test="${priorityFilter eq 'high'}">selected</c:if>>Cao</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary mb-2">Tìm kiếm & Lọc</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${not empty escalatedComplaints}">
                <table class="table table-bordered table-hover">
                    <thead class="thead-light">
                        <tr>
                            <th>ID Khiếu nại</th>
                            <th>Tên người dùng</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Độ ưu tiên</th>
                            <th>Thời gian tạo</th>
                            <th>Lý do chuyển cấp cao</th>
                            <th>ID Người chuyển cấp cao</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="complaint" items="${escalatedComplaints}">
                            <tr>
                                <td>${complaint.issueId}</td>
                                <td>${complaint.username}</td>
                                <td>${complaint.description}</td>
                                <td>${complaint.status}</td>
                                <td>${complaint.priority}</td>
                                <td><fmt:formatDate value="${complaint.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                <td>${complaint.escalationReason}</td>
                                <td><c:choose><c:when test="${complaint.escalatedByUserId != null}">${complaint.escalatedByUserId}</c:when><c:otherwise>N/A</c:otherwise></c:choose></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/OperatorReplyComplaintServlet?issueId=${complaint.issueId}" class="btn btn-info btn-sm">Chi tiết</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <nav aria-label="Page navigation" class="pagination-container">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/operatorComplaintList?page=1&searchTerm=${searchTerm}&priorityFilter=${priorityFilter}" aria-label="First">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/operatorComplaintList?page=${currentPage - 1}&searchTerm=${searchTerm}&priorityFilter=${priorityFilter}" aria-label="Previous">
                                <span aria-hidden="true">&lsaquo;</span>
                            </a>
                        </li>
                        <c:forEach begin="${1}" end="${totalPages}" var="i">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link" href="${pageContext.request.contextPath}/operatorComplaintList?page=${i}&searchTerm=${searchTerm}&priorityFilter=${priorityFilter}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/operatorComplaintList?page=${currentPage + 1}&searchTerm=${searchTerm}&priorityFilter=${priorityFilter}" aria-label="Next">
                                <span aria-hidden="true">&rsaquo;</span>
                            </a>
                        </li>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/operatorComplaintList?page=${totalPages}&searchTerm=${searchTerm}&priorityFilter=${priorityFilter}" aria-label="Last">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </nav>
                   <div class="text-center mt-3">
                       <p>Hiển thị ${totalComplaints} khiếu nại chuyển cấp cao.</p>
                   </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-info" role="alert">
                    Không tìm thấy khiếu nại nào ở trạng thái "chuyển cấp cao" phù hợp với tiêu chí tìm kiếm.
                </div>
            </c:otherwise>
        </c:choose>

        <p><a href="${pageContext.request.contextPath}/ComplaintServlet" class="btn btn-secondary mt-3">Quay lại danh sách khiếu nại chung</a></p>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>