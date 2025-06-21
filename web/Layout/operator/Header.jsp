<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-custom navbar-mainbg">
            <a class="navbar-brand navbar-logo" href="http://localhost:8080/HouseMovingSystem/homeOperator" style="display: flex;"><img id="imgId" src="img/logo.jpg" style="width: 254px;height: 64px !important;border-radius: 15px;"/></a>
            <button class="navbar-toggler" type="button" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <i class="fas fa-bars text-white"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ml-auto">
                    <div class="hori-selector"><div class="left"></div><div class="right"></div></div>
                    <li class="nav-item active">
                        <a class="nav-link" href="javascript:void(0);"><i class="far fa-address-book"></i>Tài Khoản</a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="javascript:void(0);"><i class="far fa-address-book"></i>Tài Khoản</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="javascript:void(0);"><i class="far fa-copy"></i>Đăng Xuất</a>
                    </li>
                </ul>
            </div>
        </nav>

<!--         jQuery + Bootstrap JS 
-->        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <!-- Custom JS -->
        <script src="${pageContext.request.contextPath}/js/Header.js"></script>
    </body>
</html>