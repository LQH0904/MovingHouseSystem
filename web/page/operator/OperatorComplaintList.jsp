<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Danh sách Khiếu nại Chuyển cấp cao</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/Complaint.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            .updated-ids {
                font-weight: bold;
                color: #28a745; 
                margin-left: 5px;
            }
            .alert {
                padding: 10px;
                margin-bottom: 15px;
                border-radius: 5px;
            }
            .alert-success {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }
            .alert-danger {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f5c6cb;
            }
            /* CSS cho hàng được làm nổi bật */
            .highlighted-row {
                background-color: #fff3cd !important; /* Màu vàng nhạt, dùng !important để đảm bảo */
                animation: fadeOut 5s forwards; /* Hiệu ứng mờ dần trong 5 giây */
            }

            @keyframes fadeOut {
                0% { background-color: #fff3cd; } /* Bắt đầu với màu highlight */
                100% { background-color: transparent; } /* Kết thúc với màu nền trong suốt */
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include></div>
            <div class="div2"><jsp:include page="../../Layout/operator/Header.jsp"></jsp:include></div>
            <div class="div3">
                <h1>Danh sách Khiếu nại</h1>

                <c:if test="${not empty successMessage}">
                    <p class="alert alert-success">
                        ${successMessage}
                        <c:if test="${not empty updatedIssueIds}">
                            <br>ID(s) đã cập nhật: 
                            <span class="updated-ids">
                                <c:forEach var="id" items="${updatedIssueIds}" varStatus="loop">
                                    ${id}<c:if test="${!loop.last}">, </c:if>
                                </c:forEach>
                            </span>
                        </c:if>
                    </p>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <p class="alert alert-danger">${errorMessage}</p>
                </c:if>

                <form class="form-container" action="${pageContext.request.contextPath}/operatorComplaintList" method="get">
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
                            <tr id="complaint-${complaint.issueId}" 
                                <c:if test="${complaint.issueId == highlightedComplaintId}">class="highlighted-row"</c:if>>
                                <td>${complaint.issueId}</td>
                                <td>${complaint.username}</td>
                                <td>${complaint.description}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${complaint.status == 'new'}">Mới</c:when>
                                        <c:when test="${complaint.status == 'in_progress'}">Đang xử lý</c:when>
                                        <c:when test="${complaint.status == 'resolved'}">Đã giải quyết</c:when>
                                        <c:when test="${complaint.status == 'escalated'}">Đã chuyển cấp</c:when>
                                        <c:when test="${complaint.status == 'closed'}">Đã đóng</c:when>
                                        <c:otherwise>${complaint.status}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${complaint.priority == 'low'}">Thấp</c:when>
                                        <c:when test="${complaint.priority == 'medium'}">Trung bình</c:when>
                                        <c:when test="${complaint.priority == 'high'}">Cao</c:when>
                                        <c:when test="${complaint.priority == 'urgent'}">Khẩn cấp</c:when>
                                        <c:otherwise>${complaint.priority}</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${complaint.assignedToUsername != null ? complaint.assignedToUsername : 'Chưa giao'}</td>
                                <td>${complaint.createdAt}</td>
                                <td>${complaint.resolvedAt}</td>
                                <td>
                                    <a class="action-link" href="${pageContext.request.contextPath}/OperatorReplyComplaintServlet?issueId=${complaint.issueId}">Phản hồi</a>
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
                    <span class="total">Tổng số khiếu nại: ${totalComplaints}</span>

                    <c:if test="${totalPages > 1}">
                        <c:url var="baseUrl" value="/operatorComplaintList">
                            <c:if test="${searchTerm != null && !searchTerm.isEmpty()}">
                                <c:param name="searchTerm" value="${searchTerm}"/>
                            </c:if>
                            <c:if test="${priorityFilter != null && !priorityFilter.isEmpty()}">
                                <c:param name="priorityFilter" value="${priorityFilter}"/>
                            </c:if>
                        </c:url>

                        <div class="page-links">
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
                                    <c:forEach var="operator" items="${operators}">
                                        <option value="${operator.userId}">${operator.username}</option>
                                    </c:forEach>
                                </select>
                            </p>
                            <div class="modal-footer">
                                <button type="submit">Gán</button>
                                <button type="button" onclick="closeAssignModal()">Hủy</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/Header.js"></script>
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

            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }

            // JavaScript để tự động cuộn và xóa highlight
            document.addEventListener('DOMContentLoaded', function() {
                var highlightedId = '${highlightedComplaintId}';
                if (highlightedId && highlightedId !== '') {
                    var row = document.getElementById('complaint-' + highlightedId);
                    if (row) {
                        // Cuộn đến hàng được highlight
                        row.scrollIntoView({ behavior: 'smooth', block: 'center' });
                        // CSS animation sẽ tự động xử lý việc fadeOut
                    }
                }
            });
        </script>
    </body>
</html>