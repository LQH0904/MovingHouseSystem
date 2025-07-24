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
            <div class="form-section" id="suggestionForm">
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
