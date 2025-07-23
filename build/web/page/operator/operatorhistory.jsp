<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Lịch sử phản hồi</title>
         <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f8f9fa;
                margin: 0;
                padding: 20px;
            }

            .container {
                max-width: 800px;
                margin: auto;
                background: #fff;
                padding: 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            }

            h2 {
                color: #007bff;
                margin-bottom: 30px;
            }

            .reply-item {
                background-color: #f1f1f1;
                padding: 15px 20px;
                border-left: 5px solid #007bff;
                margin-bottom: 20px;
                border-radius: 5px;
            }

            .reply-item p {
                margin: 5px 0;
            }

            hr {
                margin-top: 15px;
            }

            .btn {
                display: inline-block;
                padding: 10px 20px;
                background-color: #007bff;
                color: #fff;
                text-decoration: none;
                border-radius: 5px;
                transition: background-color 0.3s ease;
            }

            .btn:hover {
                background-color: #0056b3;
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
            </div>
    </body>
</html>
