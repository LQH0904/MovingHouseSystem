<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.OperationProcedure"%>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/UserList.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/CRUDFeeConfiguration.css">

    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="/Layout/operator/Header.jsp"></jsp:include> </div>
                <div class="div3"> 
                    <div class="form-container">
    <form method="post" action="${pageContext.request.contextPath}/add-fee" class="add-form">
        <h2 class="add-title">Thêm Cấu hình phí</h2>

        <label for="feeType">Loại phí:</label>
        <input type="text" id="feeType" name="feeType" required>

        <label>Mô tả:</label>
        <div id="description-container">
            <textarea name="descriptions" required placeholder="Nội dung dòng 1..."></textarea>
        </div>

        <button type="button" class="add-desc-btn" onclick="addDescription()">+ Thêm nội dung</button><br>
        <button type="submit" class="submit-btn">Lưu</button>
    </form>
</div>
eeeeeeeeeeeee
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
