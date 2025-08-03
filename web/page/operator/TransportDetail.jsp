<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Chi Tiết Người Dùng</title>
    <%-- Thêm CSS của bạn ở đây nếu cần --%>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        .container { border: 1px solid #ccc; padding: 15px; border-radius: 5px; }
        .image-section img { max-width: 500px; border: 1px solid #ddd; padding: 5px; }
    </style>
</head>
<body>

    <div class="container">
        <h1>Chi Tiết Người Dùng</h1>
        <hr>

        <c:choose>
            <%-- ========== KHI VAI TRÒ LÀ STORAGE UNIT (roleId = 5) ========== --%>
            <c:when test="${roleId == 5}">
                <h2>Thông Tin Đơn Vị Lưu Kho</h2>

                <c:if test="${not empty storageUnit}">
                    <p><strong>Tên kho:</strong> ${storageUnit.warehouseName}</p>
                    <p><strong>Địa chỉ:</strong> ${storageUnit.location}</p>
                    <p><strong>Trạng thái:</strong> ${storageUnit.registrationStatus}</p>

                    <div class="image-section">
                        <h3>Giấy phép kinh doanh</h3>
                        <c:if test="${not empty storageUnit.businessCertificate}">
                            <%-- ĐÂY LÀ DÒNG QUAN TRỌNG NHẤT --%>
                            <img src="${pageContext.request.contextPath}${storageUnit.businessCertificate}" alt="Hình ảnh Giấy phép kinh doanh">
                        </c:if>
                    </div>

                    <div class="image-section">
                        <h3>Bảo hiểm</h3>
                        <c:if test="${not empty storageUnit.insurance}">
                            <img src="${pageContext.request.contextPath}${storageUnit.insurance}" alt="Hình ảnh Bảo hiểm">
                        </c:if>
                    </div>
                    
                    <div class="image-section">
                        <h3>Sơ đồ mặt bằng</h3>
                        <c:if test="${not empty storageUnit.floorPlan}">
                            <img src="${pageContext.request.contextPath}${storageUnit.floorPlan}" alt="Hình ảnh Sơ đồ mặt bằng">
                        </c:if>
                    </div>

                </c:if>
            </c:when>

            <%-- ========== KHI VAI TRÒ LÀ TRANSPORT UNIT (roleId = 4) ========== --%>
            <c:when test="${roleId == 4}">
                 <h2>Thông Tin Đơn Vị Vận Chuyển</h2>
                 <c:if test="${not empty transportUnit}">
                    <%-- Nếu Transport Unit cũng lưu ảnh trên server, bạn cũng phải thêm ${pageContext.request.contextPath} vào trước link ảnh --%>
                    <%-- Ví dụ: <img src="${pageContext.request.contextPath}${transportUnit.businessCertificate}"> --%>
                    <%-- Nếu Transport Unit dùng Cloudinary, bạn chỉ cần <img src="${transportUnit.businessCertificate}"> --%>
                 </c:if>
            </c:when>

            <%-- CÁC VAI TRÒ CÒN LẠI --%>
            <c:otherwise>
                <h2>Thông Tin Người Dùng Cơ Bản</h2>
                 <c:if test="${not empty user}">
                     <p><strong>Tên người dùng:</strong> ${user.username}</p>
                     <p><strong>Email:</strong> ${user.email}</p>
                 </c:if>
            </c:otherwise>
        </c:choose>
    </div>

</body>
</html>