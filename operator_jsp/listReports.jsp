<%-- 
    Document   : listReports
    Created on : May 31, 2025, 10:13:47 PM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/showInventoryReports.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.6.0/css/all.min.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <div class="img_log">
                    ảnh đăng nhập
                </div>
                <div class="worklink">
                    <a id="id1" href='http://localhost:8435/HouseMovingSystem/invRURL'>báo cáo doanh thu</a>
                    <a id="id1" href='http://localhost:8435/HouseMovingSystem/repURL' style="background-color: red; color: white;">báo cáo tổng quan</a>
                </div>

            </div>
            <div class="div2">
                <a id="icon" href="http://localhost:8435/HouseMovingSystem/homeOperator" class="fa-solid fa-home"></a>
                <i id="icon2" class="fa-solid fa-gear"></i>
            </div>
            <div class="div3">
                <form action="repURL" method="get">
                    <input type="hidden" name="service" value="listReports" />
                    <%-- Nếu có ô tìm kiếm theo tiêu đề: --%>
                    TÌm kiếm: <input type="text" name="reportTitle"
                                     value="<%= request.getParameter("reportTitle") != null ? request.getParameter("reportTitle") : "" %>" />
                    <button type="submit" name="submit" value="search">Tìm</button>
                </form> 
                <form>
                    <button type="submit" name="sort" value="desc"
                            <%-- Nếu trước đó request đã có sort=desc, có thể highlight nút --%>
                            <%= "desc".equals(request.getParameter("sort")) ? "style=\"background-color:#ddd;\"" : "" %>
                            >Sắp xếp theo ngày</button>
                </form>


                <%@ page import="entity.Reports, java.util.Vector" %>
                <%
                  Vector<Reports> vector =
                      (Vector<Reports>) request.getAttribute("reportsData");
                  if (vector == null) vector = new Vector<>();
                %>

                <p>xắp xếp</p>
                <p>tìm kiếm</p>
                <form action="repURL" method="">
                    <input type="hidden" name="service" value="listReports"/>
                    <div class="scroll-list_wrp">
                        <p class="sticky-header">bảng báo cáo tổng hợp</p>
                        <table class="">   

                            <% for (Reports reports : vector) {%>
                            <tr onclick="redirectToDetail(<%= reports.getReportId() %>)" style="cursor: pointer;">
                                <td class="tdinvRdiv3" id="td1"><%= reports.getCreatedAt().substring(0, 10) %></td>
                                <td class="tdinvRdiv3" id="td2"><%= reports.getTitle()%></td>
                            </tr>
                            <%}%>
                        </table>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function redirectToDetail(reportId) {
                // Chuyển hướng đến trang chi tiết với ID của báo cáo
                window.location.href = 'repURL?service=viewDetail&reportId=' + reportId;

                // Hoặc chuyển đến URL khác tùy ý
                // window.location.href = 'your-other-page.jsp?id=' + reportId;
            }
        </script>
    </body>
</html>
