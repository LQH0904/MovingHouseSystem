<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gửi Thông báo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
        <style>
            body {
                font-family: 'Poppins', sans-serif;
                background: linear-gradient(135deg, #e0e7ff 0%, #ffffff 100%);
                min-height: 100vh;
                padding: 40px 20px;
                display: flex;
                justify-content: center;
                align-items: center;
                overflow-x: hidden;
            }
            .form-container {
                max-width: 700px;
                width: 100%;
                animation: fadeIn 0.8s ease-in-out;
            }
            .card {
                border: none;
                border-radius: 20px;
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
                background: #ffffff;
                overflow: hidden;
                transition: transform 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .card-header {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                color: white;
                font-weight: 600;
                font-size: 1.5rem;
                padding: 20px;
                border-top-left-radius: 20px;
                border-top-right-radius: 20px;
                display: flex;
                align-items: center;
                gap: 12px;
                text-transform: uppercase;
                letter-spacing: 1px;
            }
            .nav-links {
                margin: 20px 0;
                display: flex;
                gap: 20px;
            }
            .nav-links a {
                text-decoration: none;
                color: #007bff;
                font-weight: 500;
                font-size: 1rem;
                padding: 8px 16px;
                border-radius: 8px;
                transition: background-color 0.3s, color 0.3s;
            }
            .nav-links a:hover {
                background-color: #007bff;
                color: white;
            }
            .form-select, .form-control, .form-control textarea {
                border-radius: 10px;
                border: 2px solid #e0e7ff;
                padding: 12px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            .form-select:focus, .form-control:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            }
            .btn-primary {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                border: none;
                border-radius: 10px;
                padding: 12px 24px;
                color: white;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .btn-primary:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.4);
            }
            .form-label {
                font-weight: 500;
                color: #333;
                margin-bottom: 8px;
            }
            .form-label i {
                margin-right: 8px;
                color: #007bff;
            }
            .alert {
                border-radius: 10px;
                padding: 15px;
                font-size: 0.9rem;
                animation: slideIn 0.5s ease-in-out;
                display: flex;
                align-items: center;
                gap: 10px;
            }
            @keyframes fadeIn {
                from { opacity: 0; transform: translateY(20px); }
                to { opacity: 1; transform: translateY(0); }
            }
            @keyframes slideIn {
                from { opacity: 0; transform: translateX(-20px); }
                to { opacity: 1; transform: translateX(0); }
            }
        </style>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <div class="form-container">
            <div class="card">
                <div class="card-header">
                    <i class="bi bi-megaphone-fill"></i> Gửi Thông báo
                </div>
                <div class="card-body p-4">
                    <c:if test="${sessionScope.acc == null || (sessionScope.acc.roleId != 1 && sessionScope.acc.roleId != 2)}">
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-circle"></i> Chỉ Admin hoặc Operator có quyền truy cập chức năng này.
                            <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a>
                        </div>
                    </c:if>
                    <c:if test="${sessionScope.acc != null && (sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2)}">
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/analyz"><i class="bi bi-graph-up-arrow"></i> Phân tích Báo cáo</a>
                            <a href="${pageContext.request.contextPath}/login"><i class="bi bi-house-door-fill"></i> Trang chủ</a>
                        </div>
                        <form id="sendNotificationForm" action="${pageContext.request.contextPath}/sendNotification" method="post">
                            <div class="mb-4">
                                <label for="roleId" class="form-label"><i class="bi bi-people-fill"></i> Chọn vai trò:</label>
                                <select class="form-select" name="roleId" id="roleId" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="4">Đơn vị vận chuyển</option>
                                    <option value="5">Đơn vị kho</option>
                                    <option value="6">Khách hàng</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label for="userId" class="form-label"><i class="bi bi-person-badge-fill"></i> Chọn người dùng:</label>
                                <select class="form-select" name="userId" id="userId" required>
                                    <option value="">-- Chọn người dùng --</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label for="message" class="form-label"><i class="bi bi-chat-left-text"></i> Nội dung thông báo:</label>
                                <textarea class="form-control" name="message" id="message" rows="5" required></textarea>
                            </div>
                            <div class="mb-4">
                                <label for="notificationType" class="form-label"><i class="bi bi-bell-fill"></i> Loại thông báo (tùy chọn):</label>
                                <select class="form-select" name="notificationType" id="notificationType">
                                    <option value="">-- Có thể không chọn --</option>
                                    <option value="reward">Khen thưởng</option>
                                    <option value="suggestion">Gợi ý</option>
                                    <option value="warning">Cảnh báo</option>
                                    <option value="urgent">Khẩn cấp</option>
                                    <option value="reminder">Nhắc nhở</option>
                                </select>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-send-check"></i> Gửi thông báo
                            </button>
                        </form>
                        <c:if test="${not empty requestScope.message}">
                            <div id="success-alert" class="alert alert-success mt-4" role="alert">
                                <i class="bi bi-check-circle-fill"></i> ${requestScope.message}
                            </div>
                        </c:if>
                        <c:if test="${not empty requestScope.error}">
                            <div class="alert alert-danger mt-4" role="alert">
                                <i class="bi bi-x-circle-fill"></i> ${requestScope.error}
                            </div>
                        </c:if>
                    </c:if>
                </div>
            </div>
        </div>
        <script>
            setTimeout(() => {
                const alertBox = document.getElementById("success-alert");
                if (alertBox) {
                    alertBox.style.transition = "opacity 0.5s ease-out";
                    alertBox.style.opacity = "0";
                    setTimeout(() => alertBox.remove(), 500);
                }
            }, 3000);

            $(document).ready(function () {
                $('#roleId').change(function () {
                    var roleId = $(this).val();
                    var userDropdown = $('#userId');

                    userDropdown.empty();
                    userDropdown.append('<option value="">-- Chọn người dùng --</option>');

                    if (roleId) {
                        $.ajax({
                            url: '${pageContext.request.contextPath}/sendNotification?roleId=' + roleId,
                            type: 'GET',
                            dataType: 'json',
                            success: function (data) {
                                console.log('Users data:', data);
                                if (data && data.length > 0) {
                                    $.each(data, function (index, user) {
                                        var displayName = user.username ? user.username : 'Không có tên';
                                        var displayEmail = user.email ? user.email : 'Không có email';
                                        userDropdown.append('<option value="' + user.userId + '">' + displayName + ' (' + displayEmail + ')</option>');
                                    });
                                } else {
                                    userDropdown.append('<option value="">Không có người dùng</option>');
                                }
                            },
                            error: function (xhr, status, error) {
                                console.error('Error fetching users:', error);
                                userDropdown.append('<option value="">Lỗi khi tải danh sách người dùng</option>');
                            }
                        });
                    }
                });

                $('#sendNotificationForm').on('submit', function (e) {
                    if (!$('#userId').val()) {
                        e.preventDefault();
                        alert('Vui lòng chọn một người dùng hợp lệ.');
                    }
                });
            });
        </script>
    </body>
</html>