<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.FeeConfiguration"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Cấu hình phí</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/ProPoliFee.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/UserList.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp" /></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp" /></div>
            <div class="div3">
                <h2 class="section-title">Cấu hình phí</h2>

                <div class="action-buttons">
                    <a href="add-fee" class="add-btn">Thêm Cấu hình phí</a>

                    <form method="post" action="export-fees-to-excel" style="display:inline;">
                        <button type="submit" class="excel-btn">Tải Excel</button>
                    </form>
                </div>

                <table class="center-table" border="1">
                    <tr>
                        <th class="center-text">STT</th>
                        <th>Loại phí</th>
                        <th>Mô tả</th>
                        <th class="center-text">Hành động</th>
                    </tr>
                    <%
                        List<FeeConfiguration> feeList = (List<FeeConfiguration>) request.getAttribute("feeConfigs");
                        if (feeList != null && !feeList.isEmpty()) {
                            for (FeeConfiguration fee : feeList) {
                    %>
                    <tr>
                        <td class="center-text"><%= fee.getFeeNumber() %></td>
                        <td><%= fee.getFeeType() %></td>
                        <td><pre class="description-text"><%= fee.getDescription() %></pre></td>
                        <td class="action-cell">
                            <a href="edit-fee?id=<%= fee.getId() %>" class="edit-btn">Sửa</a>
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
