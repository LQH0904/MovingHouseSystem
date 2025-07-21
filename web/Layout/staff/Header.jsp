<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <!-- Bootstrap 4 CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <style>
            .hori-selector {
                display: inline-block;
                position: absolute;
                height: 100%;
                top: 0;
                left: 0;
                background-color: rgba(255, 255, 255, 0.6); 
                border-top-left-radius: 15px;
                border-top-right-radius: 15px;
                margin-top: 10px;
                transition-duration: 0.6s;
                transition-timing-function: cubic-bezier(0.68, -0.55, 0.265, 1.55);
                z-index: 0; 
            }

        </style>
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-mainbg">
            <div class="container-fluid">
                <a class="navbar-brand navbar-logo" href="${pageContext.request.contextPath}/homeStaff">
                    <img src="${pageContext.request.contextPath}/img/logo.jpg" alt="Logo" style="width: 254px; height: 64px; border-radius: 15px;" />
                </a>
                <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ml-auto mb-2 mb-lg-0">
                        <div class="hori-selector"></div>
                        <c:if test="${sessionScope.acc != null && (sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2)}">
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/analyz"><i class="bi bi-bar-chart-fill"></i>Phân tích Báo cáo</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/sendNotification"><i class="bi bi-send-fill"></i>Gửi Thông báo</a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link" href="${pageContext.request.contextPath}/notifications"><i class="bi bi-bell-fill"></i>Thông báo</a>
                            </li>
                        </c:if>
                        <li class="nav-item">
                            <a class="nav-link" href="javascript:void(0);"><i class="bi bi-person-circle"></i>Tài Khoản</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i>Đăng Xuất</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- jQuery + Bootstrap JS (đặt trước custom script) -->
        <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            $(document).ready(function () {
                function updateHoriSelector() {
                    var tabsNewAnim = $('#navbarSupportedContent');
                    var activeItemNewAnim = tabsNewAnim.find('.nav-item.active');
                    if (activeItemNewAnim.length === 0) {
                        activeItemNewAnim = tabsNewAnim.find('.nav-item:first');
                        activeItemNewAnim.addClass('active');
                    }
                    var activeWidthNewAnimHeight = activeItemNewAnim.innerHeight();
                    var activeWidthNewAnimWidth = activeItemNewAnim.innerWidth();
                    var itemPosNewAnim = activeItemNewAnim.position();
                    $(".hori-selector").css({
                        "top": itemPosNewAnim.top + "px",
                        "left": itemPosNewAnim.left + "px",
                        "height": activeWidthNewAnimHeight + "px",
                        "width": activeWidthNewAnimWidth + "px"
                    });
                }

                $("#navbarSupportedContent").on("click", "li", function (e) {
                    $('#navbarSupportedContent ul li').removeClass("active");
                    $(this).addClass('active');
                    updateHoriSelector();
                });

                setTimeout(function () {
                    updateHoriSelector();
                }, 100);
                $(window).on('resize', function () {
                    setTimeout(function () {
                        updateHoriSelector();
                    }, 400);
                });

                $(".navbar-toggler").click(function () {
                    $(".navbar-collapse").slideToggle(300);
                    setTimeout(function () {
                        updateHoriSelector();
                    }, 300);
                });

                var path = window.location.pathname.split("/").pop();
                if (path === '' || path === 'HouseMovingSystem') {
                    path = 'homeOperator';
                }
                var target = $('#navbarSupportedContent ul li a[href*="' + path + '"]');
                if (target.length > 0) {
                    $('#navbarSupportedContent ul li').removeClass('active');
                    target.parent().addClass('active');
                } else {
                    $('#navbarSupportedContent ul li:first').addClass('active'); 
                }
                updateHoriSelector();
                $('[data-toggle="tooltip"]').tooltip();
            });
        </script>

        <script src="${pageContext.request.contextPath}/js/Header.js"></script> 

    </body>
</html>
