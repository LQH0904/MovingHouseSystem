<%-- /webpage/AskQuestion.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <title>Hỗ trợ khách hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <style>
            /* =================================================================== */
            /* === CSS SIDEBAR CỦA BẠN - GIỮ NGUYÊN THEO YÊU CẦU === */
            /* =================================================================== */
            .sidebar {
                width: 250px;
                background: linear-gradient(to bottom, #B794F4, #C9A7F4);
                color: white;
                height: 100vh;
                position: fixed;
                padding-top: 10px;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }
            .sidebar .sidebar-item {
                padding: 6px 12px;
                font-size: 0.85rem;
                color: #fff;
                text-decoration: none;
                display: flex;
                align-items: center;
            }
            .sidebar .sidebar-item:hover {
                background-color: rgba(255, 255, 255, 0.2);
            }
            .sidebar .sidebar-item.active {
                background-color: rgba(255, 255, 255, 0.3);
            }

            /* =================================================================== */
            /* === CSS MỚI CHO GIAO DIỆN CHUYÊN NGHIỆP HƠN === */
            /* =================================================================== */
            :root {
                --primary-color: #8a63d2; /* Tông màu tím đậm hơn từ sidebar */
                --light-gray: #f4f7f9;
                --text-dark: #333;
                --text-light: #666;
                --border-color: #e8eaed;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: var(--light-gray);
                margin: 0;
            }

            /* Sửa lỗi layout chồng chéo */
            .div1 {
                position: fixed;
                top: 0;
                left: 0;
                height: 100%;
                z-index: 100;
            }
            .div3 {
                margin-left: 250px; /* Đẩy nội dung sang phải để không bị sidebar che */
                padding: 20px;
            }

            .support-container {
                display: flex;
                max-width: 1200px;
                margin: 0 auto;
                gap: 24px;
            }
            .faq-column, .chat-column {
                background: #fff;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.08);
                padding: 25px;
            }
            .faq-column {
                flex: 6;
            }
            .chat-column {
                flex: 4;
                display: flex;
                flex-direction: column;
                max-height: 85vh;
            }

            /* FAQ Styles */
            .faq-title, .chat-title {
                font-size: 24px;
                color: var(--text-dark);
                margin-top: 0;
                border-bottom: 1px solid var(--border-color);
                padding-bottom: 15px;
                font-weight: 600;
            }
            .faq-item {
                border-bottom: 1px solid var(--border-color);
            }
            .faq-question {
                padding: 18px 5px;
                cursor: pointer;
                display: flex;
                justify-content: space-between;
                align-items: center;
                font-weight: 500;
                transition: color 0.2s;
            }
            .faq-question:hover {
                color: var(--primary-color);
            }
            .faq-answer {
                padding: 0 15px;
                max-height: 0;
                overflow: hidden;
                transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out;
                color: var(--text-light);
                line-height: 1.6;
            }
            .faq-item.active .faq-answer {
                max-height: 200px;
                padding: 0 15px 18px;
            }
            .faq-item.active .faq-icon {
                transform: rotate(90deg);
                color: var(--primary-color);
            }
            .faq-icon {
                transition: transform 0.4s;
                color: #aaa;
            }

            /* Chat Styles */
            .chat-history {
                flex-grow: 1;
                padding: 10px;
                overflow-y: auto;
                margin-bottom: 10px;
            }
            /* Custom scrollbar */
            .chat-history::-webkit-scrollbar {
                width: 6px;
            }
            .chat-history::-webkit-scrollbar-track {
                background: #f1f1f1;
            }
            .chat-history::-webkit-scrollbar-thumb {
                background: #ccc;
                border-radius: 6px;
            }
            .chat-history::-webkit-scrollbar-thumb:hover {
                background: #aaa;
            }

            .chat-message {
                margin-bottom: 18px;
                display: flex;
                flex-direction: column;
            }
            .message-bubble {
                padding: 12px 18px;
                border-radius: 20px;
                max-width: 85%;
                line-height: 1.5;
                font-size: 15px;
            }
            .user-message {
                align-items: flex-end;
            }
            .user-message .message-bubble {
                background: var(--primary-color);
                color: white;
                border-bottom-right-radius: 5px;
            }
            .bot-message {
                align-items: flex-start;
            }
            .bot-message .message-bubble {
                background-color: #f1f1f1;
                color: var(--text-dark);
                border-bottom-left-radius: 5px;
            }

            .chat-input-area {
                padding-top: 15px;
                border-top: 1px solid var(--border-color);
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .chat-input {
                flex-grow: 1;
                padding: 12px 18px;
                border: 1px solid #ddd;
                border-radius: 22px;
                outline: none;
                transition: border-color 0.2s, box-shadow 0.2s;
            }
            .chat-input:focus {
                border-color: var(--primary-color);
                box-shadow: 0 0 0 3px rgba(138, 99, 210, 0.2);
            }
            .chat-send-btn {
                width: 44px;
                height: 44px;
                border: none;
                background-color: var(--primary-color);
                color: white;
                border-radius: 50%;
                cursor: pointer;
                font-size: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                transition: background-color 0.2s;
            }
            .chat-send-btn:hover {
                background-color: #744db9;
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <%-- Sidebar của bạn, được đặt trong div1 --%>
            <div class="div1">
                <div class="sidebar">
                    <div class="sidebar-item">Customer</div>
                    <a href="${pageContext.request.contextPath}/transport" class="sidebar-item">Dashboard</a>
                    <a href="${pageContext.request.contextPath}/orderHistory" class="sidebar-item">Đơn hàng vận chuyển</a>
                    <a href="${pageContext.request.contextPath}/customer/ask-question" class="sidebar-item active">Đặt câu hỏi</a>
                    <a href="${pageContext.request.contextPath}/logout" class="sidebar-item">Đăng xuất</a>
                </div>
            </div>

            <%-- Phần nội dung chính, được đặt trong div3 --%>
            <div class="div3">
                <div class="support-container">
                    <div class="faq-column">
                        <h2 class="faq-title">Câu hỏi thường gặp</h2>
                        <div id="faq-list">
                            <c:forEach var="faq" items="${faqList}">
                                <div class="faq-item">
                                    <div class="faq-question">
                                        <span>${faq.question}</span>
                                        <i class="fas fa-chevron-right faq-icon"></i>
                                    </div>
                                    <div class="faq-answer">
                                        <p>${faq.reply}</p>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <div class="chat-column">
                        <h2 class="chat-title">Hộp thoại hỗ trợ</h2>
                        <div class="chat-history" id="chat-history">
                            <c:forEach var="log" items="${chatHistory}">
                                <div class="chat-message user-message">
                                    <div class="message-bubble">${log.message}</div>
                                </div>
                                <div class="chat-message bot-message">
                                    <div class="message-bubble">${log.response}</div>
                                </div>
                            </c:forEach>
                        </div>
                        <form id="chat-form" class="chat-input-area">
                            <input type="text" id="chat-input" class="chat-input" placeholder="Nhập câu hỏi của bạn..." autocomplete="off">
                            <button type="submit" class="chat-send-btn"><i class="fas fa-paper-plane"></i></button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Bọc toàn bộ code trong sự kiện này để đảm bảo HTML đã tải xong
            document.addEventListener('DOMContentLoaded', function () {
                // --- Logic cho FAQ Accordion ---
                const faqList = document.getElementById('faq-list');
                if (faqList) {
                    faqList.addEventListener('click', function (e) {
                        const question = e.target.closest('.faq-question');
                        if (question) {
                            // Đóng tất cả các câu trả lời khác
                            document.querySelectorAll('#faq-list .faq-item.active').forEach(item => {
                                if (item !== question.parentElement) {
                                    item.classList.remove('active');
                                }
                            });
                            // Mở hoặc đóng câu hiện tại
                            const item = question.parentElement;
                            item.classList.toggle('active');
                        }
                    });
                }

                // --- Logic cho Chatbot ---
                const chatForm = document.getElementById('chat-form');
                const chatInput = document.getElementById('chat-input');
                const chatHistory = document.getElementById('chat-history');

                function addMessageToHistory(message, isUser) {
                    const messageDiv = document.createElement('div');
                    messageDiv.className = isUser ? 'chat-message user-message' : 'chat-message bot-message';

                    const bubbleDiv = document.createElement('div');
                    bubbleDiv.className = 'message-bubble';
                    bubbleDiv.innerText = message;

                    messageDiv.appendChild(bubbleDiv);
                    chatHistory.appendChild(messageDiv);

                    chatHistory.scrollTop = chatHistory.scrollHeight;
                }

                if (chatForm) {
                    chatForm.addEventListener('submit', function (e) {
                        e.preventDefault();
                        const userMessage = chatInput.value.trim();

                        if (userMessage) {
                            addMessageToHistory(userMessage, true);
                            chatInput.value = '';

                            fetch('${pageContext.request.contextPath}/customer/submit-question', {
                                method: 'POST',
                                headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                                body: 'message=' + encodeURIComponent(userMessage)
                            })
                                    .then(response => {
                                        if (!response.ok) {
                                            throw new Error('Network response was not ok. Status: ' + response.status);
                                        }
                                        return response.json();
                                    })
                                    .then(data => {
                                        if (data.response) {
                                            addMessageToHistory(data.response, false);
                                        } else {
                                            addMessageToHistory("Có lỗi xảy ra, vui lòng thử lại.", false);
                                        }
                                    })
                                    .catch(error => {
                                        console.error('Error:', error);
                                        addMessageToHistory("Không thể kết nối đến server.", false);
                                    });
                        }
                    });
                }

                if (chatHistory) {
                    chatHistory.scrollTop = chatHistory.scrollHeight;
                }
            });
        </script>
    </body>
</html>