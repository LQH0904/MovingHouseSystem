<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html>
<head>
    <title>Lỗi Hệ Thống</title>
</head>
<body style="font-family: Arial; background-color: #f8d7da; padding: 20px;">
    <h2 style="color: #721c24;">Lỗi xảy ra:</h2>
    <pre style="background: #f1b0b7; padding: 10px; border-radius: 5px;">
${errorMessage}
    </pre>
    <a href="javascript:history.back()">Quay lại</a>
</body>
</html>
