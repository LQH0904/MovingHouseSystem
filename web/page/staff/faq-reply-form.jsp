<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.FAQQuestion" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Trả lời Câu hỏi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/faq-form.css">
</head>
<body>
    <div class="form-container">
        <h2>Trả lời Câu hỏi</h2>
        <form method="post" action="${pageContext.request.contextPath}/reply-faq">
            <input type="hidden" name="faqId" value="${param.id}" />

            <label for="reply">Nội dung trả lời (tối đa 500 ký tự):</label><br/>
            <textarea id="reply" name="reply" maxlength="500" required placeholder="Nhập câu trả lời..."></textarea><br/>

            <button type="submit">Gửi</button>
            <a href="${pageContext.request.contextPath}/staff/faq-list">Hủy</a>
        </form>
    </div>
</body>
</html>
