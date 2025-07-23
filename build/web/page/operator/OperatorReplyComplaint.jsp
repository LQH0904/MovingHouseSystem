<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Phản hồi khiếu nại</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.8.1/font/bootstrap-icons.css">
         <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            :root {
                --primary-color: #3498db;
                --success-color: #28a745;
                --error-color: #dc3545;
                --warning-color: #ffc107;
                --danger-color: #e74c3c;
                --light-gray: #f8f9fa;
                --dark-gray: #343a40;
            }

            body {
                background-color: #f5f7fa;
                color: #333;
                line-height: 1.6;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .container {
                padding: 2rem;
                max-width: 1200px;
                margin: 2rem auto;
                background-color: #fff;
                border-radius: 0.5rem;
                box-shadow: 0 0.125rem 0.25rem rgba(0, 0, 0, 0.075);
            }

            .header {
                border-bottom: 1px solid #dee2e6;
                padding-bottom: 1rem;
                margin-bottom: 1.5rem;
            }

            .complaint-card {
                background-color: var(--light-gray);
                border-left: 4px solid var(--primary-color);
                border-radius: 0.25rem;
                padding: 1.25rem;
                margin-bottom: 1.5rem;
            }

            .complaint-item {
                margin-bottom: 0.75rem;
            }

            .form-label {
                font-weight: 500;
                margin-bottom: 0.5rem;
            }

            .form-control, .form-select {
                border-radius: 0.25rem;
                padding: 0.5rem 0.75rem;
                margin-bottom: 1rem;
            }

            textarea.form-control {
                min-height: 120px;
                resize: vertical;
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .alert {
                border-radius: 0.25rem;
                padding: 0.75rem 1.25rem;
                margin-bottom: 1.5rem;
            }

            .history-table {
                margin-top: 1.5rem;
            }

            .empty-history {
                text-align: center;
                padding: 2rem;
                color: #6c757d;
                background-color: var(--light-gray);
                border-radius: 0.25rem;
            }

            /* Badge styles */
            .badge {
                font-size: 0.875em;
                font-weight: 600;
                padding: 0.35em 0.65em;
                border-radius: 0.25rem;
                text-transform: capitalize;
            }
            .bg-escalated {
                background-color: var(--warning-color);
                color: #212529;
            }
            .bg-resolved {
                background-color: var(--success-color);
                color: white;
            }
            .bg-processing {
                background-color: var(--primary-color);
                color: white;
            }
            .bg-priority-low {
                background-color: #6c757d;
                color: white;
            }
            .bg-priority-medium {
                background-color: #ffc107;
                color: #212529;
            }
            .bg-priority-high {
                background-color: #fd7e14;
                color: white;
            }
            .bg-priority-critical {
                background-color: var(--danger-color);
                color: white;
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
            <div class="header">
                <h2 class="mb-0">Phản hồi khiếu nại</h2>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success"><c:out value="${successMessage}"/></div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger"><c:out value="${errorMessage}"/></div>
            </c:if>

            <!-- Thông tin khiếu nại -->
            <div class="complaint-card">
                <div class="complaint-item">
                    <strong>Mã khiếu nại:</strong> #<c:out value="${complaint.issueId}"/>
                </div>
                <div class="complaint-item">
                    <strong>Người khiếu nại:</strong> <c:out value="${complaint.username}"/>
                </div>
                <div class="complaint-item">
                    <strong>Nội dung khiếu nại:</strong> 
                    <p class="mb-0"><c:out value="${complaint.description}"/></p>
                </div>
                <div class="complaint-item">
                    <strong>Ngày tạo:</strong> 
                    <fmt:formatDate value="${complaint.createdAt}" pattern="dd/MM/yyyy HH:mm" />
                </div>
                <div class="complaint-item">
                    <strong>Trạng thái:</strong> 
                    <span class="badge bg-${complaint.status}">
                        <c:choose>
                            <c:when test="${complaint.status == 'escalated'}">Đã chuyển</c:when>
                            <c:when test="${complaint.status == 'resolved'}">Đã giải quyết</c:when>
                            <c:when test="${complaint.status == 'processing'}">Đang xử lý</c:when>
                            <c:otherwise><c:out value="${complaint.status}"/></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="complaint-item">
                    <strong>Mức độ ưu tiên:</strong> 
                    <span class="badge">
                        <c:choose>
                            <c:when test="${complaint.priority == 'Low'}">Thấp</c:when>
                            <c:when test="${complaint.priority == 'Medium'}">Trung bình</c:when>
                            <c:when test="${complaint.priority == 'High'}">Cao</c:when>
                            <c:when test="${complaint.priority == 'Critical'}">Nghiêm trọng</c:when>
                            <c:otherwise><c:out value="${complaint.priority}"/></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                
            </div>

            <!-- Form phản hồi -->
            <form action="${pageContext.request.contextPath}/OperatorReplyComplaintServlet" method="post">
                <input type="hidden" name="issueId" value="${complaint.issueId}">

                <div class="row mb-3">
                    <div class="col-md-4">
                        <label for="status" class="form-label">Trạng thái</label>
                        <select name="status" id="status" class="form-select">
                            <option value="processing" ${complaint.status == 'processing' ? 'selected' : ''}>Đang xử lý</option>
                            <option value="escalated" ${complaint.status == 'escalated' ? 'selected' : ''}>Đã chuyển</option>
                            <option value="resolved" ${complaint.status == 'resolved' ? 'selected' : ''}>Đã giải quyết</option>
                        </select>
                    </div>

                    <div class="col-md-4">
                        <label for="priority" class="form-label">Mức độ ưu tiên</label>
                        <select name="priority" id="priority" class="form-select">
                            <option value="Low" ${complaint.priority == 'low' ? 'selected' : ''}>Thấp</option>
                            <option value="Medium" ${complaint.priority == 'medium' ? 'selected' : ''}>Trung bình</option>
                            <option value="High" ${complaint.priority == 'high' ? 'selected' : ''}>Cao</option>
                            <option value="Critical" ${complaint.priority == 'Critical' ? 'selected' : ''}>Nghiêm trọng</option>
                        </select>
                    </div>

       
                </div>

                <div class="mb-3">
                    <label for="replyContent" class="form-label">Nội dung phản hồi</label>
                    <textarea name="replyContent" id="replyContent" class="form-control" 
                              placeholder="Nhập nội dung phản hồi (tối đa 500 ký tự)" 
                              maxlength="500" required></textarea>
                </div>

                <div class="d-flex justify-content-between">
                    <div>
                        <button type="submit" class="btn btn-primary me-2">
                            <i class="bi bi-send-fill me-1"></i> Gửi phản hồi
                        </button>
                        <a href="${pageContext.request.contextPath}/operatorComplaintList" class="btn btn-secondary">
                            <i class="bi bi-arrow-left me-1"></i> Quay lại
                        </a>
                    </div>
                    <small class="text-muted align-self-center">Ký tự còn lại: <span id="charCount">500</span></small>
                </div>
            </form>

            <!-- Lịch sử phản hồi -->
            <h3 class="mt-5 mb-3">Lịch sử phản hồi</h3>

            <c:choose>
                <c:when test="${empty replyHistory}">
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
                                    <th style="width: 20%">Người phản hồi</th>
                                    <th style="width: 60%">Nội dung</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="reply" items="${replyHistory}">
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
        </div>
            </div>

        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const textarea = document.getElementById('replyContent');
                const charCount = document.getElementById('charCount');

                textarea.addEventListener('input', function () {
                    const remaining = 500 - this.value.length;
                    charCount.textContent = remaining;

                    if (remaining < 50) {
                        charCount.style.color = '#dc3545';
                    } else if (remaining < 100) {
                        charCount.style.color = '#fd7e14';
                    } else {
                        charCount.style.color = '#6c757d';
                    }
                });
            });
        </script>
    </body>
</html>