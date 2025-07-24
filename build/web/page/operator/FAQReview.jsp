<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.FAQQuestion"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
<head>
    <title>Đánh giá Câu hỏi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .faq-container {
            max-width: 900px;
            margin: 40px auto;
            background-color: #fff;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
        }

        .faq-container h2 {
            text-align: center;
            color: #2c3e50;
            font-size: 28px;
            font-weight: 600;
            border-bottom: 2px solid #3498db;
            padding-bottom: 12px;
            margin-bottom: 30px;
        }

        .faq-card {
            background: #fafafa;
            border-radius: 10px;
            padding: 20px 24px;
            margin-bottom: 25px;
            box-shadow: 0 1px 6px rgba(0, 0, 0, 0.05);
            transition: transform 0.2s ease;
        }

        .faq-card:hover {
            transform: translateY(-2px);
        }

        .faq-card p {
            font-size: 16px;
            line-height: 1.6;
            color: #34495e;
            margin-bottom: 10px;
        }

        .faq-card p strong {
            color: #2c3e50;
        }

        label {
            font-weight: 600;
            color: #2c3e50;
        }

        textarea {
            width: 100%;
            padding: 10px 12px;
            font-size: 15px;
            border-radius: 6px;
            border: 1px solid #ccc;
            resize: vertical;
            min-height: 100px;
            margin-top: 8px;
            margin-bottom: 15px;
            transition: border-color 0.3s;
        }

        textarea:focus {
            border-color: #3498db;
            outline: none;
        }

        button {
            padding: 10px 20px;
            background-color: #3498db;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 15px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #2980b9;
        }

    </style>
</head>
<body>
    <div class="parent">
        <div class="div1">
            <jsp:include page="/Layout/operator/SideBar.jsp"/>
        </div>
        <div class="div2">
            <jsp:include page="/Layout/operator/Header.jsp"/>
        </div>
        <div class="div3">
            <div class="faq-container">
                <h2>Đánh giá Câu hỏi</h2>

                <c:forEach var="faq" items="${faqs}">
                    <div class="faq-card">
                        <p><strong>Câu hỏi:</strong> ${faq.question}</p>
                        <p><strong>Trả lời:</strong> ${faq.reply != null ? faq.reply : "Chưa có trả lời"}</p>

                        <form action="${pageContext.request.contextPath}/review-faq" method="post">
                            <input type="hidden" name="faqId" value="${faq.faqId}">
                            <label for="review-${faq.faqId}">Đánh giá (tối đa 500 ký tự):</label>
                            <textarea id="review-${faq.faqId}" name="review" maxlength="500" required placeholder="Nhập đánh giá...">${faq.review}</textarea>
                            <button type="submit">Lưu đánh giá</button>
                        </form>
                    </div>
                </c:forEach>

            </div>
        </div>
    </div>
</body>
</html>
