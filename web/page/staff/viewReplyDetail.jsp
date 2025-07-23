<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/staff/ReplyDetail.css">
    </head>
    <body class="bg-light">
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../Layout/staff/SideBar.jsp"></jsp:include>
                </div>
                <div class="div2">
                <jsp:include page="../../Layout/staff/Header.jsp"></jsp:include>
                </div>
                <div class="div3 p-4">
                    <div class="container mt-5">
                        <h3 class="mb-4">Chi tiết phản hồi</h3>

                        <!-- Nếu có lỗi -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger">${errorMessage}</div>
                    </c:if>

                    <!-- Nếu có dữ liệu phản hồi -->
                    <c:if test="${reply != null}">
                        <div class="table-responsive">
                            <table class="table table-hover table-bordered">
                                <thead class="table-primary">
                                    <tr>
                                        <th>#No</th>
                                        <th>Id người phản hồi</th>
                                        <th>Nội dung phản hồi</th>
                                        <th>Thời gian phản hồi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach items="${reply}" var="i">
                                        <tr>
                                            <td>${i.replyId}</td>
                                            <td>${i.replierId}</td>
                                            <td>${i.replyContent}</td>
                                            <td><fmt:formatDate value="${i.repliedAt}" pattern="dd/MM/yyyy HH:mm:ss"/></td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>

                    <!-- Nút quay lại -->
                    <div class="mt-4">
                        <a href="${pageContext.request.contextPath}/viewComplaintDetail" class="btn btn-secondary">
                            <i class="bi bi-arrow-left"></i> Quay lại khiếu nại
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>