<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Đơn nghỉ phép</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <style>
      /* General styling for div3 */
      .div3 {
          flex-grow: 1;
          padding: 2rem;
          background-color: #f8f9fa; /* Light background for the content area */
          border-radius: 8px;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
          margin: 1rem;
          color: #333;
          font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
          display: flex;
          flex-direction: column;
          gap: 1.5rem;
      }

      .div3 h2 {
          font-size: 2.2rem;
          font-weight: 700;
          color: #2c3e50;
          margin-bottom: 1.5rem;
          text-align: center;
      }

      /* Button styling */
      .btn {
          display: inline-flex;
          align-items: center;
          justify-content: center;
          padding: 0.8rem 1.5rem;
          font-size: 1rem;
          font-weight: 600;
          color: #ffffff;
          background-color: #4CAF50; /* Professional green */
          border: none;
          border-radius: 6px;
          cursor: pointer;
          transition: background-color 0.3s ease, transform 0.2s ease;
          text-decoration: none;
          white-space: nowrap;
          margin-bottom: 1.5rem;
          align-self: flex-start; /* Align button to the start */
      }

      .btn:hover {
          background-color: #45a049;
          transform: translateY(-2px);
      }

      .btn:active {
          transform: translateY(0);
      }

      .submit-btn {
          width: 100%;
          margin-top: 1rem;
      }

      /* Table styling */
      .user-list-table {
          width: 100%;
          border-collapse: collapse;
          background-color: #ffffff;
          border-radius: 8px;
          overflow: hidden; /* Ensures rounded corners apply to children */
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }

      .user-list-table thead th {
          background-color: #e9ecef; /* Light grey for header */
          color: #495057;
          padding: 1rem 1.2rem;
          text-align: left;
          font-weight: 600;
          border-bottom: 1px solid #dee2e6;
          font-size: 0.95rem;
      }

      .user-list-table tbody td {
          padding: 1rem 1.2rem;
          border-bottom: 1px solid #e9ecef;
          color: #343a40;
          font-size: 0.9rem;
      }

      .user-list-table tbody tr:nth-child(even) {
          background-color: #f8f9fa; /* Slightly different background for even rows */
      }

      .user-list-table tbody tr:hover {
          background-color: #e2f0ff; /* Highlight row on hover */
      }

      .user-list-table .no-data {
          text-align: center;
          font-style: italic;
          color: #6c757d;
          padding: 2rem;
      }

      /* Form styling */
      #suggestionForm {
          background-color: #ffffff;
          padding: 2rem;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
          border: 1px solid #e9ecef;
          margin-top: 1.5rem;
      }

      #suggestionForm label {
          display: block;
          margin-bottom: 0.5rem;
          font-weight: 600;
          color: #343a40;
      }

      #suggestionForm input[type="date"],
      #suggestionForm textarea {
          width: calc(100% - 20px); /* Account for padding */
          padding: 0.8rem 10px;
          margin-bottom: 1rem;
          border: 1px solid #ced4da;
          border-radius: 4px;
          font-size: 1rem;
          color: #495057;
          transition: border-color 0.3s ease, box-shadow 0.3s ease;
      }

      #suggestionForm input[type="date"]:focus,
      #suggestionForm textarea:focus {
          border-color: #80bdff;
          outline: 0;
          box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
      }

      #suggestionForm textarea {
          resize: vertical; /* Allow vertical resizing */
          min-height: 80px;
      }

      /* Responsive adjustments for tables */
      @media (max-width: 768px) {
          .div3 {
              padding: 1rem;
              margin: 0.5rem;
          }

          .div3 h2 {
              font-size: 1.8rem;
          }

          .btn {
              width: 100%;
              text-align: center;
          }

          .user-list-table, .user-list-table tbody, .user-list-table tr, .user-list-table td {
              display: block;
              width: 100%;
          }

          .user-list-table thead {
              display: none; /* Hide table headers on small screens */
          }

          .user-list-table tr {
              margin-bottom: 1rem;
              border: 1px solid #dee2e6;
              border-radius: 8px;
              overflow: hidden;
              box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
          }

          .user-list-table td {
              text-align: right;
              padding-left: 50%; /* Space for the data-label */
              position: relative;
              border: none;
              border-bottom: 1px solid #e9ecef;
          }

          .user-list-table td:last-child {
              border-bottom: none;
          }

          .user-list-table td::before {
              content: attr(data-label);
              position: absolute;
              left: 10px;
              width: calc(50% - 20px);
              padding-right: 10px;
              white-space: nowrap;
              text-align: left;
              font-weight: 600;
              color: #495057;
          }
      }
  </style>
</head>
<body>
<div class="parent">
    <div class="div1"><jsp:include page="/Layout/staff/SideBar.jsp"/></div>
    <div class="div2"><jsp:include page="/Layout/staff/Header.jsp"/></div>
    <div class="div3">
        <h2>Danh sách đơn nghỉ phép của bạn</h2>

        <button class="btn" onclick="toggleForm()">+ Gửi đơn nghỉ phép</button>

        <table class="user-list-table">
            <thead>
            <tr>
                <th>STT</th>
                <th>Từ ngày</th>
                <th>Đến ngày</th>
                <th>Lý do</th>
                <th>Trạng thái</th>
                <th>Phản hồi</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="r" items="${requests}" varStatus="loop">
                <tr>
                    <td data-label="STT">${loop.index + 1}</td>
                    <td data-label="Từ ngày">${r.startDate}</td>
                    <td data-label="Đến ngày">${r.endDate}</td>
                    <td data-label="Lý do">${r.reason}</td>
                    <td data-label="Trạng thái">
    <c:choose>
        <c:when test="${r.status == 'approved'}">
            <span style="color: #27ae60; font-weight: bold;">Đã duyệt</span>
        </c:when>
        <c:when test="${r.status == 'rejected'}">
            <span style="color: #e74c3c; font-weight: bold;">Bị từ chối</span>
        </c:when>
        <c:when test="${r.status == 'pending'}">
            <span style="color: #f39c12; font-weight: bold;">Chờ xử lý</span>
        </c:when>
        <%-- Thêm các trường hợp khác nếu có --%>
        <c:otherwise>
            <span style="color: #7f8c8d;">${r.status}</span> <%-- Hiển thị trạng thái gốc nếu không khớp --%>
        </c:otherwise>
    </c:choose>
</td>
                    <td data-label="Phản hồi">${r.operatorReply}</td>
                </tr>
            </c:forEach>
            <c:if test="${empty requests}">
                <tr><td colspan="6" class="no-data">Chưa có đơn nghỉ phép nào.</td></tr>
            </c:if>
            </tbody>
        </table>

        <div id="suggestionForm" style="display:none;">
            <form method="post" action="${pageContext.request.contextPath}/submit-leave-request">
                <label for="startDate">Từ ngày</label>
                <input type="date" name="startDate" required>

                <label for="endDate">Đến ngày</label>
                <input type="date" name="endDate" required>

                <label for="reason">Lý do</label>
                <textarea name="reason" rows="3" required></textarea>

                <button type="submit" class="btn submit-btn">Gửi đơn</button>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleForm() {
        const form = document.getElementById('suggestionForm');
        form.style.display = (form.style.display === 'none') ? 'block' : 'none';
    }
</script>
</body>
</html>
