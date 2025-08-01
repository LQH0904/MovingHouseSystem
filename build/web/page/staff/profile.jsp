<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Hồ sơ người dùng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <style>
            .profile-container {
                max-width: 1200px;
                margin: 0 auto;
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            }

            .profile-header {
                display: flex;
                align-items: center;
                margin-bottom: 2rem;
                padding-bottom: 1.5rem;
                border-bottom: 1px solid #e9ecef;
            }

            .profile-avatar {
                width: 150px;
                height: 150px;
                border-radius: 50%;
                object-fit: cover;
                margin-right: 2rem;
                border: 5px solid #f8f9fa;
                box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.1);
            }

            .profile-info {
                flex: 1;
            }

            .profile-name {
                font-size: 1.75rem;
                margin-bottom: 0.5rem;
                color: #2c3e50;
                font-weight: 600;
            }

            .profile-email {
                color: #6c757d;
                margin-bottom: 1rem;
                font-size: 1.1rem;
            }

            .profile-actions .btn {
                padding: 0.5rem 1.25rem;
                border-radius: 0.375rem;
                margin-right: 0.75rem;
                margin-bottom: 0.5rem;
                transition: all 0.2s ease;
            }

            .profile-actions .btn:hover {
                transform: translateY(-2px);
                box-shadow: 0 0.25rem 0.5rem rgba(0, 0, 0, 0.15);
            }

            .section {
                margin-bottom: 2rem;
                padding-bottom: 1.5rem;
                border-bottom: 1px solid #e9ecef;
            }

            .section:last-child {
                border-bottom: none;
            }

            .section-title {
                font-size: 1.25rem;
                color: #3498db;
                margin-bottom: 1.25rem;
                font-weight: 600;
                display: flex;
                align-items: center;
            }
.section-title::before {
                content: "";
                display: inline-block;
                width: 6px;
                height: 1.5rem;
                background-color: #3498db;
                margin-right: 0.75rem;
                border-radius: 3px;
            }

            .profile-detail {
                display: flex;
                margin-bottom: 0.75rem;
            }

            .detail-label {
                min-width: 200px;
                color: #495057;
                font-weight: 500;
            }

            .detail-value {
                color: #212529;
            }

            @media (max-width: 768px) {
                .profile-header {
                    flex-direction: column;
                    text-align: center;
                }

                .profile-avatar {
                    margin-right: 0;
                    margin-bottom: 1.5rem;
                }

                .profile-actions {
                    justify-content: center;
                }

                .profile-detail {
                    flex-direction: column;
                }

                .detail-label {
                    margin-bottom: 0.25rem;
                }
            }
        </style>
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
                    <div class="profile-container">
                        <h3 class="mb-4 text-primary border-bottom pb-2">
                            <i class="bi bi-person-badge me-2"></i>Hồ sơ người dùng
                        </h3>

                    <c:if test="${not empty message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle me-2"></i>${message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    </c:if>

                    <div class="profile-header">
                        <img src="https://i.pinimg.com/originals/b8/5e/cf/b85ecfd8cff510945f6659786312ba28.gif" alt="Avatar" class="profile-avatar">
                        <div class="profile-info">
<h1 class="profile-name">${profile.firstName} ${profile.lastName}</h1>
                            <p class="profile-email">
                                <i class="bi bi-envelope me-2"></i>${profile.email}
                            </p>
                            <div class="profile-actions d-flex flex-wrap">
                                <a href="profile?action=update" class="btn btn-primary">
                                    <i class="bi bi-pencil-square me-2"></i>Cập nhật thông tin
                                </a>
                                <a href="page/staff/change-password.jsp" class="btn btn-success">
                                    <i class="bi bi-key me-2"></i>Đổi mật khẩu
                                </a>
                            </div>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">
                            <i class="bi bi-person-lines-fill me-2"></i>Thông tin cá nhân
                        </h2>
                        <div class="profile-detail">
                            <span class="detail-label">Họ và tên:</span>
                            <span class="detail-value">${profile.firstName} ${profile.lastName}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Email:</span>
                            <span class="detail-value">${profile.email}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Số điện thoại:</span>
                            <span class="detail-value">${profile.phoneNumber}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Ngày sinh:</span>
                            <span class="detail-value">${profile.dateOfBirth}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Giới tính:</span>
                            <span class="detail-value">${profile.gender}</span>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">
                            <i class="bi bi-house-door me-2"></i>Địa chỉ
                        </h2>
                        <div class="profile-detail">
                            <span class="detail-label">Quốc gia:</span>
                            <span class="detail-value">${profile.country}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Thành phố:</span>
                            <span class="detail-value">${profile.city}</span>
</div>
                        <div class="profile-detail">
                            <span class="detail-label">Quận/Huyện:</span>
                            <span class="detail-value">${profile.district}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Đường/Phố:</span>
                            <span class="detail-value">${profile.street}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Mã bưu điện:</span>
                            <span class="detail-value">${profile.postalCode}</span>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">
                            <i class="bi bi-sliders me-2"></i>Tùy chỉnh
                        </h2>
                        <div class="profile-detail">
                            <span class="detail-label">Ngôn ngữ ưa thích:</span>
                            <span class="detail-value">${profile.languagePreference}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Giao diện:</span>
                            <span class="detail-value">${profile.themePreference}</span>
                        </div>
                    </div>

                    <div class="section">
                        <h2 class="section-title">
                            <i class="bi bi-share me-2"></i>Liên kết mạng xã hội
                        </h2>
                        <div class="profile-detail">
                            <span class="detail-label">Facebook:</span>
                            <span class="detail-value">${profile.facebookLink}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Google:</span>
                            <span class="detail-value">${profile.googleLink}</span>
                        </div>
                        <div class="profile-detail">
                            <span class="detail-label">Twitter:</span>
                            <span class="detail-value">${profile.twitterLink}</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
