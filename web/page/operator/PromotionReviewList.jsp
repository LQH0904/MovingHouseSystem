<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<html>
<head>
    <title>Danh sách gợi ý khuyến mãi</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    <style>
        /* CSS cho div3 - Danh sách gợi ý khuyến mãi */
.div3 {
  padding: 24px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 120px);
}

.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 32px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
  position: relative;
  overflow: hidden;
}

.container::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
}

h2 {
  text-align: center;
  font-size: 32px;
  font-weight: 700;
  color: #2c3e50;
  margin-bottom: 40px;
  position: relative;
  padding-bottom: 16px;
}

h2::after {
  content: "";
  position: absolute;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 80px;
  height: 3px;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  border-radius: 2px;
}

/* Table Styling */
table {
  width: 100%;
  border-collapse: collapse;
  border-spacing: 0;
  background: #ffffff;
  border-radius: 12px;
  overflow: hidden;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
}

thead {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

th {
  padding: 18px 20px;
  text-align: left;
  color: #ffffff;
  font-weight: 600;
  font-size: 14px;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border: none;
}

tbody tr {
  transition: all 0.3s ease;
  border-bottom: 1px solid #e8ecf0;
}

tbody tr:hover {
  background-color: #f8f9ff;
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
}

tbody tr:last-child {
  border-bottom: none;
}

td {
  padding: 16px 20px;
  color: #2c3e50;
  font-size: 14px;
  line-height: 1.5;
  vertical-align: middle;
}

/* STT Column */
td:first-child {
  font-weight: 600;
  color: #667eea;
  text-align: center;
  width: 60px;
}

/* Title Column */
td:nth-child(2) {
  font-weight: 600;
  color: #2c3e50;
  max-width: 200px;
}

/* Content Column */
td:nth-child(3) {
  max-width: 300px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
  color: #5a6c7d;
}

/* Status Column */
td:nth-child(4) {
  text-align: center;
  width: 120px;
}

/* Status Badge Styling */
td:nth-child(4)::before {
  content: attr(data-status);
  display: inline-block;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 12px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

/* Status Colors - You can customize based on your status values */
td:nth-child(4)[data-status*="active"]::before,
td:nth-child(4)[data-status*="hoạt động"]::before {
  background: #d4edda;
  color: #155724;
}

td:nth-child(4)[data-status*="pending"]::before,
td:nth-child(4)[data-status*="chờ"]::before {
  background: #fff3cd;
  color: #856404;
}

td:nth-child(4)[data-status*="inactive"]::before,
td:nth-child(4)[data-status*="ngừng"]::before {
  background: #f8d7da;
  color: #721c24;
}

/* Action Column */
td:last-child {
  text-align: center;
  width: 120px;
}

/* Button Styling */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 10px 20px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  border: none;
  border-radius: 8px;
  font-size: 13px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  text-decoration: none;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
  background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
}

.btn:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
}

/* Add icon to button */
.btn::before {
  content: "👁️";
  font-size: 14px;
}

/* Empty State */
td[colspan] {
  text-align: center;
  color: #8e9aaf;
  font-style: italic;
  padding: 40px 20px;
  font-size: 16px;
  background: #f8f9fa;
}

td[colspan]::before {
  content: "📋";
  display: block;
  font-size: 48px;
  margin-bottom: 16px;
  opacity: 0.5;
}

/* Loading Animation */
@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.container {
  animation: fadeInUp 0.6s ease-out;
}

tbody tr {
  animation: fadeInUp 0.4s ease-out;
  animation-fill-mode: both;
}

tbody tr:nth-child(1) {
  animation-delay: 0.1s;
}
tbody tr:nth-child(2) {
  animation-delay: 0.2s;
}
tbody tr:nth-child(3) {
  animation-delay: 0.3s;
}
tbody tr:nth-child(4) {
  animation-delay: 0.4s;
}
tbody tr:nth-child(5) {
  animation-delay: 0.5s;
}

/* Responsive Design */
@media screen and (max-width: 1024px) {
  .div3 {
    padding: 16px;
  }

  .container {
    padding: 24px;
    margin: 0 8px;
  }

  h2 {
    font-size: 28px;
    margin-bottom: 32px;
  }
}

@media screen and (max-width: 768px) {
  .div3 {
    padding: 12px;
  }

  .container {
    padding: 20px;
    border-radius: 12px;
  }

  h2 {
    font-size: 24px;
    margin-bottom: 24px;
  }

  /* Mobile Table Layout */
  table,
  thead,
  tbody,
  th,
  td,
  tr {
    display: block;
  }

  thead {
    display: none;
  }

  tbody tr {
    margin-bottom: 20px;
    background: #ffffff;
    border-radius: 12px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    padding: 20px;
    border: 1px solid #e8ecf0;
  }

  tbody tr:hover {
    transform: none;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
  }

  td {
    position: relative;
    padding: 12px 0 12px 120px;
    border: none;
    border-bottom: 1px solid #f1f3f5;
    min-height: 40px;
    display: flex;
    align-items: center;
  }

  td:last-child {
    border-bottom: none;
    justify-content: flex-start;
  }

  td::before {
    position: absolute;
    top: 12px;
    left: 0;
    width: 110px;
    font-weight: 700;
    color: #667eea;
    font-size: 12px;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }

  td:nth-of-type(1)::before {
    content: "STT";
  }
  td:nth-of-type(2)::before {
    content: "Tên";
  }
  td:nth-of-type(3)::before {
    content: "Nội dung";
  }
  td:nth-of-type(4)::before {
    content: "Trạng thái";
  }
  td:nth-of-type(5)::before {
    content: "Hành động";
  }

  /* Mobile Content Adjustments */
  td:nth-child(3) {
    white-space: normal;
    overflow: visible;
    text-overflow: initial;
    max-width: none;
  }

  td:nth-child(4) {
    text-align: left;
  }

  .btn {
    padding: 8px 16px;
    font-size: 12px;
  }
}

@media screen and (max-width: 480px) {
  .container {
    padding: 16px;
    margin: 0 4px;
  }

  h2 {
    font-size: 20px;
    margin-bottom: 20px;
  }

  tbody tr {
    padding: 16px;
    margin-bottom: 16px;
  }

  td {
    padding: 10px 0 10px 100px;
    font-size: 13px;
  }

  td::before {
    width: 90px;
    font-size: 11px;
  }
}

/* Print Styles */
@media print {
  .div3 {
    background: none;
    padding: 0;
  }

  .container {
    box-shadow: none;
    border: 1px solid #ddd;
  }

  .btn {
    display: none;
  }

  tbody tr:hover {
    background: none;
    transform: none;
    box-shadow: none;
  }
}

    </style>
</head>
<body>
<div class="parent">
    <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
    <div class="div3">
        <div class="container">
        <h2>Danh sách gợi ý khuyến mãi</h2>
        <table>
            <thead>
                <tr>
                    <th>STT</th>
                    <th>Tên</th>
                    <th>Nội dung</th>
                    <th>Trạng thái</th>
                    <th>Hành động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="s" items="${suggestions}" varStatus="loop">
                    <tr>
                        <td>${loop.index + 1}</td>
                        <td>${s.title}</td>
                        <td title="${s.content}">${s.content}</td>
                        <td data-status="${s.status}">${s.status}</td>
                        <td>
                            <form action="promotion-detail" method="get" style="display:inline;">
                                <input type="hidden" name="id" value="${s.id}">
                                <button class="btn" type="submit">Chi tiết</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty suggestions}">
                    <tr>
                        <td colspan="5">Chưa có gợi ý khuyến mãi nào.</td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
    </div>
</div>
</body>
</html>
