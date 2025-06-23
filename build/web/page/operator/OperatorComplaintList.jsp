<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Khiếu nại Chuyển cấp cao</title>
    <style>
        /* CSS cho modal */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
            padding-top: 60px;
        }

        .modal-content {
            background-color: #fefefe;
            margin: 5% auto; /* 15% from the top and centered */
            padding: 20px;
            border: 1px solid #888;
            width: 80%; /* Could be more or less, depending on screen size */
            max-width: 500px;
            box-shadow: 0 4px 8px 0 rgba(0,0,0,0.2), 0 6px 20px 0 rgba(0,0,0,0.19);
            -webkit-animation-name: animatetop;
            -webkit-animation-duration: 0.4s;
            animation-name: animatetop;
            animation-duration: 0.4s;
        }

        /* Add Animation */
        @-webkit-keyframes animatetop {
            from {top: -300px; opacity: 0}
            to {top: 0; opacity: 1}
        }

        @keyframes animatetop {
            from {top: -300px; opacity: 0}
            to {top: 0; opacity: 1}
        }

        /* The Close Button */
        .close-button {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close-button:hover,
        .close-button:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .pagination a {
            padding: 5px 10px;
            border: 1px solid #ddd;
            text-decoration: none;
            margin-right: 5px;
        }
        .pagination a.active {
            background-color: #007bff;
            color: white;
        }
    </style>
</head>
<body>
    <h1>Danh sách Khiếu nại Chuyển cấp cao</h1>

    <c:if test="${not empty successMessage}">
        <p style="color: green;">${successMessage}</p>
    </c:if>
    <c:if test="${not empty errorMessage}">
        <p style="color: red;">${errorMessage}</p>
    </c:if>

    <form action="${pageContext.request.contextPath}/operatorComplaintList" method="get">
        <label for="searchTerm">Tìm kiếm:</label>
        <input type="text" id="searchTerm" name="searchTerm" value="${searchTerm != null ? searchTerm : ''}">

        <label for="priorityFilter">Lọc theo Ưu tiên:</label>
        <select id="priorityFilter" name="priorityFilter">
            <option value="">Tất cả</option>
            <option value="low" ${priorityFilter == 'low' ? 'selected' : ''}>Thấp</option>
            <option value="medium" ${priorityFilter == 'medium' ? 'selected' : ''}>Trung bình</option>
            <option value="high" ${priorityFilter == 'high' ? 'selected' : ''}>Cao</option>
        </select>
        <button type="submit">Tìm kiếm và Lọc</button>
    </form>

    <table>
        <thead>
            <tr>
                <th>ID Khiếu nại</th>
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
                    <td>${complaint.status}</td>
                    <td>${complaint.priority}</td>
                    <td>${complaint.assignedToUsername != null ? complaint.assignedToUsername : 'Chưa giao'}</td>
                    <td>${complaint.createdAt}</td>
                    <td>${complaint.resolvedAt}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/OperatorReplyComplaintServlet?issueId=${complaint.issueId}">Phản hồi</a>
                        <c:if test="${complaint.assignedToUsername == null || complaint.assignedToUsername eq ''}">
                            <button onclick="openAssignModal('${complaint.issueId}')">Gán</button>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty escalatedComplaints}">
                <tr>
                    <td colspan="9">Không có khiếu nại chuyển cấp cao nào.</td>
                </tr>
            </c:if>
        </tbody>
    </table>

    <div class="pagination">
        Tổng số khiếu nại: ${totalComplaints}
        <c:if test="${totalPages > 1}">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <c:url var="pageUrl" value="/operatorComplaintList">
                    <c:param name="page" value="${i}"/>
                    <c:if test="${searchTerm != null && !searchTerm.isEmpty()}">
                        <c:param name="searchTerm" value="${searchTerm}"/>
                    </c:if>
                    <c:if test="${priorityFilter != null && !priorityFilter.isEmpty()}">
                        <c:param name="priorityFilter" value="${priorityFilter}"/>
                    </c:if>
                </c:url>
                <a href="${pageUrl}" class="${currentPage == i ? 'active' : ''}">${i}</a>
            </c:forEach>
        </c:if>
    </div>

    <div id="assignModal" class="modal">
        <div class="modal-content">
            <span class="close-button" onclick="closeAssignModal()">&times;</span>
            <h3>Gán khiếu nại cho Operator</h3>
            <form action="${pageContext.request.contextPath}/assignComplaint" method="post">
                <input type="hidden" id="modalIssueId" name="issueId">
                <p>
                    <label for="operatorSelect">Chọn Operator:</label>
                    <select id="operatorSelect" name="operatorUserId" required>
                        <c:if test="${empty operators}">
                            <option value="">Không có Operator nào</option>
                        </c:if>
                        <c:forEach var="operator" items="${operators}"> <%-- Đã đổi tên biến và thuộc tính --%>
                            <option value="${operator.userId}">${operator.username}</option>
                        </c:forEach>
                    </select>
                </p>
                <button type="submit">Gán</button>
                <button type="button" onclick="closeAssignModal()">Hủy</button>
            </form>
        </div>
    </div>

    <script>
        var modal = document.getElementById("assignModal");
        var span = document.getElementsByClassName("close-button")[0];

        function openAssignModal(issueId) {
            document.getElementById('modalIssueId').value = issueId;
            modal.style.display = "block";
        }

        function closeAssignModal() {
            modal.style.display = "none";
        }

        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
            }
        }
    </script>

</body>
</html>