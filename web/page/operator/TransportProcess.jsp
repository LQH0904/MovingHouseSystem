<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Transport Process</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/TransportProcess.css">
        <style>

        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"/></div>
            <div class="div2"><jsp:include page="/Layout/operator/Header.jsp"/></div>
            <div class="div3">
                <div class="container">
                    <div class="card">
                        <h3>Thông tin đơn hàng</h3>
                        <div class="info-row">
                            <div class="info-col">
                                <label>ID Đơn hàng:</label>
                                <p>DH00123</p>
                            </div>
                            <div class="info-col">
                                <label>Đơn vị vận chuyển:</label>
                                <p>Giao hàng Tiết kiệm</p>
                            </div>
                            <div class="info-col">
                                <label>Kho bãi:</label>
                                <p>Kho Hà Nội - Mỹ Đình</p>
                            </div>
                            <div class="info-col">
                                <label>Khách hàng:</label>
                                <p>Nguyễn Văn A - 0901234567</p>
                            </div>
                            <div class="info-col">
                                <label>Ngày nhận đồ:</label>
                                <p>15/06/2025</p>
                            </div>
                            <div class="info-col">
                                <label>Ngày chuyển đồ:</label>
                                <p>16/06/2025</p>
                            </div>
                        </div>
                    </div>

                    <div class="card">
                        <h3>Quy trình vận chuyển</h3>
                    <div class="process-container">
    <div class="step">
        <div class="circle">1</div>
        <div class="label">Địa chỉ nhận</div>
    </div>

    <a href="#" class="line-clickable"></a>

    <div class="step">
        <div class="circle">2</div>
        <div class="label">Kho</div>
    </div>

    <a href="#" class="line-clickable"></a>

    <div class="step">
        <div class="circle">3</div>
        <div class="label">Địa chỉ trả</div>
    </div>
</div>

                        <iframe 
                            src="https://www.google.com/maps/embed?pb=!1m28!1m12!1m3!1d3723.7362570131716!2d105.8463162153713!3d21.036237892676062!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m13!3e0!4m5!1s0x3135ab8b3af41f21%3A0xf3c66e5bc62e9c2!2zSG_DoCBHw7JuLCBIw7MgTuG7mWksIFZpZXRuYW0!3m2!1d21.028511!2d105.804817!4m5!1s0x3135abc60e7d3f19%3A0x2be9d7d0b5abcbf4!2zRlBUIFVuaXZlcnNpdHkgxJDhu5FuZyBIw6Bu!3m2!1d21.0157859!2d105.5251909!5e0!3m2!1svi!2s!4v1750092236000!5m2!1svi!2s" 
                            allowfullscreen 
                            referrerpolicy="no-referrer-when-downgrade">
                        </iframe>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
