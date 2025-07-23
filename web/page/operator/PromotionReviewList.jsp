<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Danh sách gợi ý khuyến mãi</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            padding: 30px;
        }
        .container {
            max-width: 900px;
            margin: auto;
            background: #fff;
            padding: 25px 30px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            padding: 10px 12px;
            border-bottom: 1px solid #ddd;
        }
        th {
            background-color: #f0f0f0;
        }
        .btn {
            padding: 6px 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 14px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
         <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    </style>
</head>
<body>
<div class="container">
    <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
    <h2>Danh sách gợi ý khuyến mãi</h2>

    <table>
        <tr>
            <th>STT</th>
            <th>Tên</th>
            <th>Nội dung</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        <c:forEach var="s" items="${suggestions}" varStatus="loop">
            <tr>
                <td>${loop.index + 1}</td>
                <td>${s.title}</td>
                <td>${s.content}</td>
                <td>${s.status}</td>
                <td>
                    <form action="promotion-detail" method="get" style="display:inline;">
                        <input type="hidden" name="id" value="${s.id}">
                        <button class="btn">Chi tiết</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        <c:if test="${empty suggestions}">
            <tr><td colspan="5" style="text-align: center; color: gray;">Chưa có gợi ý nào.</td></tr>
        </c:if>
    </table>
</div></div></div></div></div>
</body>
</html>
