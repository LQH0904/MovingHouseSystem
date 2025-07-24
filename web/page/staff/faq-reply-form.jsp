<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="model.FAQQuestion" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <title>Trả lời Câu hỏi</title>
        
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        
        <style>
    .div3 {
        background-color: #f8f9fc;
        padding: 30px;
        font-family: "Segoe UI", Tahoma, sans-serif;
    }

    .div3 h2 {
        color: #343a40;
        font-size: 24px;
        margin-bottom: 25px;
        border-left: 5px solid #007bff;
        padding-left: 12px;
    }

    .div3 .form-container {
        background-color: #ffffff;
        padding: 25px;
        border-radius: 10px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        max-width: 700px;
        margin: 0 auto;
    }

    .div3 label {
        display: block;
        margin-top: 15px;
        font-weight: 600;
        color: #495057;
    }

    .div3 textarea {
        width: 100%;
        min-height: 120px;
        padding: 10px;
        margin-top: 8px;
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 14px;
        resize: vertical;
        box-sizing: border-box;
        transition: border-color 0.3s ease;
    }

    .div3 textarea:focus {
        border-color: #007bff;
        outline: none;
        box-shadow: 0 0 0 0.1rem rgba(0, 123, 255, 0.25);
    }

    .div3 button[type="submit"] {
        margin-top: 20px;
        padding: 10px 20px;
        background-color: #28a745;
        border: none;
        color: white;
        font-size: 15px;
        border-radius: 5px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    .div3 button[type="submit"]:hover {
        background-color: #218838;
    }

    .div3 a {
        margin-left: 15px;
        font-size: 14px;
        text-decoration: none;
        color: #6c757d;
        border: 1px solid #6c757d;
        padding: 8px 14px;
        border-radius: 5px;
        transition: background-color 0.3s ease, color 0.3s ease;
    }

    .div3 a:hover {
        background-color: #6c757d;
        color: white;
    }
</style>

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
            </div>

        </div>

    </body>
</html>
