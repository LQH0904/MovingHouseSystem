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

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/replyComplaint.css">
        <style>
            /* Thêm style mới cho character counter */
            .char-counter {
                font-size: 0.8rem;
                text-align: right;
                margin-top: 0.25rem;
                color: #6c757d;
            }
            .char-counter.warning {
                color: #ffc107;
            }
            .char-counter.danger {
                color: #dc3545;
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
                </div>
                <div class="div3 p-4">
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
                                <textarea name="replyContent" class="form-control" rows="4" maxlength="265" required></textarea>
                                <div class="char-counter" id="charCounter">0/265 ký tự</div>
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
            </div>
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

            // Thêm script mới để đếm ký tự
            document.addEventListener('DOMContentLoaded', function () {
                const textarea = document.querySelector('textarea[name="replyContent"]');
                const charCounter = document.getElementById('charCounter');

                textarea.addEventListener('input', function () {
                    const currentLength = this.value.length;
                    const maxLength = 265;
                    charCounter.textContent = `${currentLength}/${maxLength} ký tự`;

                    // Đổi màu khi gần đạt giới hạn
                    if (currentLength > maxLength * 0.8) {
                        charCounter.className = 'char-counter warning';
                    } else if (currentLength > maxLength) {
                        charCounter.className = 'char-counter danger';
                    } else {
                        charCounter.className = 'char-counter';
                    }

                    // Giới hạn ký tự
                    if (currentLength > maxLength) {
                        this.value = this.value.substring(0, maxLength);
                        charCounter.textContent = `${maxLength}/${maxLength} ký tự (đã đạt giới hạn)`;
                        charCounter.className = 'char-counter danger';
                    }
                });

                // Validate khi submit form
                const form = document.querySelector('.needs-validation');
                form.addEventListener('submit', function (e) {
                    const replyContent = textarea.value;
                    if (replyContent.length > 265) {
                        e.preventDefault();
                        alert('Nội dung phản hồi không được vượt quá 265 ký tự');
                        textarea.focus();
                    }
                });
            });
        </script>
    </body>
</html>