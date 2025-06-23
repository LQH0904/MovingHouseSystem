<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.OperationProcedure"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/CRUDProcedure.css">
</head>
<body>
<div class="parent">
    <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp" /></div>
    <div class="div2"><jsp:include page="/Layout/operator/Header.jsp" /></div>
    <div class="div3">
        <div class="form-container add-form">
            <h2 class="add-title">Chỉnh sửa Quy trình</h2>
            <form action="edit-procedure" method="post">
                <input type="hidden" name="id" value="<%= request.getAttribute("id") %>">

                <label for="stepTitle">Tiêu đề:</label>
                <input type="text" id="stepTitle" name="stepTitle" required value="<%= request.getAttribute("stepTitle") %>">

                <label>Nội dung mô tả:</label>
                <div id="descriptionContainer">
                    <%
                        String content = (String) request.getAttribute("stepDescription");
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
                    <button type="button" class="delete-btn" onclick="confirmDeleteAndSubmit()">Xóa quy trình này</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function addDescriptionField() {
        const container = document.getElementById("descriptionContainer");
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
        const container = document.getElementById("descriptionContainer");
        if (container.childElementCount > 1) {
            button.parentNode.remove();
        } else {
            alert("Phải có ít nhất 1 dòng nội dung.");
        }
    }

    function confirmDeleteAndSubmit() {
        if (confirm("Bạn có chắc chắn muốn xóa quy trình này?")) {
            const form = document.createElement("form");
            form.method = "post";
            form.action = "delete-procedure";

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
