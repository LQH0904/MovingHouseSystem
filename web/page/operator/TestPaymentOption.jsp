<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Test Thanh Toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #ecf0f3;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 60px auto;
            background: #ffffff;
            padding: 35px 40px;
            border-radius: 15px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
            font-size: 24px;
        }

        label {
            font-weight: 600;
            display: block;
            margin-bottom: 8px;
            color: #444;
        }

        input[type="number"],
        input[type="text"],
        select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #ccd1d9;
            border-radius: 8px;
            font-size: 15px;
            margin-bottom: 20px;
            background-color: #f9f9f9;
            transition: border-color 0.3s ease, box-shadow 0.3s ease;
        }

        input:focus,
        select:focus {
            border-color: #3498db;
            outline: none;
            box-shadow: 0 0 6px rgba(52, 152, 219, 0.3);
            background-color: #fff;
        }

        button {
            width: 100%;
            padding: 12px;
            background-color: #3498db;
            color: white;
            font-size: 16px;
            font-weight: bold;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.2s;
        }

        button:hover {
            background-color: #2980b9;
            transform: scale(1.01);
        }

        select option {
            padding: 8px;
        }

        @media (max-width: 576px) {
            .container {
                padding: 25px 20px;
                margin: 30px 10px;
            }
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
                    <label for="amount">Nhập số tiền:</label>
                    <input type="number" name="amount" id="amount" required min="1000" placeholder="VD: 200000" />

                    <label for="username">Username (mô phỏng người dùng):</label>
                    <input type="text" name="username" id="username" required value="huy123" />

                    <label for="bankName">Chọn ngân hàng + STK:</label>
                    <select name="bankName" id="bankName" required>
                        <option value="">-- Chọn ngân hàng --</option>
                        <c:forEach var="b" items="${bankList}">
                            <option value="${b.bankName}">
                                ${b.bankName} - ${b.accountNumber} (${b.accountName})
                            </option>
                        </c:forEach>
                    </select>

                    <button type="submit">Xem thông tin thanh toán</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>
