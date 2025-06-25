<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
// Kiểm tra session
String redirectURL = null;
if (session.getAttribute("acc") == null) {
    redirectURL = "/login";
    response.sendRedirect(request.getContextPath() + redirectURL);
    return;
}
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Báo cáo Hiệu suất Kho bãi</title>

    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../../Layout/operator/SideBar.jsp"></jsp:include>
            </div>
            <div class="div2">
                <jsp:include page="../../../Layout/operator/Header.jsp"></jsp:include>
            </div>
            <div class="div3">
            <jsp:include page="../reportSummary/CostAndProfitReport.jsp"></jsp:include>
            </div>
        </div>    

    </body>
</html>