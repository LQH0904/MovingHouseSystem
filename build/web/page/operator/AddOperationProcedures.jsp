<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
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
        <meta charset="UTF-8">
        <title>Thêm Quy trình</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/CRUDProcedure.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp" /></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp" /></div>

            <div class="div3">
                <div class="form-container">
                    <h2>Thêm Quy trình</h2>
<form method="post" action="${pageContext.request.contextPath}/add-procedure" class="add-form">
                        <label for="stepTitle">Tiêu đề:</label>
                        <input type="text" id="stepTitle" name="stepTitle" required>

                        <label>Nội dung mô tả:</label>
                        <div id="description-container">
                            <textarea name="descriptions" required placeholder="Nội dung dòng 1..."></textarea>
                        </div>

                        <button type="button" class="add-desc-btn" onclick="addDescription()">+ Thêm nội dung</button><br>

                        <button type="submit" class="submit-btn">Lưu</button>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function addDescription() {
                const container = document.getElementById("description-container");
                const textarea = document.createElement("textarea");
                textarea.name = "descriptions";
                textarea.placeholder = "Nội dung dòng...";
                container.appendChild(textarea);
            }
        </script>
    </body>
</html>
