<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Danh sách gợi ý khuyến mãi</title>
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

        .container {
            max-width: 1100px;
            margin: 30px auto;
            padding: 30px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
            animation: fadeIn 0.5s ease-in-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            text-align: center;
            font-size: 28px;
            font-weight: 700;
            color: #2d3436;
            margin-bottom: 30px;
            border-bottom: 2px solid #3498db;
            padding-bottom: 12px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            border-spacing: 0;
        }

        thead {
            background-color: #f1f3f5;
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
        }

        th {
            color: #333;
            font-weight: 600;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        tr:hover {
            background-color: #eef6ff;
        }

        .btn {
            padding: 8px 16px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: #0056b3;
        }

        td:last-child {
            text-align: center;
        }

        td[colspan] {
            text-align: center;
            color: #999;
            font-style: italic;
            padding: 20px 0;
        }

        /* Responsive */
        @media screen and (max-width: 768px) {
            table, thead, tbody, th, td, tr {
                display: block;
            }

            thead {
                display: none;
            }

            tr {
                margin-bottom: 15px;
                background: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 6px rgba(0,0,0,0.05);
                padding: 10px;
            }

            td {
                position: relative;
                padding-left: 50%;
                border: none;
                border-bottom: 1px solid #eee;
            }

            td:before {
                position: absolute;
                top: 12px;
                left: 16px;
                width: 45%;
                font-weight: bold;
                white-space: nowrap;
                color: #333;
            }

            td:nth-of-type(1):before { content: "STT"; }
            td:nth-of-type(2):before { content: "Tên"; }
            td:nth-of-type(3):before { content: "Nội dung"; }
            td:nth-of-type(4):before { content: "Trạng thái"; }
            td:nth-of-type(5):before { content: "Hành động"; }
        }
    </style>
</head>
<body>
<div class="parent">
    <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
    <div class="div3">
        <div class="container">
            <h2>Danh sách gợi ý khuyến mãi</h2>

            <table>
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên</th>
                        <th>Nội dung</th>
                        <th>Trạng thái</th>
                        <th>Hành động</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="s" items="${suggestions}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${s.title}</td>
                            <td>${s.content}</td>
                            <td>${s.status}</td>
                            <td>
                                <form action="promotion-detail" method="get" style="display:inline;">
                                    <input type="hidden" name="id" value="${s.id}">
                                    <button class="btn" type="submit">Chi tiết</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty suggestions}">
                        <tr>
                            <td colspan="5">Chưa có gợi ý nào.</td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>
