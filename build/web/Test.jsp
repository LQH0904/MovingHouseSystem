<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
    <title>Header + Menu Layout Fix Overflow</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
    <style>
        html, body {
            overflow-x: hidden;
            margin: 0; padding: 0;
            box-sizing: border-box;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            background: #f8f9fa;
            height: 100%;
        }
        .main-content {
            margin-left: 220px; 
            margin-top: 60px; 
            padding: 20px;
            max-width: calc(100vw - 220px);
            box-sizing: border-box;
            background-color: #fff;
            min-height: calc(100vh - 60px);
        }
    </style>
</head>
<body>

    <jsp:include page="Common/Header.jsp" />
    <jsp:include page="Common/Menu.jsp" />

    <div class="main-content">
        <h2>Main Content Area</h2>
        <p>Phần này bạn sẽ đổ nội dung chính vào, hiện giờ để test layout.</p>
    </div>

</body>
</html>