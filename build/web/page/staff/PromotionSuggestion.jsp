<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Gợi ý khuyến mãi</title>

    <!-- Chỉ include CSS đúng cách -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/PromotionSuggestion.css">
    
    <style>
    /* Chỉ styling trong .div3 */
    .div3 {
        padding: 20px;
        background-color: #f8f9fc;
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
    }

    .div3 h2 {
        margin-bottom: 20px;
        font-size: 24px;
        color: #333;
        border-bottom: 2px solid #ccc;
        padding-bottom: 10px;
    }

    .div3 .btn {
        background-color: #007bff;
        color: white;
        border: none;
        padding: 8px 16px;
        border-radius: 5px;
        cursor: pointer;
        font-size: 14px;
        margin-bottom: 15px;
        transition: background-color 0.2s ease;
    }

    .div3 .btn:hover {
        background-color: #0056b3;
    }

    .div3 .user-list-table {
        width: 100%;
        border-collapse: collapse;
        background-color: white;
        border-radius: 8px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    }

    .div3 .user-list-table th,
    .div3 .user-list-table td {
        padding: 12px;
        text-align: left;
        border-bottom: 1px solid #ddd;
        font-size: 14px;
    }

    .div3 .user-list-table th {
        background-color: #f1f3f6;
        font-weight: bold;
        color: #555;
    }

    .div3 .user-list-table tbody tr:hover {
        background-color: #f5f9ff;
    }

    /* Form Section */
    .div3 #suggestionForm {
        display: none;
        margin-top: 25px;
        background: white;
        padding: 20px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }

    .div3 #suggestionForm label {
        display: block;
        margin-top: 15px;
        font-weight: 600;
        color: #333;
    }

    .div3 #suggestionForm input[type="text"],
    .div3 #suggestionForm textarea,
    .div3 #suggestionForm input[type="date"] {
        width: 100%;
        padding: 8px 12px;
        margin-top: 6px;
        border: 1px solid #ccc;
        border-radius: 5px;
        font-size: 14px;
        box-sizing: border-box;
        transition: border-color 0.3s ease;
    }

    .div3 #suggestionForm input:focus,
    .div3 #suggestionForm textarea:focus {
        border-color: #007bff;
        outline: none;
    }

    .div3 .submit-btn {
        margin-top: 20px;
        width: 100%;
        background-color: #28a745;
        padding: 10px;
        font-size: 15px;
    }

    .div3 .submit-btn:hover {
        background-color: #218838;
    }

    .div3 .no-data {
        text-align: center;
        color: gray;
        padding: 15px 0;
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
            <!-- Nội dung trang PromotionSuggestion -->
            <h2>Danh sách gợi ý khuyến mãi của bạn</h2>

            <button class="btn" onclick="toggleForm()">+ Gợi ý khuyến mãi</button>

            <table class="user-list-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên</th>
                        <th>Nội dung</th>
                        <th>Ngày bắt đầu</th>
                        <th>Ngày kết thúc</th>
                        <th>Lý do</th>
                        <th>Trạng thái</th>
                        <th>Phản hồi</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${suggestions}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${s.title}</td>
                            <td>${s.content}</td>
                            <td>${s.startDate}</td>
                            <td>${s.endDate}</td>
                            <td>${s.reason}</td>
                            <td>${s.status}</td>
                            <td>${s.reply}</td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty suggestions}">
                        <tr><td colspan="8" style="text-align: center; color: gray;">Chưa có gợi ý nào.</td></tr>
                    </c:if>
                </tbody>
            </table>

            <!-- Form toggle -->
            <div class="form-section" id="suggestionForm" style="display: none;">
                <form method="post" action="submit-promotion">
                    <label for="title">Tên khuyến mãi</label>
                    <input type="text" id="title" name="title" required>

                    <label for="content">Nội dung khuyến mãi</label>
                    <textarea name="content" id="content" rows="3" required></textarea>

                    <label for="reason">Lý do đề xuất</label>
                    <textarea name="reason" id="reason" rows="3" required></textarea>

                    <label for="startDate">Ngày bắt đầu</label>
                    <input type="date" id="startDate" name="startDate" required>

                    <label for="endDate">Ngày kết thúc</label>
                    <input type="date" id="endDate" name="endDate" required>

                    <button type="submit" class="btn submit-btn">Gửi Gợi Ý</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        function toggleForm() {
            const form = document.getElementById('suggestionForm');
            form.style.display = form.style.display === 'none' || form.style.display === '' ? 'block' : 'none';
        }
    </script>
</body>
</html>
