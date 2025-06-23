<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.FeeConfiguration"%>
<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
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
            <h2 class="propoli-title">Cấu hình phí</h2>
            <table class="propoli-table">
                <tr>
                    <th>STT</th>
                    <th>Loại phí</th>
                    <th>Mô tả</th>
                </tr>
                <%
                    List<model.FeeConfiguration> feeList = (List<model.FeeConfiguration>) request.getAttribute("feeConfigs");
                    if (feeList != null && !feeList.isEmpty()) {
                        for (model.FeeConfiguration fee : feeList) {
                %>
                <tr>
                    <td><%= fee.getFeeNumber() %></td>
                    <td><%= fee.getFeeType() %></td>
                    <td><pre><%= fee.getDescription() %></pre></td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr><td colspan="3">Không có dữ liệu.</td></tr>
                <%
                    }
                %>
            </table>
        </div>
    </div>
</body>

</html>
