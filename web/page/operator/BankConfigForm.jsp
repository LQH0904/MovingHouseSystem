<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Cấu hình ngân hàng</title>
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
        width: 100%;
        min-height: 100vh;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        padding: 50px 20px;
    }

    .form-box {
        background: white;
        padding: 30px 40px;
        border-radius: 12px;
        box-shadow: 0 10px 25px rgba(0,0,0,0.1);
        width: 500px;
        animation: fadeIn 0.4s ease-in-out;
    }

    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }

    h2 {
        text-align: center;
        margin-bottom: 30px;
        color: #2c3e50;
        font-size: 24px;
        border-bottom: 2px solid #3498db;
        padding-bottom: 10px;
    }

    label {
        display: block;
        margin: 14px 0 6px;
        font-weight: 600;
        color: #333;
    }

    input[type="text"],
    select {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
        font-size: 15px;
        transition: all 0.3s ease;
    }

    input[type="text"]:focus,
    select:focus {
        border-color: #3498db;
        outline: none;
        box-shadow: 0 0 5px rgba(52,152,219,0.3);
    }

    button {
        width: 100%;
        padding: 12px;
        margin-top: 20px;
        border: none;
        background-color: #3498db;
        color: white;
        font-size: 15px;
        border-radius: 6px;
        cursor: pointer;
        transition: background-color 0.3s ease;
    }

    button:hover {
        background-color: #2980b9;
    }

    .qr-btn {
        background-color: #27ae60;
        margin-top: 12px;
    }

    .qr-btn:hover {
        background-color: #1e8449;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 25px;
    }

    table th,
    table td {
        padding: 10px 12px;
        border-bottom: 1px solid #e0e0e0;
        text-align: left;
        font-size: 14px;
    }

    table th {
        background-color: #f7f9fa;
        font-weight: 600;
        color: #333;
    }

    table tr:hover {
        background-color: #f2f2f2;
    }

    .form-box h3 {
        margin-top: 40px;
        font-size: 18px;
        color: #2c3e50;
        border-bottom: 1px solid #ccc;
        padding-bottom: 8px;
    }

    a.delete-link {
        color: #e74c3c;
        text-decoration: none;
        font-weight: 500;
    }

    a.delete-link:hover {
        text-decoration: underline;
    }
</style>

    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
        <div class="container">
            <div class="form-box">
                <h2>Cấu hình thông tin thanh toán</h2>
                <form method="post" action="${pageContext.request.contextPath}/update-bank">
                    <label>Ngân hàng:</label>
                    <select name="bankName" required>
                        <option value="">-- Chọn ngân hàng --</option>
                        <option value="Vietcombank">Vietcombank</option>
                        <option value="VietinBank">VietinBank</option>
                        <option value="MB Bank">MB Bank</option>
                        <option value="TPBank">TPBank</option>
                        <option value="BIDV">BIDV</option>
                        <option value="ACB">ACB</option>
                    </select>

                    <label>Số tài khoản:</label>
                    <input type="text" name="accountNumber" required />

                    <label>Tên tài khoản:</label>
                    <input type="text" name="accountName" required />

                    <button type="submit">Lưu</button>
                </form>
                <c:if test="${not empty bankList}">
                    <h3 style="margin-top: 30px;">Danh sách ngân hàng đã lưu</h3>
                    <table style="width: 100%; border-collapse: collapse; margin-top: 10px;">
                        <tr style="background-color: #eee;">
                            <th>Ngân hàng</th>
                            <th>Số tài khoản</th>
                            <th>Tên tài khoản</th>
                            <th>Thao tác</th>
                        </tr>
                        <c:forEach var="b" items="${bankList}">
                            <tr>
                                <td>${b.bankName}</td>
                                <td>${b.accountNumber}</td>
                                <td>${b.accountName}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/delete-bank?id=${b.configId}" 
                                       onclick="return confirm('Bạn có chắc muốn xóa?')"
                                       style="color: red;">Xóa</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </table>
                </c:if>


                <a href="${pageContext.request.contextPath}/test-payment-option">
    <button type="button" class="qr-btn">Test QR</button>
</a>

            </div>
        </div></div></div></div></div>
    </body>
</html>
