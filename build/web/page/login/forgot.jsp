<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<jsp:include page="../../page/login/pass.jsp"/>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <title>Quên mật khẩu</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
        <style>
            .form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 16px;
                margin-bottom: 15px;
            }
            .form-group select {
                width: 100%;
                padding: 10px 12px;
                border: 1px solid #ccc;
                border-radius: 5px;
                font-size: 16px;
                line-height: 1.5;
                height: auto;
                min-height: 44px; 
                box-sizing: border-box;
            }
        </style>
    </head>
    <body>
        <a href="login" class="btn btn-secondary back-button">← Quay lại Đăng nhập</a>

        <div class="container mt-5">
            <h2 style="color: darkred;">Quên mật khẩu</h2>

            <!-- Step 1: Enter email and role -->
            <c:if test="${empty requestScope.step || requestScope.step == 'enterEmail'}">
                <p>Vui lòng chọn vai trò và nhập email để khôi phục mật khẩu</p>
                <form action="forgot" method="post">
                    <div class="form-group">
                        <select name="role_id" id="role_id" required class="form-control">
                            <option value="2">Operator</option>
                            <option value="3">Staff</option>
                            <option value="4">Đơn vị vận chuyển</option>
                            <option value="5">Đơn vị kho bãi</option>
                            <option value="6" selected>Khách hàng</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <input type="email" name="email" placeholder="Địa chỉ Email" required
                               value="${requestScope.email != null ? requestScope.email : ''}" class="form-control" />
                    </div>
                    <button type="submit" class="btn btn-primary">Gửi mã khôi phục</button>
                </form>
                <c:if test="${not empty requestScope.message}">
                    <p class="message mt-3" style="color: red; font-size: 1.25rem; font-weight: bold; padding: 10px 15px; border-radius: 5px;">
                        ${requestScope.message}
                    </p>
                </c:if>
            </c:if>

            <!-- Step 2: Enter code -->
            <c:if test="${requestScope.step == 'enterCode'}">
                <p>Mã khôi phục đã được gửi đến email:</p>
                <p><strong>${requestScope.email}</strong></p>
                <form action="confirmresetcode" method="post">
                    <input type="hidden" name="email" value="${requestScope.email}" />
                    <input type="hidden" name="role_id" value="${requestScope.role_id}" />
                    <div class="form-group">
                        <input type="text" name="resetcode" placeholder="Nhập mã khôi phục" required
                               value="${requestScope.code != null ? requestScope.code : ''}" class="form-control" />
                    </div>
                    <button type="submit" class="btn btn-success">Xác nhận mã khôi phục</button>
                </form>
                <c:if test="${not empty requestScope.message}">
                    <p class="message mt-3" style="color: red; font-size: 1.25rem; font-weight: bold; padding: 10px 15px; border-radius: 5px;">
                        ${requestScope.message}
                    </p>
                </c:if>
            </c:if>
        </div>
    </body>
</html>

