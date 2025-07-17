<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.SystemLog"%>
<%@page import="model.DataChangeLog"%>
<%@page import="model.Users"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
       <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Log Detail</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/logDetail.css">  
    </head>
    <body>
        <%
             String type = (String) request.getAttribute("type");
            Users loggedInUser = (Users) session.getAttribute("acc");
            // Ensure only logged-in admins can view logs
                if (loggedInUser == null || loggedInUser.getRoleId() != 1) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String logType = (String) request.getAttribute("logType"); // "system" or "data_change"
        %>

        <div class="container">
            <h2>Chi tiết Log</h2>

            <% if ("system".equals(logType)) {
                SystemLog log = (SystemLog) request.getAttribute("logDetail");
                if (log != null) { %>
            <div class="log-detail-item">
                <div class="log-detail-label">Log ID:</div>
                <div class="log-detail-value"><%= log.getLogId() %></div>
            </div>
            <div class="log-detail-item">
                <div class="log-detail-label">User:</div>
                <div class="log-detail-value"><%= (log.getUsername() != null && !log.getUsername().isEmpty()) ? log.getUsername() : "N/A (ID: " + log.getUserId() + ")" %></div>
            </div>
            <div class="log-detail-item">
                <div class="log-detail-label">Action:</div>
                <div class="log-detail-value"><%= log.getAction() %></div>
            </div>
            <div class="log-detail-item">
                <div class="log-detail-label">Timestamp:</div>
                <div class="log-detail-value"><%= sdf.format(log.getTimestamp()) %></div>
            </div>
            <div class="log-detail-item">
                <div class="log-detail-label">Details:</div>
                <div class="log-detail-value"><pre><%= log.getDetails() != null ? log.getDetails() : "" %></pre></div>
                </div>
            <% } else { %>
                <p style="text-align: center;">Không tìm thấy log hệ thống.</p>
            <% }
        } else if ("data_change".equals(logType)) {
            DataChangeLog log = (DataChangeLog) request.getAttribute("logDetail");
            if (log != null) { %>
                <div class="log-detail-item">
                    <div class="log-detail-label">Change ID:</div>
                    <div class="log-detail-value"><%= log.getChangeId() %></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Table:</div>
                    <div class="log-detail-value"><%= log.getTableName() %></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Record ID:</div>
                    <div class="log-detail-value"><%= log.getRecordId() %></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Column:</div>
                    <div class="log-detail-value"><%= log.getColumnName() != null ? log.getColumnName() : "N/A (Full Record)" %></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Old Value:</div>
                    <div class="log-detail-value"><pre><%= log.getOldValue() != null ? log.getOldValue() : "NULL" %></pre></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">New Value:</div>
                    <div class="log-detail-value"><pre><%= log.getNewValue() != null ? log.getNewValue() : "NULL" %></pre></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Changed By:</div>
                    <div class="log-detail-value"><%= (log.getChangedByUsername() != null && !log.getChangedByUsername().isEmpty()) ? log.getChangedByUsername() : "N/A (ID: " + log.getChangedByUserId() + ")" %></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Timestamp:</div>
                    <div class="log-detail-value"><%= sdf.format(log.getChangeTimestamp()) %></div>
                </div>
                <div class="log-detail-item">
                    <div class="log-detail-label">Type:</div>
                    <div class="log-detail-value"><%= log.getChangeType() %></div>
                </div>
            <% } else { %>
                <p style="text-align: center;">Không tìm thấy log thay đổi dữ liệu.</p>
            <% }
        } else { %>
            <p style="text-align: center;">Loại log không hợp lệ hoặc không được chỉ định.</p>
            <% } %>

        <div class="centered-link">
            <a href="LogViewerServlet?type=<%= logType %>" class="back-button">Back to Log List</a>
        </div>
    </div>
</body>
</html>