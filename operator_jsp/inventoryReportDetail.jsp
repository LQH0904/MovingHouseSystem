<%-- 
    Document   : inventoryReportDetail
    Created on : May 30, 2025, 10:10:50 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/showInventoryReportDetail.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <div class="img_log">
                    ảnh đăng nhập
                </div>
                <div class="worklink">
                    <a id="id1" href='http://localhost:8435/HouseMovingSystem/invRURL' style="background-color: red; color: white;">báo cáo doanh thu</a>
                    <a id="id1" href='http://localhost:8435/HouseMovingSystem/repURL'>báo cáo tổng quan</a>
                </div>
                
            </div>
            <div class="div2">
                <a id="icon" href="http://localhost:8435/HouseMovingSystem/homeOperator" class="fa-solid fa-home"></a>
                <i id="icon2" class="fa-solid fa-gear"></i>
            </div>
            <div class="div3">
                <%@ page import="entity.InventoryReports, java.util.Vector" %>
                <%
                  Vector<InventoryReports> vector =
                      (Vector<InventoryReports>) request.getAttribute("invReportDetail");
                  if (vector == null) vector = new Vector<>();
                %>

                <p>chi tiết báo cáo</p>
                <form action="invRURL" method="">
                    <input type="hidden" name="service" value="viewDetail"/>
                    <table>
                        <% for (InventoryReports invReports : vector) {%>
                        <tr>
                            <td class="td1">ngày tạo: </td>
                            <td><%= invReports.getCreatedAt().substring(0, 10) %></td>
                        </tr>
                        <tr>
                            <td class="td1">tiêu đề: </td>
                            <td><%=invReports.getTitle()%></td>
                        </tr>
                        <tr>
                            <td class="td1">nội dung báo cáo: </td>

                        </tr>
                        <tr>
                            <td class="td1"></td>
                            <td class="tdinvRdiv3" id="td2"><%=invReports.getInventoryDetails()%></td>
                        </tr>
                        <%}%>
                    </table>
                </form>
                <p>
                    <button onclick="window.location.href = 'http://localhost:8435/HouseMovingSystem/invRURL'">quay lại</button>
                    <button>xác nhận</button>
                    <button>gửi thông báo</button>
                </p>

            </div>
        </div>
        
    </body>
</html>
