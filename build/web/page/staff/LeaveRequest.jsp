<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đơn nghỉ phép</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f4f6f9;
            margin: 0;
            padding: 0;
        }

        .div3 {
            padding: 40px;
        }

        h2 {
            text-align: center;
            font-size: 26px;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        .btn {
            display: inline-block;
            background-color: #3498db !important;
            color: white;
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            margin-bottom: 25px;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #2980b9;
        }

        table.user-list-table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
        }

        table.user-list-table th,
        table.user-list-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        table.user-list-table th {
            background-color: #f1f3f5;
            color: #333;
            font-weight: 600;
        }

        table.user-list-table tr:hover td {
            background-color: #f9fbff;
        }

        .no-data {
            text-align: center;
            color: #888;
            font-style: italic;
        }

        #suggestionForm {
            margin-top: 40px;
            padding: 25px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.06);
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        form label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #333;
        }

        form input[type="date"],
        form textarea {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        form textarea {
            resize: vertical;
        }

        .submit-btn {
            width: 100%;
            margin-top: 20px;
            font-weight: bold;
        }

        @media screen and (max-width: 768px) {
            .div3 {
                padding: 20px;
            }

            table.user-list-table, thead, tbody, th, td, tr {
                display: block;
            }

            table.user-list-table thead {
                display: none;
            }

            table.user-list-table tr {
                margin-bottom: 15px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 1px 4px rgba(0,0,0,0.05);
                padding: 10px;
            }

            table.user-list-table td {
                position: relative;
                padding-left: 50%;
                border: none;
            }

            table.user-list-table td:before {
                position: absolute;
                top: 12px;
                left: 16px;
                width: 45%;
                font-weight: bold;
                color: #555;
                content: attr(data-label);
            }
        }
    </style>
</head>
<body>
<div class="parent">
    <div class="div1"><jsp:include page="/Layout/staff/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="/Layout/staff/Header.jsp"/></div>
    <div class="div3">
        <h2>Danh sách đơn nghỉ phép của bạn</h2>

        <button class="btn" onclick="toggleForm()">+ Gửi đơn nghỉ phép</button>

        <table class="user-list-table">
            <thead>
            <tr>
                <th>STT</th>
                <th>Từ ngày</th>
                <th>Đến ngày</th>
                <th>Lý do</th>
                <th>Trạng thái</th>
                <th>Phản hồi</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="r" items="${requests}" varStatus="loop">
                <tr>
                    <td data-label="STT">${loop.index + 1}</td>
                    <td data-label="Từ ngày">${r.startDate}</td>
                    <td data-label="Đến ngày">${r.endDate}</td>
                    <td data-label="Lý do">${r.reason}</td>
                    <td data-label="Trạng thái">${r.status}</td>
                    <td data-label="Phản hồi">${r.operatorReply}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty requests}">
                <tr><td colspan="6" class="no-data">Chưa có đơn nghỉ phép nào.</td></tr>
            </c:if>
            </tbody>
        </table>

        <div id="suggestionForm" style="display:none;">
            <form method="post" action="${pageContext.request.contextPath}/submit-leave-request">
                <label for="startDate">Từ ngày</label>
                <input type="date" name="startDate" required>

                <label for="endDate">Đến ngày</label>
                <input type="date" name="endDate" required>

                <label for="reason">Lý do</label>
                <textarea name="reason" rows="3" required></textarea>

                <button type="submit" class="btn submit-btn">Gửi đơn</button>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleForm() {
        const form = document.getElementById('suggestionForm');
        form.style.display = (form.style.display === 'none') ? 'block' : 'none';
    }
</script>
</body>
</html>
