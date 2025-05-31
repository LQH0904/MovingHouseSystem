<%-- 
    Document   : InventoryReports
    Created on : May 30, 2025, 8:10:42 AM
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/showInventoryReports.css">
    </head>
    <body>
        <div class="parent">
            <div class="div1">mau 1</div>
            <div class="div2">mau 2</div>
            <div class="div3">
                <%@ page import="entity.InventoryReports, java.util.Vector" %>
                <%
                  Vector<InventoryReports> vector =
                      (Vector<InventoryReports>) request.getAttribute("inventoryReportsData");
                  if (vector == null) vector = new Vector<>();
                %>

                <p>xắp xếp</p>
                
                <form action="invRURL" method="">
                    <input type="hidden" name="service" value="listInventoryReports"/>
                    <div class="scroll-list_wrp">
                        <p>bảng báo cáo tồn kho</p>
                        <table class="">
                            <% for (InventoryReports invReports : vector) {%>
                            <tr onclick="redirectToDetail(<%= invReports.getReporId() %>)" style="cursor: pointer;">
                                <td class="tdinvRdiv3" id="td1"><%= invReports.getCreatedAt().substring(0, 10) %></td>
                                <td class="tdinvRdiv3" id="td2"><%=invReports.getTitle()%></td>
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
                window.location.href = 'invRURL?service=viewDetail&reportId=' + reportId;

                // Hoặc chuyển đến URL khác tùy ý
                // window.location.href = 'your-other-page.jsp?id=' + reportId;
            }
        </script>
    </body>
</html>