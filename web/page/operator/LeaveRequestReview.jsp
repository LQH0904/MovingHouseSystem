<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <title>Quản lý đơn nghỉ phép</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            /* CSS chỉ cho div3 - Quản lý đơn nghỉ phép */
            .div3 {
                padding: 24px;
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: calc(100vh - 120px);
                position: relative;
            }

            /* Container cho nội dung trong div3 */
            .div3 h2,
            .div3 table {
                max-width: 1400px;
                margin: 0 auto;
            }

            .div3 h2 {
                background: #ffffff;
                padding: 32px 32px 16px 32px;
                border-radius: 16px 16px 0 0;
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.08);
                position: relative;
                margin-bottom: 0;
                animation: slideInUp 0.6s ease-out;
            }

            .div3 h2::before {
                content: "";
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
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

            /* Header Styling chỉ trong div3 */
            .div3 h2 {
                text-align: center;
                font-size: 32px;
                font-weight: 700;
                color: #2c3e50;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .div3 h2::after {
                content: "";
                position: absolute;
                bottom: 0;
                left: 50%;
                transform: translateX(-50%);
                width: 120px;
                height: 3px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
            }

            .div3 h2::before {
                content: "📋";
                position: absolute;
                top: 8px;
                left: 50%;
                transform: translateX(-50%);
                font-size: 24px;
                opacity: 0.7;
                z-index: 2;
            }

            /* Table Styling chỉ trong div3 */
            .div3 table {
                width: 100%;
                border-collapse: collapse;
                border-spacing: 0;
                background: #ffffff;
                border-radius: 0 0 16px 16px;
                overflow: hidden;
                box-shadow: 0 12px 40px rgba(0, 0, 0, 0.08);
                margin: 0 auto;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                animation: slideInUp 0.6s ease-out 0.1s both;
            }

            /* Table Header chỉ trong div3 */
            .div3 thead {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .div3 th {
                padding: 20px 16px;
                text-align: left;
                color: #ffffff;
                font-weight: 600;
                font-size: 14px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                border: none;
                position: relative;
            }

            .div3 th::before {
                margin-right: 8px;
                font-size: 16px;
            }

            .div3 th:nth-child(1)::before {
                content: "👤";
            }
            .div3 th:nth-child(2)::before {
                content: "📅";
            }
            .div3 th:nth-child(3)::before {
                content: "📅";
            }
            .div3 th:nth-child(4)::before {
                content: "📝";
            }
           
            .div3 th:nth-child(6)::before {
                content: "💬";
            }
            .div3 th:nth-child(7)::before {
                content: "⚙️";
            }

            /* Table Body chỉ trong div3 */
            .div3 tbody tr {
                transition: all 0.3s ease;
                border-bottom: 1px solid #e8ecf0;
                animation: fadeInUp 0.4s ease-out;
                animation-fill-mode: both;
            }

            .div3 tbody tr:nth-child(1) {
                animation-delay: 0.1s;
            }
            .div3 tbody tr:nth-child(2) {
                animation-delay: 0.2s;
            }
            .div3 tbody tr:nth-child(3) {
                animation-delay: 0.3s;
            }
            .div3 tbody tr:nth-child(4) {
                animation-delay: 0.4s;
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

            .div3 tbody tr:hover {
                background-color: #f8f9ff;
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.1);
            }

            .div3 tbody tr:last-child {
                border-bottom: none;
            }

            /* Table Cells chỉ trong div3 */
            .div3 td {
                padding: 16px;
                color: #2c3e50;
                font-size: 14px;
                line-height: 1.5;
                vertical-align: middle;
                border: none;
            }

            /* Employee Name Column */
            .div3 td:nth-child(1) {
                font-weight: 600;
                color: #667eea;
                position: relative;
            }

            .div3 td:nth-child(1)::before {
                content: "👤";
                margin-right: 8px;
                opacity: 0.7;
            }

            /* Date Columns */
            .div3 td:nth-child(2),
            .div3 td:nth-child(3) {
                font-family: "Courier New", monospace;
                background: #f8f9ff;
                border-radius: 6px;
                margin: 2px;
                text-align: center;
                font-weight: 500;
                color: #5a67d8;
            }

            /* Reason Column */
            .div3 td:nth-child(4) {
                max-width: 200px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                color: #5a6c7d;
                position: relative;
            }

            .div3 td:nth-child(4):hover {
                white-space: normal;
                overflow: visible;
                background: #fff3cd;
                border-radius: 6px;
                padding: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                z-index: 10;
                position: relative;
            }

            /* Status Column */
            .div3 td:nth-child(5) {
                text-align: center;
                font-weight: 600;
                position: relative;
            }

            /* Status Badge Styling */
            

            

        



            /* Default status */
 

            /* Reply Column */
            .div3 td:nth-child(6) {
                max-width: 150px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
                font-style: italic;
                color: #6c757d;
            }

            .div3 td:nth-child(6):hover {
                white-space: normal;
                overflow: visible;
                background: #e8f4fd;
                border-radius: 6px;
                padding: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                z-index: 10;
                position: relative;
            }

            /* Action Column */
            .div3 td:nth-child(7) {
                text-align: center;
                width: 120px;
            }

            /* Link/Button Styling chỉ trong div3 */
            .div3 a {
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 8px 16px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                text-decoration: none;
                border-radius: 8px;
                font-size: 12px;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .div3 a:hover {
                transform: translateY(-2px);
                box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
                background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
            }

            .div3 a:active {
                transform: translateY(0);
                box-shadow: 0 2px 8px rgba(102, 126, 234, 0.3);
            }

            .div3 a::before {
                content: "👁️";
                font-size: 14px;
            }

            /* Processed Status Styling chỉ trong div3 */
            .div3 span[style*="color: #ff0000"] {
                color: #e74c3c !important;
                font-weight: 600;
                font-style: italic;
                display: inline-flex;
                align-items: center;
                gap: 6px;
                padding: 6px 12px;
                background: linear-gradient(135deg, #fee 0%, #fdd 100%);
                border-radius: 20px;
                border: 1px solid #e74c3c;
                font-size: 11px;
                text-transform: uppercase;
                letter-spacing: 0.5px;
            }

            .div3 span[style*="color: #ff0000"]::before {
                content: "✅";
                font-size: 12px;
            }

            /* Responsive Design chỉ cho div3 */
            @media screen and (max-width: 1200px) {
                .div3 {
                    padding: 16px;
                }

                .div3 h2,
                .div3 table {
                    margin: 0 8px;
                }

                .div3 h2 {
                    padding: 24px 24px 16px 24px;
                    font-size: 28px;
                }
            }

            @media screen and (max-width: 768px) {
                .div3 {
                    padding: 12px;
                }

                .div3 h2 {
                    padding: 20px 20px 16px 20px;
                    font-size: 24px;
                    border-radius: 12px;
                }

                .div3 table {
                    border-radius: 12px;
                }

                /* Mobile Table Layout chỉ trong div3 */
                .div3 table,
                .div3 thead,
                .div3 tbody,
                .div3 th,
                .div3 td,
                .div3 tr {
                    display: block;
                }

                .div3 thead {
                    display: none;
                }

                .div3 tbody tr {
                    margin-bottom: 20px;
                    background: #ffffff;
                    border-radius: 12px;
                    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
                    padding: 20px;
                    border: 1px solid #e8ecf0;
                }

                .div3 tbody tr:hover {
                    transform: none;
                    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
                }

                .div3 td {
                    position: relative;
                    padding: 12px 0 12px 140px;
                    border: none;
                    border-bottom: 1px solid #f1f3f5;
                    min-height: 40px;
                    display: flex;
                    align-items: center;
                }

                .div3 td:last-child {
                    border-bottom: none;
                    justify-content: flex-start;
                }

                .div3 td::before {
                    position: absolute;
                    top: 12px;
                    left: 0;
                    width: 130px;
                    font-weight: 700;
                    color: #667eea;
                    font-size: 12px;
                    text-transform: uppercase;
                    letter-spacing: 0.5px;
                }

                .div3 td:nth-of-type(1)::before {
                    content: "👤 Nhân viên";
                }
                .div3 td:nth-of-type(2)::before {
                    content: "📅 Ngày bắt đầu";
                }
                .div3 td:nth-of-type(3)::before {
                    content: "📅 Ngày kết thúc";
                }
                .div3 td:nth-of-type(4)::before {
                    content: "📝 Lý do";
                }
                
                .div3 td:nth-of-type(6)::before {
                    content: "💬 Phản hồi";
                }
                .div3 td:nth-of-type(7)::before {
                    content: "⚙️ Hành động";
                }

                /* Mobile Content Adjustments */
                .div3 td:nth-child(4),
                .div3 td:nth-child(6) {
                    white-space: normal;
                    overflow: visible;
                    text-overflow: initial;
                    max-width: none;
                }

                .div3 td:nth-child(5)::after {
                    position: static;
                    transform: none;
                    display: inline-block;
                    margin: 0;
                }
            }

            @media screen and (max-width: 480px) {
                .div3 h2,
                .div3 table {
                    margin: 0 4px;
                }

                .div3 h2 {
                    padding: 16px 16px 16px 16px;
                    font-size: 20px;
                }

                .div3 tbody tr {
                    padding: 16px;
                    margin-bottom: 16px;
                }

                .div3 td {
                    padding: 10px 0 10px 120px;
                    font-size: 13px;
                }

                .div3 td::before {
                    width: 110px;
                    font-size: 11px;
                }

                .div3 a {
                    padding: 6px 12px;
                    font-size: 11px;
                }
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp" />
            </div>
            <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp" />
            </div>
            <div class="div3">
                <h2>Danh sách đơn nghỉ phép của nhân viên</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Nhân viên</th>
                            <th>Ngày bắt đầu</th>
                            <th>Ngày kết thúc</th>
                            <th>Lý do</th>
                            <th>Phản hồi</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${requests}">
                            <tr>
                                <td>${r.staffName}</td>
                                <td>${r.startDate}</td>
                                <td>${r.endDate}</td>
                                <td>${r.reason}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty r.operatorReply}">
                                            ${r.operatorReply}
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${r.status == 'approved'}">
                                            <span style="color: #ff0000">Đã được xử lý<span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="${pageContext.request.contextPath}/operator/review-leave-request?id=${r.requestId}">Chi tiết</a>
                                                </c:otherwise>
                                            </c:choose>
                                            </td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>

                                        </table>
                                        </div>
                                        </div>
                                        </body>
                                        </html>
