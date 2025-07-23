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
                        <a href="${pageContext.request.contextPath}/UserListServlet" class="nav-link">
                            <i class="bx bx-home-alt icon"></i>
                            <span class="link">Người dùng</span>
                        </a>
                    </li>

                    <c:if test="${sessionScope.acc != null && (sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 3)}">
                        
                        <li class="list">
                            <a href="${pageContext.request.contextPath}/exportData" class="nav-link">
                                <i class="bx bx-export icon"></i>
                                <span class="link">Xuất dữ liệu</span>
                            </a>
                        </li>
                    </c:if>
                    <li class="list has-submenu">
                        <a href="#" class="nav-link" onclick="toggleSubmenu(event)">
                            <i class="bx bx-bar-chart-alt-2 icon"></i>
                            <span class="link">Báo Cáo </span>
                            <i class="bx bx-chevron-down arrow"></i>
                        </a>
                        <ul class="submenu">
                            <li class="submenu-item">
                                <a href="http://localhost:9999/HouseMovingSystem/transportReport" class="submenu-link">
                                    <i class="bx bx-calendar icon"></i>
                                    <span class="link">Báo Cáo Vận Chuyển </span>
                                </a>
                            </li>
                            <li class="submenu-item">
                                <a href="http://localhost:9999/HouseMovingSystem/StorageReportController" class="submenu-link">
                                    <i class="bx bx-calendar-week icon"></i>
                                    <span class="link">Báo Cáo Kho Bãi </span>
                                </a>
                            </li>
                            <li class="submenu-item">
                                <a href="http://localhost:9999/HouseMovingSystem/SurveyCustomerCharController?action=page" class="submenu-link">
                                    <i class="bx bx-calendar-alt icon"></i>
                                    <span class="link">Báo Cáo Khách Hàng </span>
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/orderList" class="nav-link">
                            <i class="bx bx-bell icon"></i>
                            <span class="link">Đơn Hàng</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/ComplaintServlet" class="nav-link">
                            <i class="bx bx-pie-chart-alt-2 icon"></i>
                            <span class="link">Khiếu Nại</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/SurveyTestController" class="nav-link">
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">Thử phiếu khảo sát</span>
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <script src="${pageContext.request.contextPath}/js/SideBar.js"></script>
        <script>
            function toggleSubmenu(event) {
                event.preventDefault();
                const listItem = event.currentTarget.parentElement;
                const submenu = listItem.querySelector('.submenu');
                const arrow = listItem.querySelector('.arrow');
                
                // Toggle active class
                listItem.classList.toggle('active');
                
                // Rotate arrow
                if (listItem.classList.contains('active')) {
                    arrow.style.transform = 'rotate(180deg)';
                    submenu.style.maxHeight = submenu.scrollHeight + 'px';
                } else {
                    arrow.style.transform = 'rotate(0deg)';
                    submenu.style.maxHeight = '0px';
                }
            }
        </script>
    </body>
</html>