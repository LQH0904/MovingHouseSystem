<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        
        <style>
            /* CSS cho khối div3 - Chi tiết phản hồi */
            .div3 {
                background: linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%);
                min-height: 100vh;
                padding: 2rem;
                position: relative;
                overflow-x: auto;
            }

            .div3::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
            }

            .div3 .container {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                padding: 2.5rem;
                margin-top: 1rem;
                border: 1px solid rgba(255, 255, 255, 0.2);
                animation: slideInFromTop 0.8s ease-out;
            }

            .div3 h3 {
                color: #2d3748;
                font-weight: 700;
                font-size: 2rem;
                margin-bottom: 2rem;
                position: relative;
                text-align: center;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }

            .div3 h3::after {
                content: '';
                position: absolute;
                bottom: -10px;
                left: 50%;
                transform: translateX(-50%);
                width: 80px;
                height: 4px;
                background: linear-gradient(90deg, #667eea 0%, #764ba2 100%);
                border-radius: 2px;
            }

            /* Styling cho alert */
            .div3 .alert-danger {
                background: linear-gradient(135deg, #ff6b6b, #ee5a52);
                border: none;
                color: white;
                border-radius: 15px;
                padding: 1rem 1.5rem;
                box-shadow: 0 8px 25px rgba(238, 90, 82, 0.3);
                font-weight: 500;
            }

            /* Styling cho table container */
            .div3 .table-responsive {
                border-radius: 15px;
                overflow: hidden;
                box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1);
                margin-bottom: 2rem;
                background: white;
            }

            .div3 .table {
                margin-bottom: 0;
                border-collapse: separate;
                border-spacing: 0;
            }

            .div3 .table thead th {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                padding: 1.2rem 1rem;
                border: none;
                font-size: 0.9rem;
                position: relative;
            }

            .div3 .table thead th:first-child {
                border-top-left-radius: 15px;
            }

            .div3 .table thead th:last-child {
                border-top-right-radius: 15px;
            }

            .div3 .table tbody tr {
                transition: all 0.3s ease;
                background: white;
            }

            .div3 .table tbody tr:hover {
                background: linear-gradient(135deg, #f8f9ff 0%, #e6f3ff 100%);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(102, 126, 234, 0.15);
            }

            .div3 .table tbody td {
                padding: 1.2rem 1rem;
                border: none;
                border-bottom: 1px solid #e2e8f0;
                vertical-align: middle;
                font-weight: 500;
                color: #4a5568;
                position: relative;
            }

            .div3 .table tbody tr:last-child td {
                border-bottom: none;
            }

            .div3 .table tbody tr:last-child td:first-child {
                border-bottom-left-radius: 15px;
            }

            .div3 .table tbody tr:last-child td:last-child {
                border-bottom-right-radius: 15px;
            }

            /* Styling đặc biệt cho các cột */
            .div3 .table tbody td:first-child {
                font-weight: 700;
                color: #667eea;
                background: linear-gradient(135deg, #f0f4ff 0%, #e6f3ff 100%);
                border-right: 3px solid #667eea;
            }

            .div3 .table tbody td:nth-child(3) {
                max-width: 300px;
                word-wrap: break-word;
                line-height: 1.6;
            }

            .div3 .table tbody td:last-child {
                font-family: 'Courier New', monospace;
                background: #f8f9fa;
                color: #6c757d;
                font-size: 0.9rem;
            }

            /* Styling cho nút quay lại */
            .div3 .btn-secondary {
                background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
                border: none;
                border-radius: 50px;
                padding: 0.8rem 2rem;
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                transition: all 0.3s ease;
                box-shadow: 0 8px 25px rgba(108, 117, 125, 0.3);
                position: relative;
                overflow: hidden;
            }

            .div3 .btn-secondary::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }

            .div3 .btn-secondary:hover::before {
                left: 100%;
            }

            .div3 .btn-secondary:hover {
                transform: translateY(-3px);
                box-shadow: 0 15px 35px rgba(108, 117, 125, 0.4);
                background: linear-gradient(135deg, #5a6268 0%, #3d4043 100%);
            }

            .div3 .btn-secondary i {
                margin-right: 0.5rem;
                transition: transform 0.3s ease;
            }

            .div3 .btn-secondary:hover i {
                transform: translateX(-3px);
            }

            /* Responsive design */
            @media (max-width: 768px) {
                .div3 {
                    padding: 1rem;
                }
                
                .div3 .container {
                    padding: 1.5rem;
                    border-radius: 15px;
                }
                
                .div3 h3 {
                    font-size: 1.5rem;
                }
                
                .div3 .table thead th,
                .div3 .table tbody td {
                    padding: 0.8rem 0.5rem;
                    font-size: 0.85rem;
                }
                
                .div3 .btn-secondary {
                    padding: 0.6rem 1.5rem;
                    font-size: 0.9rem;
                }
            }

            @media (max-width: 576px) {
                .div3 .table thead th:nth-child(3),
                .div3 .table tbody td:nth-child(3) {
                    max-width: 150px;
                    font-size: 0.8rem;
                }
            }

            /* Animation cho table rows */
            .div3 .table tbody tr {
                opacity: 0;
                animation: fadeInUp 0.6s ease forwards;
            }

            .div3 .table tbody tr:nth-child(1) { animation-delay: 0.1s; }
            .div3 .table tbody tr:nth-child(2) { animation-delay: 0.2s; }
            .div3 .table tbody tr:nth-child(3) { animation-delay: 0.3s; }
            .div3 .table tbody tr:nth-child(4) { animation-delay: 0.4s; }
            .div3 .table tbody tr:nth-child(5) { animation-delay: 0.5s; }

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

            /* Loading animation cho container */
            @keyframes slideInFromTop {
                from {
                    opacity: 0;
                    transform: translateY(-50px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body class="bg-light">
        <div class="parent">
            <% if (currentUserRoleId == 2) { %>
            <div class="div1">
                <jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include>
                </div>
            <% } %>

            <% if (currentUserRoleId == 3) { %>
            <div class="div1">
                <jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
                </div>
            <% }%>  
            <div class="div3 p-4">
                <div class="container mt-5">
                    <h3 class="mb-4">Chi tiết phản hồi</h3>
                    <!-- Nếu có lỗi -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>
                    <!-- Nếu có dữ liệu phản hồi -->
                    <c:if test="${reply != null}">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th>#No</th>
                                        <th>Id người phản hồi</th>
                                        <th>Nội dung phản hồi</th>
                                        <th>Thời gian phản hồi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reply}" var="i">
                                        <tr>
                                            <td>${i.replyId}</td>
                                            <td>${i.replierId}</td>
                                            <td>${i.replyContent}</td>
                                            <td><fmt:formatDate value="${i.repliedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                    <!-- Nút quay lại -->
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/viewComplaintDetail" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại khiếu nại
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>