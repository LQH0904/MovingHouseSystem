<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="model.OperationProcedure"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quy trình vận hành</title>
</head>
<body>
    <h2>Quy trình vận hành</h2>
    <table border="1">
        <tr>
            <th>Bước</th>
            <th>Tiêu đề</th>
            <th>Mô tả</th>
        </tr>
        <%
            List<OperationProcedure> procedureList = (List<OperationProcedure>) request.getAttribute("procedures");
            if (procedureList != null && !procedureList.isEmpty()) {
                for (OperationProcedure procedure : procedureList) {
        %>
        <tr>
            <td><%= procedure.getStepNumber() %></td>
            <td><%= procedure.getStepTitle() %></td>
            <td><%= procedure.getStepDescription() %></td>
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
