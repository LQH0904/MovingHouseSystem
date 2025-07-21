<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="model.SystemLog"%>
<%@page import="model.DataChangeLog"%>
<%@page import="model.Users"%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>View Logs</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/viewLogs.css">  

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

            String logTypeTitle = (String) request.getAttribute("logTypeTitle");
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        %>
        <div class="container">
            <h2><%= logTypeTitle != null ? logTypeTitle : "Logs" %></h2>

            <%-- Form tìm kiếm và lọc sẽ được thêm ở đây sau --%>

            <% if (logTypeTitle != null && logTypeTitle.contains("System Activities Log")) {
                List<SystemLog> systemLogs = (List<SystemLog>) request.getAttribute("logs");
                if (systemLogs != null && !systemLogs.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Log ID</th>
                        <th>User</th>
                        <th>Action</th>
                        <th>Timestamp</th>
                        <th>Details</th>
                        <th></th> <%-- Cột cho nút Action --%>
                    </tr>
                </thead>
                <tbody>
                    <% for (SystemLog log : systemLogs) { %>
                    <tr>
                        <td><%= log.getLogId() %></td>
                        <td><%= (log.getUsername() != null && !log.getUsername().isEmpty()) ? log.getUsername() : "N/A (ID: " + log.getUserId() + ")" %></td>
                        <td><%= log.getAction() %></td>
                        <td><%= sdf.format(log.getTimestamp()) %></td>
                        <td><%= log.getDetails() != null ? log.getDetails() : "" %></td>
                        <td><a href="LogViewerServlet?action=viewDetail&type=system&logId=<%= log.getLogId() %>" class="detail-button">View Details</a></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="text-align: center;">No system activities logged yet.</p>
            <% }
        } else if (logTypeTitle != null && logTypeTitle.contains("Data Change Audit Log")) {
            List<DataChangeLog> dataChangeLogs = (List<DataChangeLog>) request.getAttribute("logs");
            if (dataChangeLogs != null && !dataChangeLogs.isEmpty()) { %>
            <table>
                <thead>
                    <tr>
                        <th>Change ID</th>
                        <th>Table</th>
                        <th>Record ID</th>
                        <th>Column</th>
                        <th>Old Value</th>
                        <th>New Value</th>
                        <th>Changed By</th>
                        <th>Timestamp</th>
                        <th>Type</th>
                        <th></th> <%-- Cột cho nút Action --%>
                    </tr>
                </thead>
                <tbody>
                    <% for (DataChangeLog log : dataChangeLogs) { %>
                    <tr>
                        <td><%= log.getChangeId() %></td>
                        <td><%= log.getTableName() %></td>
                        <td><%= log.getRecordId() %></td>
                        <td><%= log.getColumnName() != null ? log.getColumnName() : "N/A (Full Record)" %></td>
                        <td><pre><%= log.getOldValue() != null ? log.getOldValue() : "NULL" %></pre></td>
                        <td><pre><%= log.getNewValue() != null ? log.getNewValue() : "NULL" %></pre></td>
                        <td><%= (log.getChangedByUsername() != null && !log.getChangedByUsername().isEmpty()) ? log.getChangedByUsername() : "N/A (ID: " + log.getChangedByUserId() + ")" %></td>
                        <td><%= sdf.format(log.getChangeTimestamp()) %></td>
                        <td><%= log.getChangeType() %></td>
                        <td><a href="LogViewerServlet?action=viewDetail&type=data_change&logId=<%= log.getChangeId() %>" class="detail-button">View Details</a></td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <% } else { %>
            <p style="text-align: center;">No data changes logged yet.</p>
            <% }
        } %>

            <p style="text-align: center;"><a href="page/admin/dashboard.jsp" class="back-button">Back to Dashboard</a></p>
        </div>

        <div class="filter-section" style="margin-bottom: 30px; padding: 20px; background-color: #f9f9f9; border-radius: 8px; border: 1px solid #e0e0e0;">
            <h3>Filter Logs</h3>
            <form action="LogViewerServlet" method="get">
                <input type="hidden" name="type" value="<%= type %>"> <%-- Giữ loại log hiện tại --%>
                <input type="hidden" name="action" value="filter"> <%-- Thêm action filter --%>

                <div style="display: flex; flex-wrap: wrap; gap: 15px; margin-bottom: 20px;">
                    <div style="flex: 1; min-width: 200px;">
                        <label for="usernameFilter" style="display: block; margin-bottom: 5px;">Username:</label>
                        <input type="text" id="usernameFilter" name="username" class="form-control" placeholder="Enter username" value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="actionFilter" style="display: block; margin-bottom: 5px;">Action:</label>
                        <input type="text" id="actionFilter" name="actionType" class="form-control" placeholder="Enter action type" value="<%= request.getParameter("actionType") != null ? request.getParameter("actionType") : "" %>">
                    </div>
                    <% if (logTypeTitle != null && logTypeTitle.contains("System Activities Log")) { %>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="detailsFilter" style="display: block; margin-bottom: 5px;">Details Keyword:</label>
                        <input type="text" id="detailsFilter" name="detailsKeyword" class="form-control" placeholder="Search in details" value="<%= request.getParameter("detailsKeyword") != null ? request.getParameter("detailsKeyword") : "" %>">
                    </div>
                    <% } else if (logTypeTitle != null && logTypeTitle.contains("Data Change Audit Log")) { %>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="tableNameFilter" style="display: block; margin-bottom: 5px;">Table Name:</label>
                        <input type="text" id="tableNameFilter" name="tableName" class="form-control" placeholder="Enter table name" value="<%= request.getParameter("tableName") != null ? request.getParameter("tableName") : "" %>">
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="changeTypeFilter" style="display: block; margin-bottom: 5px;">Change Type:</label>
                        <select id="changeTypeFilter" name="changeType" class="form-control">
                            <option value="">All</option>
                            <option value="INSERT" <%= "INSERT".equals(request.getParameter("changeType")) ? "selected" : "" %>>INSERT</option>
                            <option value="UPDATE" <%= "UPDATE".equals(request.getParameter("changeType")) ? "selected" : "" %>>UPDATE</option>
                            <option value="DELETE" <%= "DELETE".equals(request.getParameter("changeType")) ? "selected" : "" %>>DELETE</option>
                        </select>
                    </div>
                    <% } %>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="startDateFilter" style="display: block; margin-bottom: 5px;">Start Date:</label>
                        <input type="date" id="startDateFilter" name="startDate" class="form-control" value="<%= request.getParameter("startDate") != null ? request.getParameter("startDate") : "" %>">
                    </div>
                    <div style="flex: 1; min-width: 200px;">
                        <label for="endDateFilter" style="display: block; margin-bottom: 5px;">End Date:</label>
                        <input type="date" id="endDateFilter" name="endDate" class="form-control" value="<%= request.getParameter("endDate") != null ? request.getParameter("endDate") : "" %>">
                    </div>
                </div>
                <button type="submit" class="btn-primary" style="width: auto; padding: 10px 25px;">Apply Filter</button>
                <a href="LogViewerServlet?type=<%= type %>" class="btn-secondary" style="margin-left: 10px; text-decoration: none; padding: 10px 25px; background-color: #6c757d; color: white; border-radius: 4px;">Clear Filter</a>
            </form>
        </div>
    </body>
</html>