<%-- 
    Document   : reportDetail
    Created on : May 31, 2025, 10:13:26 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/showInventoryReportDetail.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <div class="img_log">
                    ảnh đăng nhập
                </div>
                <div class="worklink">
                    <a id="id1" href='http://localhost:8436/HouseMovingSystem/invRURL'>báo cáo doanh thu</a>
                    <a id="id1" href='http://localhost:8436/HouseMovingSystem/repURL' style="background-color: red; color: white;">báo cáo tổng quan</a>
                </div>
                
            </div>
            <div class="div2">mau 2</div>
            <div class="div3">
                <%@ page import="entity.Reports, java.util.Vector" %>
                <%
                  Vector<Reports> vector =
                      (Vector<Reports>) request.getAttribute("reportDetail");
                  if (vector == null) vector = new Vector<>();
                %>

                <p>chi tiết báo cáo</p>
                <form action="repURL" method="">
                    <input type="hidden" name="service" value="viewDetail"/>
                    <table>
                        <% for (Reports reports : vector) {%>
                        <tr>
                            <td class="td1">ngày tạo: </td>
                            <td><%= reports.getCreatedAt().substring(0, 10) %></td>
                        </tr>
                        <tr>
                            <td class="td1">tiêu đề: </td>
                            <td><%=reports.getTitle()%></td>
                        </tr>
                        <tr>
                            <td class="td1">nội dung báo cáo: </td>

                        </tr>
                        <tr>
                            <td class="td1"></td>
                            <td class="tdinvRdiv3" id="td2"><%=reports.getData()%></td>
                        </tr>
                        <%}%>
                    </table>
                </form>
                <p>
                    <button onclick="window.location.href = 'http://localhost:8436/HouseMovingSystem/repURL'">quay lại</button>
                    <button>xác nhận</button>
                    <button>gửi thông báo</button>
                </p>

            </div>
        </div>

    </body>
</html>
