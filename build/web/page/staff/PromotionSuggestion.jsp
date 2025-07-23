<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
    <head>
        <title>Gợi ý khuyến mãi</title>
        <style>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f6f9;
                padding: 40px;
            }
            .container {
                max-width: 1000px;
                margin: auto;
                background: white;
                padding: 25px 30px;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-bottom: 30px;
            }
            th, td {
                padding: 10px 15px;
                border-bottom: 1px solid #ddd;
                text-align: left;
            }
            th {
                background-color: #f0f0f0;
            }
            .btn {
                background-color: #007bff;
                color: white;
                padding: 10px 18px;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                font-size: 15px;
            }
            .btn:hover {
                background-color: #0056b3;
            }
            .form-section {
                display: none;
                margin-top: 30px;
            }
            textarea, input[type="text"], input[type="date"] {
                width: 100%;
                padding: 10px;
                margin-top: 6px;
                border: 1px solid #ccc;
                border-radius: 6px;
            }
            label {
                font-weight: bold;
                margin-top: 15px;
                display: block;
            }
            .submit-btn {
                background-color: #28a745;
                margin-top: 20px;
            }
            .submit-btn:hover {
                background-color: #218838;
            }
            .parent {
    display: grid;
    grid-template-columns: 250px 1fr; /* Sidebar 250px, phần còn lại là content */
    grid-template-rows: auto 1fr;
    min-height: 100vh;
}

.div1 {
    grid-row: 1 / span 2; /* Sidebar kéo dài 2 hàng */
    grid-column: 1;
    background-color: #343a40;
    color: white;
    padding: 20px;
}

.div2 {
    grid-column: 2;
    grid-row: 1;
}

.div3 {
    grid-column: 2;
    grid-row: 2;
    padding: 20px;
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
                    <h2>Danh sách gợi ý khuyến mãi của bạn</h2>

                    <button class="btn" onclick="toggleForm()">+ Gợi ý khuyến mãi</button>

                    <table>
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
                    </table>

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
