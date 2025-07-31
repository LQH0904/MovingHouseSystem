<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.FAQQuestion"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Câu hỏi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/faq.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/staff/SideBar.jsp" />
            </div>
            <div class="div2">
                <jsp:include page="/Layout/staff/Header.jsp" />
            </div>
            <div class="div3">
                <div class="faq-container">
                    <h2>Câu hỏi thường gặp</h2>
                    <c:forEach var="faq" items="${faqs}" varStatus="status">
                        <div class="faq-card">
                            <div class="faq-index">#${status.index + 1}</div>
                            <div class="faq-content">
                                <p class="question"><strong>Câu hỏi:</strong> ${faq.question}</p>
                                <p class="reply">
                                    <strong> Trả lời:</strong>
                                    <c:choose>
                                        <c:when test="${empty faq.reply}">
                                            <span class="no-reply">Chưa có trả lời</span>
                                        </c:when>
                                        <c:otherwise>${faq.reply}</c:otherwise>
                                    </c:choose>
                                </p>
                                <p class="review"><strong>Đánh giá câu trả lời :</strong> ${faq.review != null ? faq.review : "Chưa có"}</p>
                                <a class="reply-btn" href="${pageContext.request.contextPath}/page/staff/faq-reply-form.jsp?id=${faq.faqId}">

                                    <c:choose>
                                        <c:when test="${empty faq.reply}">Trả lời</c:when>
                                        <c:otherwise>Sửa</c:otherwise>
                                    </c:choose>
                                </a>
                            </div>
                        </div>
                    </c:forEach>
                </div>
                <div>
                    <div>
                        <div>
                            </body>
                            </html>
