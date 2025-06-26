<%-- 
    Document   : EditFeeConfiguration
    Created on : Jun 23, 2025, 8:14:30 PM
    Author     : admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chỉnh sửa Cấu hình phí</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/CRUDFeeConfiguration.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp" /></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp" /></div>
            <div class="div3">
                <div class="form-container ">
                    <form method="post" action="${pageContext.request.contextPath}/edit-fee" class="add-form">
                        <h2 class="add-title">Chỉnh sửa Cấu hình phí</h2>

                        <input type="hidden" name="id" value="<%= request.getAttribute("id") %>">

                        <label for="feeType">Loại phí:</label>
                        <input type="text" id="feeType" name="feeType" required value="<%= request.getAttribute("feeType") %>">

                        <label>Mô tả:</label>
                        <div id="description-container">
                            <%
                                String content = (String) request.getAttribute("description");
                                String[] lines = content.split("\\r?\\n");
                                int index = 1;
                                for (String line : lines) {
                                    line = line.trim().replaceFirst("^\\.\\s*", "");
                            %>
                            <div class="description-line">
                                <input type="text" name="desc<%= index %>" required value="<%= line %>" />
                                <button type="button" class="delete-line-btn" onclick="removeLine(this)">Xóa</button>
                            </div>
                            <%
                                    index++;
                                }
                            %>
                        </div>

                        <button type="button" class="add-desc-btn" onclick="addDescriptionField()">+ Thêm nội dung</button>

                        <div class="form-actions">
                            <button type="submit" class="submit-btn">Cập nhật</button>
                            <button type="button" class="delete-btn" onclick="confirmDeleteAndSubmit()">Xóa cấu hình này</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <script>
            function addDescriptionField() {
                const container = document.getElementById("description-container");
                const index = container.children.length + 1;

                const div = document.createElement("div");
                div.className = "description-line";

                const input = document.createElement("input");
                input.type = "text";
                input.name = "desc" + index;
                input.required = true;

                const btn = document.createElement("button");
                btn.type = "button";
                btn.className = "delete-line-btn";
                btn.textContent = "Xóa";
                btn.onclick = function () {
                    removeLine(btn);
                };

                div.appendChild(input);
                div.appendChild(btn);
                container.appendChild(div);
            }

            function removeLine(button) {
                const container = document.getElementById("description-container");
                if (container.childElementCount > 1) {
                    button.parentNode.remove();
                } else {
                    alert("Phải có ít nhất 1 dòng nội dung.");
                }
            }

            function confirmDeleteAndSubmit() {
                if (confirm("Bạn có chắc chắn muốn xóa cấu hình phí này?")) {
                    const form = document.createElement("form");
                    form.method = "post";
                    form.action = "${pageContext.request.contextPath}/delete-fee";

                    const hiddenId = document.createElement("input");
                    hiddenId.type = "hidden";
                    hiddenId.name = "id";
                    hiddenId.value = "<%= request.getAttribute("id") %>";

                    form.appendChild(hiddenId);
                    document.body.appendChild(form);
                    form.submit();
                }
            }
        </script>
    </body>
</html>
