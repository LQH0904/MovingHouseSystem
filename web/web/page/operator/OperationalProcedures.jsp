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
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp" /></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp" /></div>

            <div class="div3">
                <h2 class="section-title">Quy trình vận hành</h2>

                <div class="action-buttons">
                    <a href="add-procedure" class="add-btn">Thêm Quy trình</a>

                    <form action="export-procedures-to-excel" method="post" style="display:inline;">
                        <button type="submit" class="excel-btn">Tải Excel</button>
                    </form>

                </div>

                <table class="center-table" border="1">
                    <tr>
                        <th class="center-text">STT</th>
                        <th>Tiêu đề</th>
                        <th>Mô tả</th>
                        <th class="center-text">Hành động</th>
                    </tr>
                    <%
                        List<OperationProcedure> procedureList = (List<OperationProcedure>) request.getAttribute("procedures");
                        if (procedureList != null && !procedureList.isEmpty()) {
                            for (OperationProcedure procedure : procedureList) {
                    %>
                    <tr>
                        <td class="center-text"><%= procedure.getStepNumber() %></td>
                        <td><%= procedure.getStepTitle() %></td>
                        <td><pre class="description-text"><%= procedure.getStepDescription() %></pre></td>
                        <td class="action-cell">
                            <a href="#" class="edit-btn">Sửa</a>
                        </td>

                        </td>

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
