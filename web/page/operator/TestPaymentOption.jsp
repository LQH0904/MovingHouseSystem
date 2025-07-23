<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Test Thanh Toán</title>
    <style>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 50px auto;
            background: #fff;
            padding: 30px 40px;
            border-radius: 10px;
            box-shadow: 0 6px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #2c3e50;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: #333;
        }

        input[type="number"],
        input[type="text"],
        select {
            width: 100%;
            padding: 10px 12px;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        input:focus, select:focus {
            outline: none;
            border-color: #3498db;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            border: none;
            font-size: 15px;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>
    <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
    <div class="container">
        <h2>Chọn phương thức thanh toán</h2>
        <form action="${pageContext.request.contextPath}/payment-info" method="get">
            <label>Nhập số tiền:</label>
            <input type="number" name="amount" required min="1000" />

            <label>Username (mô phỏng người dùng):</label>
            <input type="text" name="username" required value="huy123" />

            <label>Chọn ngân hàng + STK:</label>
            <select name="bankName" required>
                <option value="">-- Chọn ngân hàng --</option>
                <c:forEach var="b" items="${bankList}">
                    <option value="${b.bankName}">
                        ${b.bankName} - ${b.accountNumber} (${b.accountName})
                    </option>
                </c:forEach>
            </select>

            <button type="submit">Xem thông tin thanh toán</button>
        </form>
    </div></div></div></div></div>
</body>
</html>
