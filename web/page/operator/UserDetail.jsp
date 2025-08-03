<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
int currentUserId = userAccount.getUserId();    
String currentUsername = userAccount.getUsername();    
int currentUserRoleId = userAccount.getRoleId();
%>
<html>
<head>
    <title>Chi Tiết Người Dùng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    
    <style>
        /* =================================================================== */
        /* ============= CSS CHỈ CHO PHẦN CONTENT (DIV3) ================== */
        /* =================================================================== */
        
        /* CSS Variables cho màu sắc */
        :root {
            --primary-blue: #2563eb;
            --primary-blue-light: #3b82f6;
            --secondary-blue: #e0f2fe;
            --success-green: #10b981;
            --warning-orange: #f59e0b;
            --error-red: #ef4444;
            --text-primary: #1e293b;
            --text-secondary: #64748b;
            --text-muted: #94a3b8;
            --border-color: #e2e8f0;
            --bg-light: #f8fafc;
        }

        /* Chỉ CSS cho phần content */
        .content {
            max-width: 1000px;
            margin: 24px auto;
            padding: 32px;
            background-color: #ffffff; /* Background trắng như yêu cầu */
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
            font-family: 'Inter', sans-serif;
            border: 1px solid var(--border-color);
        }

        /* Header title */
        .user-list-title {
            font-size: 28px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 32px;
            padding-bottom: 16px;
            border-bottom: 3px solid var(--primary-blue);
            display: flex;
            align-items: center;
            gap: 12px;
            position: relative;
        }

        .user-list-title::before {
            content: '\f007'; /* Font Awesome user icon */
            font-family: 'Font Awesome 6 Free';
            font-weight: 900;
            color: var(--primary-blue);
            font-size: 24px;
        }

        /* Thiết kế bảng hiện đại */
        .user-list-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
            background: #ffffff;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);
            border: 1px solid var(--border-color);
            margin-bottom: 32px;
        }

        .user-list-table tr {
            transition: all 0.2s ease;
        }

        .user-list-table tr:hover {
            background-color: var(--bg-light);
            transform: translateX(2px);
        }

        .user-list-table th,
        .user-list-table td {
            padding: 18px 24px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
            vertical-align: middle;
        }

        .user-list-table tr:last-child th,
        .user-list-table tr:last-child td {
            border-bottom: none;
        }

        .user-list-table th {
            width: 200px;
            font-weight: 600;
            color: var(--text-secondary);
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            background: linear-gradient(135deg, var(--bg-light) 0%, #ffffff 100%);
            position: relative;
        }

        .user-list-table th::after {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 4px;
            background: var(--primary-blue);
        }

        .user-list-table td {
            color: var(--text-primary);
            font-size: 15px;
            font-weight: 500;
        }

        /* Status Pills */
        .status-pill {
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-align: center;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            text-transform: capitalize;
            letter-spacing: 0.3px;
            transition: all 0.2s ease;
        }

        .status-pill::before {
            content: '';
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .status-active {
            color: #065f46;
            background-color: #d1fae5;
            border: 1px solid #86efac;
        }

        .status-active::before {
            background: var(--success-green);
        }

        .status-inactive {
            color: #991b1b;
            background-color: #fee2e2;
            border: 1px solid #fca5a5;
        }

        .status-inactive::before {
            background: var(--error-red);
        }

        .status-pending {
            color: #92400e;
            background-color: #fef3c7;
            border: 1px solid #fcd34d;
        }

        .status-pending::before {
            background: var(--warning-orange);
        }

        .status-unknown {
            color: #374151;
            background-color: #f3f4f6;
            border: 1px solid #d1d5db;
        }

        .status-unknown::before {
            background: var(--text-muted);
        }

        /* Highlight values */
        .highlight-value {
            background: linear-gradient(135deg, var(--secondary-blue) 0%, rgba(37, 99, 235, 0.1) 100%);
            padding: 4px 10px;
            border-radius: 6px;
            font-weight: 600;
            color: var(--primary-blue);
            border: 1px solid rgba(37, 99, 235, 0.2);
        }

        /* Nút quay lại */
        .back-button {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 24px;
            border-radius: 8px;
            border: 2px solid var(--primary-blue);
            background: var(--primary-blue);
            color: white;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.2);
        }

        .back-button:hover {
            background: var(--primary-blue-light);
            border-color: var(--primary-blue-light);
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
        }

        .back-button:active {
            transform: translateY(0);
        }

        .back-button i {
            font-size: 12px;
        }

        /* Thông báo không có dữ liệu */
        .no-data-message {
            text-align: center;
            padding: 48px 20px;
            color: var(--text-secondary);
            font-size: 16px;
            background: var(--bg-light);
            border-radius: 12px;
            border: 2px dashed var(--border-color);
        }

        .no-data-message i {
            font-size: 36px;
            color: var(--text-muted);
            margin-bottom: 12px;
            display: block;
        }

        /* Icons trong bảng */
        .user-list-table th i {
            color: var(--primary-blue);
            margin-right: 6px;
            font-size: 12px;
        }

        /* Responsive cho mobile */
        @media (max-width: 768px) {
            .content {
                margin: 16px;
                padding: 20px;
            }

            .user-list-title {
                font-size: 22px;
                margin-bottom: 24px;
            }

            .user-list-table th,
            .user-list-table td {
                padding: 12px 16px;
                font-size: 13px;
            }

            .user-list-table th {
                width: 120px;
            }

            .back-button {
                width: 100%;
                justify-content: center;
                padding: 14px 24px;
            }
        }

        /* Animation nhẹ */
        .content {
            animation: fadeIn 0.4s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .user-list-table tr {
            animation: slideIn 0.3s ease-out forwards;
            opacity: 0;
        }

        .user-list-table tr:nth-child(1) { animation-delay: 0.05s; }
        .user-list-table tr:nth-child(2) { animation-delay: 0.1s; }
        .user-list-table tr:nth-child(3) { animation-delay: 0.15s; }
        .user-list-table tr:nth-child(4) { animation-delay: 0.2s; }
        .user-list-table tr:nth-child(5) { animation-delay: 0.25s; }
        .user-list-table tr:nth-child(6) { animation-delay: 0.3s; }
        .user-list-table tr:nth-child(7) { animation-delay: 0.35s; }
        .user-list-table tr:nth-child(8) { animation-delay: 0.4s; }

        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateX(-10px);
            }
            to {
                opacity: 1;
                transform: translateX(0);
            }
        }
    </style>
