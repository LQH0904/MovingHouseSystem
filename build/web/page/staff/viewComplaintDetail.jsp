<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Khiếu nại</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">

        <style>
            body {
                background-color: #f8f9fa; /* màu nền nhẹ */
            }

            h3, h4 {
                color: #0d6efd; /* màu xanh Bootstrap */
            }

            .card {
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
                border-radius: 10px;
            }

            .card-body p {
                margin-bottom: 10px;
                font-size: 16px;
            }

            .list-group-item {
                border: 1px solid #dee2e6;
                border-radius: 5px;
                margin-bottom: 10px;
                background-color: #fff;
            }

            .list-group-item p {
                margin: 0;
            }

            .btn-success, .btn-secondary {
                border-radius: 8px;
                padding: 8px 20px;
                font-size: 16px;
                transition: all 0.3s ease;
            }

            .btn-success:hover, .btn-secondary:hover {
                opacity: 0.9;
                transform: scale(1.02);
            }

            .alert-info, .alert-danger {
                border-radius: 8px;
            }

            .container {
                max-width: 800px;
                background-color: #ffffff;
                padding: 30px;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
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
                    <div class="container mt-5">
                        <h3 class="mb-4">Chi tiết Khiếu nại #<c:out value="${complaint.issueId}"/></h3>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <c:if test="${complaint != null}">
                        <div class="card mb-4">
                            <div class="card-body">
                                <p><strong>Người gửi:</strong> <c:out value="${complaint.username}"/></p>
                                <p><strong>Mô tả:</strong> <c:out value="${complaint.description}"/></p>
                                <p><strong>Trạng thái:</strong> <c:out value="${complaint.status}"/></p>
                                <p><strong>Ưu tiên:</strong> <c:out value="${complaint.priority}"/></p>
                                <p><strong>Ngày tạo:</strong> <fmt:formatDate value="${complaint.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/></p>
                                <p><strong>Ngày xử lý:</strong>
                                    <c:choose>
                                        <c:when test="${complaint.resolvedAt != null}">
                                            <fmt:formatDate value="${complaint.resolvedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </c:when>
                                        <c:otherwise>Chưa xử lý</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>
                        </div>

                        <h4>Lịch sử phản hồi</h4>
                        <c:choose>
                            <c:when test="${not empty replies}">
                                <div class="list-group">
                                    <c:forEach var="reply" items="${replies}">
                                        <div class="list-group-item">
                                            <p class="mb-1"><strong>Nội dung:</strong> <c:out value="${reply.replyContent}"/></p>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${reply.repliedAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                            </small>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="alert alert-info">Chưa có phản hồi nào.</div>
                            </c:otherwise>
                        </c:choose>
                        <a href="${pageContext.request.contextPath}/ViewReplyDetailServlet?issueId=${complaint.issueId}" 
                           class="btn btn-outline-primary mt-3">
                            <i class="bi bi-clock-history"></i> Xem chi tiết lịch sử phản hồi
                        </a>

                        <a href="${pageContext.request.contextPath}/replyComplaint?issueId=${complaint.issueId}" class="btn btn-success mt-3">
                            <i class="bi bi-reply-fill"></i> Phản hồi
                        </a>
                    </c:if>

                    <a href="${pageContext.request.contextPath}/ComplaintServlet" class="btn btn-secondary mt-3">Quay lại danh sách</a>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>