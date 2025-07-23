<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Quản lý Cảnh báo Bảo mật</title>
    <style>
        body { font-family: Arial; background: #f4f6f9; margin: 0; padding: 20px; }
        .card { background: white; border-radius: 8px; padding: 20px; margin-bottom: 20px; box-shadow: 0 0 6px rgba(0,0,0,0.1); }
        .card.red { border-left: 5px solid #dc3545; }
        .card.yellow { border-left: 5px solid #ffc107; }
        .card.green { border-left: 5px solid #28a745; }
        .header { font-size: 20px; font-weight: bold; margin-bottom: 10px; }
        .btn { padding: 8px 14px; background: #007bff; color: white; border: none; border-radius: 5px; cursor: pointer; }
        .btn:hover { background: #0056b3; }
        form input, textarea, select { width: 100%; padding: 8px; margin: 5px 0 15px; border-radius: 5px; border: 1px solid #ccc; }
    </style>
</head>
<body>
    <div class="card">
        <div class="header">Tạo cảnh báo mới</div>
        <form action="${pageContext.request.contextPath}/admin/generate-alert" method="post">
            <input name="title" placeholder="Tiêu đề" required />
            <textarea name="description" placeholder="Mô tả" required></textarea>
            <select name="level" required>
                <option value="Cao">Cao</option>
                <option value="Trung bình">Trung bình</option>
                <option value="Thấp">Thấp</option>
            </select>
            <select name="status">
                <option>Đang hoạt động</option>
                <option>Đang điều tra</option>
                <option>Đã giải quyết</option>
            </select>
            <input name="ipAddress" placeholder="Địa chỉ IP (nếu có)" />
            <input name="userEmail" placeholder="Email người dùng (nếu có)" />
            <button class="btn" type="submit">Tạo cảnh báo</button>
        </form>
    </div>

    <c:forEach var="a" items="${alerts}">
        <div class="card ${a.level == 'Cao' ? 'red' : a.level == 'Trung bình' ? 'yellow' : 'green'}">
            <div><strong>${a.title}</strong></div>
            <div>${a.description}</div>
            <div>IP: ${a.ipAddress} | Email: ${a.userEmail}</div>
            <div>Mức độ: ${a.level} | Trạng thái: ${a.status} | ${a.createdAt}</div>
        </div>
    </c:forEach>
</body>
</html>
