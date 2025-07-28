<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*, model.UserSessionInfo, listener.SessionTracker" %>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Session Logs</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <style>
        .user-sessions-dashboard {
            padding: 24px;
            background: linear-gradient(135deg, #f8fafc 0%, #f1f5f9 100%);
            min-height: 100vh;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        }

        .dashboard-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            background: white;
            padding: 20px 24px;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
        }

        .dashboard-title {
            margin: 0;
            color: #1e293b;
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .dashboard-title-icon {
            width: 32px;
            height: 32px;
            background: linear-gradient(135deg, #4f46e5, #7c3aed);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .dashboard-actions {
            display: flex;
            gap: 12px;
        }

        .action-button {
            padding: 8px 16px;
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            color: #475569;
            cursor: pointer;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .action-button:hover {
            border-color: #cbd5e1;
            background: #f8fafc;
        }

        .action-button.primary {
            background: #4f46e5;
            color: white;
            border-color: #4f46e5;
        }

        .action-button.primary:hover {
            background: #4338ca;
        }

        .sessions-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            overflow: hidden;
        }

        .card-header {
            padding: 16px 24px;
            border-bottom: 1px solid #f1f5f9;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .card-title {
            margin: 0;
            font-size: 18px;
            font-weight: 600;
            color: #1e293b;
        }

        .card-actions {
            display: flex;
            gap: 8px;
        }

        .search-input {
            padding: 8px 12px;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            font-size: 14px;
            width: 240px;
            outline: none;
            transition: border-color 0.2s;
        }

        .search-input:focus {
            border-color: #4f46e5;
            box-shadow: 0 0 0 2px rgba(79, 70, 229, 0.1);
        }

        .sessions-table {
            width: 100%;
            border-collapse: collapse;
        }

        .sessions-table th {
            text-align: left;
            padding: 12px 24px;
            font-size: 14px;
            font-weight: 600;
            color: #64748b;
            background: #f8fafc;
            border-bottom: 1px solid #e2e8f0;
            position: relative;
            cursor: pointer;
            user-select: none;
        }

        .sessions-table th:hover {
            background: #f1f5f9;
        }

        .sessions-table th::after {
            content: '↕';
            position: absolute;
            right: 8px;
            opacity: 0.3;
        }

        .sessions-table th.sort-asc::after {
            content: '↑';
            opacity: 1;
        }

        .sessions-table th.sort-desc::after {
            content: '↓';
            opacity: 1;
        }

        .sessions-table td {
            padding: 16px 24px;
            font-size: 14px;
            color: #334155;
            border-bottom: 1px solid #f1f5f9;
        }

        .sessions-table tr:last-child td {
            border-bottom: none;
        }

        .sessions-table tr:hover td {
            background: #f8fafc;
        }

        .username-cell {
            font-weight: 500;
            color: #1e293b;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            background: #e2e8f0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #64748b;
            font-size: 14px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        .status-badge.active {
            background: #dcfce7;
            color: #166534;
        }

        .status-badge.inactive {
            background: #f1f5f9;
            color: #64748b;
        }

        .status-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .status-dot.active {
            background: #22c55e;
            animation: pulse 2s infinite;
        }

        .status-dot.inactive {
            background: #94a3b8;
        }

        .timestamp {
            color: #64748b;
            font-size: 13px;
        }

        .empty-state {
            padding: 48px 24px;
            text-align: center;
            color: #64748b;
        }

        .empty-icon {
            width: 64px;
            height: 64px;
            margin: 0 auto 16px;
            background: #f1f5f9;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .empty-title {
            font-size: 18px;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .pagination {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 24px;
            border-top: 1px solid #f1f5f9;
        }

        .page-info {
            font-size: 14px;
            color: #64748b;
        }

        .page-controls {
            display: flex;
            gap: 8px;
        }

        .page-button {
            width: 32px;
            height: 32px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            background: white;
            color: #64748b;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s;
        }

        .page-button:hover {
            border-color: #cbd5e1;
            background: #f8fafc;
        }

        .page-button.active {
            background: #4f46e5;
            color: white;
            border-color: #4f46e5;
        }

        .page-button.disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        @media (max-width: 768px) {
            .dashboard-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 16px;
            }

            .dashboard-actions {
                width: 100%;
                justify-content: flex-end;
            }

            .card-header {
                flex-direction: column;
                gap: 12px;
                align-items: flex-start;
            }

            .search-input {
                width: 100%;
            }

            .sessions-table {
                display: block;
                overflow-x: auto;
            }

            .sessions-table th, 
            .sessions-table td {
                padding: 12px 16px;
            }

            .pagination {
                flex-direction: column;
                gap: 12px;
                align-items: flex-start;
            }
        }
    </style>
</head>
<body>
    <div class="parent">
        <div class="div1"><jsp:include page="/Layout/admin/SideBar_Admin.jsp"></jsp:include></div>
        <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"></jsp:include></div>
        <div class="div3">
            <div class="user-sessions-dashboard">
                <div class="dashboard-header">
                    <h1 class="dashboard-title">
                        <div class="dashboard-title-icon">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path>
                                <circle cx="9" cy="7" r="4"></circle>
                                <path d="M23 21v-2a4 4 0 0 0-3-3.87"></path>
                                <path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                            </svg>
                        </div>
                        Lịch sử đăng nhập người dùng
                    </h1>
                    <div class="dashboard-actions">
                        
                        <button class="action-button primary">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <polyline points="23 4 23 10 17 10"></polyline>
                                <polyline points="1 20 1 14 7 14"></polyline>
                                <path d="M3.51 9a9 9 0 0 1 14.85-3.36L23 10M1 14l4.64 4.36A9 9 0 0 0 20.49 15"></path>
                            </svg>
                            Làm mới
                        </button>
                    </div>
                </div>

                <div class="sessions-card">
                    <div class="card-header">
                        <h2 class="card-title">Danh sách phiên đăng nhập</h2>
                        <div class="card-actions">
                            <input type="text" class="search-input" placeholder="Tìm kiếm theo tên người dùng..." id="searchInput">
                        </div>
                    </div>

                    <c:if test="${empty sessionScope.sessionLogs && SessionTracker.sessionLogs.size() == 0}">
                        <div class="empty-state">
                            <div class="empty-icon">
                                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                    <circle cx="12" cy="12" r="10"></circle>
                                    <line x1="12" y1="8" x2="12" y2="12"></line>
                                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                                </svg>
                            </div>
                            <h3 class="empty-title">Chưa có dữ liệu</h3>
                            <p>Chưa có phiên đăng nhập nào được ghi lại trong hệ thống.</p>
                        </div>
                    </c:if>

                    <c:if test="${not empty sessionScope.sessionLogs || SessionTracker.sessionLogs.size() > 0}">
                        <div style="overflow-x: auto;">
                            <table class="sessions-table" id="sessionsTable">
                                <thead>
                                    <tr>
                                        <th class="sort-asc" data-sort="username">Tên người dùng</th>
                                        <th data-sort="login">Thời gian đăng nhập</th>
                                        <th data-sort="logout">Thời gian đăng xuất</th>
                                        <th data-sort="status">Trạng thái</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                    for (UserSessionInfo info : SessionTracker.sessionLogs) {
                                        boolean isActive = info.getLogoutTime() == null;
                                        String firstLetter = info.getUsername().substring(0, 1).toUpperCase();
                                    %>
                                    <tr>
                                        <td>
                                            <div class="username-cell">
                                                <div class="user-avatar"><%= firstLetter %></div>
                                                <span><%= info.getUsername() %></span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="timestamp"><%= info.getLoginTime() %></span>
                                        </td>
                                        <td>
                                            <span class="timestamp"><%= info.getLogoutTime() != null ? info.getLogoutTime() : "—" %></span>
                                        </td>
                                        <td>
                                            <% if (isActive) { %>
                                                <div class="status-badge active">
                                                    <div class="status-dot active"></div>
                                                    <span>Đang hoạt động</span>
                                                </div>
                                            <% } else { %>
                                                <div class="status-badge inactive">
                                                    <div class="status-dot inactive"></div>
                                                    <span>Đã đăng xuất</span>
                                                </div>
                                            <% } %>
                                        </td>
                                    </tr>
                                    <% } %>
                                </tbody>
                            </table>
                        </div>

                        <div class="pagination">
                            <div class="page-info">Hiển thị <span id="startRange">1</span>-<span id="endRange"><%= Math.min(10, SessionTracker.sessionLogs.size()) %></span> của <span id="totalItems"><%= SessionTracker.sessionLogs.size() %></span> kết quả</div>
                            <div class="page-controls">
                                <button class="page-button disabled" id="prevPage">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="15 18 9 12 15 6"></polyline>
                                    </svg>
                                </button>
                                <button class="page-button active">1</button>
                                <button class="page-button" id="nextPage">
                                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                        <polyline points="9 18 15 12 9 6"></polyline>
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Sorting functionality
            const table = document.getElementById('sessionsTable');
            if (table) {
                const headers = table.querySelectorAll('th');
                const tableBody = table.querySelector('tbody');
                const rows = tableBody.querySelectorAll('tr');

                // Sort direction: asc or desc
                const directions = Array.from(headers).map(function() {
                    return '';
                });

                // Transform the content of given cell in given column
                const transform = function(index, content) {
                    // Get the data type of column
                    const type = headers[index].getAttribute('data-type');
                    switch (type) {
                        case 'number':
                            return parseFloat(content);
                        case 'date':
                            return new Date(content);
                        default:
                            return content;
                    }
                };

                const sortColumn = function(index) {
                    // Get the current direction
                    const direction = directions[index] || 'asc';
                    
                    // A factor based on the direction
                    const multiplier = (direction === 'asc') ? 1 : -1;

                    const newRows = Array.from(rows);

                    newRows.sort(function(rowA, rowB) {
                        const cellA = rowA.querySelectorAll('td')[index].textContent.trim();
                        const cellB = rowB.querySelectorAll('td')[index].textContent.trim();

                        const a = transform(index, cellA);
                        const b = transform(index, cellB);

                        if (a < b) {
                            return -1 * multiplier;
                        }
                        if (a > b) {
                            return 1 * multiplier;
                        }
                        return 0;
                    });

                    // Remove old rows
                    [].forEach.call(rows, function(row) {
                        tableBody.removeChild(row);
                    });

                    // Reverse the direction
                    directions[index] = direction === 'asc' ? 'desc' : 'asc';

                    // Update header classes
                    headers.forEach(header => {
                        header.classList.remove('sort-asc', 'sort-desc');
                    });
                    
                    headers[index].classList.add(directions[index] === 'asc' ? 'sort-asc' : 'sort-desc');

                    // Append new row
                    newRows.forEach(function(newRow) {
                        tableBody.appendChild(newRow);
                    });
                };

                [].forEach.call(headers, function(header, index) {
                    header.addEventListener('click', function() {
                        sortColumn(index);
                    });
                });
            }

            // Search functionality
            const searchInput = document.getElementById('searchInput');
            if (searchInput) {
                searchInput.addEventListener('input', function() {
                    const searchTerm = this.value.toLowerCase();
                    const rows = document.querySelectorAll('#sessionsTable tbody tr');
                    
                    rows.forEach(row => {
                        const username = row.querySelector('.username-cell span').textContent.toLowerCase();
                        if (username.includes(searchTerm)) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    });
                });
            }

            // Refresh button functionality
            const refreshButton = document.querySelector('.action-button.primary');
            if (refreshButton) {
                refreshButton.addEventListener('click', function() {
                    location.reload();
                });
            }
        });
    </script>
</body>
</html>

