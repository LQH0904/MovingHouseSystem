<%-- Giả sử đây là nội dung đầy đủ của OperatorComplaintList.jsp của bạn --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Danh Sách Khiếu Nại Cấp Cao (Operator)</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <script src="${pageContext.request.contextPath}/js/jquery-3.5.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
    <style>
        /* CSS tùy chỉnh nếu có */
        body {
            display: flex;
        }
        .main-content {
            flex-grow: 1;
            padding: 20px;
            margin-left: 250px; /* Bằng với chiều rộng của sidebar */
        }
        .pagination-container {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }
    </style>
</head>
<body>

    <div class="main-content">
        <h1>Danh Sách Khiếu Nại Cấp Cao</h1>

        <%-- Hiển thị thông báo cập nhật --%>
        <c:if test="${not empty updateMessage}">
            <div class="alert alert-${updateMessageType} alert-dismissible fade show" role="alert">
                ${updateMessage}
                <button type="button" class="close" data-dismiss="alert" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
        </c:if>

        <%-- Form tìm kiếm và lọc --%>
        <form action="${pageContext.request.contextPath}/OperatorComplaintServlet" method="GET" class="form-inline mb-3">
            <div class="form-group mr-2">
                <input type="text" name="search" class="form-control" placeholder="Tìm kiếm theo Username/Mô tả" value="${searchTerm}">
            </div>
            <div class="form-group mr-2">
                <select name="priorityFilter" class="form-control">
                    <option value="">Tất cả ưu tiên</option>
                    <option value="low" ${priorityFilter eq 'low' ? 'selected' : ''}>Thấp</option>
                    <option value="medium" ${priorityFilter eq 'medium' ? 'selected' : ''}>Trung bình</option>
                    <option value="high" ${priorityFilter eq 'high' ? 'selected' : ''}>Cao</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Tìm kiếm/Lọc</button>
        </form>

        <p>Tổng số khiếu nại cấp cao: ${totalComplaints}</p>

        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Mô tả</th>
                    <th>Trạng thái</th>
                    <th>Ưu tiên</th>
                    <th>Ngày tạo</th>
                    <th>Ngày xử lý</th>
                    <th>Thao tác</th>
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
                                <td>${complaint.createdAt}</td>
                                <td>${complaint.resolvedAt != null ? complaint.resolvedAt : 'N/A'}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/OperatorComplaintServlet?action=view&issueId=${complaint.issueId}" class="btn btn-info btn-sm">Xem/Phản hồi</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="8" class="text-center">Không có khiếu nại cấp cao nào được tìm thấy.</td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>

        <%-- Phân trang --%>
        <div class="pagination-container">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/OperatorComplaintServlet?page=${currentPage - 1}&search=${searchTerm}&priorityFilter=${priorityFilter}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="${pageContext.request.contextPath}/OperatorComplaintServlet?page=${i}&search=${searchTerm}&priorityFilter=${priorityFilter}">${i}</a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="${pageContext.request.contextPath}/OperatorComplaintServlet?page=${currentPage + 1}&search=${searchTerm}&priorityFilter=${priorityFilter}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </div>
    </div>
</body>
</html>