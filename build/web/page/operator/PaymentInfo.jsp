<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
<head>
    <title>Thông tin thanh toán</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, sans-serif;
            background-color: #ecf0f3;
            margin: 0;
            padding: 0;
        }

        .payment-box {
            max-width: 520px;
            margin: 60px auto;
            background: #fff;
            padding: 35px 40px;
            border-radius: 12px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.08);
            animation: fadeIn 0.4s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        h2 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 25px;
            font-size: 22px;
            border-bottom: 1px solid #ccc;
            padding-bottom: 10px;
        }

        p {
            margin: 12px 0;
            font-size: 15px;
            color: #444;
            line-height: 1.6;
        }

        strong {
            font-weight: 600;
            color: #2c3e50;
        }

        .qr-option {
            text-align: center;
            margin-top: 30px;
        }

        .qr-option h2 {
            font-size: 18px;
            color: #3498db;
            margin-bottom: 16px;
        }

        .qr-option img {
            max-width: 100%;
            border: 1px solid #ccc;
            border-radius: 10px;
            padding: 8px;
            background: #f9f9f9;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        @media (max-width: 600px) {
            .payment-box {
                margin: 30px 15px;
                padding: 25px 20px;
            }
        }
    </style>
</head>
<body>
<div class="parent">
    <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
    <div class="div3">
        <div class="payment-box">
            <h2>Thông tin chuyển khoản</h2>

            <p><strong>Người nhận:</strong> ${config.accountName}</p>
            <p><strong>Số tài khoản:</strong> ${config.accountNumber}</p>
            <p><strong>Ngân hàng:</strong> ${config.bankName}</p>
            <p><strong>Số tiền:</strong> ${amount} VND</p>
            <p><strong>Ghi chú khi chuyển khoản:</strong> ${username} thanh toán</p>

            <div class="qr-option">
                <h2>Quét mã QR để thanh toán</h2>

                <c:url var="qrUrl" value="https://img.vietqr.io/image/${bankCode}-${config.accountNumber}-print.png">
                    <c:param name="amount" value="${amount}" />
                    <c:param name="addInfo" value="${username} thanh toán" />
                    <c:param name="accountName" value="${config.accountName}" />
                </c:url>

                <img src="${qrUrl}" alt="QR thanh toán" />
            </div>
        </div>
    </div>
</div>
</body>
</html>
