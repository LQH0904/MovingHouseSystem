<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.FAQQuestion" %>
<%
    List<FAQQuestion> faqList = (List<FAQQuestion>) request.getAttribute("faqList");
%>
<html>
<head>
    <title>Câu hỏi thường gặp</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .faq-container {
            max-width: 900px;
            margin: 30px auto;
            background: #fff;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }

        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }

        .faq-list {
            margin-bottom: 40px;
        }

        .faq-item {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 1px solid #ccc;
        }

        .faq-item .question {
            font-weight: bold;
            color: #444;
        }

        .faq-item .answer {
            margin-top: 8px;
            color: #555;
        }

        .ask-question-form textarea {
            width: 100%;
            height: 100px;
            padding: 10px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 5px;
            resize: vertical;
        }

        .ask-question-form button {
            margin-top: 10px;
            padding: 10px 20px;
            font-size: 14px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .ask-question-form button:hover {
            background-color: #0056b3;
        }

    </style>
</head>
<body>

    <div class="faq-container">
        <h2>Câu hỏi thường gặp</h2>

        <div class="faq-list">
            <% if (faqList != null && !faqList.isEmpty()) { %>
                <% for (FAQQuestion faq : faqList) { %>
                    <div class="faq-item">
                        <div class="question">❓ <%= faq.getQuestion() %></div>
                        <div class="answer">
                            <%= (faq.getReply() != null && !faq.getReply().isEmpty())
                                ? faq.getReply()
                                : "<em>Chưa có trả lời</em>" %>
                        </div>
                    </div>
                <% } %>
            <% } else { %>
                <p>Không có câu hỏi thường gặp nào.</p>
            <% } %>
        </div>

        <div class="ask-question-form">
            <h3>Gửi câu hỏi của bạn</h3>
            <form action="<%= request.getContextPath() %>/customer/faq" method="post">
                <textarea name="question" placeholder="Nhập câu hỏi của bạn..." required></textarea>
                <button type="submit">Gửi câu hỏi</button>
            </form>
        </div>
    </div>

</body>
</html>
