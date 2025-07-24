<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.StaffLeaveBalance, model.LeaveRequest, java.util.List"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Đơn nghỉ phép</title>
    <style>
        body { font-family: sans-serif; background: #f5f5f5; margin: 0; padding: 20px; }
        h2 { margin-bottom: 20px; }
        .balance { margin-bottom: 15px; font-weight: bold; }
        .request-card {
            background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px;
            box-shadow: 0 0 5px rgba(0,0,0,0.1);
        }
        .status-pending { color: orange; }
        .status-approved { color: green; }
        .status-rejected { color: red; }
        .new-request { margin-top: 30px; padding: 15px; background: #fff; border-radius: 8px; }
        textarea, input[type="date"] { width: 100%; padding: 8px; margin-bottom: 10px; border-radius: 4px; border: 1px solid #ccc; }
        button { padding: 10px 20px; background: #007bff; color: white; border: none; border-radius: 4px; cursor: pointer; }
        button:hover { background: #0056b3; }
    </style>
</head>
<body>
    <h2>Đơn nghỉ phép</h2>

    <div class="balance">
        Ngày phép còn lại: <c:out value="${balance.remainingDays}"/>
    </div>

    <c:forEach var="req" items="${requestList}">
        <div class="request-card">
            <div><strong>Ngày:</strong> <c:out value="${req.startDate}"/> → <c:out value="${req.endDate}"/></div>
            <div><strong>Lý do:</strong> <c:out value="${req.reason}"/></div>
            <div><strong>Trạng thái:</strong>
                <span class="status-${req.status}">
                    <c:choose>
                        <c:when test="${req.status == 'pending'}">Đang chờ</c:when>
                        <c:when test="${req.status == 'approved'}">Đã duyệt</c:when>
                        <c:otherwise>Từ chối</c:otherwise>
                    </c:choose>
                </span>
            </div>
            <c:if test="${not empty req.operatorReply}">
                <div><strong>Phản hồi:</strong> <c:out value="${req.operatorReply}"/></div>
            </c:if>
        </div>
    </c:forEach>

    <div class="new-request">
        <form method="post" action="${pageContext.request.contextPath}/staff/leave/create" onsubmit="return validateForm()">
            <h3>Tạo đơn nghỉ mới</h3>
            <label>Lý do:</label>
            <textarea name="reason" maxlength="500" required></textarea>

            <label>Ngày bắt đầu:</label>
            <input type="date" name="start_date" required>

            <label>Ngày kết thúc:</label>
            <input type="date" name="end_date" required>

            <button type="submit">Gửi đơn</button>
        </form>
    </div>

    <script>
        function validateForm() {
            const start = new Date(document.querySelector('input[name="start_date"]').value);
            const end = new Date(document.querySelector('input[name="end_date"]').value);
            if (end < start) {
                alert("Ngày kết thúc phải lớn hơn hoặc bằng ngày bắt đầu.");
                return false;
            }
            return true;
        }
    </script>
</body>
</html>
