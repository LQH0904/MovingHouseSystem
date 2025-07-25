<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<html>
    <head>
        <title>Chi tiết đơn nghỉ phép</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f4f6f9;
                margin: 0;
                padding: 0;
            }

            .container {
                max-width: 750px;
                margin: 40px auto;
                background-color: #fff;
                padding: 35px 40px;
                border-radius: 14px;
                box-shadow: 0 12px 30px rgba(0,0,0,0.08);
                animation: fadeIn 0.4s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            h2 {
                text-align: center;
                font-size: 26px;
                margin-bottom: 30px;
                color: #2d3436;
                border-bottom: 1px solid #ddd;
                padding-bottom: 12px;
            }

            label {
                display: block;
                margin-top: 20px;
                font-weight: 600;
                color: #333;
            }

            input[type="text"],
            textarea {
                width: 100%;
                padding: 12px 14px;
                margin-top: 6px;
                border: 1px solid #ccc;
                border-radius: 6px;
                font-size: 15px;
                background-color: #fcfcfc;
                transition: border-color 0.3s ease, box-shadow 0.3s ease;
            }

            input[type="text"]:focus,
            textarea:focus {
                border-color: #3498db;
                box-shadow: 0 0 5px rgba(52, 152, 219, 0.25);
                outline: none;
            }

            input:disabled,
            textarea:disabled {
                background-color: #f1f1f1;
                color: #777;
            }

            textarea {
                resize: vertical;
                min-height: 100px;
            }

            .actions {
                margin-top: 30px;
                text-align: center;
            }

            .btn {
                display: inline-block;
                padding: 11px 24px;
                font-size: 15px;
                font-weight: bold;
                border: none;
                border-radius: 6px;
                cursor: pointer;
                transition: all 0.25s ease;
            }

            .btn-approve {
                background-color: #2ecc71;
                color: white;
            }

            .btn-approve:hover {
                background-color: #27ae60;
                transform: scale(1.03);
            }

            .btn-reject {
                background-color: #e74c3c;
                color: white;
                margin-left: 14px;
            }

            .btn-reject:hover {
                background-color: #c0392b;
                transform: scale(1.03);
            }
            button.btn-approve {
                background-color: #2ecc71 !important;
                color: white !important;
            }

            button.btn-reject {
                background-color: #e74c3c !important;
                color: white !important;
            }

            button.btn-approve:hover {
                background-color: #27ae60 !important;
            }

            button.btn-reject:hover {
                background-color: #c0392b !important;
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
