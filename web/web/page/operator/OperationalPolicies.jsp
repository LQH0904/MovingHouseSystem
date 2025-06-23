<%@page import="java.util.List"%>
<%@page import="model.OperationPolicy"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
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
            <h2 class="propoli-title">Chính sách vận hành</h2>
            <table class="propoli-table">
                <tr>
                    <th>STT</th>
                    <th>Tiêu đề</th>
                    <th>Nội dung</th>
                </tr>
                <%
                    List<model.OperationPolicy> policyList = (List<model.OperationPolicy>) request.getAttribute("policies");
                    if (policyList != null && !policyList.isEmpty()) {
                        for (model.OperationPolicy policy : policyList) {
                %>
                <tr>
                    <td><%= policy.getPolicyNumber() %></td>
                    <td><%= policy.getPolicyTitle() %></td>
                    <td><pre><%= policy.getPolicyContent() %></pre></td>
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
