<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thêm Chính sách</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/CRUDPolicies.css">
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
                    <h2>Thêm Chính sách</h2>
                    <form method="post" action="${pageContext.request.contextPath}/add-policy" class="add-form">
                        <label for="policyTitle">Tiêu đề:</label>
                        <input type="text" id="policyTitle" name="policyTitle" required>

                        <label>Nội dung:</label>
                        <div id="description-container">
                            <textarea name="contents" required placeholder="Nội dung dòng 1..."></textarea>
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
                textarea.name = "contents";
                textarea.placeholder = "Nội dung dòng...";
                container.appendChild(textarea);
            }
        </script>
    </body>
</html>