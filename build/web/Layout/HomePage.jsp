<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="../css/HomePage.css">

    </head>
    <body>
        
        <div class="parent">
            <div class="div1"><jsp:include page="../Layout/SideBar.jsp"></jsp:include> </div>
            <div class="div2">  <jsp:include page="../Layout/Header.jsp"></jsp:include> </div>
            <div class="div3"> </div>
        </div>
    </body>
</html>