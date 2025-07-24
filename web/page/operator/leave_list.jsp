<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.LeaveRequest, java.util.List"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý đơn nghỉ phép</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f9f9f9; }
        h2 { margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { padding: 12px; text-align: left; background: #fff; border-bottom: 1px solid #ddd; }
        tr:hover { background-color: #f1f1f1; }
        .action a { padding: 6px 12px; background: #007bff; color: white; border-radius: 4px; text-decoration: none; }
        .action a:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h2>Danh sách đơn xin nghỉ</h2>

    <table>
        <tr>
            <th>STT</th>
            <th>Tên nhân viên</th>
            <th>Ngày bắt đầu</th>
            <th>Ngày kết thúc</th>
            <th>Lý do</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        <c:forEach var="req" items="${requestList}" varStatus="i">
            <tr>
                <td>${i.index + 1}</td>
                <td><c:out value="${req.staffName}"/></td>
                <td><c:out value="${req.startDate}"/></td>
                <td><c:out value="${req.endDate}"/></td>
                <td><c:out value="${req.reason}"/></td>
                <td><c:out value="${req.status}"/></td>
                <td class="action">
                    <a href="${pageContext.request.contextPath}/operator/leave/detail?id=${req.requestId}">Chi tiết</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</body>
</html>
