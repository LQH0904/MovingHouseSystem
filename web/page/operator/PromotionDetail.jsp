<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
    <head>
        <title>Chi tiết gợi ý</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding: 40px;
            }
            .container {
                max-width: 700px;
                margin: auto;
                background-color: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                color: #333;
            }
            .info-row {
                margin: 12px 0;
            }
            label {
                font-weight: bold;
                display: block;
                margin-bottom: 6px;
            }
            .readonly {
                background-color: #f1f1f1;
                padding: 8px;
                border-radius: 5px;
            }
            textarea {
                width: 100%;
                padding: 10px;
                margin-top: 6px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
            .btn {
                background-color: #28a745;
                color: white;
                padding: 10px 18px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                margin-top: 20px;
            }
            .btn:hover {
                background-color: #218838;
            }
             <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
        <div class="container">
            <h2>Chi tiết Gợi ý Khuyến mãi</h2>

            <div class="info-row"><label>Người gửi:</label><div class="readonly">${suggestion.user.username}</div></div>
            <div class="info-row"><label>Tên khuyến mãi:</label><div class="readonly">${suggestion.title}</div></div>
            <div class="info-row"><label>Nội dung:</label><div class="readonly">${suggestion.content}</div></div>
            <div class="info-row"><label>Lý do:</label><div class="readonly">${suggestion.reason}</div></div>
            <div class="info-row"><label>Thời gian:</label><div class="readonly">${suggestion.startDate} - ${suggestion.endDate}</div></div>
            <form method="post" action="${pageContext.request.contextPath}/submit-review">
    <input type="hidden" name="id" value="${suggestion.id}" />

    <label for="status">Trạng thái</label>
    <select name="status" id="status" required>
        <option value="">-- Chọn trạng thái --</option>
        <option value="Duyệt">Duyệt</option>
        <option value="Không duyệt">Không duyệt</option>
    </select>

</form>



            <form action="submit-review" method="post">
                <input type="hidden" name="id" value="${suggestion.id}">

                <label for="reply">Phản hồi / Đánh giá</label>
                <textarea id="reply" name="reply" rows="4" required maxlength="500"
                          placeholder="Viết đánh giá ngắn gọn (tối đa 500 ký tự)"></textarea>

                <button class="btn" type="submit">Gửi đánh giá</button>
            </form>
        </div></div></div></div></div>
    </body>
</html>
