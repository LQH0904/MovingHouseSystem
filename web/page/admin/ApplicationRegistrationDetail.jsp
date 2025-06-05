<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Application Registration Detail Page</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
        <!-- Bootstrap Icons -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />

        <style>
            body {
                background-color: #f8f9fa;
            }
            .detail-card {
                max-width: 700px;
                margin: 40px auto;
                box-shadow: 0 4px 15px rgba(0,0,0,0.1);
                border-radius: 12px;
            }
            .badge-status {
                font-size: 1rem;
                padding: 0.5em 1em;
                border-radius: 50px;
                font-weight: 600;
                text-transform: capitalize;
            }
            .badge-transport {
                background-color: #0d6efd;
                color: white;
            }
            .badge-storage {
                background-color: #198754;
                color: white;
            }
            .badge-pending {
                background-color: #ffc107;
                color: #212529;
            }
            .badge-approved {
                background-color: #198754;
                color: white;
            }
            .badge-rejected {
                background-color: #dc3545;
                color: white;
            }
            .header-icon {
                font-size: 2.5rem;
                color: #0d6efd;
                margin-right: 12px;
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1"><jsp:include page="../../Layout/SideBar.jsp"></jsp:include></div>
            <div class="div2"><jsp:include page="../../Layout/Header.jsp"></jsp:include></div>

                <div class="div3">
                    <div class="container">
                        <div class="card detail-card bg-white p-4">
                            <div class="d-flex align-items-center mb-4">
                                <i class="bi bi-info-circle header-icon"></i>
                                <h3 class="mb-0">Chi tiết đăng ký</h3>
                            </div>

                        <c:if test="${not empty registration}">
                            <dl class="row mb-4">
                                <dt class="col-sm-4">ID</dt>
                                <dd class="col-sm-8"><strong>${registration.id}</strong></dd>

                                <dt class="col-sm-4">Tên</dt>
                                <dd class="col-sm-8">${registration.name}</dd>

                                <dt class="col-sm-4">Loại</dt>

                                <dd class="col-sm-8">
                                    <c:choose>
                                        <c:when test="${registration.type == 'transport'}">
                                            <span class="badge badge-status badge-transport">Vận chuyển</span>
                                        </c:when>
                                        <c:when test="${registration.type == 'storage'}">
                                            <span class="badge badge-status badge-storage">Kho bãi</span>
                                        </c:when>

                                    </c:choose>
                                </dd>



                                <dt class="col-sm-4">Trạng thái đăng ký</dt>

                                <dd class="col-sm-8">
                                    <c:choose>
                                        <c:when test="${registration.registrationStatus == 'pending'}">
                                            <span class="badge badge-status badge-pending">Đang chờ</span>
                                        </c:when>
                                        <c:when test="${registration.registrationStatus == 'approved'}">
                                            <span class="badge badge-status badge-approved">Đã duyệt</span>
                                        </c:when>
                                        <c:when test="${registration.registrationStatus == 'rejected'}">
                                            <span class="badge badge-status badge-rejected">Từ chối</span>
                                        </c:when>

                                    </c:choose>
                                </dd>

                                <!-- Các trường dữ liệu chưa có, để trống -->
                                <dt class="col-sm-4">Thông tin liên hệ</dt>
                                <dd class="col-sm-8"><i class="text-muted">Chưa có</i></dd>

                                <dt class="col-sm-4">Ngày tạo</dt>
                                <dd class="col-sm-8"><i class="text-muted">Chưa có</i></dd>

                                <dt class="col-sm-4">Tên người dùng</dt>
                                <dd class="col-sm-8"><i class="text-muted">Chưa có</i></dd>

                                <dt class="col-sm-4">Email</dt>
                                <dd class="col-sm-8"><i class="text-muted">Chưa có</i></dd>
                            </dl>

                            <div class="d-flex justify-content-between">
                                <a href="registrationList" class="btn btn-outline-primary">
                                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                                </a>
                            </div>
                        </c:if>

                        <c:if test="${empty registration}">
                            <div class="alert alert-warning text-center" role="alert">
                                Không tìm thấy thông tin đăng ký!
                            </div>
                            <div class="text-center">
                                <a href="registrationList" class="btn btn-outline-primary">
                                    <i class="bi bi-arrow-left"></i> Quay lại danh sách
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
