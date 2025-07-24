<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Chi tiết gợi ý</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f6f9;
                margin: 0;
            }

            .container {
                max-width: 850px;
                margin: 40px auto;
                padding: 30px;
                background-color: #fff;
                border-radius: 12px;
                box-shadow: 0 10px 25px rgba(0, 0, 0, 0.07);
                animation: fadeIn 0.5s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h2 {
                text-align: center;
                font-size: 28px;
                color: #2d3436;
                margin-bottom: 30px;
                border-bottom: 2px solid #3498db;
                padding-bottom: 10px;
            }

            .info-row {
                margin-bottom: 18px;
            }

            label {
                font-weight: 600;
                margin-bottom: 6px;
                display: inline-block;
                color: #333;
            }

            .readonly {
                background-color: #f1f3f5;
                padding: 10px 14px;
                border-radius: 6px;
                border: 1px solid #dee2e6;
                font-size: 15px;
                color: #555;
            }

            textarea, select {
                width: 100%;
                padding: 12px 14px;
                font-size: 15px;
                border: 1px solid #ccc;
                border-radius: 6px;
                box-sizing: border-box;
                resize: vertical;
                transition: border-color 0.3s ease;
            }

            textarea:focus, select:focus {
                border-color: #3498db;
                outline: none;
            }

            .btn {
                background-color: #3498db;
                color: white;
                padding: 12px 22px;
                border: none;
                border-radius: 6px;
                font-weight: 500;
                font-size: 15px;
                cursor: pointer;
                margin-top: 20px;
                transition: background-color 0.3s ease;
            }

            .btn:hover {
                background-color: #2c80b4;
            }

            form {
                margin-top: 25px;
            }
        </style>

    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
                <div class="container">
                    <h2>Chi tiết Gợi ý Khuyến mãi</h2>

                    <div class="info-row">
                        <label>Người gửi:</label>
                        <div class="readonly">${suggestion.user.username}</div>
                    </div>
                    <div class="info-row">
                        <label>Tên khuyến mãi:</label>
                        <div class="readonly">${suggestion.title}</div>
                    </div>
                    <div class="info-row">
                        <label>Nội dung:</label>
                        <div class="readonly">${suggestion.content}</div>
                    </div>
                    <div class="info-row">
                        <label>Lý do:</label>
                        <div class="readonly">${suggestion.reason}</div>
                    </div>
                    <div class="info-row">
                        <label>Thời gian:</label>
                        <div class="readonly">${suggestion.startDate} - ${suggestion.endDate}</div>
                    </div>

                    <form action="${pageContext.request.contextPath}/submit-review" method="post">
                        <input type="hidden" name="id" value="${suggestion.id}" />

                        <div class="info-row">
                            <label for="status">Trạng thái:</label>
                            <select name="status" id="status" required>
                                <option value="">-- Chọn trạng thái --</option>
                                <option value="Duyệt">Duyệt</option>
                                <option value="Không duyệt">Không duyệt</option>
                            </select>
                        </div>

                        <div class="info-row">
                            <label for="reply">Phản hồi / Đánh giá:</label>
                            <textarea id="reply" name="reply" rows="4" required maxlength="500"
                                      placeholder="Viết đánh giá ngắn gọn (tối đa 500 ký tự)"></textarea>
                        </div>

                        <button class="btn" type="submit">Gửi đánh giá</button>
                    </form>
                </div>
            </div>

    </body>
</html>
