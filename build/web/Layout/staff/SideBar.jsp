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
                        <a href="${pageContext.request.contextPath}/CustomerListServlet" class="nav-link">
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
<<<<<<< HEAD
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">Thử phiếu khảo sát</span>
                        </a>
                    </li>
                   
                    <li class="list">
                        <a href="javascript:void(0);" class="nav-link" onclick="toggleSubMenu('policy-submenu')">
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">Câu hỏi</span>
                            <i class="bx bx-chevron-down" style="margin-left:auto;"></i>
=======
                            <i class="bx bx-folder-open icon"></i>
                            <span class="link">Thử phiếu khảo sát</span>
>>>>>>> origin/DucVer2
                        </a>
                        <ul class="sub-menu" id="policy-submenu" style="display:none; padding-left: 25px;">
                            <li><a href="${pageContext.request.contextPath}/staff/faq-list">Câu hỏi thường gặp</a></li>
                            <li><a href="${pageContext.request.contextPath}/staff/chat-bot-log">Câu hỏi của khách hàng</a></li>
                            
                        </ul>
                    </li>
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/staff-promotions" class="nav-link">
                            <i class="bx bx-gift icon"></i>
                            <span class="link">Gợi ý khuyến mãi</span>
                        </a>
                    </li>
<<<<<<< HEAD
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/staff-leave" class="nav-link">
                            <i class="bx bx-calendar-check icon"></i>
                            <span class="link">Đơn nghỉ phép</span>
                        </a>
                    </li>


                    
=======
>>>>>>> origin/DucVer2
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
<<<<<<< HEAD
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
=======
>>>>>>> origin/DucVer2
    </body>
</html>