<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.LeaveRequest, model.StaffLeaveBalance"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chi tiết đơn nghỉ phép</title>
    <style>
        body { font-family: sans-serif; padding: 20px; background: #f2f2f2; }
        .box { background: #fff; padding: 20px; border-radius: 8px; max-width: 600px; margin: auto; }
        .row { margin-bottom: 12px; }
        textarea { width: 100%; height: 80px; }
        button { padding: 8px 16px; background: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #218838; }
    </style>
</head>
<body>
    <div class="box">
        <h2>Đơn xin nghỉ: <c:out value="${request.staffName}"/></h2>

        <div class="row">Ngày bắt đầu: <c:out value="${request.startDate}"/></div>
        <div class="row">Ngày kết thúc: <c:out value="${request.endDate}"/></div>
        <div class="row">Lý do: <c:out value="${request.reason}"/></div>
        <div class="row">Số ngày phép còn lại: <c:out value="${balance.remainingDays}"/></div>

        <form method="post" action="${pageContext.request.contextPath}/operator/leave/detail">
            <input type="hidden" name="requestId" value="${request.requestId}" />
            <div class="row">
                <label>Phản hồi:</label>
                <textarea name="reply" required><c:out value="${request.operatorReply}"/></textarea>
            </div>
            <div class="row">
                <label><input type="radio" name="status" value="approved" required> Duyệt</label>
                <label><input type="radio" name="status" value="rejected"> Từ chối</label>
            </div>
            <button type="submit">Xác nhận</button>
        </form>
    </div>
</body>
</html>
