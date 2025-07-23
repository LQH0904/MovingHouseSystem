<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<html>
    <head>
        <title>Thông tin thanh toán</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 0;
            }

            .payment-box {
                max-width: 500px;
                margin: 40px auto;
                background: white;
                padding: 30px 40px;
                border-radius: 10px;
                box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            }

            h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #2c3e50;
            }

            p {
                margin: 12px 0;
                font-size: 15px;
                color: #333;
            }

            strong {
                color: #2c3e50;
            }

            .qr-option {
                text-align: center;
                margin-top: 30px;
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
                <div class="payment-box">
                    <h2>Thông tin chuyển khoản</h2>

                    <p><strong>Người nhận:</strong> ${config.accountName}</p>
                    <p><strong>Số tài khoản:</strong> ${config.accountNumber}</p>
                    <p><strong>Ngân hàng:</strong> ${config.bankName}</p>
                    <p><strong>Số tiền:</strong> ${amount} VND</p>
                    <p><strong>Ghi chú khi chuyển khoản:</strong> ${username} thanh toán</p>

                    <div class="qr-option">
                        <h2>Quét mã QR bằng app ngân hàng</h2>

                        <c:url var="qrUrl" value="https://img.vietqr.io/image/${bankCode}-${config.accountNumber}-print.png">
                            <c:param name="amount" value="${amount}" />
                            <c:param name="addInfo" value="${username} thanh toán" />
                            <c:param name="accountName" value="${config.accountName}" />
                        </c:url>

                        <img src="${qrUrl}" alt="QR thanh toán" style="max-width:300px;" />
                    </div>
                </div></div></div></div></div>
</body>
</html>
