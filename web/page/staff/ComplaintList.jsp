<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page import="model.UserAdmin"%>
<%
    // Header for preventing caching
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Update Profile</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/UpDateProfile.css">
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

                <div class="div3 p-4"> <%-- Thêm padding để nội dung không dính vào lề --%>
                <h3 class="mb-4 text-primary border-bottom pb-2">Danh Sách Khiếu Nại</h3>

                <%-- Hiển thị thông báo cập nhật (nếu có) --%>
                <c:if test="${not empty updateMessage}">
                    <div class="alert alert-${updateMessageType} alert-dismissible fade show" role="alert">
                        <c:out value="${updateMessage}"/>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                </c:if>

                <%-- Form tìm kiếm và lọc --%>
                <form action="${pageContext.request.contextPath}/ComplaintServlet" method="get" class="mb-4">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" name="search" class="form-control"
                                   placeholder="Tìm kiếm theo tên người dùng hoặc mô tả"
                                   value="${searchTerm != null ? searchTerm : ''}">
                        </div>
                        <div class="col-md-3">
                            <select name="statusFilter" class="form-select">
                                <option value="">-- Trạng thái --</option>
                                <option value="open" ${statusFilter eq 'open' ? 'selected' : ''}>Mở</option>
                                <option value="in_progress" ${statusFilter eq 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
                                <option value="resolved" ${statusFilter eq 'resolved' ? 'selected' : ''}>Đã xử lý</option>
                                <option value="escalated" ${statusFilter eq 'escalated' ? 'selected' : ''}>Chuyển cấp cao</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <select name="priorityFilter" class="form-select">
                                <option value="">-- Ưu tiên --</option>
                                <option value="low" ${priorityFilter eq 'low' ? 'selected' : ''}>Thấp</option>
                                <option value="normal" ${priorityFilter eq 'normal' ? 'selected' : ''}>Bình thường</option>
                                <option value="high" ${priorityFilter eq 'high' ? 'selected' : ''}>Cao</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel me-1"></i> Tìm</button>
                        </div>
                    </div>
                </form>

                <%-- Bảng hiển thị danh sách khiếu nại --%>
                <div class="table-responsive">
                    <table class="table table-hover table-striped">
                        <thead class="table-primary">
                            <tr>
                                <th>ID</th>
                                <th>Người Gửi</th>
                                <th>Mô Tả</th>
                                <th>Trạng Thái</th>
                                <th>Ưu Tiên</th>
                                <th>Ngày Tạo</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${not empty complaints}">
                                    <c:forEach var="complaint" items="${complaints}">
                                        <tr>
                                            <td><c:out value="${complaint.issueId}"/></td>
                                            <td><c:out value="${complaint.username}"/></td>
                                            <td><c:out value="${complaint.description}"/></td>
                                            <td>
                                                <span class="badge rounded-pill p-2
                                                      <c:choose>
                                                          <c:when test="${complaint.status eq 'open'}">bg-secondary</c:when>
                                                          <c:when test="${complaint.status eq 'in_progress'}">bg-info text-dark</c:when>
                                                          <c:when test="${complaint.status eq 'resolved'}">bg-success</c:when>
                                                          <c:when test="${complaint.status eq 'escalated'}">bg-danger</c:when>
                                                          <c:otherwise>bg-light text-dark</c:otherwise>
                                                      </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${complaint.status eq 'open'}">Mở</c:when>
                                                        <c:when test="${complaint.status eq 'in_progress'}">Đang xử lý</c:when>
                                                        <c:when test="${complaint.status eq 'resolved'}">Đã xử lý</c:when>
                                                        <c:when test="${complaint.status eq 'escalated'}">Chuyển cấp cao</c:when>
                                                        <c:otherwise><c:out value="${complaint.status}"/></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td>
                                                <span class="badge rounded-pill p-2
                                                      <c:choose>
                                                          <c:when test="${complaint.priority eq 'high'}">bg-warning text-dark</c:when>
                                                          <c:when test="${complaint.priority eq 'normal'}">bg-secondary</c:when>
                                                          <c:when test="${complaint.priority eq 'low'}">bg-info text-dark</c:when>
                                                          <c:otherwise>bg-light text-dark</c:otherwise>
                                                      </c:choose>">
                                                    <c:choose>
                                                        <c:when test="${complaint.priority eq 'high'}">Cao</c:when>
                                                        <c:when test="${complaint.priority eq 'normal'}">Bình thường</c:when>
                                                        <c:when test="${complaint.priority eq 'low'}">Thấp</c:when>
                                                        <c:otherwise><c:out value="${complaint.priority}"/></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td><fmt:formatDate value="${complaint.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                            <td>
                                                <%-- Đường dẫn đến trang chi tiết/trả lời khiếu nại --%>
                                                <a href="${pageContext.request.contextPath}/ComplaintServlet?action=view&issueId=${complaint.issueId}"
                                                   class="btn btn-sm btn-info">Chi tiết / Trả lời</a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <tr>
                                        <td colspan="7" class="text-center">Không tìm thấy khiếu nại nào.</td>
                                    </tr>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </div>

                <%-- Phần phân trang --%>
                <div class="pagination-wrapper mt-3 d-flex justify-content-center">
                    <ul class="pagination">
                        <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/ComplaintServlet?page=${currentPage - 1}&search=${searchTerm}&statusFilter=${statusFilter}&priorityFilter=${priorityFilter}"
                               aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                <a class="page-link"
                                   href="${pageContext.request.contextPath}/ComplaintServlet?page=${i}&search=${searchTerm}&statusFilter=${statusFilter}&priorityFilter=${priorityFilter}">${i}</a>
                            </li>
                        </c:forEach>
                        <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                            <a class="page-link"
                               href="${pageContext.request.contextPath}/ComplaintServlet?page=${currentPage + 1}&search=${searchTerm}&statusFilter=${statusFilter}&priorityFilter=${priorityFilter}"
                               aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/Header.js"></script> <%-- Giả sử Header.js là file JS chung --%>
        <script>
            // Xóa các tham số `updateStatus` và `message` khỏi URL sau khi trang tải để URL sạch hơn
            window.onload = function () {
                const url = new URL(window.location);
                if (url.searchParams.has("updateStatus")) {
                    url.searchParams.delete("updateStatus");
                    if (url.searchParams.has("message")) {
                        url.searchParams.delete("message");
                    }
                    window.history.replaceState({}, '', url.toString());
                }
            };
        </script>
    </body>
</html>