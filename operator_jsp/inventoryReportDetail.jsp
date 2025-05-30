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

                <p>chi tiết báo cáo</p>
                <form action="invRURL" method="">
                    <input type="hidden" name="service" value="viewDetail"/>
                    <table>
                        <% for (InventoryReports invReports : vector) {%>
                        <tr>
                            <td class="tdinvRdiv3" id="td1"><%= invReports.getCreatedAt().substring(0, 10) %></td>
                            <td class="tdinvRdiv3" id="td2"><%=invReports.getInventoryDetails()%></td>
                        </tr>
                        <%}%>
                    </table>
                </form>
            </div>
        </div>

    </body>
</html>
