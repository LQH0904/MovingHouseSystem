<%@page import="model.FeeConfiguration"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Cấu hình phí</title></head>
<body>
    <h2>Cấu hình phí</h2>
    <%
        FeeConfiguration config = (FeeConfiguration) request.getAttribute("feeConfig");
        if (config != null) {
    %>
    <form method="post" action="config-fee-update">
        <textarea name="content" rows="20" cols="100" readonly><%= config.getContent() %></textarea><br><br>
        <button type="button" onclick="enableEdit()">Sửa</button>
        <button type="submit" id="saveBtn" style="display:none;">Lưu</button>
    </form>
    <script>
        function enableEdit() {
            document.querySelector('textarea').removeAttribute('readonly');
            document.getElementById('saveBtn').style.display = 'inline';
        }
    </script>
    <%
        } else {
            out.print("Không có dữ liệu cấu hình phí.");
        }
    %>
</body>
</html>
