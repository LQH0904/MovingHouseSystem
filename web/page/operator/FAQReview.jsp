<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.FAQQuestion"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>

<html>
    <head>
        <title>Đánh giá Câu hỏi</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

        <style>
            /* CSS chỉ cho div3 - Đánh giá Câu hỏi */
            .div3 {
                padding: 24px;
                background: linear-gradient(135deg, #e6fffa 0%, #b2f5ea 100%);
                min-height: calc(100vh - 120px);
                position: relative;
            }

            /* Container cho nội dung chính trong div3 */
            .div3 .faq-container {
                max-width: 900px;
                margin: 0 auto;
                padding: 40px;
                background: #ffffff;
                border-radius: 16px;
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.08);
                position: relative;
                overflow: hidden;
                animation: slideInUp 0.6s ease-out;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .div3 .faq-container::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #38b2ac 0%, #319795 100%);
            }

            @keyframes slideInUp {
                from {
                    opacity: 0;
                    transform: translateY(40px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Header Styling */
            .div3 h2 {
                text-align: center;
                font-size: 32px;
                font-weight: 700;
                color: #2d3748;
                margin-bottom: 40px;
                position: relative;
                padding-bottom: 16px;
            }

            .div3 h2::after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 120px;
                height: 3px;
                background: linear-gradient(90deg, #38b2ac 0%, #319795 100%);
                border-radius: 2px;
            }

            .div3 h2::before {
                content: "❓";
                position: absolute;
                top: -10px;
                left: 50%;
                transform: translateX(-50%);
                font-size: 24px;
                opacity: 0.7;
            }

            /* FAQ Card Styling */
            .div3 .faq-card {
                background: linear-gradient(135deg, #f0fff4 0%, #e6fffa 100%);
                border: 2px solid #b2f5ea;
                border-radius: 12px;
                padding: 28px;
                margin-bottom: 24px;
                box-shadow: 0 6px 20px rgba(0, 0, 0, 0.05);
                transition: all 0.3s ease;
                animation: fadeInCard 0.5s ease-out;
                animation-fill-mode: both;
            }

            .div3 .faq-card:nth-child(2) {
                animation-delay: 0.1s;
            }
            .div3 .faq-card:nth-child(3) {
                animation-delay: 0.2s;
            }
            .div3 .faq-card:nth-child(4) {
                animation-delay: 0.3s;
            }
            .div3 .faq-card:nth-child(5) {
                animation-delay: 0.4s;
            }

            @keyframes fadeInCard {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .div3 .faq-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 30px rgba(56, 178, 172, 0.15);
                border-color: #38b2ac;
            }

            /* Paragraphs in FAQ Card */
            .div3 .faq-card p {
                font-size: 16px;
                line-height: 1.6;
                color: #4a5568;
                margin-bottom: 12px;
            }

            .div3 .faq-card p strong {
                color: #319795;
                font-weight: 700;
                margin-right: 8px;
            }

            /* Form Styling */
            .div3 .faq-card form {
                margin-top: 20px;
                padding-top: 20px;
                border-top: 1px solid #b2f5ea;
            }

            .div3 .faq-card label {
                display: block;
                font-weight: 700;
                font-size: 14px;
                color: #319795;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                margin-bottom: 10px;
            }

            .div3 .faq-card textarea {
                width: 100%;
                padding: 14px 18px;
                border: 2px solid #b2f5ea;
                border-radius: 10px;
                font-size: 15px;
                font-family: inherit;
                transition: all 0.3s ease;
                box-sizing: border-box;
                background: #ffffff;
                resize: vertical;
                min-height: 100px;
                line-height: 1.5;
            }

            .div3 .faq-card textarea:focus {
                border-color: #38b2ac;
                outline: none;
                box-shadow: 0 0 0 3px rgba(56, 178, 172, 0.1);
                transform: translateY(-1px);
            }

            .div3 .faq-card textarea:hover {
                border-color: #4fd1c5;
            }

            .div3 .faq-card textarea::placeholder {
                color: #a0aec0;
                font-style: italic;
            }

            /* Button Styling */
            .div3 .faq-card button[type="submit"] {
                display: inline-flex;
                align-items: center;
                gap: 8px;
                padding: 14px 28px;
                margin-top: 20px;
                background: linear-gradient(135deg, #38b2ac 0%, #319795 100%);
                color: white;
                border: none;
                border-radius: 10px;
                font-size: 15px;
                font-weight: 700;
                cursor: pointer;
                transition: all 0.3s ease;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                box-shadow: 0 4px 16px rgba(56, 178, 172, 0.3);
                position: relative;
                overflow: hidden;
            }

            .div3 .faq-card button[type="submit"]::before {
                content: "💾";
                font-size: 16px;
            }

            .div3 .faq-card button[type="submit"]::after {
                content: "";
                position: absolute;
                top: 50%;
                left: 50%;
                width: 0;
                height: 0;
                background: rgba(255, 255, 255, 0.2);
                border-radius: 50%;
                transform: translate(-50%, -50%);
                transition: all 0.3s ease;
            }

            .div3 .faq-card button[type="submit"]:hover {
                transform: translateY(-3px);
                box-shadow: 0 8px 24px rgba(56, 178, 172, 0.4);
                background: linear-gradient(135deg, #319795 0%, #2c7a7b 100%);
            }

            .div3 .faq-card button[type="submit"]:hover::after {
                width: 200px;
                height: 200px;
            }

            .div3 .faq-card button[type="submit"]:active {
                transform: translateY(-1px);
                box-shadow: 0 4px 16px rgba(56, 178, 172, 0.3);
            }

            /* Responsive Design */
            @media screen and (max-width: 1024px) {
                .div3 {
                    padding: 16px;
                }

                .div3 .faq-container {
                    padding: 32px;
                    margin: 0 8px;
                }

                .div3 h2 {
                    font-size: 28px;
                    margin-bottom: 32px;
                }

                .div3 .faq-card {
                    padding: 24px;
                    margin-bottom: 20px;
                }
            }

            @media screen and (max-width: 768px) {
                .div3 {
                    padding: 12px;
                }

                .div3 .faq-container {
                    padding: 24px;
                    border-radius: 12px;
                }

                .div3 h2 {
                    font-size: 24px;
                    margin-bottom: 24px;
                }

                .div3 .faq-card {
                    padding: 20px;
                    margin-bottom: 16px;
                }

                .div3 .faq-card p {
                    font-size: 15px;
                }

                .div3 .faq-card textarea {
                    padding: 12px 16px;
                    font-size: 14px;
                }

                .div3 .faq-card button[type="submit"] {
                    width: 100%;
                    justify-content: center;
                    padding: 12px 20px;
                    font-size: 14px;
                }
            }

            @media screen and (max-width: 480px) {
                .div3 .faq-container {
                    padding: 16px;
                    margin: 0 4px;
                }

                .div3 h2 {
                    font-size: 20px;
                    margin-bottom: 20px;
                }

                .div3 .faq-card {
                    padding: 16px;
                    margin-bottom: 12px;
                }
            }

            /* Print Styles */
            @media print {
                .div3 {
                    background: none;
                    padding: 0;
                }

                .div3 .faq-container {
                    box-shadow: none;
                    border: 1px solid #ddd;
                }

                .div3 .faq-card form {
                    display: none; /* Hide forms when printing */
                }

                .div3 .faq-card:hover {
                    transform: none;
                    box-shadow: none;
                }
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
