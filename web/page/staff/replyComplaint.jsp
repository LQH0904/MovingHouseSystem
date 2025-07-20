<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Khiếu nại & Phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

        <%-- Các file CSS dùng chung --%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/replyComplaint.css">
    </head>
    <body class="bg-light">
        <div class="container mt-4">
            <h3 class="mb-4 text-primary border-bottom pb-2">Chi tiết Khiếu nại #<c:out value="${currentComplaint.issueId}"/></h3>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <c:if test="${currentComplaint != null}">
                <div class="card mb-4">
                    <div class="card-header bg-primary text-white">Thông tin Khiếu nại</div>
                    <div class="card-body">
                        <p><strong>Người gửi:</strong> ${currentComplaint.username}</p>
                        <p><strong>Mô tả:</strong> ${currentComplaint.description}</p>
                        <p><strong>Trạng thái:</strong> ${currentComplaint.status}</p>
                        <p><strong>Ưu tiên:</strong> ${currentComplaint.priority}</p>
                        <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${currentComplaint.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                        <p><strong>Ngày xử lý:</strong>
                            <c:choose>
                                <c:when test="${currentComplaint.resolvedAt != null}">
                                    <fmt:formatDate value="${currentComplaint.resolvedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </c:when>
                                <c:otherwise>Chưa xử lý</c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>

                <h4 class="mb-3 text-primary">Trả lời Khiếu nại</h4>
                <form action="${pageContext.request.contextPath}/replyComplaint" method="post" class="needs-validation" novalidate>
                    <input type="hidden" name="issueId" value="${currentComplaint.issueId}">
                    <div class="mb-3">
                        <label class="form-label">Trạng thái mới:</label>
                        <select name="status" class="form-select" required>
                            <option value="open">Mở</option>
                            <option value="in_progress">Đang xử lý</option>
                            <option value="resolved">Đã xử lý</option>
                            <option value="escalated">Chuyển cấp</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Mức độ ưu tiên:</label>
                        <select name="priority" class="form-select" required>
                            <option value="low">Thấp</option>
                            <option value="normal">Bình thường</option>
                            <option value="high">Cao</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Nội dung phản hồi:</label>
                        <textarea name="replyContent" class="form-control" rows="4" required></textarea>
                    </div>
                    <button type="submit" class="btn btn-success">Gửi phản hồi</button>
                    <a href="${pageContext.request.contextPath}/ComplaintServlet" class="btn btn-secondary">Quay lại danh sách</a>
                </form>

                <h4 class="mt-5 text-primary">Lịch sử phản hồi</h4>
                  <c:choose>
                <c:when test="${empty replies}">
                    <div class="empty-history">
                        <i class="bi bi-chat-left-text" style="font-size: 2rem;"></i>
                        <p class="mt-2 mb-0">Chưa có phản hồi nào</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive history-table">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th style="width: 20%">Thời gian</th>
                                    <th style="width: 20%">ID Người phản hồi</th>
                                    <th style="width: 60%">Nội dung</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reply" items="${replies}">
                                    <tr>
                                        <td>
                                            <fmt:formatDate value="${reply.repliedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </td>
                                        <td><c:out value="${reply.replierId}"/></td>
                                        <td><c:out value="${reply.replyContent}"/></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
</c:if>  

            <c:if test="${currentComplaint == null}">
                <div class="alert alert-warning text-center">Không tìm thấy thông tin khiếu nại.</div>
            </c:if>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            (function () {
                'use strict';
                var forms = document.querySelectorAll('.needs-validation');
                Array.prototype.slice.call(forms).forEach(function (form) {
                    form.addEventListener('submit', function (event) {
                        if (!form.checkValidity()) {
                            event.preventDefault();
                            event.stopPropagation();
                        }
                        form.classList.add('was-validated');
                    }, false);
                });
            })();
        </script>
    </body>
</html>
