<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.ChatbotLog" %>
<%
    List<ChatbotLog> logs = (List<ChatbotLog>) request.getAttribute("logList");
%>
<html>
<head>
    <title>Câu hỏi từ khách hàng</title>
    <style>
        table {
            width: 95%;
            margin: 20px auto;
            border-collapse: collapse;
        }
        th, td {
            padding: 12px;
            border: 1px solid #ccc;
        }
        textarea {
            width: 100%;
            height: 60px;
        }
        .action-btns {
            display: flex;
            gap: 8px;
            justify-content: center;
        }
        .delete-modal {
            display: none;
            position: fixed;
            top: 30%;
            left: 50%;
            transform: translate(-50%, -30%);
            background: white;
            padding: 20px;
            border: 1px solid #aaa;
            box-shadow: 0 0 8px rgba(0,0,0,0.2);
            z-index: 1000;
        }
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0; left: 0;
            width: 100%; height: 100%;
            background: rgba(0,0,0,0.5);
            z-index: 999;
        }
    </style>
</head>
<body>
<jsp:include page="../../Layout/staff/Header.jsp"/>

<h2 style="text-align:center;">Danh sách câu hỏi từ khách hàng</h2>

<table>
    <thead>
    <tr>
        <th>Tên người hỏi</th>
        <th>Câu hỏi</th>
        <th>Trả lời</th>
        <th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <% for (ChatbotLog log : logs) { %>
        <tr>
            <td><%= log.getReview() %></td>
            <td><%= log.getQuestion() %></td>
            <td>
                <form method="post" action="${pageContext.request.contextPath}/staff/chat-bot-log">
                    <input type="hidden" name="action" value="update"/>
                    <input type="hidden" name="logId" value="<%= log.getLogId() %>"/>
                    <textarea name="reply"><%= log.getReply() == null ? "" : log.getReply() %></textarea>
                    <button type="submit">Lưu</button>
                </form>
            </td>
            <td>
                <div class="action-btns">
                    <button onclick="confirmDelete(<%= log.getLogId() %>)">Xoá</button>
                </div>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>

<!-- Modal -->
<div class="modal-overlay" id="overlay"></div>
<div class="delete-modal" id="deleteModal">
    <p>Bạn có chắc muốn xoá đi câu hỏi này? Hãy chắc chắn bạn đã trả lời.</p>
    <form method="post" action="${pageContext.request.contextPath}/staff/chat-bot-log">
        <input type="hidden" name="action" value="delete"/>
        <input type="hidden" id="deleteLogId" name="logId" value=""/>
        <button type="submit">Xoá</button>
        <button type="button" onclick="closeModal()">Huỷ</button>
    </form>
</div>

<script>
    function confirmDelete(logId) {
        document.getElementById('deleteLogId').value = logId;
        document.getElementById('overlay').style.display = 'block';
        document.getElementById('deleteModal').style.display = 'block';
    }
    function closeModal() {
        document.getElementById('overlay').style.display = 'none';
        document.getElementById('deleteModal').style.display = 'none';
    }
</script>

</body>
</html>
