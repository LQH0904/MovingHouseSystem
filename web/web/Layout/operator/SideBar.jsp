<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Sidebar Menu | Side Navigation Bar</title>
        <!-- CSS -->

        <!-- Boxicons CSS -->
        <link
            href="https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">

            <div class="sidebar-content">
                <ul class="lists">
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/UserListServlet" class="nav-link">
                            <i class="bx bx-home-alt icon"></i>
                            <span class="link">Người dùng</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/repURL" class="nav-link">
                            <i class="bx bx-bar-chart-alt-2 icon"></i>
                            <span class="link">Báo Cáo Doanh Thu </span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="#" class="nav-link">
                            <i class="bx bx-bell icon"></i>
                            <span class="link">Đơn Hàng </span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/invRURL" class="nav-link">
                            <i class="bx bx-message-rounded icon"></i>
                            <span class="link">Báo Cáo Tồn Kho </span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/ComplaintServlet" class="nav-link">
                            <i class="bx bx-pie-chart-alt-2 icon"></i>
                            <span class="link">Khiếu Nại</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/operator/listApplication" class="nav-link">
                            <i class="bx bx-heart icon"></i>
                            <span class="link">Duyệt Đơn</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="#" class="nav-link">
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">Files</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="javascript:void(0);" class="nav-link" onclick="toggleSubMenu('policy-submenu')">
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">Chính sách</span>
                            <i class="bx bx-chevron-down" style="margin-left:auto;"></i>
                        </a>
                        <ul class="sub-menu" id="policy-submenu" style="display:none; padding-left: 25px;">
                            <li><a href="${pageContext.request.contextPath}/operation-procedure">Quy trình hoạt động</a></li>
                            <li><a href="${pageContext.request.contextPath}/operation-policy">Chính sách hoạt động</a></li>
                            <li><a href="${pageContext.request.contextPath}/config-fee">Cấu hình phí</a></li>
                        </ul>
                    </li>

                    <li class="list">
                        <a href="#" class="nav-link">
                            <i class="bx bx-cog icon"></i>
                            <span class="link">Settings</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                            <i class="bx bx-log-out icon"></i>
                            <span class="link">Logout</span>
                        </a>
                    </li>
                </ul>

            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/SideBar.js"></script>
<script>
    function toggleSubMenu(id) {
        const submenu = document.getElementById(id);
        if (submenu.style.display === "none") {
            submenu.style.display = "block";
        } else {
            submenu.style.display = "none";
        }
    }
</script>

    </body>
</html>