<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Cấu hình ngân hàng</title>
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 0;
            }

            .container {
                width: 100%;
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .form-box {
                background: white;
                padding: 30px 40px;
                border-radius: 10px;
                box-shadow: 0 8px 24px rgba(0,0,0,0.1);
                width: 400px;
            }

            h2 {
                text-align: center;
                margin-bottom: 25px;
                color: #2c3e50;
            }

            label {
                display: block;
                margin: 10px 0 5px;
                font-weight: 500;
            }

            input[type="text"],
            select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }

            input[type="text"]:focus,
            select:focus {
                border-color: #3498db;
                outline: none;
            }

            button {
                width: 100%;
                padding: 10px;
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
                margin-top: 10px;
            }

            .qr-btn:hover {
                background-color: #1e8449;
            }
        </style>
    </head>
    <body>
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
        </div>
    </body>
</html>
