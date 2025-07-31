<%-- 
    Document   : notifications
    Created on : Jul 7, 2025, 11:10:34 PM
    Author     : admin
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thông báo</title>
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
            .notification-container {
                max-width: 900px;
                width: 100%;
                animation: fadeIn 0.8s ease-in-out;
            }
            .notification-card {
                position: relative;
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border-left: 5px solid transparent;
                margin-bottom: 20px;
                background: #ffffff;
            }
            .notification-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            }
            .notification-card.unread {
                border-left: 5px solid #dc3545;
                background: #fff5f5;
            }
            .notification-card .badge-unread {
                position: absolute;
                top: 15px;
                left: 15px;
                width: 12px;
                height: 12px;
                background-color: #dc3545;
                border-radius: 50%;
            }
            .notification-type {
                font-weight: 600;
                text-transform: capitalize;
                font-size: 1.1rem;
                color: #333;
            }
            .reward {
                border-left-color: #28a745 !important;
            }
            .warning {
                border-left-color: #ffc107 !important;
            }
            .urgent {
                border-left-color: #dc3545 !important;
            }
            .suggestion {
                border-left-color: #17a2b8 !important;
            }
            .reminder {
                border-left-color: #6c757d !important;
            }
            .filter-container {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 25px;
                background: #f8f9fa;
                padding: 15px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            }
            .filter-container select {
                max-width: 250px;
                border: 2px solid #e0e7ff;
                border-radius: 10px;
                padding: 10px;
                transition: border-color 0.3s, box-shadow 0.3s;
            }
            .filter-container select:focus {
                border-color: #007bff;
                box-shadow: 0 0 8px rgba(0, 123, 255, 0.3);
            }
            .unread-count {
                background: #dc3545;
                color: white;
                border-radius: 12px;
                padding: 4px 10px;
                font-size: 0.85rem;
                margin-left: 10px;
                vertical-align: middle;
            }
            .mark-all-read-btn {
                background: linear-gradient(90deg, #007bff 0%, #00c4ff 100%);
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 10px;
                font-weight: 500;
                text-transform: uppercase;
                transition: transform 0.2s, box-shadow 0.2s;
            }
            .mark-all-read-btn:hover {
                transform: scale(1.05);
                box-shadow: 0 4px 12px rgba(0, 123, 255, 0.4);
            }
            .mark-all-read-btn:disabled {
                background: #6c757d;
                cursor: not-allowed;
                transform: none;
                box-shadow: none;
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
            .nav-links a {
                text-decoration: none;
                color: #007bff;
                font-weight: 500;
                padding: 8px 16px;
                border-radius: 8px;
                transition: background-color 0.3s, color 0.3s;
            }
            .nav-links a:hover {
                background-color: #007bff;
                color: white;
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
        <div class="notification-container">
            <h2 class="text-center mb-4">
                <i class="bi bi-bell-fill me-2"></i>Thông báo
                <c:set var="unreadCount" value="0"/>
                <c:forEach var="notification" items="${notifications}">
                    <c:if test="${notification.status == 'sent'}">
                        <c:set var="unreadCount" value="${unreadCount + 1}"/>
                    </c:if>
                </c:forEach>
                <c:if test="${unreadCount > 0}">
                    <span class="unread-count">${unreadCount}</span>
                </c:if>
            </h2>

            <c:if test="${sessionScope.acc == null}">
                <div class="alert alert-danger text-center" role="alert">
                    <i class="bi bi-exclamation-circle"></i> Vui lòng đăng nhập để xem thông báo.
                    <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a>
                </div>
            </c:if>

            <c:if test="${sessionScope.acc != null}">              

                <c:if test="${sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2 || sessionScope.acc.roleId == 4 || sessionScope.acc.roleId == 5 || sessionScope.acc.roleId == 6}">
                    <div class="filter-container">
                        <select class="form-select" id="statusFilter">
                            <option value="">Tất cả loại thông báo</option>
                            <c:if test="${sessionScope.acc.roleId == 1 || sessionScope.acc.roleId == 2 || sessionScope.acc.roleId == 4 || sessionScope.acc.roleId == 5}">
                                <option value="reward">Khen thưởng</option>
                                <option value="suggestion">Gợi ý</option>
                            </c:if>
                            <option value="warning">Cảnh báo</option>
                            <option value="urgent">Khẩn cấp</option>
                            <option value="reminder">Nhắc nhở</option>
                        </select>
<!--                        <button id="markAllReadBtn" class="mark-all-read-btn" ${unreadCount == 0 ? 'disabled' : ''}>Đánh dấu tất cả đã đọc</button>-->
                    </div>

                    <div id="notifications">
                        <c:if test="${empty notifications}">
                            <div class="alert alert-info text-center">Không có thông báo nào.</div>
                        </c:if>
                        <c:forEach var="notification" items="${notifications}">
                            <div class="card notification-card mb-3 ${notification.notificationType} <c:if test='${notification.status == "sent"}'>unread</c:if>" 
                                 data-notification-id="${notification.notificationId}">
                                <div class="card-body">
                                    <div class="badge-unread <c:if test='${notification.status == "read"}'>d-none</c:if>"></div>
                                    <h5 class="card-title">
                                        <i class="bi bi-bell-fill me-2 <c:if test='${notification.status == "sent"}'>text-danger</c:if>"></i>
                                        <span class="notification-type">${notification.notificationType}</span>
                                    </h5>
                                    <p class="card-text">${notification.message}</p>
                                    <c:if test="${notification.orderId != null}">
                                        <p class="card-text"><strong>Đơn hàng:</strong> #${notification.orderId}</p>
                                    </c:if>
                                    <p class="card-text">
                                        <small class="text-muted">
                                            <fmt:formatDate value="${notification.createdAt}" pattern="dd/MM/yyyy HH:mm:ss"/>
                                        </small>
                                    </p>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    <div class="nav-links mt-4">
                        <a href="${pageContext.request.contextPath}/login"><i class="bi bi-house-door-fill"></i> Về Trang chủ</a>
                    </div>
                </c:if>
            </c:if>
        </div>
        <script>
            $(document).ready(function () {
                const userId = '${sessionScope.acc.userId}';
                const roleId = ${sessionScope.acc.roleId};
                let unreadCount = ${unreadCount};

                // Cập nhật số lượng thông báo chưa đọc
                function updateUnreadCount(count) {
                    unreadCount = count;
                    const $unreadBadge = $('.unread-count');
                    if (count > 0) {
                        if ($unreadBadge.length) {
                            $unreadBadge.text(count);
                        } else {
                            $('<span class="unread-count">' + count + '</span>').insertAfter('.bi-bell-fill');
                        }
                        $('#markAllReadBtn').prop('disabled', false);
                    } else {
                        $unreadBadge.remove();
                        $('#markAllReadBtn').prop('disabled', true);
                    }
                }

                // Lọc thông báo
                function filterNotifications(filter) {
                    console.log('Filter selected:', filter);
                    let hasVisibleNotifications = false;
                    $('.notification-card').each(function () {
                        const card = $(this);
                        console.log('Card classes:', card.attr('class'));
                        if (!filter || card.hasClass(filter)) {
                            card.show();
                            hasVisibleNotifications = true;
                        } else {
                            card.hide();
                        }
                    });
                    if (!hasVisibleNotifications && $('.notification-card').length > 0) {
                        $('#notifications').append('<div class="alert alert-info text-center no-match-alert">Không có thông báo nào khớp với bộ lọc.</div>');
                    } else {
                        $('.no-match-alert').remove();
                    }
                }

                // Áp dụng bộ lọc khi thay đổi dropdown
                $('#statusFilter').change(function () {
                    const filter = $(this).val();
                    filterNotifications(filter);
                });

                // Đánh dấu tất cả đã đọc
                $('#markAllReadBtn').click(function () {
                    $.ajax({
                        url: '${pageContext.request.contextPath}/markAllNotificationsRead',
                        method: 'POST',
                        data: { userId: userId },
                        dataType: 'json',
                        success: function (response) {
                            if (response.success) {
                                $('.notification-card.unread').each(function () {
                                    const card = $(this);
                                    card.removeClass('unread');
                                    card.find('.badge-unread').addClass('d-none');
                                    card.find('.bi-bell-fill').removeClass('text-danger');
                                });
                                updateUnreadCount(0);
                            } else {
                                alert('Lỗi khi đánh dấu tất cả đã đọc: ' + response.error);
                            }
                        },
                        error: function () {
                            alert('Lỗi khi gửi yêu cầu.');
                        }
                    });
                });

                // WebSocket khởi tạo
                const ws = new WebSocket('ws://localhost:8081/?userId=' + userId);
                ws.onmessage = function (event) {
                    const notification = JSON.parse(event.data);
                    const statusFilter = $('#statusFilter').val();
                    const validTypes = (roleId === 1 || roleId === 2 || roleId === 4 || roleId === 5)
                            ? ['reward', 'warning', 'urgent', 'suggestion', 'reminder']
                            : ['warning', 'urgent', 'reminder'];

                    if ($(`.notification-card[data-notification-id="${notification.id}"]`).length > 0) {
                        return;
                    }

                    if (validTypes.includes(notification.notificationType) && (!statusFilter || notification.notificationType === statusFilter)) {
                        let orderHtml = '';
                        if (notification.orderId) {
                            orderHtml = '<p class="card-text"><strong>Đơn hàng:</strong> #' + notification.orderId + '</p>';
                        }

                        const createdAt = new Date(notification.createdAt).toLocaleString('vi-VN', {
                            day: '2-digit',
                            month: '2-digit',
                            year: 'numeric',
                            hour: '2-digit',
                            minute: '2-digit',
                            second: '2-digit'
                        });

                        const html = `
                            <div class="card notification-card mb-3 ${notification.notificationType} unread" data-notification-id="${notification.id}">
                                <div class="card-body">
                                    <div class="badge-unread"></div>
                                    <h5 class="card-title">
                                        <i class="bi bi-bell-fill text-danger me-2"></i>
                                        <span class="notification-type">${notification.notificationType}</span>
                                    </h5>
                                    <p class="card-text">${notification.message}</p>
                                    ${orderHtml}
                                    <p class="card-text">
                                        <small class="text-muted">${createdAt}</small>
                                    </p>
                                </div>
                            </div>`;
                        $('#notifications').prepend(html);
                        $('.no-match-alert').remove();
                        if (notification.status === 'sent') {
                            updateUnreadCount(unreadCount + 1);
                        }
                    }
                };

                // Đánh dấu thông báo đã đọc khi click
                $(document).on('click', '.notification-card.unread', function () {
                    const card = $(this);
                    const notificationId = card.data('notification-id');
                    $.ajax({
                        url: '${pageContext.request.contextPath}/markNotificationRead',
                        method: 'POST',
                        data: {notificationId: notificationId},
                        dataType: 'json',
                        success: function (response) {
                            if (response.success) {
                                card.removeClass('unread');
                                card.find('.badge-unread').addClass('d-none');
                                card.find('.bi-bell-fill').removeClass('text-danger');
                                updateUnreadCount(unreadCount - 1);
                            } else {
                                alert('Lỗi đánh dấu đã đọc: ' + response.error);
                            }
                        },
                        error: function () {
                            alert('Lỗi khi gửi yêu cầu.');
                        }
                    });
                });

                filterNotifications($('#statusFilter').val());
            });
        </script>
    </body>
</html>