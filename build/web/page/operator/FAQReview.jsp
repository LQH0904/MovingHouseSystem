<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.FAQQuestion"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Đánh giá Câu hỏi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/faq-review.css">
</head>
<body>
    <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
<div class="faq-container">
    <h2>Đánh giá Câu hỏi</h2>

    <c:forEach var="faq" items="${faqs}">
        <div class="faq-card">
            <p><strong>Câu hỏi:</strong> ${faq.question}</p>
            <p><strong>Trả lời:</strong> ${faq.reply != null ? faq.reply : "Chưa có trả lời"}</p>

            <form action="${pageContext.request.contextPath}/review-faq" method="post">
                <input type="hidden" name="faqId" value="${faq.faqId}">
                <label>Đánh giá (tối đa 500 ký tự):</label><br>
                <textarea name="review" maxlength="500" required placeholder="Nhập đánh giá...">${faq.review}</textarea><br>
                <button type="submit">Lưu đánh giá</button>
            </form>
        </div>
    </c:forEach>

</div>
</div>
</div>
</div>
</body>
</html>
