<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết Khiếu nại</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/OperatorDetail.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            body {
                background-color: #f8f9fa;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }
            .parent {
                display: grid;
                grid-template-columns: 250px 1fr;
                grid-template-rows: auto 1fr;
                min-height: 100vh;
            }
            .div1 {
                grid-column: 1;
                grid-row: 1 / span 2;
            }
            .div2 {
                grid-column: 2;
                grid-row: 1;
            }
            .div3 {
                grid-column: 2;
                grid-row: 2;
                padding: 20px;
            }
            .container {
                background-color: white;
                border-radius: 8px;
                box-shadow: 0 2px 4px rgba(0,0,0,0.1);
                padding: 2rem;
                margin-top: 1rem;
                margin-bottom: 2rem;
            }
            .complaint-details {
                background-color: #f8f9fa;
                padding: 1.5rem;
                border-radius: 8px;
                margin-bottom: 1.5rem;
            }
            .complaint-details p {
                margin-bottom: 0.8rem;
            }
            .btn-group {
                margin-bottom: 1.5rem;
            }
            .btn {
                margin-right: 0.5rem;
            }
            .alert {
                padding: 0.75rem 1.25rem;
                margin-bottom: 1rem;
                border-radius: 0.25rem;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 1rem;
            }
            th, td {
                padding: 0.75rem;
                text-align: left;
                border: 1px solid #dee2e6;
            }
            th {
                background-color: #f8f9fa;
            }
            .no-history {
                text-align: center;
                padding: 1rem;
                color: #6c757d;
                font-style: italic;
            }
        </style>
    </head>
    <body>
        <div class="parent">
           <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp" />
            </div>
            <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp" />
            </div>
            <div class="div3">
                <div class="container">
                    <h1 class="mb-4">Chi tiết Khiếu nại</h1>

                    <!-- Thông báo -->
                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${successMessage}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <!-- THÔNG TIN CHI TIẾT KHIẾU NẠI -->
                    <div class="complaint-details">
                        <p><strong>ID:</strong> ${complaint.issueId}</p>
                        <p><strong>Người gửi:</strong> ${complaint.username}</p>
                        <p><strong>Mô tả:</strong> ${complaint.description}</p>
                        <p><strong>Trạng thái:</strong> 
                            <span class="badge bg-${complaint.status == 'resolved' ? 'success' : 
                                                    complaint.status == 'processing' ? 'primary' : 
                                                    complaint.status == 'escalated' ? 'warning' : 'secondary'}">
                                      ${complaint.status}
                                  </span>
                            </p>
                            <p><strong>Mức độ ưu tiên:</strong> 
                                <span class="badge bg-${complaint.priority == 'High' ? 'danger' : 
                                                        complaint.priority == 'Medium' ? 'warning' : 
                                                        complaint.priority == 'Low' ? 'success' : 'secondary'}">
                                          ${complaint.priority}
                                      </span>
                                </p>
                                <p><strong>Ngày tạo:</strong> 
                                    <fmt:formatDate value="${complaint.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                                </p>
                                <p><strong>Ngày giải quyết:</strong> 
                                    <c:choose>
                                        <c:when test="${complaint.resolvedAt != null}">
                                            <fmt:formatDate value="${complaint.resolvedAt}" pattern="dd/MM/yyyy HH:mm" />
                                        </c:when>
                                        <c:otherwise>Chưa giải quyết</c:otherwise>
                                    </c:choose>
                                </p>
                            </div>

                            <!-- NÚT CHỨC NĂNG -->
                            <div class="btn-group">
                                <form action="${pageContext.request.contextPath}/OperatorReplyComplaintServlet" method="get" style="display:inline;">
                                    <input type="hidden" name="issueId" value="${complaint.issueId}">
                                    <button type="submit" class="btn btn-primary">Phản hồi</button> 
                                </form>

                                <form action="${pageContext.request.contextPath}/OperatorHistoryServlet" method="get" style="display:inline;">
                                    <input type="hidden" name="issueId" value="${complaint.issueId}" />
                                    <button type="submit" class="btn btn-info">Xem lịch sử phản hồi</button>
                                </form>

                                <form action="${pageContext.request.contextPath}/operatorComplaintList" method="get" style="display:inline;">
                                    <button type="submit" class="btn btn-secondary">Quay lại danh sách</button>
                                </form>
                            </div>

                            <hr>

                            <!-- LỊCH SỬ PHẢN HỒI -->
                            <c:choose>
                                <c:when test="${not empty replyHistory}">
                                    <h3>Lịch sử phản hồi</h3>
                                    <table class="table table-bordered">
                                        <thead class="table-light">
                                            <tr>
                                                <th>Người phản hồi</th>
                                                <th>Nội dung</th>
                                                <th>Thời gian</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="reply" items="${replyHistory}">
                                                <tr>
                                                    <td>${reply.replierName}</td>
                                                    <td>${reply.content}</td>
                                                    <td><fmt:formatDate value="${reply.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-history">
                                        <p><em>Chưa có phản hồi nào.</em></p>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>

                <!-- Bootstrap JS Bundle with Popper -->
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>
        </html>