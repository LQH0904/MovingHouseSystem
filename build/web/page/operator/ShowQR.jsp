<%@page contentType="text/html;charset=UTF-8"%>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<html>
    
<head>
    <title>Quét mã QR để thanh toán</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f6f9;
            text-align: center;
        }

        .qr-box {
            margin-top: 40px;
        }

        img {
            width: 300px;
            height: 300px;
        }

        h2 {
            margin-top: 20px;
            color: #2c3e50;
        }

        p {
            color: #555;
        }
    </style>
</head>
<body>
    <p>Link QR: https://img.vietqr.io/image/970423-00000119443-print.png?amount=500000&addInfo=huy123%20thanh%20toan&accountName=LUONG%20QUANG%20HUY</p>

    <h2>Quét mã QR bằng App ngân hàng</h2>
    <div class="qr-box">
        <c:if test="${not empty qrURL}">
            <img src="${qrURL}" alt="QR Thanh toán" style="width:300px;height:300px;" />
            <p>Mã QR sẽ tự động điền sẵn số tài khoản, số tiền và nội dung giao dịch.</p>
        </c:if>
        <c:if test="${empty qrURL}">
            <p>Không thể tạo mã QR. Vui lòng thử lại.</p>
        </c:if>
    </div>
</body>
</html>
