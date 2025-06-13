<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Khiếu nại và Phản hồi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    <style>
        body > nav.navbar-mainbg:first-of-type {
            display: none !important;
        }
        body > ul.pagination:first-of-type,
        body > div.pagination:first-of-type {
            display: none !important;
        }
    </style>
</head>
<body class="bg-light">
<div class="parent">
    <div class="div1"><jsp:include page="../../Layout/operator/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="../../Layout/operator/Header.jsp"/></div>
    <div class="div3 px-4 pt-4">
        <h3 class="mb-4 text-primary border-bottom pb-2">
            Chi tiết Khiếu nại #<c:out value="${currentComplaint.issueId != null ? currentComplaint.issueId : 'Không xác định'}"/>
        </h3>

        <c:if test="${currentComplaint != null}">
            <div class="card mb-4 border-primary">
                <div class="card-header bg-primary text-white fs-5">Thông tin khiếu nại</div>
                <div class="card-body">
                    <div class="row mb-2">
                        <div class="col-md-3"><strong>ID Khiếu nại:</strong></div>
                        <div class="col-md-9"><c:out value="${currentComplaint.issueId}"/></div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-md-3"><strong>Người gửi:</strong></div>
                        <div class="col-md-9"><c:out value="${currentComplaint.username}"/></div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-md-3"><strong>Mô tả:</strong></div>
                        <div class="col-md-9"><c:out value="${currentComplaint.description}"/></div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-md-3"><strong>Trạng thái hiện tại:</strong></div>
                        <div class="col-md-9">
                            <span id="currentStatusBadge" class="badge rounded-pill p-2
                                <c:choose>
                                    <c:when test="${currentComplaint.status eq 'open'}">bg-secondary</c:when>
                                    <c:when test="${currentComplaint.status eq 'in_progress'}">bg-info text-dark</c:when>
                                    <c:when test="${currentComplaint.status eq 'resolved'}">bg-success</c:when>
                                    <c:when test="${currentComplaint.status eq 'escalated'}">bg-danger</c:when>
                                    <c:otherwise>bg-light text-dark</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${currentComplaint.status eq 'open'}">Mở</c:when>
                                    <c:when test="${currentComplaint.status eq 'in_progress'}">Đang xử lý</c:when>
                                    <c:when test="${currentComplaint.status eq 'resolved'}">Đã xử lý</c:when>
                                    <c:when test="${currentComplaint.status eq 'escalated'}">Chuyển cấp cao</c:when>
                                    <c:otherwise><c:out value="${currentComplaint.status}"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-md-3"><strong>Ưu tiên:</strong></div>
                        <div class="col-md-9">
                            <span class="badge rounded-pill p-2
                                <c:choose>
                                    <c:when test="${currentComplaint.priority eq 'high'}">bg-warning text-dark</c:when>
                                    <c:when test="${currentComplaint.priority eq 'normal'}">bg-secondary</c:when>
                                    <c:when test="${currentComplaint.priority eq 'low'}">bg-info text-dark</c:when>
                                    <c:otherwise>bg-light text-dark</c:otherwise>
                                </c:choose>">
                                <c:choose>
                                    <c:when test="${currentComplaint.priority eq 'high'}">Cao</c:when>
                                    <c:when test="${currentComplaint.priority eq 'normal'}">Bình thường</c:when>
                                    <c:when test="${currentComplaint.priority eq 'low'}">Thấp</c:when>
                                    <c:otherwise><c:out value="${currentComplaint.priority}"/></c:otherwise>
                                </c:choose>
                            </span>
                        </div>
                    </div>
                    <div class="row mb-2">
                        <div class="col-md-3"><strong>Ngày tạo:</strong></div>
                        <div class="col-md-9">
                            <c:choose>
                                <c:when test="${currentComplaint.createdAt != null}">
                                    <fmt:formatDate value="${currentComplaint.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                </c:when>
                                <c:otherwise>Không có</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>

            <h4 class="mb-3 text-primary border-bottom pb-2">Trả lời Khiếu nại</h4>
            <form action="${pageContext.request.contextPath}/ComplaintServlet" method="post" class="needs-validation" novalidate>
                <input type="hidden" name="issueId" value="${currentComplaint.issueId}">

                <div class="mb-3">
                    <label for="status" class="form-label fw-bold">Trạng thái mới:</label>
                    <select name="status" id="status" class="form-select" required>
                        <option value="">-- Chọn trạng thái --</option>
                        <option value="open" <c:if test="${currentComplaint.status eq 'open'}">selected</c:if>>Mở</option>
                        <option value="in_progress" <c:if test="${currentComplaint.status eq 'in_progress'}">selected</c:if>>Đang xử lý</option>
                        <option value="resolved" <c:if test="${currentComplaint.status eq 'resolved'}">selected</c:if>>Đã xử lý</option>
                        <option value="escalated" <c:if test="${currentComplaint.status eq 'escalated'}">selected</c:if>>Chuyển cấp cao</option>
                    </select>
                    <div class="invalid-feedback">Vui lòng chọn một trạng thái.</div>
                </div>

                <div class="mb-3">
                    <label for="replyContent" class="form-label fw-bold">Nội dung phản hồi:</label>
                    <textarea class="form-control" id="replyContent" name="replyContent" rows="4" placeholder="Nhập nội dung phản hồi của bạn..." required></textarea>
                    <div class="invalid-feedback">Vui lòng nhập nội dung phản hồi.</div>
                </div>

                <button type="submit" class="btn btn-success me-2">
                    <i class="bi bi-send-fill me-1"></i> Gửi phản hồi
                </button>
                <a href="${pageContext.request.contextPath}/ComplaintServlet" class="btn btn-secondary">
                    <i class="bi bi-arrow-left-circle me-1"></i> Quay lại danh sách
                </a>
            </form>
        </c:if>

        <c:if test="${currentComplaint == null}">
            <div class="alert alert-warning text-center" role="alert">
                Không tìm thấy thông tin khiếu nại. Vui lòng kiểm tra lại ID khiếu nại hoặc quay lại
                <a href="${pageContext.request.contextPath}/ComplaintServlet">danh sách khiếu nại</a>.
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        'use strict';
        var forms = document.querySelectorAll('.needs-validation');
        Array.prototype.slice.call(forms)
            .forEach(function (form) {
                form.addEventListener('submit', function (event) {
                    if (!form.checkValidity()) {
                        event.preventDefault();
                        event.stopPropagation();
                    }
                    form.classList.add('was-validated');
                }, false);
            });
    })();

    const urlParams = new URLSearchParams(window.location.search);
    const updateStatus = urlParams.get('updateStatus');
    const issueIdFromUrl = urlParams.get('issueId');

    window.onload = function() {
        if (updateStatus === 'success') {
            alert('Cập nhật trạng thái khiếu nại thành công!');
            window.location.href = '${pageContext.request.contextPath}/ComplaintServlet';
        } else if (updateStatus === 'error') {
            alert('Lỗi: Không thể cập nhật trạng thái khiếu nại. Vui lòng thử lại.');
            const newUrl = window.location.protocol + "//" + window.location.host + window.location.pathname + '?action=view&issueId=' + issueIdFromUrl;
            window.history.replaceState({}, document.title, newUrl);
        }
    };
</script>
</body>
</html>
