<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Transport Process</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/operator/TransportProcess.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

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

                            <!-- Line 1 -->
                            <a href="#" class="line-clickable" data-target="detail1"></a>

                            <div class="step">
                                <div class="circle">2</div>
                                <div class="label">Kho</div>
                            </div>

                            <!-- Line 2 -->
                            <a href="#" class="line-clickable" data-target="detail2"></a>

                            <div class="step">
                                <div class="circle">3</div>
                                <div class="label">Địa chỉ trả</div>
                            </div>
                        </div>

                        <!-- Khối chi tiết 1: Địa chỉ nhận -> Kho -->
                        <div id="detail1" class="detail-box" style="display: none;">
                            <h4>Thông tin: Địa chỉ nhận → Kho</h4>
                            <p><strong>Địa chỉ nhận:</strong> 123 Láng Hạ, Hà Nội</p>
                            <p><strong>Ngày nhận:</strong> 15/06/2025</p>
                            <p><strong>Ngày nhập kho:</strong> 16/06/2025</p>
                            <iframe 
                                src="https://www.google.com/maps/embed?pb=!1m28!1m12!1m3!1d14898.806800799142!2d105.51549388975474!3d21.00459132221299!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m13!3e6!4m5!1s0x31345b996e8db849%3A0xe69a2e597e2e3382!2zS2h1IHF1w6JuIHPhu7EgxJBIUUcgSG_DoCBM4bqhYyAoSG9sYSk!3m2!1d20.999808599999998!2d105.5194564!4m5!1s0x31345b12ef6dfebd%3A0xca27c2be63cf4db4!2zVHJ1bmcgVMOibSDEkOG7lWkgTeG7m2kgU8OhbmcgVOG6oW8gUXXhu5Fj4oCm!3m2!1d21.0106543!2d105.5316046!5e0!3m2!1sen!2s!4v1750173648646!5m2!1sen!2s" 
                                style="width: 100%; height: 600px; border: none;" 
                                allowfullscreen 
                                referrerpolicy="no-referrer-when-downgrade">
                            </iframe>
                        </div>

                        <!-- Khối chi tiết 2: Kho -> Địa chỉ trả -->
                        <div id="detail2" class="detail-box" style="display: none;">
                            <h4>Thông tin: Kho → Địa chỉ trả</h4>
                            <p><strong>Địa chỉ kho:</strong> Kho Hà Nội - Mỹ Đình</p>
                            <p><strong>Ngày nhập kho:</strong> 16/06/2025</p>
                            <p><strong>Địa chỉ trả:</strong> 789 Cầu Giấy, Hà Nội</p>
                            <p><strong>Ngày trả:</strong> 17/06/2025</p>
                            <iframe 
                                src="https://www.google.com/maps/embed?pb=!1m24!1m12!1m3!1d238385.53608285185!2d105.50995151955694!3d21.001694491153074!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!4m9!3e0!4m3!3m2!1d21.0002043!2d105.5206437!4m3!3m2!1d21.0002392!2d105.82909289999999!5e0!3m2!1sen!2s!4v1750173765352!5m2!1sen!2s" 
                                style="width: 100%; height: 600px; border: none;" 
                                allowfullscreen 
                                referrerpolicy="no-referrer-when-downgrade">
                            </iframe>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </body>
    <script src="${pageContext.request.contextPath}/js/operator/TransportProcess.js"></script>
</html>
