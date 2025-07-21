<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html> 
<html lang="en"> 
    <head> 
        <meta charset="UTF-8" /> 
        <meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
        <meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
        <title>Sidebar Menu | Side Navigation Bar</title> 
        <link href="https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css" rel="stylesheet" />
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
                    <c:if test="${sessionScope.acc != null && (sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2)}">
                        <li class="list">
                            <a href="${pageContext.request.contextPath}/analyz" class="nav-link">
                                <i class="bx bx-pie-chart-alt-2 icon"></i>
                                <span class="link">Phân tích Báo cáo</span>
                            </a>
                        </li>
                        <li class="list">
                            <a href="${pageContext.request.contextPath}/sendNotification" class="nav-link">
                                <i class="bx bx-message-rounded icon"></i>
                                <span class="link">Gửi Thông báo</span>
                            </a>
                        </li>
                        <li class="list">
                            <a href="${pageContext.request.contextPath}/notifications" class="nav-link">
                                <i class="bx bx-bell icon"></i>
                                <span class="link">Thông báo</span>
                            </a>
                        </li>
                    </c:if>

                    <!-- Menu có submenu -->
                    <li class="list has-submenu">
                        <a href="#" class="nav-link" onclick="toggleSubmenu(event)">
                            <i class="bx bx-bar-chart-alt-2 icon"></i>
                            <span class="link">Báo Cáo </span>
                            <i class="bx bx-chevron-down arrow"></i>
                        </a>
                        <ul class="submenu">
                            <li class="submenu-item">
                                <a href="http://localhost:9999/HouseMovingSystem/LogViewerServlet" class="submenu-link">
                                    <i class="bx bx-calendar icon"></i>
                                    <span class="link"> admin </span>
                                </a>
                            </li>
                            <li class="submenu-item">
                                <a href="http://localhost:9999/HouseMovingSystem/StorageReportController" class="submenu-link">
                                    <i class="bx bx-calendar-week icon"></i>
                                    <span class="link"> Bãi </span>
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
                            <i class="bx bx-calendar-alt icon"></i>
                            <span class="link">Đơn Hàng</span>
                        </a>
                    </li>
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/ComplaintServlet" class="nav-link">
                            <i class="bx bx-pie-chart-alt-2 icon"></i>
                            <span class="link">Danh sách khiếu nại</span>
                        </a>
                   
                            
                    <li class="list">
                        <a href="http://localhost:9999/HouseMovingSystem/customer-survey" class="nav-link">
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">mẫu survey</span>
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
                </ul>

            </div>
        </div>

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