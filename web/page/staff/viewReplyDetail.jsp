<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Chi tiết phản hồi</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>
    <body class="bg-light">
        <div class="container mt-5">
            <h3 class="mb-4">Chi tiết phản hồi</h3>

            <!-- Nếu có lỗi -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">${errorMessage}</div>
            </c:if>

            <!-- Nếu có dữ liệu phản hồi -->
            <c:if test="${reply != null}">
                <table border="1">
                    <thead>
                        <tr>
                            <th>#No</th>
                            <th>Id người phản hồi:</th>
                            <th>Nội dung phản hồi:</th>
                            <th>Thời gian phản hồi:</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${reply}" var="i">
                            <tr>
                                <td>${i.replyId}</td>
                                <td>${i.replierId}</td>
                                <td>${i.replyContent}</td>
                                <td>${i.repliedAt}</td>
                            </tr>
                        </c:forEach>

                    </tbody>
                </table>
            </c:if>

            <!-- Nút quay lại -->
            <div class="mt-4">
                <a href="${pageContext.request.contextPath}/viewComplaintDetail" class="btn btn-secondary">
                    ← Quay lại khiếu nại
                </a>
            </div>
        </div>
    </body>
</html>