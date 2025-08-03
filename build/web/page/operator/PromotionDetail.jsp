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
        <title>Chi tiết gợi ý</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            /* CSS cho div3 - Chi tiết gợi ý khuyến mãi */
.div3 {
  padding: 24px;
  background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
  min-height: calc(100vh - 120px);
}

.container {
  max-width: 900px;
  margin: 0 auto;
  padding: 40px;
  background: #ffffff;
  border-radius: 16px;
  box-shadow: 0 12px 40px rgba(0, 0, 0, 0.08);
  position: relative;
  overflow: hidden;
  animation: slideInUp 0.6s ease-out;
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

@keyframes slideInUp {
  from {
    opacity: 0;
    transform: translateY(40px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Header Styling */
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
  width: 100px;
  height: 3px;
  background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
  border-radius: 2px;
}

h2::before {
  content: "📋";
  position: absolute;
  top: -10px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 24px;
  opacity: 0.7;
}

/* Information Rows */
.info-row {
  margin-bottom: 24px;
  padding: 20px;
  background: #f8f9ff;
  border-radius: 12px;
  border-left: 4px solid #667eea;
  transition: all 0.3s ease;
  animation: fadeInLeft 0.5s ease-out;
  animation-fill-mode: both;
}

.info-row:nth-child(1) {
  animation-delay: 0.1s;
}
.info-row:nth-child(2) {
  animation-delay: 0.2s;
}
.info-row:nth-child(3) {
  animation-delay: 0.3s;
}
.info-row:nth-child(4) {
  animation-delay: 0.4s;
}
.info-row:nth-child(5) {
  animation-delay: 0.5s;
}

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.info-row:hover {
  background: #f0f4ff;
  transform: translateX(4px);
  box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);
}

/* Labels */
label {
  font-weight: 700;
  font-size: 14px;
  color: #667eea;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 8px;
  display: block;
  position: relative;
}

/* Add icons to labels */
label::before {
  margin-right: 8px;
  font-size: 16px;
}

label[for="status"]::before {
  content: "⚡";
}
label[for="reply"]::before {
  content: "💬";
}
.info-row:nth-child(1) label::before {
  content: "👤";
}
.info-row:nth-child(2) label::before {
  content: "🏷️";
}
.info-row:nth-child(3) label::before {
  content: "📝";
}
.info-row:nth-child(4) label::before {
  content: "💡";
}
.info-row:nth-child(5) label::before {
  content: "⏰";
}

/* Readonly Fields */
.readonly {
  background: linear-gradient(135deg, #ffffff 0%, #f8f9ff 100%);
  padding: 16px 20px;
  border-radius: 8px;
  border: 2px solid #e8ecf0;
  font-size: 15px;
  color: #2c3e50;
  line-height: 1.6;
  min-height: 20px;
  position: relative;
  transition: all 0.3s ease;
}

.readonly:hover {
  border-color: #667eea;
  box-shadow: 0 2px 8px rgba(102, 126, 234, 0.1);
}

/* Special styling for time period */
.info-row:nth-child(5) .readonly {
  background: linear-gradient(135deg, #fff3e0 0%, #ffe0b2 100%);
  border-color: #ff9800;
  color: #e65100;
  font-weight: 600;
  text-align: center;
}

/* Form Styling */
form {
  margin-top: 40px;
  padding: 32px;
  background: linear-gradient(135deg, #f8f9ff 0%, #ffffff 100%);
  border-radius: 16px;
  border: 2px solid #e8ecf0;
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.05);
  animation: fadeInUp 0.6s ease-out 0.6s both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

form::before {
  content: "📝 Đánh giá gợi ý";
  display: block;
  font-size: 18px;
  font-weight: 700;
  color: #667eea;
  margin-bottom: 24px;
  text-align: center;
  padding-bottom: 16px;
  border-bottom: 2px solid #e8ecf0;
}

/* Form Controls */
select,
textarea {
  width: 100%;
  padding: 16px 20px;
  font-size: 15px;
  border: 2px solid #e8ecf0;
  border-radius: 12px;
  box-sizing: border-box;
  transition: all 0.3s ease;
  font-family: inherit;
  background: #ffffff;
}

select:focus,
textarea:focus {
  border-color: #667eea;
  outline: none;
  box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
  transform: translateY(-1px);
}

select:hover,
textarea:hover {
  border-color: #a8b3ea;
}

/* Select Styling */
select {
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3e%3cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='m6 8 4 4 4-4'/%3e%3c/svg%3e");
  background-position: right 12px center;
  background-repeat: no-repeat;
  background-size: 16px;
  padding-right: 48px;
  appearance: none;
}

select option {
  padding: 12px;
  background: #ffffff;
  color: #2c3e50;
}

select option:hover {
  background: #f8f9ff;
}

/* Textarea Styling */
textarea {
  resize: vertical;
  min-height: 120px;
  line-height: 1.6;
}

textarea::placeholder {
  color: #8e9aaf;
  font-style: italic;
}

/* Character Counter */
textarea + .char-counter {
  display: block;
  text-align: right;
  font-size: 12px;
  color: #8e9aaf;
  margin-top: 4px;
}

/* Button Styling */
.btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 16px 32px;
  border: none;
  border-radius: 12px;
  font-weight: 600;
  font-size: 16px;
  cursor: pointer;
  margin-top: 24px;
  transition: all 0.3s ease;
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
  position: relative;
  overflow: hidden;
}

.btn::before {
  content: "✅";
  font-size: 18px;
}

.btn::after {
  content: "";
  position: absolute;
  top: 50%;
  left: 50%;
  width: 0;
  height: 0;
  background: rgba(255, 255, 255, 0.2);
  border-radius: 50%;
  transform: translate(-50%, -50%);
  transition: all 0.3s ease;
}

.btn:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(102, 126, 234, 0.4);
  background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
}

.btn:hover::after {
  width: 300px;
  height: 300px;
}

.btn:active {
  transform: translateY(0);
  box-shadow: 0 4px 16px rgba(102, 126, 234, 0.3);
}

/* Status-specific styling */
select[name="status"] option[value="Duyệt"] {
  color: #22c55e;
  font-weight: 600;
}

select[name="status"] option[value="Không duyệt"] {
  color: #ef4444;
  font-weight: 600;
}

/* Validation States */
.error {
  border-color: #ef4444 !important;
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1) !important;
}

.success {
  border-color: #22c55e !important;
  box-shadow: 0 0 0 3px rgba(34, 197, 94, 0.1) !important;
}

/* Loading State */
.btn:disabled {
  opacity: 0.7;
  cursor: not-allowed;
  transform: none;
}

.btn:disabled::before {
  content: "⏳";
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}

/* Responsive Design */
@media screen and (max-width: 1024px) {
  .div3 {
    padding: 16px;
  }

  .container {
    padding: 32px;
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
    padding: 24px;
    border-radius: 12px;
  }

  h2 {
    font-size: 24px;
    margin-bottom: 24px;
  }

  .info-row {
    padding: 16px;
    margin-bottom: 16px;
  }

  form {
    padding: 24px;
    margin-top: 24px;
  }

  .btn {
    width: 100%;
    justify-content: center;
    padding: 14px 24px;
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

  .info-row {
    padding: 12px;
    margin-bottom: 12px;
  }

  form {
    padding: 16px;
  }

  select,
  textarea {
    padding: 12px 16px;
    font-size: 14px;
  }

  .btn {
    padding: 12px 20px;
    font-size: 14px;
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

  form {
    display: none;
  }

  .info-row:hover {
    background: #f8f9ff;
    transform: none;
    box-shadow: none;
  }
}

/* Dark Mode Support */
@media (prefers-color-scheme: dark) {
  .container {
    background: #1a1a1a;
    color: #ffffff;
  }

  .info-row {
    background: #2a2a2a;
    border-left-color: #667eea;
  }

  .readonly {
    background: #333333;
    border-color: #444444;
    color: #ffffff;
  }

  form {
    background: #2a2a2a;
    border-color: #444444;
  }

  select,
  textarea {
    background: #333333;
    border-color: #444444;
    color: #ffffff;
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
        <h2>Chi tiết Gợi ý Khuyến mãi</h2>
        
        <div class="info-row">
            <label>Người gửi:</label>
            <div class="readonly">${suggestion.user.username}</div>
        </div>
        
        <div class="info-row">
            <label>Tên khuyến mãi:</label>
            <div class="readonly">${suggestion.title}</div>
        </div>
        
        <div class="info-row">
            <label>Nội dung:</label>
            <div class="readonly">${suggestion.content}</div>
        </div>
        
        <div class="info-row">
            <label>Lý do:</label>
            <div class="readonly">${suggestion.reason}</div>
        </div>
        
        <div class="info-row">
            <label>Thời gian:</label>
            <div class="readonly">${suggestion.startDate} - ${suggestion.endDate}</div>
        </div>
        
        <form action="${pageContext.request.contextPath}/submit-review" method="post">
            <input type="hidden" name="id" value="${suggestion.id}" />
            
            <div class="info-row">
                <label for="status">Trạng thái:</label>
                <select name="status" id="status" required>
                    <option value="">-- Chọn trạng thái --</option>
                    <option value="Duyệt">✅ Duyệt</option>
                    <option value="Không duyệt">❌ Không duyệt</option>
                </select>
            </div>
            
            <div class="info-row">
                <label for="reply">Phản hồi / Đánh giá:</label>
                <textarea id="reply" name="reply" rows="4" required maxlength="500"
                          placeholder="Viết đánh giá ngắn gọn về gợi ý này... (tối đa 500 ký tự)"
                          oninput="updateCharCounter(this)"></textarea>
                <span class="char-counter">0/500</span>
            </div>
            
            <button class="btn" type="submit">Gửi đánh giá</button>
        </form>
    </div>
            </div>

    </body>
    <script>
function updateCharCounter(textarea) {
    const counter = textarea.nextElementSibling;
    const current = textarea.value.length;
    const max = textarea.maxLength;
    counter.textContent = current + '/' + max;
    
    if (current > max * 0.9) {
        counter.style.color = '#ef4444';
    } else if (current > max * 0.7) {
        counter.style.color = '#f59e0b';
    } else {
        counter.style.color = '#8e9aaf';
    }
}
</script>
</html>
