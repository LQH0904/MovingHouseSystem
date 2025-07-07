<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.OperationPolicy"%>
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
                <h2 class="section-title">Chính sách vận hành</h2>

                <div class="action-buttons">
                    <a href="add-policy" class="add-btn">Thêm Chính sách</a>
                    <form method="post" action="export-policies-to-excel" style="display:inline;">
                        <button type="submit" class="excel-btn">Tải Excel</button>
                    </form>

                </div>

                <table class="center-table" border="1">
                    <tr>
                        <th class="center-text">STT</th>
                        <th>Tiêu đề</th>
                        <th>Nội dung</th>
                        <th class="center-text">Hành động</th>
                    </tr>
                    <%
                        List<OperationPolicy> policyList = (List<OperationPolicy>) request.getAttribute("policies");
                        if (policyList != null && !policyList.isEmpty()) {
                            for (OperationPolicy policy : policyList) {
                    %>
                    <tr>
                        <td class="center-text"><%= policy.getPolicyNumber() %></td>
                        <td><%= policy.getPolicyTitle() %></td>
                        <td><pre class="description-text"><%= policy.getPolicyContent() %></pre></td>
                        <td class="action-cell"><a href="edit-policy?id=<%= policy.getId() %>" class="edit-btn">Sửa</a>
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
