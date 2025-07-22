<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="java.util.*, model.UserSessionInfo, listener.SessionTracker" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">

    </head>
    <body>
        
        <div class="parent">
            <div class="div1"><jsp:include page="/Layout/operator/SideBar.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="/Layout/operator/Header.jsp"></jsp:include> </div>
            <div class="div3"> 
                <h2>Danh sách user đã login/logout</h2>
    <table border="1">
        <c:if test="${empty sessionScope.sessionLogs}">
    <p>Chưa có session nào được ghi lại.</p>
   </c:if>
        <tr>
            <th>Username</th>
            <th>Login Time</th>
            <th>Logout Time</th>
        </tr>
        <%
            for (UserSessionInfo info : SessionTracker.sessionLogs) {
        %>
        <tr>
            <td><%= info.getUsername() %></td>
            <td><%= info.getLoginTime() %></td>
            <td><%= info.getLogoutTime() != null ? info.getLogoutTime() : "Đang hoạt động" %></td>
        </tr>
        <%
            }
        %>
    </table>
            </div>
        </div>
    </body>
</html>