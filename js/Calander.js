/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Lịch cập nhật thời gian thực cho trang homeOperator
class LiveCalendar {
    constructor() {
        this.currentDate = new Date();
        this.viewDate = new Date();
        this.selectedDate = null;
        this.init();
    }

    init() {
        // Đợi DOM load xong
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', () => {
                this.setupCalendar();
            });
        } else {
            this.setupCalendar();
        }
    }

    setupCalendar() {
        this.updateTime();
        this.renderCalendar();
        this.bindEvents();
        
        // Cập nhật thời gian mỗi giây
        setInterval(() => {
            this.updateTime();
        }, 1000);
    }

    updateTime() {
        const now = new Date();
        
        // Kiểm tra các element có tồn tại không
        const timeElement = document.getElementById('currentTime');
        const dateElement = document.getElementById('currentDate');
        
        if (timeElement && dateElement) {
            // Cập nhật thời gian hiện tại
            const timeStr = now.toLocaleTimeString('vi-VN', {
                hour: '2-digit',
                minute: '2-digit',
                second: '2-digit',
                hour12: false
            });
            timeElement.textContent = timeStr;
            
            // Cập nhật ngày hiện tại
            const dateStr = now.toLocaleDateString('vi-VN', {
                weekday: 'short',
                month: 'short',
                day: 'numeric'
            });
            dateElement.textContent = dateStr;

            // Cập nhật các múi giờ
            this.updateTimeZones(now);
        }
    }

    updateTimeZones(now) {
        const vietnamTimeElement = document.getElementById('vietnamTime');
        const tokyoTimeElement = document.getElementById('tokyoTime');
        
        if (vietnamTimeElement) {
            // Việt Nam (UTC+7)
            const vietnamTime = new Intl.DateTimeFormat('vi-VN', {
                timeZone: 'Asia/Ho_Chi_Minh',
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            }).format(now);
            vietnamTimeElement.textContent = vietnamTime;
        }

        if (tokyoTimeElement) {
            // Tokyo (UTC+9)
            const tokyoTime = new Intl.DateTimeFormat('ja-JP', {
                timeZone: 'Asia/Tokyo',
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            }).format(now);
            tokyoTimeElement.textContent = tokyoTime;
        }
    }

    renderCalendar() {
        const monthNames = [
            'T1', 'T2', 'T3', 'T4', 'T5', 'T6',
            'T7', 'T8', 'T9', 'T10', 'T11', 'T12'
        ];
        
        const dayNames = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];

        const monthYearElement = document.getElementById('monthYear');
        if (monthYearElement) {
            // Cập nhật tiêu đề tháng
            monthYearElement.textContent = 
                `${monthNames[this.viewDate.getMonth()]} ${this.viewDate.getFullYear()}`;
        }

        // Xóa lịch cũ
        const grid = document.getElementById('calendarGrid');
        if (!grid) return;
        
        grid.innerHTML = '';

        // Tạo tiêu đề các ngày trong tuần
        dayNames.forEach(day => {
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
            dayCell.addEventListener('click', () => {
                document.querySelectorAll('.day-cell.selected').forEach(cell => {
                    cell.classList.remove('selected');
                });
                dayCell.classList.add('selected');
                this.selectedDate = new Date(cellDate);
            });
            
            grid.appendChild(dayCell);
        }
    }

    isSameDay(date1, date2) {
        return date1.getDate() === date2.getDate() &&
               date1.getMonth() === date2.getMonth() &&
               date1.getFullYear() === date2.getFullYear();
    }

    bindEvents() {
        const prevBtn = document.getElementById('prevMonth');
        const nextBtn = document.getElementById('nextMonth');
        
        if (prevBtn) {
            prevBtn.addEventListener('click', () => {
                this.viewDate.setMonth(this.viewDate.getMonth() - 1);
                this.renderCalendar();
            });
        }

        if (nextBtn) {
            nextBtn.addEventListener('click', () => {
                this.viewDate.setMonth(this.viewDate.getMonth() + 1);
                this.renderCalendar();
            });
        }
    }
}

// Khởi tạo lịch khi script được load
const calendarInstance = new LiveCalendar();