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
        <style>
            body {
                font-family: 'Segoe UI', sans-serif;
                background: linear-gradient(to right, #f4f6f8, #e9ecef);
                padding: 20px;
            }
            .notification-container {
                max-width: 850px;
                margin: auto;
            }
            .notification-card {
                position: relative;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                border-left: 5px solid transparent;
            }
            .notification-card:hover {
                transform: translateY(-3px);
                box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            }
            .notification-card.unread {
                border-left: 5px solid #dc3545;
                background-color: #fff;
            }
            .notification-card .badge-unread {
                position: absolute;
                top: 12px;
                left: 12px;
                width: 12px;
                height: 12px;
                background-color: #dc3545;
                border-radius: 50%;
            }
            .notification-type {
                font-weight: 600;
                text-transform: capitalize;
                font-size: 1rem;
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
                margin-bottom: 15px;
            }
            .filter-container select {
                max-width: 250px;
            }
            .unread-count {
                display: inline-block;
                background-color: #dc3545;
                color: white;
                border-radius: 12px;
                padding: 2px 8px;
                font-size: 0.8rem;
                margin-left: 8px;
                vertical-align: middle;
            }
            .mark-all-read-btn {
                background-color: #007bff;
                color: white;
                border: none;
                padding: 6px 12px;
                border-radius: 4px;
                cursor: pointer;
                font-size: 0.9rem;
            }
            .mark-all-read-btn:hover {
                background-color: #0056b3;
            }
            .mark-all-read-btn:disabled {
                background-color: #6c757d;
                cursor: not-allowed;
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
                    Vui lòng đăng nhập để xem thông báo.
                    <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a>
                </div>
            </c:if>

            <c:if test="${sessionScope.acc != null}">
                <c:if test="${sessionScope.acc.roleId != 1 && sessionScope.acc.roleId != 2 &&sessionScope.acc.roleId != 4 && sessionScope.acc.roleId != 5 && sessionScope.acc.roleId != 6}">
                    <div class="alert alert-danger text-center" role="alert">
                        Bạn không có quyền xem thông báo.
                        <a href="${pageContext.request.contextPath}/login" class="alert-link">Đăng nhập</a>

                    </div>
                </c:if>

                <c:if test="${sessionScope.acc.roleId == 1 ||sessionScope.acc.roleId == 2 ||sessionScope.acc.roleId == 4 || sessionScope.acc.roleId == 5 || sessionScope.acc.roleId == 6}">
                    <div class="filter-container">
                        <select class="form-select" id="statusFilter">
                            <option value="">Tất cả loại thông báo</option>
                            <c:if test="${sessionScope.acc.roleId == 1 ||sessionScope.acc.roleId == 2 ||sessionScope.acc.roleId == 4 || sessionScope.acc.roleId == 5}">
                                <option value="reward">Khen thưởng</option>
                                <option value="suggestion">Gợi ý</option>
                            </c:if>
                            <option value="warning">Cảnh báo</option>
                            <option value="urgent">Khẩn cấp</option>
                            <option value="reminder">Nhắc nhở</option>
                        </select>
                    </div>

                    <div id="notifications">
                        <c:if test="${empty notifications}">
                            <div class="alert alert-info text-center">Không có thông báo nào.</div>
                        </c:if>
                        <c:forEach var="notification" items="${notifications}">
                            <div class="card notification-card mb-2 ${notification.notificationType}
                                 <c:if test='${notification.status == "sent"}'>unread</c:if>" 
                                 data-notification-id="${notification.notificationId}">
                                <div class="card-body">
                                    <div class="badge-unread
                                         <c:if test='${notification.status == "read"}'>d-none</c:if>"></div>
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
                    <a href="${pageContext.request.contextPath}/login"><i class="fas fa-home"></i> Về Trang chủ</a>

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
                                console.log('Filter selected:', filter); // Debug
                                let hasVisibleNotifications = false;
                                $('.notification-card').each(function () {
                                    const card = $(this);
                                    console.log('Card classes:', card.attr('class')); // Debug
                                    if (!filter || card.hasClass(filter)) {
                                        card.show();
                                        hasVisibleNotifications = true;
                                    } else {
                                        card.hide();
                                    }
                                });
                                // Hiển thị thông báo nếu không có thông báo nào khớp
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

                            // WebSocket khởi tạo
                            const ws = new WebSocket('ws://localhost:8081/?userId=' + userId);
                            ws.onmessage = function (event) {
                                const notification = JSON.parse(event.data);
                                const statusFilter = $('#statusFilter').val();
                                const validTypes = (roleId === 4 || roleId === 5)
                                        ? ['reward', 'warning', 'urgent', 'suggestion', 'reminder']
                                        : ['warning', 'urgent', 'reminder'];

                                // Kiểm tra thông báo trùng lặp
                                if ($(`.notification-card[data-notification-id="${notification.id}"]`).length > 0) {
                                    return;
                                }

                                // Kiểm tra loại thông báo hợp lệ và bộ lọc
                                if (validTypes.includes(notification.notificationType) && (!statusFilter || notification.notificationType === statusFilter)) {
                                    let orderHtml = '';
                                    if (notification.orderId) {
                                        orderHtml = '<p class="card-text"><strong>Đơn hàng:</strong> #' + notification.orderId + '</p>';
                                    }

                                    // Định dạng ngày tháng
                                    const createdAt = new Date(notification.createdAt).toLocaleString('vi-VN', {
                                        day: '2-digit',
                                        month: '2-digit',
                                        year: 'numeric',
                                        hour: '2-digit',
                                        minute: '2-digit',
                                        second: '2-digit'
                                    });

                                    const html = `
                                        <div class="card notification-card mb-2 ${notification.notificationType} unread" data-notification-id="${notification.id}">
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
                </c:if>
            </c:if>
        </div>
    </body>
</html>