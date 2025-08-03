<%-- page/staff/FAQList.jsp (Phiên bản đầy đủ với modal) --%>
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
        <style>
            /* FAQ Container Styling */
            .faq-container {
                max-width: 1200px;
                margin: 0 auto;
                padding: 2rem;
                background: #f8fafc;
                min-height: calc(100vh - 120px);
            }

            /* Header Section */
            .faq-container > div:first-child {
                margin-bottom: 2rem;
                padding-bottom: 1rem;
                border-bottom: 2px solid #e2e8f0;
            }

            .faq-container h2 {
                color: #1e293b;
                font-size: 2rem;
                font-weight: 700;
                margin: 0;
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .faq-container h2::before {
                content: "❓";
                font-size: 1.5rem;
            }

            /* Create FAQ Button */
            .create-faq-btn {
                background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
                color: white;
                border: none;
                padding: 0.75rem 1.5rem;
                border-radius: 0.5rem;
                font-weight: 600;
                font-size: 0.95rem;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
                position: relative;
                overflow: hidden;
            }

            .create-faq-btn::before {
                content: "+";
                margin-right: 0.5rem;
                font-size: 1.2rem;
                font-weight: bold;
            }

            .create-faq-btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 15px -3px rgba(59, 130, 246, 0.4);
                background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            }

            .create-faq-btn:active {
                transform: translateY(0);
            }

            /* Error Message */
            .faq-container p[style*="color: red"] {
                background: #fef2f2;
                color: #dc2626;
                padding: 1rem;
                border-radius: 0.5rem;
                border-left: 4px solid #dc2626;
                margin: 1rem 0;
                font-weight: 500;
            }

            /* FAQ Card */
            .faq-card {
                background: white;
                border-radius: 1rem;
                padding: 1.5rem;
                margin-bottom: 1.5rem;
                box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
                border: 1px solid #e2e8f0;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .faq-card::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                width: 4px;
                height: 100%;
                background: linear-gradient(135deg, #3b82f6, #8b5cf6);
            }

            .faq-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 25px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            }

            /* FAQ Index */
            .faq-index {
                position: absolute;
                top: 1rem;
                right: 1rem;
                background: linear-gradient(135deg, #f1f5f9, #e2e8f0);
                color: #64748b;
                padding: 0.25rem 0.75rem;
                border-radius: 1rem;
                font-size: 0.875rem;
                font-weight: 600;
            }

            /* FAQ Content */
            .faq-content {
                padding-right: 4rem;
            }

            .faq-content p {
                margin: 1rem 0;
                line-height: 1.6;
            }

            .question {
                color: #1e293b;
                font-size: 1.1rem;
            }

            .question strong {
                color: #3b82f6;
                font-weight: 700;
            }

            .reply {
                color: #475569;
            }

            .reply strong {
                color: #059669;
                font-weight: 700;
            }

            .no-reply {
                color: #f59e0b;
                font-style: italic;
                font-weight: 500;
            }

            .review {
                color: #6b7280;
                font-size: 0.95rem;
            }

            .review strong {
                color: #7c3aed;
                font-weight: 700;
            }

            /* Action Buttons */
            .action-buttons {
                display: flex;
                gap: 0.75rem;
                margin-top: 1.5rem;
                padding-top: 1rem;
                border-top: 1px solid #f1f5f9;
            }

            .reply-btn {
                background: linear-gradient(135deg, #059669 0%, #047857 100%);
                color: white;
                text-decoration: none;
                padding: 0.5rem 1rem;
                border-radius: 0.375rem;
                font-weight: 500;
                font-size: 0.875rem;
                transition: all 0.3s ease;
                box-shadow: 0 2px 4px -1px rgba(5, 150, 105, 0.3);
            }

            .reply-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px -2px rgba(5, 150, 105, 0.4);
                background: linear-gradient(135deg, #047857 0%, #065f46 100%);
            }

            .delete-btn {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
                color: white;
                border: none;
                padding: 0.5rem 1rem;
                border-radius: 0.375rem;
                font-weight: 500;
                font-size: 0.875rem;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 2px 4px -1px rgba(220, 38, 38, 0.3);
            }

            .delete-btn:hover {
                transform: translateY(-1px);
                box-shadow: 0 4px 8px -2px rgba(220, 38, 38, 0.4);
                background: linear-gradient(135deg, #b91c1c 0%, #991b1b 100%);
            }

            .action-buttons form {
                margin: 0;
            }

            /* Modal Styling */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(4px);
                animation: fadeIn 0.3s ease;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                }
                to {
                    opacity: 1;
                }
            }

            .modal-content {
                background-color: white;
                margin: 5% auto;
                border-radius: 1rem;
                width: 90%;
                max-width: 600px;
                box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
                animation: slideIn 0.3s ease;
                overflow: hidden;
            }

            @keyframes slideIn {
                from {
                    transform: translateY(-50px);
                    opacity: 0;
                }
                to {
                    transform: translateY(0);
                    opacity: 1;
                }
            }

            .modal-header {
                background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
                color: white;
                padding: 1.5rem 2rem;
                position: relative;
            }

            .modal-header h2 {
                margin: 0;
                font-size: 1.5rem;
                font-weight: 700;
            }

            .close-btn {
                position: absolute;
                right: 1.5rem;
                top: 50%;
                transform: translateY(-50%);
                color: white;
                font-size: 2rem;
                font-weight: bold;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 2rem;
                height: 2rem;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }

            .close-btn:hover {
                background: rgba(255, 255, 255, 0.2);
                transform: translateY(-50%) rotate(90deg);
            }

            .modal-body {
                padding: 2rem;
            }

            .modal-body p {
                color: #64748b;
                margin-bottom: 1rem;
                font-size: 1rem;
                line-height: 1.6;
            }

            .modal-body textarea {
                width: 100%;
                min-height: 120px;
                padding: 1rem;
                border: 2px solid #e2e8f0;
                border-radius: 0.5rem;
                font-size: 1rem;
                font-family: inherit;
                resize: vertical;
                transition: all 0.3s ease;
                box-sizing: border-box;
            }

            .modal-body textarea:focus {
                outline: none;
                border-color: #3b82f6;
                box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
            }

            .modal-body textarea::placeholder {
                color: #9ca3af;
                font-style: italic;
            }

            .modal-footer {
                padding: 1.5rem 2rem;
                background: #f8fafc;
                border-top: 1px solid #e2e8f0;
                display: flex;
                justify-content: flex-end;
            }

            .modal-footer button {
                background: linear-gradient(135deg, #3b82f6 0%, #1d4ed8 100%);
                color: white;
                border: none;
                padding: 0.75rem 2rem;
                border-radius: 0.5rem;
                font-weight: 600;
                font-size: 1rem;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 4px 6px -1px rgba(59, 130, 246, 0.3);
            }

            .modal-footer button:hover {
                transform: translateY(-1px);
                box-shadow: 0 6px 12px -2px rgba(59, 130, 246, 0.4);
                background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .faq-container {
                    padding: 1rem;
                }

                .faq-container > div:first-child {
                    flex-direction: column;
                    gap: 1rem;
                    align-items: stretch !important;
                }

                .faq-card {
                    padding: 1rem;
                }

                .faq-content {
                    padding-right: 0;
                }

                .faq-index {
                    position: static;
                    align-self: flex-start;
                    margin-bottom: 1rem;
                }

                .action-buttons {
                    flex-direction: column;
                }

                .modal-content {
                    margin: 10% auto;
                    width: 95%;
                }

                .modal-body, .modal-footer {
                    padding: 1.5rem;
                }
            }

            @media (max-width: 480px) {
                .faq-container h2 {
                    font-size: 1.5rem;
                }

                .create-faq-btn {
                    width: 100%;
                    justify-content: center;
                }
            }

            /* Loading Animation */
            .faq-card.loading {
                opacity: 0.7;
                pointer-events: none;
            }

            /* Empty State */
            .faq-container:empty::after {
                content: "Chưa có câu hỏi nào. Hãy tạo câu hỏi đầu tiên!";
                display: block;
                text-align: center;
                color: #9ca3af;
                font-style: italic;
                padding: 3rem;
                background: white;
                border-radius: 1rem;
                border: 2px dashed #e5e7eb;
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
                <div class="faq-container">
                    <div style="display: flex; justify-content: space-between; align-items: center;">
                        <h2>Câu hỏi thường gặp</h2>
                        <button id="createFaqBtn" class="create-faq-btn">Tạo câu hỏi</button>
                    </div>

                    <c:if test="${not empty sessionScope.errorMessage}">
                        <p style="color: red;">${sessionScope.errorMessage}</p>
                        <c:remove var="errorMessage" scope="session" />
                    </c:if>

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
                                <div class="action-buttons">
                                    <a class="reply-btn" href="${pageContext.request.contextPath}/page/staff/faq-reply-form.jsp?id=${faq.faqId}">
                                        <c:choose>
                                            <c:when test="${empty faq.reply}">Trả lời</c:when>
                                            <c:otherwise>Sửa</c:otherwise>
                                        </c:choose>
                                    </a>
                                    <form action="${pageContext.request.contextPath}/staff/delete-faq" method="post" 
                                          onsubmit="return confirm('Bạn có chắc chắn muốn xóa câu hỏi này? Hành động này không thể hoàn tác.');">

                                        <%-- Gửi ID của câu hỏi một cách ẩn --%>
                                        <input type="hidden" name="faqId" value="${faq.faqId}">

                                        <button type="submit" class="delete-btn">Xóa</button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <div id="addFaqModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <span class="close-btn">&times;</span>
                    <h2>Tạo câu hỏi mới</h2>
                </div>
                <form action="${pageContext.request.contextPath}/staff/add-faq" method="post">
                    <div class="modal-body">
                        <p>Nhập nội dung câu hỏi bạn muốn thêm vào danh sách:</p>
                        <textarea name="question" placeholder="Ví dụ: Làm thế nào để xem lịch sử đơn hàng?" required></textarea>
                    </div>
                    <div class="modal-footer">
                        <button type="submit">Lưu câu hỏi</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            // Lấy các phần tử
            var modal = document.getElementById("addFaqModal");
            var btn = document.getElementById("createFaqBtn");
            var span = document.getElementsByClassName("close-btn")[0];

            // Khi người dùng click vào nút, mở modal
            btn.onclick = function () {
                modal.style.display = "block";
            };

            // Khi người dùng click vào <span> (x), đóng modal
            span.onclick = function () {
                modal.style.display = "none";
            };

            // Khi người dùng click ra ngoài modal, đóng nó lại
            window.onclick = function (event) {
                if (event.target === modal) {
                    modal.style.display = "none";
                }
            };
        </script>
    </body>
</html>