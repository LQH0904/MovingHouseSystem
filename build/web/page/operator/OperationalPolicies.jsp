<%@page import="java.util.List"%>
<%@page import="model.OperationPolicy"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head><title>Chính sách vận hành</title></head>
<body>
    <h2>Chính sách vận hành</h2>
    <table border="1" cellpadding="8">
        <tr>
            <th>Tiêu đề</th>
            <th>Nội dung</th>
        </tr>
        <%
            List<OperationPolicy> policyList = (List<OperationPolicy>) request.getAttribute("policies");
            if (policyList != null) {
                for (OperationPolicy policy : policyList) {
        %>
        <tr>
            <td><%= policy.getTitle() %></td>
            <td><%= policy.getDescription() %></td>
        </tr>
        <%
                }
            }
        %>
    </table>
</body>
</html>
