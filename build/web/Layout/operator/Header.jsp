<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>

        <link href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" rel="stylesheet">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=UnifrakturMaguntia&display=swap" rel="stylesheet">

        <%-- Sửa đường dẫn CSS thành tuyệt đối --%>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
    </head>
    <body>
        <nav class="navbar navbar-expand-custom navbar-mainbg">
            <a class="navbar-brand navbar-logo" href="http://localhost:9999/HouseMovingSystem/homeOperator" style="display: flex;"><img id="imgId" src="${pageContext.request.contextPath}/img/logo.jpg" style="width: 254px;height: 64px !important;border-radius: 15px;"/></a>
            <button class="navbar-toggler" type="button" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <i class="fas fa-bars text-white"></i>
            </button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <div style="color: white;font-family: 'UnifrakturMaguntia', cursive;font-size: 30px;"> chào mừng đến trang dành cho điều hành viên </div>
                <ul class="navbar-nav ml-auto">
                    <li class="hori-selector">
                        <div class="left"></div>
                        <div class="right"></div>
                            
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

        <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

        <%-- Sửa đường dẫn JS thành tuyệt đối --%>
        <script src="${pageContext.request.contextPath}/js/Header.js"></script>
    </body>
</html>