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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/ProPoliFee.css">

    </head>
    <body>
    <div class="parent">
        <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"></jsp:include></div>
        <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"></jsp:include></div>

        <div class="div3">
            <h2>Quy trình vận hành</h2>

            <div class="action-buttons">
                <a href="add-procedure" class="add-btn">Thêm Quy trình</a>
                <form action="export-procedures-to-excel" method="post">
                    <button type="submit" class="excel-btn">Tải Excel</button>
                </form>
            </div>

            <table class="center-table" border="1">
                <tr>
                    <th>STT</th>
                    <th>Tiêu đề</th>
                    <th>Mô tả</th>
                    <th>Hành động</th>
                </tr>
                <%
                    List<OperationProcedure> procedureList = (List<OperationProcedure>) request.getAttribute("procedures");
                    if (procedureList != null && !procedureList.isEmpty()) {
                        for (OperationProcedure procedure : procedureList) {
                %>
                <tr>
                    <td><%= procedure.getStepNumber() %></td>
                    <td><%= procedure.getStepTitle() %></td>
                    <td><pre><%= procedure.getStepDescription() %></pre></td>
                    <td><a href="edit-procedure?id=<%= procedure.getId() %>" class="edit-link">Sửa</a></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="4">Không có dữ liệu.</td></tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>
</body>



</html>
