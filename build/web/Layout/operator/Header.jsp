<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Header</title>
        <!-- Bootstrap 5 CSS (đồng bộ với Order.jsp) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons (để hiển thị icon bi-person-circle, bi-box-arrow-right) -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <!-- Font Awesome (giữ lại cho các icon khác nếu cần) -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-lg navbar-mainbg">
            <div class="container-fluid">
                <a class="navbar-brand navbar-logo" href="${pageContext.request.contextPath}/homeOperator">
                    <img src="${pageContext.request.contextPath}/img/logo.jpg" alt="Logo" style="width: 254px; height: 64px; border-radius: 15px;" />
                </a>
                <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                    <span class="navbar-toggler-icon"></span>
                </button>
                <div class="collapse navbar-collapse" id="navbarSupportedContent">
                    <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                        <div class="hori-selector"></div>                      
                        <li class="nav-item">
                            <a class="nav-link" href="javascript:void(0);"><i class="bi bi-person-circle"></i> Tài Khoản</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right"></i> Đăng Xuất</a>
                        </li>
                    </ul>
                </div>
            </div>
        </nav>

        <!-- jQuery và Bootstrap 5 JS (đồng bộ với Order.jsp) -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <%-- Sửa đường dẫn JS thành tuyệt đối --%>
        <script src="${pageContext.request.contextPath}/js/Header.js"></script>

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
                $('[data-bs-toggle="tooltip"]').tooltip();
            });
        </script>
    </body>
</html>
        <!-- Custom JS -->
        <script src="../js/Header.js"></script>
    </body>
</html>
