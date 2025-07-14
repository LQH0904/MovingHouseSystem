<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Gửi Thông báo</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background-color: #f4f6f8;
                padding: 30px;
            }

            .form-container {
                max-width: 650px;
                margin: auto;
            }

            .card {
                border: none;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                background-color: #ffffff;
            }

            .card-header {
                background-color: #0d6efd; /* Xanh nước biển */
                color: white;
                font-weight: bold;
                border-top-left-radius: 12px;
                border-top-right-radius: 12px;
                display: flex;
                align-items: center;
                gap: 10px;
                font-size: 20px;
            }

            .form-select, .form-control {
                border-radius: 8px;
            }

            .btn-analyze {
                background-color: #0d6efd;
                border: none;
                border-radius: 8px;
                color: white;
            }

            .btn-analyze:hover {
                background-color: #0b5ed7;
            }

            .nav-links {
                margin: 15px 0;
            }

            .nav-links a {
                text-decoration: none;
                color: #0d6efd;
                font-weight: 500;
                display: inline-block;
                margin-right: 15px;
            }

            .nav-links a:hover {
                text-decoration: underline;
            }

            .alert {
                border-radius: 8px;
                transition: opacity 0.5s ease-out;
            }

            .form-label i {
                margin-right: 6px;
                color: #0d6efd;
            }
        </style>

        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <div class="form-container">
            <div class="card">
                <div class="card-header">
                    <h2 class="mb-0"><i class="bi bi-megaphone-fill me-2"></i>Gửi Thông báo</h2>
                </div>
                <div class="card-body">
                    <c:if test="${sessionScope.acc == null || (sessionScope.acc.roleId != 1 && sessionScope.acc.roleId != 2)}">
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-circle me-1"></i> Chỉ Admin hoặc Operator có quyền truy cập chức năng này.
                            <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a>
                        </div>
                    </c:if>

                    <c:if test="${sessionScope.acc != null && (sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2)}">
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/analyz"><i class="bi bi-graph-up-arrow me-1"></i>Phân tích Báo cáo</a>
                            |
                            <a href="${pageContext.request.contextPath}/login"><i class="bi bi-house-door-fill me-1"></i>Trang chủ</a>
                        </div>

                        <form id="sendNotificationForm" action="${pageContext.request.contextPath}/sendNotification" method="post">
                            <div class="mb-3">
                                <label for="roleId" class="form-label"><i class="bi bi-people-fill me-2"></i>Chọn vai trò:</label>
                                <select class="form-select" name="roleId" id="roleId" required>
                                    <option value="">-- Chọn vai trò --</option>
                                    <option value="4">Đơn vị vận chuyển</option>
                                    <option value="5">Đơn vị kho</option>
                                    <option value="6">Khách hàng</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="userId" class="form-label"><i class="bi bi-person-badge-fill me-2"></i>Chọn người dùng:</label>
                                <select class="form-select" name="userId" id="userId" required>
                                    <option value="">-- Chọn người dùng --</option>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label for="message" class="form-label"><i class="bi bi-chat-left-text me-2"></i>Nội dung thông báo:</label>
                                <textarea class="form-control" name="message" id="message" rows="4" required></textarea>
                            </div>

                            <div class="mb-3">
                                <label for="notificationType" class="form-label"><i class="bi bi-bell-fill me-2"></i>Loại thông báo (tùy chọn):</label>
                                <select class="form-select" name="notificationType" id="notificationType">
                                    <option value="">-- Có thể không chọn --</option>
                                    <option value="reward"> Khen thưởng</option>
                                    <option value="suggestion"> Gợi ý</option>
                                    <option value="warning"> Cảnh báo</option>
                                    <option value="urgent"> Khẩn cấp</option>
                                    <option value="reminder"> Nhắc nhở</option>
                                </select>
                            </div>

                            <!--                            <div class="mb-3">
                                                            <label for="orderId" class="form-label"><i class="bi bi-hash me-2"></i>ID đơn hàng (tùy chọn):</label>
                                                            <input type="text" class="form-control" name="orderId" id="orderId" placeholder="Nhập ID đơn hàng (nếu có)">
                                                        </div>-->

                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-send-check me-2"></i>Gửi thông báo
                            </button>
                        </form>

                        <c:if test="${not empty requestScope.message}">
                            <div id="success-alert" class="alert alert-success mt-3" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i>${requestScope.message}
                            </div>
                        </c:if>

                        <c:if test="${not empty requestScope.error}">
                            <div class="alert alert-danger mt-3" role="alert">
                                <i class="bi bi-x-circle-fill me-2"></i>${requestScope.error}
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
                                console.log('Users data:', data); // Debug: In dữ liệu JSON
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
                                console.error('Error fetching users:', error); // Debug
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