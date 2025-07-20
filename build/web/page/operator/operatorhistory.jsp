<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử phản hồi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/ComplaintReply.css">
</head>
<body>
    <div class="container">
        <h2>Lịch sử phản hồi cho khiếu nại #${issueId}</h2>

        <c:if test="${not empty replyHistory}">
            <c:forEach var="reply" items="${replyHistory}">
                <div class="reply-item">
                    <p><strong>Người phản hồi:</strong> ${reply.replierId}</p>
                    <p><strong>Thời gian:</strong> <fmt:formatDate value="${reply.repliedAt}" pattern="dd/MM/yyyy HH:mm:ss" /></p>
                    <p><strong>Nội dung:</strong> ${reply.replyContent}</p>
                    <hr>
                </div>
            </c:forEach>
        </c:if>


        <c:if test="${empty replyHistory}">
            <p>Chưa có phản hồi nào cho khiếu nại này.</p>
        </c:if>

        <a href="operatorComplaintList" class="btn">Quay lại</a>
    </div>
</body>
</html>
