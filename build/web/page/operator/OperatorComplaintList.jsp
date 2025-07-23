<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách khiếu nại chuyển cấp</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
                font-family: 'Roboto', sans-serif;
            }
            body {
                background-color: #f5f7fa;
                color: #333;
                line-height: 1.6;
            }
            h1 {
                color: #2c3e50;
                margin-bottom: 25px;
                text-align: center;
                font-weight: 600;
                padding-bottom: 15px;
                border-bottom: 2px solid #3498db;
            }
            .form-container {
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                margin-bottom: 30px;
            }
            .filter-row {
                display: flex;
                flex-wrap: wrap;
                gap: 15px;
                align-items: center;
                margin-bottom: 10px;
            }
            .filter-group {
                display: flex;
                align-items: center;
                gap: 8px;
            }
            .filter-group label {
                white-space: nowrap;
                font-weight: 500;
                color: #2c3e50;
            }
            .filter-actions {
                margin-left: auto;
            }
            input[type="text"],
            input[type="date"],
            select {
                padding: 8px 12px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-size: 14px;
                transition: all 0.3s;
            }
            input[type="text"]:focus,
            input[type="date"]:focus,
            select:focus {
                border-color: #3498db;
                outline: none;
                box-shadow: 0 0 0 2px rgba(52, 152, 219, 0.2);
            }
            button {
                padding: 8px 20px;
                background-color: #3498db;
                color: white;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
                transition: background-color 0.3s, transform 0.2s;
            }
            button:hover {
                background-color: #2980b9;
                transform: translateY(-1px);
            }
            button:active {
                transform: translateY(0);
            }
            .success-message {
                background-color: #d4edda;
                color: #155724;
                padding: 12px 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                border-left: 4px solid #28a745;
            }
            .error-message {
                background-color: #f8d7da;
                color: #721c24;
                padding: 12px 15px;
                border-radius: 4px;
                margin-bottom: 20px;
                border-left: 4px solid #dc3545;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin: 20px 0;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                background-color: #fff;
            }
            th, td {
                padding: 12px 15px;
                text-align: left;
                border-bottom: 1px solid #e0e0e0;
            }
            th {
                background-color: #3498db;
                color: white;
                font-weight: 500;
                position: sticky;
                top: 0;
            }
            tr:nth-child(even) {
                background-color: #f8f9fa;
            }
            tr:hover {
                background-color: #f1f9ff;
            }
            a {
                color: #3498db;
                text-decoration: none;
                font-weight: 500;
                transition: color 0.3s;
            }
            a:hover {
                color: #2980b9;
                text-decoration: underline;
            }
            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 25px;
                gap: 5px;
            }
            .pagination a,
            .pagination span {
                padding: 8px 15px;
                border: 1px solid #ddd;
                border-radius: 4px;
                color: #3498db;
                text-decoration: none;
                transition: all 0.3s;
            }
            .pagination a:hover {
                background-color: #f1f9ff;
                border-color: #3498db;
            }
            .active-page {
                background-color: #3498db;
                color: white !important;
                border-color: #3498db !important;
            }
            .priority-low {
                color: #27ae60;
                font-weight: 500;
            }
            .priority-medium {
                color: #f39c12;
                font-weight: 500;
            }
            .priority-high {
                color: #e74c3c;
                font-weight: 500;
            }
            .priority-critical {
                color: #c0392b;
                font-weight: 600;
            }
            .status-new {
                color: #3498db;
                font-weight: 500;
            }
            .status-in_progress {
                color: #f39c12;
                font-weight: 500;
            }
            .status-resolved {
                color: #27ae60;
                font-weight: 500;
            }
            .status-escalated {
                color: #9b59b6;
                font-weight: 500;
            }
            .status-closed {
                color: #7f8c8d;
                font-weight: 500;
            }
            .total-count {
                text-align: right;
                margin-top: 15px;
                font-style: italic;
                color: #7f8c8d;
            }
            @media (max-width: 768px) {
                .filter-row {
                    flex-direction: column;
                    align-items: flex-start;
                    gap: 10px;
                }
                .filter-group {
                    width: 100%;
                }
                .filter-actions {
                    margin-left: 0;
                    width: 100%;
                }
                table {
                    display: block;
                    overflow-x: auto;
                }
                th, td {
                    white-space: nowrap;
                }
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../Layout/operator/SideBar.jsp" />
            </div>
            <div class="div2">
                <jsp:include page="../../Layout/operator/Header.jsp" />
            </div>
            <div class="div3">
                <h1>Danh sách khiếu nại chuyển cấp</h1>

                <c:if test="${not empty successMessage}">
                    <p class="success-message">${successMessage}</p>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <p class="error-message">${errorMessage}</p>
                </c:if>

                <form class="form-container" action="${pageContext.request.contextPath}/operatorComplaintList" method="get">
                    <div class="filter-row">
                        <div class="filter-group">
                            <label for="searchTerm">Từ khóa:</label>
                            <input type="text" id="searchTerm" name="searchTerm" value="${searchTerm}" placeholder="Tìm kiếm...">
                        </div>

                        <div class="filter-group">
                            <label for="priorityFilter">Mức độ ưu tiên:</label>
                            <select id="priorityFilter" name="priorityFilter">
                                <option value="all" ${priorityFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="low" ${priorityFilter == 'low' ? 'selected' : ''}>Thấp</option>
                                <option value="medium" ${priorityFilter == 'medium' ? 'selected' : ''}>Trung bình</option>
                                <option value="high" ${priorityFilter == 'high' ? 'selected' : ''}>Cao</option>
                                <option value="critical" ${priorityFilter == 'critical' ? 'selected' : ''}>Nghiêm trọng</option>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label for="assignedToFilter">Người phụ trách:</label>
                            <select id="assignedToFilter" name="assignedToFilter">
                                <option value="all" ${assignedToFilter == 'all' ? 'selected' : ''}>Tất cả</option>
                                <option value="unassigned" ${assignedToFilter == 'unassigned' ? 'selected' : ''}>Chưa giao</option>
                                <c:forEach var="operator" items="${operators}">
                                    <option value="${operator.username}" ${assignedToFilter == operator.username ? 'selected' : ''}>
                                        ${operator.username}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="filter-group">
                            <label for="fromDate">Từ ngày:</label>
                            <input type="date" id="fromDate" name="fromDate" value="${fromDate}">
                        </div>

                        <div class="filter-group">
                            <label for="toDate">Đến ngày:</label>
                            <input type="date" id="toDate" name="toDate" value="${toDate}">
                        </div>

                        <div class="filter-actions">
                            <button type="submit">Tìm KIếm</button>
                        </div>
                    </div>
                </form>

                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Người gửi</th>
                            <th>Mô tả</th>
                            <th>Trạng thái</th>
                            <th>Mức độ ưu tiên</th>
                            <th>Người phụ trách</th>
                            <th>Ngày tạo</th>
                            <th>Ngày giải quyết</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="complaint" items="${escalatedComplaints}">
                            <tr>
                                <td>${complaint.issueId}</td>
                                <td>${complaint.username}</td>
                                <td>${complaint.description}</td>
                                <td class="status-${complaint.status}">
                                    <c:choose>
                                        <c:when test="${complaint.status == 'new'}">Mới</c:when>
                                        <c:when test="${complaint.status == 'in_progress'}">Đang xử lý</c:when>
                                        <c:when test="${complaint.status == 'resolved'}">Đã giải quyết</c:when>
                                        <c:when test="${complaint.status == 'escalated'}">Đã chuyển cấp</c:when>
                                        <c:when test="${complaint.status == 'closed'}">Đã đóng</c:when>
                                        <c:otherwise>${complaint.status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="priority-${complaint.priority.toLowerCase()}">${complaint.priority}</td>
                                <td>${complaint.assignedToUsername != null ? complaint.assignedToUsername : 'Chưa giao'}</td>
                                <td>${complaint.createdAt}</td>
                                <td>${complaint.resolvedAt}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/OperatorDetailServlet?issueId=${complaint.issueId}">
                                        Phản hồi
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty escalatedComplaints}">
                            <tr><td colspan="9" style="text-align: center;">Không có dữ liệu.</td></tr>
                        </c:if>
                    </tbody>
                </table>

                <p class="total-count">Tổng số: ${totalComplaints}</p>

                <c:if test="${totalComplaints > 0}">
                    <div class="pagination">
                        <c:url var="baseUrl" value="/operatorComplaintList">
                            <c:if test="${searchTerm != null && !searchTerm.isEmpty()}">
                                <c:param name="searchTerm" value="${searchTerm}"/>
                            </c:if>
                            <c:if test="${priorityFilter != null && priorityFilter != 'all'}">
                                <c:param name="priorityFilter" value="${priorityFilter}"/>
                            </c:if>
                            <c:if test="${assignedToFilter != null && assignedToFilter != 'all'}">
                                <c:param name="assignedToFilter" value="${assignedToFilter}"/>
                            </c:if>
                            <c:if test="${fromDate != null && !fromDate.isEmpty()}">
                                <c:param name="fromDate" value="${fromDate}"/>
                            </c:if>
                            <c:if test="${toDate != null && !toDate.isEmpty()}">
                                <c:param name="toDate" value="${toDate}"/>
                            </c:if>
                        </c:url>

                        <c:if test="${currentPage > 1}">
                            <a href="${baseUrl}&page=${currentPage - 1}">&laquo; Trước</a>
                        </c:if>

                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <c:choose>
                                <c:when test="${i == currentPage}">
                                    <span class="active-page">${i}</span>
                                </c:when>
                                <c:otherwise>
                                    <a href="${baseUrl}&page=${i}">${i}</a>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>

                        <c:if test="${currentPage < totalPages}">
                            <a href="${baseUrl}&page=${currentPage + 1}">Sau &raquo;</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>
