<%-- /page/staff/ChatbotLogList.jsp --%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Câu hỏi của Khách hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/CustomerList.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/faq.css">
    <style>
        .editable-response textarea { width: 100%; height: 100px; border: 2px solid #409eff; outline: none; padding: 8px; box-sizing: border-box; font-family: inherit; font-size: inherit; resize: vertical; }
        .status-pill { padding: 4px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; text-align: center; display: inline-block; }
        .status-answered { color: #1a936f; background-color: rgba(45, 206, 137, 0.15); }
        .status-unanswered { color: #f56c6c; background-color: rgba(245, 108, 108, 0.15); }
        .action-button { padding: 6px 14px; font-size: 13px; font-weight: 500; border-radius: 5px; border: none; color: white; cursor: pointer; transition: background-color 0.2s; }
        .edit-btn { background-color: #007bff; }
        .save-btn { background-color: #28a745; }
        .pagination-container { display: inline-flex; justify-content: center; align-items: center; }
        .pagination-container a.page-link { display: inline-block; padding: 8px 14px; margin: 0 4px; border: 1px solid #dcdfe6; border-radius: 6px; background-color: #fff; color: #606266; text-decoration: none; transition: all 0.2s; font-size: 14px; }
        .pagination-container a.page-link:hover { color: #409eff; border-color: #409eff; }
        .pagination-container a.page-link.active { background-color: #409eff; color: white; border-color: #409eff; font-weight: 600; }
    .div3 {
        padding: 30px;
        background-color: #f9f9fb;
        font-family: "Segoe UI", sans-serif;
        color: #333;
    }

    .div3 .user-list-title {
        font-size: 24px;
        font-weight: 600;
        margin-bottom: 24px;
        color: #2c3e50;
    }

    .div3 .user-list-table {
        width: 100%;
        border-collapse: collapse;
        border-spacing: 0;
        background-color: #fff;
        border-radius: 10px;
        overflow: hidden;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
    }

    .div3 .user-list-table th, 
    .div3 .user-list-table td {
        padding: 14px 16px;
        text-align: left;
        font-size: 14px;
        vertical-align: top;
    }

    .div3 .user-list-table th {
        background-color: #f1f3f9;
        font-weight: 600;
        color: #555;
        border-bottom: 1px solid #e0e0e0;
    }

    .div3 .user-list-table tr:not(:last-child) td {
        border-bottom: 1px solid #f0f0f0;
    }

    .div3 .status-pill {
        display: inline-block;
        padding: 6px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: 500;
        text-align: center;
        white-space: nowrap;
    }

    .div3 .status-answered {
        background-color: rgba(45, 206, 137, 0.15);
        color: #1a936f;
    }

    .div3 .status-unanswered {
        background-color: rgba(245, 108, 108, 0.15);
        color: #f56c6c;
    }

    .div3 .action-button {
        padding: 6px 14px;
        font-size: 13px;
        font-weight: 500;
        border-radius: 6px;
        border: none;
        color: white;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    .div3 .edit-btn {
        background-color: #3498db;
    }

    .div3 .edit-btn:hover {
        background-color: #2980b9;
    }

    .div3 .save-btn {
        background-color: #27ae60;
    }

    .div3 .save-btn:hover {
        background-color: #1e8449;
    }

    .div3 .editable-textarea {
        width: 100%;
        height: 100px;
        padding: 10px;
        border: 1.5px solid #3498db;
        border-radius: 6px;
        resize: vertical;
        font-family: inherit;
        font-size: 14px;
        box-sizing: border-box;
    }

    .div3 .pagination-container {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-top: 24px;
        gap: 4px;
        flex-wrap: wrap;
    }

    .div3 .pagination-container a.page-link {
        padding: 8px 14px;
        border: 1px solid #dcdfe6;
        border-radius: 6px;
        background-color: #fff;
        color: #606266;
        text-decoration: none;
        font-size: 14px;
        transition: all 0.2s ease;
    }

    .div3 .pagination-container a.page-link:hover {
        color: #409eff;
        border-color: #409eff;
    }

    .div3 .pagination-container a.page-link.active {
        background-color: #409eff;
        color: white;
        border-color: #409eff;
        font-weight: 600;
    }

    .div3 span.pagination-info {
        display: block;
        margin-bottom: 10px;
        color: #606266;
        font-size: 14px;
        text-align: center;
    }
    </style>
    <script>
    function toggleEdit(button, logId) {
        const responseCell = document.getElementById('response-cell-' + logId);
        const statusCell = document.getElementById('status-cell-' + logId);

        if (!responseCell || !statusCell) {
            console.error('Không tìm thấy ô tương ứng cho logId: ' + logId);
            return;
        }

        const isEditing = button.innerText === 'Lưu';

        if (isEditing) {
            const textarea = responseCell.querySelector('textarea');
            const newText = textarea.value;
            const originalText = button.dataset.originalText;

            fetch('${pageContext.request.contextPath}/staff/update-chatbot-response', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8' },

                body: 'logId=' + logId + '&response=' + encodeURIComponent(newText)
            })
            .then(response => {
                if (!response.ok) { throw new Error('Network response was not ok. Status: ' + response.status); }
                return response.json();
            })
            .then(data => {
                if (data.status === 'success') {
                    responseCell.innerHTML = newText;
                    if (newText.trim() !== '') {
                        statusCell.innerHTML = '<span class="status-pill status-answered">Đã trả lời</span>';
                    } else {
                        statusCell.innerHTML = '<span class="status-pill status-unanswered">Chưa trả lời</span>';
                    }
                } else {
                    alert('Lỗi: ' + (data.message || 'Không thể lưu.'));
                    responseCell.innerHTML = originalText;
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('Đã có lỗi xảy ra khi kết nối tới server.');
                responseCell.innerHTML = originalText;
            })
            .finally(() => {
                button.innerText = 'Sửa';
                button.classList.remove('save-btn');
                button.classList.add('edit-btn');
            });
        } else {
            const originalText = responseCell.textContent.trim();
            button.dataset.originalText = originalText;
            responseCell.innerHTML = `<textarea class="editable-textarea">${originalText}</textarea>`;
            responseCell.querySelector('textarea').focus();
            button.innerText = 'Lưu';
            button.classList.remove('edit-btn');
            button.classList.add('save-btn');
        }
    }
</script>
</head>
<body>
    <div class="parent">
        <div class="div1"><jsp:include page="/Layout/staff/SideBar.jsp" /></div>
        <div class="div2"><jsp:include page="/Layout/staff/Header.jsp" /></div>
        <div class="div3">
            <h2 class="user-list-title">Lịch sử hội thoại của Khách hàng</h2>
            <table class="user-list-table">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Tên Khách Hàng</th>
                        <th>Câu Hỏi</th>
                        <th>Câu Trả Lời</th>
                        <th>Trạng Thái</th>
                        <th>Thao Tác</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="log" items="${logs}" varStatus="loop">
                        <tr>
                            <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                            <td>${log.username}</td>
                            <td>${log.message}</td>
                            <td id="response-cell-${log.logId}">${log.response}</td>
                            <td id="status-cell-${log.logId}">
                                <c:choose>
                                    <c:when test="${not empty log.response and log.response.trim() ne ''}">
                                        <span class="status-pill status-answered">Đã trả lời</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-unanswered">Chưa trả lời</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <button class="action-button edit-btn" onclick="toggleEdit(this, ${log.logId})">Sửa</button>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div style="text-align: center; margin-top: 20px;">
                <c:if test="${totalPages > 1}">
                    <span style="display: block; margin-bottom: 12px; color: #606266; font-size: 14px;">Trang ${currentPage} / ${totalPages}</span>
                    <div class="pagination-container">
                        <c:if test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/staff/chat-bot-log?page=${currentPage - 1}" class="page-link">&laquo;</a>
                        </c:if>
                        <c:forEach begin="1" end="${totalPages}" var="i">
                            <a href="${pageContext.request.contextPath}/staff/chat-bot-log?page=${i}" class="page-link ${i == currentPage ? 'active' : ''}">${i}</a>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/staff/chat-bot-log?page=${currentPage + 1}" class="page-link">&raquo;</a>
                        </c:if>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>