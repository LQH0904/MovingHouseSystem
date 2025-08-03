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
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<html>
    <head>
        <title>Chi Tiết Người Dùng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/UserList.css">
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
                            <tr><th>Tên người dùng</th><td>${user.username}</td></tr>
                            <tr><th>Email</th><td>${user.email}</td></tr>
                            <tr><th>Vai trò</th><td>${user.role.roleName}</td></tr>
                            <tr>
                                <th>Trạng thái</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 'active'}">Đang hoạt động</c:when>
                                        <c:when test="${user.status == 'inactive'}">Ngưng hoạt động</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>

                            <tr><th>Ngày tạo</th><td>${user.createdAt}</td></tr>
                            <tr><th>Ngày cập nhật</th><td>${user.updatedAt}</td></tr>
                        </table>
                    </c:when>

                    <c:when test="${roleId == 4}">
                        <table class="user-list-table">
                            <tr><th>Tên công ty</th><td>${transportUnit.companyName}</td></tr>
                            <tr><th>Thông tin liên hệ</th><td>${transportUnit.contactInfo}</td></tr>
                            <tr>
                                <th>Trạng thái</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 'active'}">Đang hoạt động</c:when>
                                        <c:when test="${user.status == 'inactive'}">Ngưng hoạt động</c:when>
                                        <c:when test="${user.status == 'pending'}">Đang chờ xử lý</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr><th>Ngày tạo</th><td>${transportUnit.createdAt}</td></tr>
                            <tr><th>Địa điểm</th><td>${transportUnit.location}</td></tr>
                            <tr><th>Số lượng xe</th><td>${transportUnit.vehicleCount}</td></tr>
                            <tr><th>Sức chứa</th><td>${transportUnit.capacity}</td></tr>
                            <tr><th>Người bốc xếp</th><td>${transportUnit.loader}</td></tr>
                            <tr><th>Giấy phép kinh doanh</th><td>${transportUnit.businessCertificate}</td></tr>
                            <tr><th>Bảo hiểm</th><td>${transportUnit.insurance}</td></tr>
                        </table>
                    </c:when>

                    <c:when test="${roleId == 5}">
                        <table class="user-list-table">
                            <tr><th>Tên kho</th><td>${storageUnit.warehouseName}</td></tr>
                            <tr><th>Địa điểm</th><td>${storageUnit.location}</td></tr>
                            <tr>
                                <th>Trạng thái</th>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.status == 'active'}">Đang hoạt động</c:when>
                                        <c:when test="${user.status == 'inactive'}">Ngưng hoạt động</c:when>
                                        <c:when test="${user.status == 'pending'}">Đang chờ xử lý</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr><th>Ngày tạo</th><td>${storageUnit.createdAt}</td></tr>
                            <tr><th>Giấy phép KD</th><td>${storageUnit.businessCertificate}</td></tr>
                            <tr><th>Diện tích</th><td>${storageUnit.area}</td></tr>
                            <tr><th>Số nhân viên</th><td>${storageUnit.employee}</td></tr>
                            <tr><th>SĐT</th><td>${storageUnit.phoneNumber}</td></tr>
                        </table>
                    </c:when>

                    <c:otherwise>
                        <p>Không tìm thấy thông tin chi tiết cho người dùng này.</p>
                    </c:otherwise>
                </c:choose>

                <br><button onclick="history.back()" class="add-user-btn">Quay lại</button>
            </div>
        </div>
    </div>
</body>
</html>
