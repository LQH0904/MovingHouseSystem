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
            /* CSS cho khối div3 - Lịch sử phản hồi */
            .div3 {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 2rem;
                position: relative;
                overflow-y: auto;
            }

            .div3::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #ff6b6b 0%, #feca57 100%);
                z-index: 1;
            }

            .div3 .container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(15px);
                border-radius: 25px;
                box-shadow: 
                    0 25px 50px rgba(0, 0, 0, 0.15),
                    0 0 0 1px rgba(255, 255, 255, 0.2);
                padding: 3rem;
                margin: 0 auto;
                max-width: 1000px;
                position: relative;
                overflow: hidden;
                animation: slideInFromBottom 0.8s ease-out;
            }

            .div3 .container::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 1px;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.8), transparent);
            }

            /* Tiêu đề chính */
            .div3 h2 {
                color: #2d3748;
                font-weight: 800;
                font-size: 2.2rem;
                margin-bottom: 2.5rem;
                text-align: center;
                position: relative;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            .div3 h2::after {
                content: '';
                position: absolute;
                bottom: -15px;
                left: 50%;
                transform: translateX(-50%);
                width: 120px;
                height: 4px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
                box-shadow: 0 2px 10px rgba(102, 126, 234, 0.3);
            }

            /* Reply item styling */
            .div3 .reply-item {
                background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
                border-radius: 20px;
                padding: 2rem;
                margin-bottom: 1.5rem;
                box-shadow: 
                    0 10px 30px rgba(0, 0, 0, 0.08),
                    0 0 0 1px rgba(102, 126, 234, 0.1);
                position: relative;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                border-left: 5px solid #667eea;
                animation: fadeInUp 0.6s ease forwards;
                opacity: 0;
            }

            .div3 .reply-item:nth-child(1) { animation-delay: 0.1s; }
            .div3 .reply-item:nth-child(2) { animation-delay: 0.2s; }
            .div3 .reply-item:nth-child(3) { animation-delay: 0.3s; }
            .div3 .reply-item:nth-child(4) { animation-delay: 0.4s; }
            .div3 .reply-item:nth-child(5) { animation-delay: 0.5s; }

            .div3 .reply-item::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 2px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 20px 20px 0 0;
            }

            .div3 .reply-item:hover {
                transform: translateY(-5px);
                box-shadow: 
                    0 20px 40px rgba(0, 0, 0, 0.12),
                    0 0 0 1px rgba(102, 126, 234, 0.2);
                border-left-color: #764ba2;
            }

            /* Paragraph styling trong reply item */
            .div3 .reply-item p {
                margin-bottom: 1rem;
                line-height: 1.6;
                color: #4a5568;
                font-size: 1rem;
                position: relative;
            }

            .div3 .reply-item p:last-of-type {
                margin-bottom: 0;
            }

            .div3 .reply-item p strong {
                color: #2d3748;
                font-weight: 700;
                display: inline-block;
                min-width: 120px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
                background-clip: text;
            }

            /* Styling đặc biệt cho nội dung phản hồi */
            .div3 .reply-item p:last-of-type {
                background: linear-gradient(135deg, #f0f4ff 0%, #e6f3ff 100%);
                padding: 1.2rem;
                border-radius: 15px;
                border-left: 4px solid #667eea;
                margin-top: 1rem;
                font-style: italic;
                color: #2d3748;
                font-weight: 500;
            }

            /* HR styling */
            .div3 .reply-item hr {
                border: none;
                height: 2px;
                background: linear-gradient(90deg, transparent, #e2e8f0, transparent);
                margin: 1.5rem 0;
                border-radius: 1px;
            }

            /* Empty message styling */
            .div3 p {
                text-align: center;
                font-size: 1.2rem;
                color: #6c757d;
                background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
                padding: 2rem;
                border-radius: 15px;
                border: 2px dashed #dee2e6;
                margin: 2rem 0;
                font-style: italic;
            }

            /* Button styling */
            .div3 .btn {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                border: none;
                border-radius: 50px;
                padding: 1rem 2.5rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 1px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 
                    0 10px 30px rgba(102, 126, 234, 0.3),
                    0 0 0 1px rgba(255, 255, 255, 0.1);
                position: relative;
                overflow: hidden;
                margin-top: 2rem;
                min-width: 200px;
                font-size: 0.9rem;
            }

            .div3 .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.6s ease;
            }

            .div3 .btn:hover::before {
                left: 100%;
            }

            .div3 .btn:hover {
                transform: translateY(-5px);
                box-shadow: 
                    0 20px 40px rgba(102, 126, 234, 0.4),
                    0 0 0 1px rgba(255, 255, 255, 0.2);
                background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
                color: white;
                text-decoration: none;
            }

            .div3 .btn::after {
                content: '←';
                margin-right: 0.5rem;
                font-size: 1.2rem;
                transition: transform 0.3s ease;
            }

            .div3 .btn:hover::after {
                transform: translateX(-3px);
            }

            /* Animations */
            @keyframes slideInFromBottom {
                from {
                    opacity: 0;
                    transform: translateY(50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes fadeInUp {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive Design */
            @media (max-width: 768px) {
                .div3 {
                    padding: 1rem;
                }
                
                .div3 .container {
                    padding: 2rem;
                    border-radius: 20px;
                }
                
                .div3 h2 {
                    font-size: 1.8rem;
                    margin-bottom: 2rem;
                }
                
                .div3 .reply-item {
                    padding: 1.5rem;
                    border-radius: 15px;
                }
                
                .div3 .reply-item p strong {
                    min-width: 100px;
                    font-size: 0.9rem;
                }
                
                .div3 .btn {
                    padding: 0.8rem 2rem;
                    font-size: 0.85rem;
                    min-width: 180px;
                }
            }

            @media (max-width: 576px) {
                .div3 .container {
                    padding: 1.5rem;
                    margin: 0.5rem;
                }
                
                .div3 h2 {
                    font-size: 1.5rem;
                }
                
                .div3 .reply-item {
                    padding: 1rem;
                }
                
                .div3 .reply-item p {
                    font-size: 0.9rem;
                }
                
                .div3 .reply-item p strong {
                    min-width: 80px;
                    font-size: 0.85rem;
                }
                
                .div3 .btn {
                    padding: 0.7rem 1.5rem;
                    font-size: 0.8rem;
                    min-width: 160px;
                }
            }

            /* Print styles */
            @media print {
                .div3 {
                    background: white;
                    padding: 1rem;
                }
                
                .div3 .container {
                    box-shadow: none;
                    background: white;
                }
                
                .div3 .btn {
                    display: none;
                }
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
                                <p><strong>Người phản hồi:</strong> ${reply.replierName}</p> <!-- Thay replierId bằng replierName -->
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
        </div>
    </body>
</html>