<%@page import="java.util.List"%>
<%@page import="model.OperationPolicy"%>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chính sách vận hành</title>
</head>
<body>
    <h2>Chính sách vận hành</h2>
    <table border="1" cellpadding="8" cellspacing="0">
        <tr>
            <th>STT</th>
            <th>Tiêu đề</th>
            <th>Nội dung</th>
        </tr>
        <%
            List<OperationPolicy> policyList = (List<OperationPolicy>) request.getAttribute("policies");
            if (policyList != null && !policyList.isEmpty()) {
                for (OperationPolicy policy : policyList) {
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
</body>
</html>