</head>

<body>
    <div class="parent">
        <div class="div1">
            <jsp:include page="../../Layout/operator/SideBar.jsp"></jsp:include>
        </div>
        <div class="div2">
            <jsp:include page="../../Layout/operator/Header.jsp"></jsp:include>
        </div>
        
        <div class="content">
            <h2 class="user-list-title">Chi Tiết Người Dùng</h2>
            
            <c:choose>
                <c:when test="${roleId == 2 || roleId == 3 || roleId == 6}">
                    <table class="user-list-table">
                        <tr>
                            <th><i class="fas fa-user"></i>Tên người dùng</th>
                            <td><span class="highlight-value">${user.username}</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-envelope"></i>Email</th>
                            <td>${user.email}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-user-tag"></i>Vai trò</th>
                            <td><span class="highlight-value">${user.role.roleName}</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-toggle-on"></i>Trạng thái</th>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">
                                        <span class="status-pill status-active">Hoạt động</span>
                                    </c:when>
                                    <c:when test="${user.status == 'inactive'}">
                                        <span class="status-pill status-inactive">Ngưng hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-unknown">Không xác định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-calendar-plus"></i>Ngày tạo</th>
                            <td>${user.createdAt}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-calendar-edit"></i>Ngày cập nhật</th>
                            <td>${user.updatedAt}</td>
                        </tr>
                    </table>
                </c:when>
                
                <c:when test="${roleId == 4}">
                    <table class="user-list-table">
                        <tr>
                            <th><i class="fas fa-building"></i>Tên công ty</th>
                            <td><span class="highlight-value">${transportUnit.companyName}</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-phone"></i>Thông tin liên hệ</th>
                            <td>${transportUnit.contactInfo}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-toggle-on"></i>Trạng thái</th>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">
                                        <span class="status-pill status-active">Hoạt động</span>
                                    </c:when>
                                    <c:when test="${user.status == 'inactive'}">
                                        <span class="status-pill status-inactive">Ngưng hoạt động</span>
                                    </c:when>
                                    <c:when test="${user.status == 'pending'}">
                                        <span class="status-pill status-pending">Đang chờ xử lý</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-unknown">Không xác định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-calendar-plus"></i>Ngày tạo</th>
                            <td>${transportUnit.createdAt}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-map-marker-alt"></i>Địa điểm</th>
                            <td>${transportUnit.location}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-truck"></i>Số lượng xe</th>
                            <td><span class="highlight-value">${transportUnit.vehicleCount}</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-weight-hanging"></i>Sức chứa</th>
                            <td><span class="highlight-value">${transportUnit.capacity}</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-users"></i>Người bốc xếp</th>
                            <td>
                                <span class="status-pill ${transportUnit.loader ? 'status-active' : 'status-inactive'}">
                                    ${transportUnit.loader ? 'Có' : 'Không'}
                                </span>
                            </td>
                        </tr>
                    </table>
                </c:when>
                
                <c:when test="${roleId == 5}">
                    <table class="user-list-table">
                        <tr>
                            <th><i class="fas fa-warehouse"></i>Tên kho</th>
                            <td><span class="highlight-value">${storageUnit.warehouseName}</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-map-marker-alt"></i>Địa điểm</th>
                            <td>${storageUnit.location}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-toggle-on"></i>Trạng thái</th>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status == 'active'}">
                                        <span class="status-pill status-active">Hoạt động</span>
                                    </c:when>
                                    <c:when test="${user.status == 'inactive'}">
                                        <span class="status-pill status-inactive">Ngưng hoạt động</span>
                                    </c:when>
                                    <c:when test="${user.status == 'pending'}">
                                        <span class="status-pill status-pending">Đang chờ xử lý</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="status-pill status-unknown">Không xác định</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-calendar-plus"></i>Ngày tạo</th>
                            <td>${storageUnit.createdAt}</td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-expand-arrows-alt"></i>Diện tích</th>
                            <td><span class="highlight-value">${storageUnit.area} m²</span></td>
                        </tr>
                        <tr>
                            <th><i class="fas fa-users"></i>Số nhân viên</th>
                            <td><span class="highlight-value">${storageUnit.employee}</span></td>
                        </tr>
                    </table>
                </c:when>
                
                <c:otherwise>
                    <div class="no-data-message">
                        <i class="fas fa-exclamation-triangle"></i>
                        <p>Không tìm thấy thông tin chi tiết cho người dùng này.</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <button onclick="history.back()" class="back-button">
                <i class="fas fa-arrow-left"></i>
                Quay lại
            </button>
        </div>
    </div>
</body>
</html>
