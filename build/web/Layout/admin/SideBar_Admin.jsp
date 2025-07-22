<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@page contentType="text/html" pageEncoding="UTF-8"%> 
<!DOCTYPE html> 
<html lang="en"> 
    <head> 
        <meta charset="UTF-8" /> 
        <meta http-equiv="X-UA-Compatible" content="IE=edge" /> 
        <meta name="viewport" content="width=device-width, initial-scale=1.0" /> 
        <title>Sidebar Menu | Side Navigation Bar</title> 
        <link 
            href="https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css" 
            rel="stylesheet" 
            /> 
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css"> 
    </head> 
    <body> 

        <!-- Boxicons CSS -->
        <link
            href="https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css"
            rel="stylesheet"
            />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
    </head>
    <body>

        <!-- Sidebar -->
        <div class="sidebar">

            <div class="sidebar-content">
                <ul class="lists">
                    
                    
                    
                    <li class="list ">
                        <a href="${pageContext.request.contextPath}/admin/system-performance" class="nav-link">
                            <i class="bx bx-bar-chart-alt-2 icon"></i>
                            <span class="link">Hiệu Suất </span>
                            
                        </a>
                        
                    </li>
                    
                    
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/admin/session-logs" class="nav-link">
                            <i class="bx bx-pie-chart-alt-2 icon"></i>
                            <span class="link">Hoạt Động</span>
                        </a>
                    </li>
                    
                    <li class="list">
                        <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                            <i class="bx bx-log-out icon"></i>
                            <span class="link">Logout</span>
                        </a>
                    </li>
                </ul>

            </div>
        </div>

        
    </body>
</html>