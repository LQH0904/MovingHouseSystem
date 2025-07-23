<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật thông tin cá nhân</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <style>
            .form-container {
                max-width: 900px;
                margin: 0 auto;
                background: white;
                padding: 2rem;
                border-radius: 10px;
                box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            }

            .form-container h1 {
                color: #2c3e50;
                margin-bottom: 1.5rem;
                font-size: 1.8rem;
                font-weight: 600;
                border-bottom: 1px solid #e9ecef;
                padding-bottom: 0.5rem;
            }

            .section-title {
                font-size: 1.25rem;
                color: #3498db;
                margin: 1.5rem 0 1rem;
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

            .form-group {
                margin-bottom: 1.25rem;
            }

            .form-group label {
                display: block;
                margin-bottom: 0.5rem;
                color: #495057;
                font-weight: 500;
            }

            .form-group input,
            .form-group select {
                width: 100%;
                padding: 0.5rem 0.75rem;
                border: 1px solid #ced4da;
                border-radius: 0.375rem;
                font-size: 1rem;
                transition: border-color 0.15s ease-in-out;
            }

            .form-group input:focus,
            .form-group select:focus {
                border-color: #3498db;
                outline: 0;
                box-shadow: 0 0 0 0.25rem rgba(52, 152, 219, 0.25);
            }

            .form-row {
                display: flex;
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .form-row .form-group {
                flex: 1;
            }

            .form-actions {
display: flex;
                justify-content: flex-end;
                gap: 1rem;
                margin-top: 2rem;
                padding-top: 1rem;
                border-top: 1px solid #e9ecef;
            }

            .btn {
                padding: 0.5rem 1.25rem;
                border-radius: 0.375rem;
                font-weight: 500;
                transition: all 0.2s ease;
                border: none;
                cursor: pointer;
            }

            .btn-primary {
                background-color: #3498db;
                color: white;
            }

            .btn-primary:hover {
                background-color: #2980b9;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            .btn-secondary {
                background-color: #6c757d;
                color: white;
            }

            .btn-secondary:hover {
                background-color: #5a6268;
                transform: translateY(-2px);
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            @media (max-width: 768px) {
                .form-row {
                    flex-direction: column;
                    gap: 0;
                }

                .form-actions {
                    flex-direction: column;
                }

                .btn {
                    width: 100%;
                    margin-bottom: 0.5rem;
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
                    <div class="form-container">
                        <h1><i class="bi bi-person-gear me-2"></i>Cập nhật thông tin cá nhân</h1>

                        <form action="${pageContext.request.contextPath}/profile" method="post">
                        <input type="hidden" name="action" value="updateBasicInfo">

                        <h2 class="section-title">
                            <i class="bi bi-person-lines-fill me-2"></i>Thông tin cơ bản
                        </h2>
                        <div class="form-row">
                            <div class="form-group">
                                <label for="firstName">Họ</label>
                                <input type="text" id="firstName" name="firstName" value="${profile.firstName}" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName">Tên</label>
                                <input type="text" id="lastName" name="lastName" value="${profile.lastName}" required>
</div>
                        </div>

                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" value="${profile.email}" required disabled>
                        </div>

                        <div class="form-group">
                            <label for="phoneNumber">Số điện thoại</label>
                            <input type="tel" id="phoneNumber" name="phoneNumber" value="${profile.phoneNumber}">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="dateOfBirth">Ngày sinh</label>
                                <input type="date" id="dateOfBirth" name="dateOfBirth" value="${profile.dateOfBirth}">
                            </div>
                            <div class="form-group">
                                <label for="gender">Giới tính</label>
                                <select id="gender" name="gender">
                                    <option value="Nam" ${profile.gender == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${profile.gender == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                    <option value="Khác" ${profile.gender == 'Khác' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                        </div>

                        <h2 class="section-title">
                            <i class="bi bi-house-door me-2"></i>Địa chỉ
                        </h2>
                        <div class="form-group">
                            <label for="country">Quốc gia</label>
                            <input type="text" id="country" name="country" value="${profile.country}">
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="city">Thành phố</label>
                                <input type="text" id="city" name="city" value="${profile.city}">
                            </div>
                            <div class="form-group">
                                <label for="district">Quận/Huyện</label>
                                <input type="text" id="district" name="district" value="${profile.district}">
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label for="street">Đường/Phố</label>
                                <input type="text" id="street" name="street" value="${profile.street}">
                            </div>
                            <div class="form-group">
<label for="postalCode">Mã bưu điện</label>
                                <input type="text" id="postalCode" name="postalCode" value="${profile.postalCode}">
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-save me-2"></i>Lưu thay đổi
                            </button>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-secondary">
                                <i class="bi bi-x-circle me-2"></i>Hủy bỏ
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>

