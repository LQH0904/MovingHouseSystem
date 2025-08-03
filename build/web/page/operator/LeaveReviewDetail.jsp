<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="model.Users" %>
<%
// Kiểm tra session
    String redirectURL = null;
    if (session.getAttribute("acc") == null) {
        redirectURL = "/login";
        response.sendRedirect(request.getContextPath() + redirectURL);
        return;
    }

// Lấy thông tin user từ session
    Users userAccount = (Users) session.getAttribute("acc");
    int currentUserId = userAccount.getUserId(); // Dùng getUserId() từ Users class
    String currentUsername = userAccount.getUsername(); // Lấy thêm username để hiển thị
    int currentUserRoleId = userAccount.getRoleId();
%>
<html>
    
    <head>
        <title>Chi tiết đơn nghỉ phép</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
    /* Đảm bảo box model hoạt động như mong đợi */
    .div3 * {
        box-sizing: border-box;
    }

    /* Kiểu dáng cho container chính trong div3 */
    .div3 .container {
        max-width: 700px;
        margin: 40px auto; /* Căn giữa và thêm khoảng cách trên/dưới */
        padding: 30px;
        background-color: #ffffff;
        border-radius: 12px; /* Bo tròn góc */
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1); /* Đổ bóng nhẹ nhàng */
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; /* Font chữ hiện đại */
        color: #333;
    }

    /* Tiêu đề h2 */
    .div3 h2 {
        text-align: center;
        color: #2c3e50; /* Màu chữ đậm */
        margin-bottom: 30px;
        font-size: 2em; /* Kích thước chữ lớn hơn */
        font-weight: 600; /* Độ đậm vừa phải */
    }

    /* Kiểu dáng cho các label */
    .div3 label {
        display: block; /* Mỗi label trên một dòng mới */
        margin-bottom: 8px;
        font-weight: 500; /* Chữ đậm vừa */
        color: #555;
        font-size: 0.95em;
    }

    /* Kiểu dáng cho input và textarea */
    .div3 input[type="text"],
    .div3 textarea {
        width: 100%;
        padding: 12px 15px;
        margin-bottom: 20px;
        border: 1px solid #ddd; /* Viền nhẹ */
        border-radius: 8px; /* Bo tròn góc */
        font-size: 1em;
        color: #333;
        transition: border-color 0.3s ease, box-shadow 0.3s ease; /* Hiệu ứng chuyển động mượt mà */
    }

    .div3 input[type="text"]:focus,
    .div3 textarea:focus {
        border-color: #007bff; /* Viền xanh khi focus */
        box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.25); /* Đổ bóng khi focus */
        outline: none; /* Bỏ outline mặc định của trình duyệt */
    }

    .div3 textarea {
        resize: vertical; /* Cho phép thay đổi kích thước theo chiều dọc */
        min-height: 100px; /* Chiều cao tối thiểu */
    }

    /* Kiểu dáng cho các trường bị disabled */
    .div3 input[disabled],
    .div3 textarea[disabled] {
        background-color: #f0f2f5; /* Nền xám nhạt */
        cursor: not-allowed; /* Con trỏ không cho phép */
        color: #777;
    }

    /* Kiểu dáng cho div chứa các nút hành động */
    .div3 .actions {
        display: flex; /* Sắp xếp các nút trên cùng một hàng */
        gap: 15px; /* Khoảng cách giữa các nút */
        justify-content: flex-end; /* Căn các nút sang phải */
        margin-top: 30px;
    }

    /* Kiểu dáng chung cho các nút */
    .div3 .btn {
        padding: 12px 25px;
        border: none;
        border-radius: 8px;
        font-size: 1em;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease; /* Hiệu ứng chuyển động */
        color: #fff; /* Màu chữ trắng */
    }

    .div3 .btn:hover {
        transform: translateY(-2px); /* Nâng nút lên một chút khi hover */
    }

    /* Kiểu dáng cho nút Duyệt */
    .div3 .btn-approve {
        background-color: #28a745; /* Màu xanh lá cây */
    }

    .div3 .btn-approve:hover {
        background-color: #218838; /* Màu xanh lá cây đậm hơn khi hover */
    }

    /* Kiểu dáng cho nút Từ chối */
    .div3 .btn-reject {
        background-color: #dc3545; /* Màu đỏ */
    }

    .div3 .btn-reject:hover {
        background-color: #c82333; /* Màu đỏ đậm hơn khi hover */
    }

    /* Responsive adjustments */
    @media (max-width: 768px) {
        .div3 .container {
            margin: 20px;
            padding: 20px;
        }
        .div3 h2 {
            font-size: 1.8em;
        }
        .div3 .actions {
            flex-direction: column; /* Xếp các nút theo cột trên màn hình nhỏ */
            gap: 10px;
        }
        .div3 .btn {
            width: 100%; /* Nút chiếm toàn bộ chiều rộng */
        }
    }
</style>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="/Layout/operator/SideBar.jsp" />
            </div>
            <div class="div2">
                <jsp:include page="/Layout/operator/Header.jsp" />
            </div>
            <div class="div3">
                <div class="container">
                    <h2>Chi tiết đơn nghỉ phép</h2>

                    <form method="post" action="${pageContext.request.contextPath}/operator/review-leave-request">
                        <input type="hidden" name="requestId" value="${leaveRequest.requestId}" />

                        <label>Nhân viên:</label>
                        <input type="text" value="${leaveRequest.staffName}" disabled />

                        <label>Thời gian nghỉ:</label>
                        <input type="text" value="${leaveRequest.startDate} đến ${leaveRequest.endDate}" disabled />

                        <label>Số ngày nghỉ:</label>
                        <input type="text" value="${leaveRequest.numberOfDaysOff}" disabled />



                        <label>Lý do:</label>
                        <textarea disabled>${leaveRequest.reason}</textarea>

                        <label>Phản hồi:</label>
                        <textarea name="reply" required>${leaveRequest.operatorReply}</textarea>

                        <div class="actions">
                            <button class="btn btn-approve" name="status" value="approved" type="submit">✔ Duyệt đơn</button>
                            <button class="btn btn-reject" name="status" value="rejected" type="submit">✘ Từ chối đơn</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
