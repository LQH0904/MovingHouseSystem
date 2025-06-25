<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Phản Hồi Khiếu Nại</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/Complaint.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include> </div>
            <div class="div2"> <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include> </div>
                <div class="div3">
                    <div class="container">
                        <h2>Phản Hồi Khiếu Nại</h2>

                    <c:if test="${not empty errorMessage}">
                        <p class="error-message">${errorMessage}</p>
                    </c:if>

                    <c:if test="${empty currentComplaint}">
                        <p>Không thể tải thông tin khiếu nại. Vui lòng quay lại danh sách.</p>
                        <p><a href="${pageContext.request.contextPath}/operatorComplaintList">Quay lại Danh sách Khiếu nại</a></p>
                    </c:if>

                    <c:if test="${not empty currentComplaint}">
                        <div class="complaint-details">
                            <h3>Chi tiết Khiếu nại: #${currentComplaint.issueId}</h3>
                            <p><strong>Người gửi:</strong> ${currentComplaint.username}</p>
                            <p><strong>Mô tả:</strong> ${currentComplaint.description}</p>
                            <p><strong>Trạng thái hiện tại:</strong>
                                <c:choose>
                                    <c:when test="${currentComplaint.status == 'new'}">Mới</c:when>
                                    <c:when test="${currentComplaint.status == 'pending'}">Chờ xử lý</c:when>
                                    <c:when test="${currentComplaint.status == 'in_progress'}">Đang xử lý</c:when>
                                    <c:when test="${currentComplaint.status == 'escalated'}">Đã chuyển cấp cao</c:when>
                                    <c:when test="${currentComplaint.status == 'resolved'}">Đã giải quyết</c:when>
                                    <c:when test="${currentComplaint.status == 'closed'}">Đã đóng</c:when>
                                    <c:otherwise>${currentComplaint.status}</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Mức độ ưu tiên hiện tại:</strong>
                                <c:choose>
                                    <c:when test="${currentComplaint.priority == 'low'}">Thấp</c:when>
                                    <c:when test="${currentComplaint.priority == 'medium'}">Trung bình</c:when>
                                    <c:when test="${currentComplaint.priority == 'high'}">Cao</c:when>
                                    <c:when test="${currentComplaint.priority == 'urgent'}">Khẩn cấp</c:when>
                                    <c:otherwise>${currentComplaint.priority}</c:otherwise>
                                </c:choose>
                            </p>
                            <p><strong>Gán cho:</strong> ${currentComplaint.assignedToUsername != null ? currentComplaint.assignedToUsername : 'Chưa gán'}</p>
                            <p><strong>Ngày tạo:</strong> ${currentComplaint.createdAt}</p>
                            <p><strong>Ngày giải quyết:</strong> ${currentComplaint.resolvedAt != null ? currentComplaint.resolvedAt : 'Chưa giải quyết'}</p>
                        </div>

                        <form action="${pageContext.request.contextPath}/OperatorReplyComplaintServlet" method="post">
                            <input type="hidden" name="issueId" value="${currentComplaint.issueId}">

                            <div class="form-group">
                                <label for="status">Trạng thái:</label>
                                <select id="status" name="status">
                                    <option value="pending" ${currentComplaint.status == 'pending' ? 'selected' : ''}>Chờ xử lý</option>
                                    <option value="in_progress" ${currentComplaint.status == 'in_progress' ? 'selected' : ''}>Đang xử lý</option>
                                    <option value="escalated" ${currentComplaint.status == 'escalated' ? 'selected' : ''}>Đã chuyển cấp cao</option>
                                    <option value="resolved" ${currentComplaint.status == 'resolved' ? 'selected' : ''}>Đã giải quyết</option>
                                    <option value="closed" ${currentComplaint.status == 'closed' ? 'selected' : ''}>Đã đóng</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="priority">Mức độ ưu tiên:</label>
                                <select id="priority" name="priority">
                                    <option value="low" ${currentComplaint.priority == 'low' ? 'selected' : ''}>Thấp</option>
                                    <option value="medium" ${currentComplaint.priority == 'medium' ? 'selected' : ''}>Trung bình</option>
                                    <option value="high" ${currentComplaint.priority == 'high' ? 'selected' : ''}>Cao</option>
                                    <option value="urgent" ${currentComplaint.priority == 'urgent' ? 'selected' : ''}>Khẩn cấp</option>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="assignedTo">Gán cho Operator:</label>
                                <select id="assignedTo" name="assignedTo">
                                    <option value="unassigned" ${currentComplaint.assignedTo == null ? 'selected' : ''}>Chưa gán</option>
                                    <c:forEach var="op" items="${operatorsList}">
                                        <option value="${op.userId}" ${currentComplaint.assignedTo != null && currentComplaint.assignedTo == op.userId ? 'selected' : ''}>
                                            ${op.username}
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="replyContent">Nội dung phản hồi:</label>
                                <textarea id="replyContent" name="replyContent" rows="5" placeholder="Nhập nội dung phản hồi..."></textarea>
                            </div>

                            <div class="form-group">
                                <button type="button" class="btn-submit" onclick="window.location.href = '${pageContext.request.contextPath}/operatorComplaintList'">Cập nhật và Phản hồi</button>
                                <a href="${pageContext.request.contextPath}/operatorComplaintList" class="btn-cancel">Hủy</a>
                            </div>
                        </form>

                        <div class="reply-history">
                            <h3>Lịch sử phản hồi:</h3>
                            <c:choose>
                                <c:when test="${not empty complaintReplies}">
                                    <c:forEach var="reply" items="${complaintReplies}">
                                        <div class="reply-item">
                                            <p>${reply}</p>
                                        </div>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>
                                    <p>Chưa có phản hồi nào cho khiếu nại này.</p>
                                </c:otherwise>
                            </c:choose>
                        </div>

                    </c:if>
                </div>
            </div>
        </div>
    </body>
</html>