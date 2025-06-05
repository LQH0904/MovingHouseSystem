<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<html>
    <head>
        <title>Thêm Người Dùng Mới</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/AddUser.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/SideBar.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="/Layout/Header.jsp"></jsp:include> </div>
            <div class="div3"> 
                <!-- Form thêm người dùng mới -->
                <form action="<%= request.getContextPath() %>/Operator/AddUserServlet" method="post" class="add-user-form">
                    <table class="user-form-table">
                        <tr>
                            <td>Tên Người Dùng:</td>
                            <td><input type="text" name="username" class="form-input" required></td>
                        </tr>
                        <tr>
                            <td>Mật khẩu:</td>
                            <td><input type="password" name="password" class="form-input" required></td>
                        </tr>
                        <tr>
                            <td>Email:</td>
                            <td><input type="email" name="email" class="form-input" required></td>
                        </tr>
                        <tr>
                            <td>Vai Trò:</td>
                            <td>
                                <select name="roleId" class="form-select">
<!--                                    //<option value="1">Admin</option>dành cho phần admin-->
                                    <option value="6">Customer</option>
                                    <option value="3">Staff</option>
                                    <option value="2">Operator</option>
                                    <option value="4">Transport Unit</option>
                                    <option value="5">Storage Unit</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <button type="submit" class="submit-btn">Thêm Người Dùng</button>
                            </td>
                        </tr>
                    </table>
                </form>
            </div>
        </div>
    </body>
</html>
