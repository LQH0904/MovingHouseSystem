<%-- 
    Document   : homeOperator
    Created on : Jun 3, 2025, 8:16:35 AM
    Author     : Admin
--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="css/homeOperator.css">
        <script src="js/Calander.js"></script>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="SideBar.jsp"></jsp:include>
            </div>
            <div class="div2">
                <jsp:include page="Header.jsp"></jsp:include>
            </div>

            <div class="div3">
                <!-- Nội dung chính của div3 -->
                <div class="main-content">
                    <div class="content-section">
                        <h3>Thống kê tổng quan</h3>
                        <p>Đây là khu vực hiển thị nội dung chính của ứng dụng. Bạn có thể thêm các biểu đồ, bảng dữ liệu, hoặc thông tin khác vào đây.</p>
                    </div>

                    <div class="content-section">
                        <h3>Hoạt động gần đây</h3>
                        <p>Danh sách các hoạt động và cập nhật mới nhất sẽ được hiển thị ở đây.</p>
                    </div>
                </div>

                <!-- Lịch bên phải trong div3 -->
                <div class="calendar-widget">
                    <div class="calendar-header">
                        <div class="current-time" id="currentTime"></div>
                        <div class="current-date" id="currentDate"></div>
                    </div>

                    <div class="calendar-nav">
                        <button class="nav-btn" id="prevMonth">‹</button>
                        <div class="month-year" id="monthYear"></div>
                        <button class="nav-btn" id="nextMonth">›</button>
                    </div>

                    <div class="calendar-grid" id="calendarGrid"></div>

                    <div class="time-zones">
                        <div class="timezone-card">
                            <div class="timezone-name">Hà Nội</div>
                            <div class="timezone-time" id="vietnamTime"></div>
                        </div>
                        <div class="timezone-card">
                            <div class="timezone-name">Tokyo</div>
                            <div class="timezone-time" id="tokyoTime"></div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script>
            class LiveCalendar {
                constructor() {
                    this.currentDate = new Date();
                    this.viewDate = new Date();
                    this.selectedDate = null;
                    this.init();
                }

                init() {
                    this.updateTime();
                    this.renderCalendar();
                    this.bindEvents();

                    // Cập nhật thời gian mỗi giây
                    const self = this;
                    setInterval(function () {
                        self.updateTime();
                    }, 1000);
                }

                updateTime() {
                    const now = new Date();

                    // Cập nhật thời gian hiện tại
                    const timeStr = now.toLocaleTimeString('vi-VN', {
                        hour: '2-digit',
                        minute: '2-digit',
                        second: '2-digit',
                        hour12: false
                    });
                    document.getElementById('currentTime').textContent = timeStr;

                    // Cập nhật ngày hiện tại
                    const dateStr = now.toLocaleDateString('vi-VN', {
                        weekday: 'short',
                        month: 'short',
                        day: 'numeric'
                    });
                    document.getElementById('currentDate').textContent = dateStr;

                    // Cập nhật các múi giờ
                    this.updateTimeZones(now);
                }

                updateTimeZones(now) {
                    // Việt Nam (UTC+7)
                    const vietnamTime = new Intl.DateTimeFormat('vi-VN', {
                        timeZone: 'Asia/Ho_Chi_Minh',
                        hour: '2-digit',
                        minute: '2-digit',
                        hour12: false
                    }).format(now);
                    document.getElementById('vietnamTime').textContent = vietnamTime;

                    // Tokyo (UTC+9)
                    const tokyoTime = new Intl.DateTimeFormat('ja-JP', {
                        timeZone: 'Asia/Tokyo',
                        hour: '2-digit',
                        minute: '2-digit',
                        hour12: false
                    }).format(now);
                    document.getElementById('tokyoTime').textContent = tokyoTime;
                }

                renderCalendar() {
                    const monthNames = [
                        'T1', 'T2', 'T3', 'T4', 'T5', 'T6',
                        'T7', 'T8', 'T9', 'T10', 'T11', 'T12'
                    ];

                    const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

                    // Cập nhật tiêu đề tháng
                    const monthIndex = this.viewDate.getMonth();
                    const yearValue = this.viewDate.getFullYear();
                    document.getElementById('monthYear').textContent = monthNames[monthIndex] + ' ' + yearValue;

                    // Xóa lịch cũ
                    const grid = document.getElementById('calendarGrid');
                    grid.innerHTML = '';

                    // Tạo tiêu đề các ngày trong tuần
                    const self = this;
                    dayNames.forEach(function (day) {
                        const dayHeader = document.createElement('div');
                        dayHeader.className = 'day-header';
                        dayHeader.textContent = day;
                        grid.appendChild(dayHeader);
                    });

                    // Tính toán ngày đầu tháng và số ngày trong tháng
                    const firstDay = new Date(this.viewDate.getFullYear(), this.viewDate.getMonth(), 1);
                    const startDate = new Date(firstDay);
                    startDate.setDate(startDate.getDate() - firstDay.getDay());

                    // Tạo các ô ngày
                    for (let i = 0; i < 42; i++) {
                        const cellDate = new Date(startDate);
                        cellDate.setDate(startDate.getDate() + i);

                        const dayCell = document.createElement('div');
                        dayCell.className = 'day-cell';
                        dayCell.textContent = cellDate.getDate();

                        // Kiểm tra nếu là ngày hôm nay
                        if (this.isSameDay(cellDate, this.currentDate)) {
                            dayCell.classList.add('today');
                        }

                        // Kiểm tra nếu không thuộc tháng hiện tại
                        if (cellDate.getMonth() !== this.viewDate.getMonth()) {
                            dayCell.classList.add('other-month');
                        }

                        // Kiểm tra nếu được chọn
                        if (this.selectedDate && this.isSameDay(cellDate, this.selectedDate)) {
                            dayCell.classList.add('selected');
                        }

                        // Thêm sự kiện click
                        (function (date, self) {
                            dayCell.addEventListener('click', function () {
                                const selectedCells = document.querySelectorAll('.day-cell.selected');
                                for (let j = 0; j < selectedCells.length; j++) {
                                    selectedCells[j].classList.remove('selected');
                                }
                                dayCell.classList.add('selected');
                                self.selectedDate = new Date(date);
                            });
                        })(cellDate, self);

                        grid.appendChild(dayCell);
                    }
                }

                isSameDay(date1, date2) {
                    return date1.getDate() === date2.getDate() &&
                            date1.getMonth() === date2.getMonth() &&
                            date1.getFullYear() === date2.getFullYear();
                }

                bindEvents() {
                    const self = this;
                    document.getElementById('prevMonth').addEventListener('click', function () {
                        self.viewDate.setMonth(self.viewDate.getMonth() - 1);
                        self.renderCalendar();
                    });

                    document.getElementById('nextMonth').addEventListener('click', function () {
                        self.viewDate.setMonth(self.viewDate.getMonth() + 1);
                        self.renderCalendar();
                    });
                }
            }

            // Khởi tạo lịch khi trang web được tải
            document.addEventListener('DOMContentLoaded', function () {
                new LiveCalendar();
            });
        </script>
    </body>
</html>