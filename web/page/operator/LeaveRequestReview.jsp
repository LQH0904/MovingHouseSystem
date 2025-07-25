<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
    <head>
        <title>Quản lý đơn nghỉ phép</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            body {
                font-family: Arial;
                background: #f4f4f4;
            }
            h2 {
                text-align: center;
            }
            table {
                margin: 20px auto;
                border-collapse: collapse;
                width: 90%;
                background: white;
            }
            th, td {
                padding: 12px;
                border-bottom: 1px solid #ddd;
            }
            a.button {
                padding: 5px 10px;
                background: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 4px;
            }
            a.button:hover {
                background: #0056b3;
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp" />
            </div>
            <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp" />
            </div>
            <div class="div3">
                <h2>Danh sách đơn nghỉ phép của nhân viên</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Nhân viên</th>
                            <th>Ngày bắt đầu</th>
                            <th>Ngày kết thúc</th>
                            <th>Lý do</th>
                            <th>Trạng thái</th>
                            <th>Phản hồi</th>
                            <th>Hành động</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="r" items="${requests}">
                            <tr>
                                <td>${r.staffName}</td>
                                <td>${r.startDate}</td>
                                <td>${r.endDate}</td>
                                <td>${r.reason}</td>
                                <td>${r.status}</td>
                                <td>${r.operatorReply != null ? r.operatorReply : "-"}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/operator/review-leave-request?id=${r.requestId}">Chi tiết</a>

                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table></div></div>
    </body>
</html>
