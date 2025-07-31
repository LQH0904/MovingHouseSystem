<%@ page import="model.CustomerSurvey" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
int currentUserRoleId = userAccount.getRoleId(); // Thêm dòng này để lấy role_id
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch Sử Khảo Sát Khách Hàng</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                min-height: 100vh;
                padding: 20px;
            }

            .container {
                max-width: 1200px;
                margin: 0 auto;
                background: rgba(255, 255, 255, 0.95);
                border-radius: 15px;
                box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
                overflow: hidden;
            }

            .header {
                background: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
                color: white;
                text-align: center;
                padding: 30px;
            }

            .header h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
            }

            .header p {
                font-size: 1.1rem;
                opacity: 0.9;
            }

            .content {
                padding: 30px;
            }

            .survey-grid {
                display: grid;
                gap: 25px;
                grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
            }

            .survey-card {
                background: white;
                border-radius: 12px;
                box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
                border-left: 5px solid #4f46e5;
                transition: transform 0.3s ease, box-shadow 0.3s ease;
                overflow: hidden;
            }

            .survey-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
            }

            .card-header {
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                padding: 20px;
                border-bottom: 1px solid #e2e8f0;
            }

            .card-header h3 {
                color: #1e293b;
                font-size: 1.2rem;
                margin-bottom: 5px;
            }

            .survey-date {
                color: #64748b;
                font-size: 0.9rem;
            }

            .card-body {
                padding: 20px;
            }

            .rating-section {
                margin-bottom: 20px;
            }

            .rating-section h4 {
                color: #374151;
                font-size: 1rem;
                margin-bottom: 10px;
                display: flex;
                align-items: center;
            }

            .rating-section h4::before {
                content: "⭐";
                margin-right: 8px;
            }

            .rating-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 10px;
                margin-bottom: 15px;
            }

            .rating-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 8px 12px;
                background: #f1f5f9;
                border-radius: 6px;
                font-size: 0.9rem;
            }

            .rating-value {
                font-weight: bold;
                color: #4f46e5;
            }

            .info-section {
                margin-bottom: 15px;
            }

            .info-section h4 {
                color: #374151;
                font-size: 0.95rem;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
            }

            .info-section h4::before {
                content: "📊";
                margin-right: 8px;
            }

            .info-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 8px;
            }

            .info-item {
                background: #f8fafc;
                padding: 6px 10px;
                border-radius: 4px;
                font-size: 0.85rem;
                border-left: 3px solid #e2e8f0;
            }

            .info-label {
                font-weight: 600;
                color: #64748b;
            }

            .info-value {
                color: #1e293b;
            }

            .feedback-section {
                margin-top: 15px;
                padding-top: 15px;
                border-top: 1px solid #e2e8f0;
            }

            .feedback-section h4 {
                color: #374151;
                font-size: 0.95rem;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
            }

            .feedback-section h4::before {
                content: "💬";
                margin-right: 8px;
            }

            .feedback-text {
                background: #f8fafc;
                padding: 10px;
                border-radius: 6px;
                font-style: italic;
                color: #64748b;
                min-height: 40px;
                border-left: 3px solid #4f46e5;
            }

            .no-data {
                text-align: center;
                padding: 50px;
                color: #64748b;
                font-size: 1.1rem;
            }

            .error-message {
                background: #fee2e2;
                color: #dc2626;
                padding: 15px;
                border-radius: 8px;
                margin-bottom: 20px;
                border-left: 4px solid #dc2626;
            }

            .stats-bar {
                background: #f1f5f9;
                padding: 20px;
                margin-bottom: 30px;
                border-radius: 10px;
                text-align: center;
            }

            .stats-item {
                display: inline-block;
                margin: 0 20px;
                color: #64748b;
            }

            .stats-number {
                font-size: 1.5rem;
                font-weight: bold;
                color: #4f46e5;
                display: block;
            }

            @media (max-width: 768px) {
                .survey-grid {
                    grid-template-columns: 1fr;
                }

                .rating-grid, .info-grid {
                    grid-template-columns: 1fr;
                }

                .container {
                    margin: 10px;
                    border-radius: 10px;
                }

                .header h1 {
                    font-size: 1.8rem;
                }

                .content {
                    padding: 20px;
                }
            }
            /* From Uiverse.io by ferlagher */
            .bnt_quaylai button {
                position: relative;
                font-size: 1.2em;
                padding: 0.7em 1.4em;
                background-color: #BF0426;
                text-decoration: none;
                border: none;
                border-radius: 0.5em;
                color: #DEDEDE;
                box-shadow: 0.5em 0.5em 0.5em rgba(0, 0, 0, 0.3);
            }

            .bnt_quaylai button::before {
                position: absolute;
                content: '';
                height: 0;
                width: 0;
                top: 0;
                left: 0;
                background: linear-gradient(135deg, rgb(255 149 149) 0%, rgb(115 84 84) 50%, rgba(150, 4, 31, 1) 50%, rgba(191, 4, 38, 1) 60%);
                border-radius: 0 0 0.5em 0;
                box-shadow: 0.2em 0.2em 0.2em rgba(0, 0, 0, 0.3);
                transition: 0.3s;
                border-radius: 0.5em;
            }

            .bnt_quaylai button:hover::before {
                width: 1.6em;
                height: 1.6em;
            }

            .bnt_quaylai button:active {
                box-shadow: 0.2em 0.2em 0.3em rgba(0, 0, 0, 0.3);
                transform: translate(0.1em, 0.1em);
            }

        </style>
    </head>
    <body>
        <div class="container">
            <div class="header">
                <h1>📊 Lịch Sử Thử Phiếu Khảo Sát Khách Hàng</h1>
                <p>Quản lý và theo dõi phản hồi từ khách hàng về dịch vụ vận chuyển</p>
            </div>

            <div class="content">
                <% 
                String error = (String) request.getAttribute("error");
                if (error != null) { 
                %>
                <div class="error-message">
                    ❌ <%= error %>
                </div>
                <% } %>

                <%
                @SuppressWarnings("unchecked")
                List<CustomerSurvey> surveyHistory = (List<CustomerSurvey>) request.getAttribute("surveyHistory");
            
                if (surveyHistory != null && !surveyHistory.isEmpty()) {
                %>
                <div class="stats-bar">
                    <div class="stats-item">
                        <span class="stats-number"><%= surveyHistory.size() %></span>
                        <span>Tổng số khảo sát</span>
                    </div>
                    <div class="stats-item">
                        <span class="stats-number">
                            <%= String.format("%.1f", surveyHistory.stream().mapToInt(CustomerSurvey::getOverall_satisfaction).average().orElse(0.0)) %>
                        </span>
                        <span>Điểm hài lòng TB</span>
                    </div>
                    <div class="stats-item">
                        <span class="stats-number">
                            <%= String.format("%.1f", surveyHistory.stream().mapToInt(CustomerSurvey::getRecommend_score).average().orElse(0.0)) %>
                        </span>
                        <span>Điểm giới thiệu TB</span>
                    </div>
                </div>

                <div class="survey-grid">
                    <% for (CustomerSurvey survey : surveyHistory) { %>
                    <div class="survey-card">
                        <div class="card-header">
                            <h3>Khảo sát #<%= survey.getSurveyId() %></h3>
                            <div class="survey-date">User ID: <%= survey.getUserId() %> | <%= survey.getSurveyDate().substring(0, 16).replace("T", " ") %></div>
                        </div>

                        <div class="card-body">
                            <div class="rating-section">
                                <h4>Đánh giá chung</h4>
                                <div class="rating-grid">
                                    <div class="rating-item">
                                        <span>Hài lòng tổng thể:</span>
                                        <span class="rating-value"><%= survey.getOverall_satisfaction() %>/5</span>
                                    </div>
                                    <div class="rating-item">
                                        <span>Giới thiệu cho người khác:</span>
                                        <span class="rating-value"><%= survey.getRecommend_score() %>/10</span>
                                    </div>
                                    <div class="rating-item">
                                        <span>Chăm sóc vận chuyển:</span>
                                        <span class="rating-value"><%= survey.getTransport_care() %>/5</span>
                                    </div>
                                    <div class="rating-item">
                                        <span>Tư vấn chuyên nghiệp:</span>
                                        <span class="rating-value"><%= survey.getConsultant_professionalism() %>/5</span>
                                    </div>
                                </div>
                            </div>

                            <div class="info-section">
                                <h4>Thông tin dịch vụ</h4>
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">So với mong đợi:</div>
                                        <div class="info-value"><%= survey.getExpectation() != null ? survey.getExpectation() : "Chưa đánh giá" %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Chất lượng đóng gói:</div>
                                        <div class="info-value"><%= survey.getPacking_quality() != null ? survey.getPacking_quality() : "Chưa đánh giá" %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Tình trạng đồ đạc:</div>
                                        <div class="info-value"><%= survey.getItem_condition() != null ? survey.getItem_condition() : "Chưa đánh giá" %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Đúng giờ giao hàng:</div>
                                        <div class="info-value"><%= survey.getDelivery_timeliness() != null ? survey.getDelivery_timeliness() : "Chưa đánh giá" %></div>
                                    </div>
                                </div>
                            </div>

                            <div class="info-section">
                                <h4>Thông tin khách hàng</h4>
                                <div class="info-grid">
                                    <div class="info-item">
                                        <div class="info-label">Độ tuổi:</div>
                                        <div class="info-value"><%= survey.getAge_group() != null ? survey.getAge_group() : "Chưa cung cấp" %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Khu vực:</div>
                                        <div class="info-value"><%= survey.getArea() != null ? survey.getArea() : "Chưa cung cấp" %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Loại nhà:</div>
                                        <div class="info-value"><%= survey.getHousing_type() != null ? survey.getHousing_type() : "Chưa cung cấp" %></div>
                                    </div>
                                    <div class="info-item">
                                        <div class="info-label">Yếu tố quan trọng:</div>
                                        <div class="info-value"><%= survey.getImportant_factor() != null ? survey.getImportant_factor() : "Chưa cung cấp" %></div>
                                    </div>
                                </div>
                            </div>

                            <% if (survey.getFeedback() != null && !survey.getFeedback().trim().isEmpty()) { %>
                            <div class="feedback-section">
                                <h4>Phản hồi từ khách hàng</h4>
                                <div class="feedback-text">
                                    "<%= survey.getFeedback() %>"
                                </div>
                            </div>
                            <% } %>

                            <% if (survey.getAdditional_service() != null && !survey.getAdditional_service().trim().isEmpty()) { %>
                            <div class="feedback-section">
                                <h4>Dịch vụ bổ sung mong muốn</h4>
                                <div class="feedback-text">
                                    <%= survey.getAdditional_service() %>
                                </div>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    <% } %>
                </div>
                <% } else { %>
                <div class="no-data">
                    <h3>📋 Chưa có dữ liệu khảo sát</h3>
                    <p>Hiện tại chưa có khảo sát nào từ nhân viên trong hệ thống.</p>
                </div>
                <% } %>
            </div>
        </div>
        <div style="margin-top: 40px; display: flex; justify-content: space-around;">
            <a class="bnt_quaylai" href="http://localhost:9999/HouseMovingSystem/SurveyTestController">
                <button>
                    <b>Trở về trang Test phiếu khảo sát</b>
                </button>
            </a>
            <% if (currentUserRoleId != 3) { %>
            <a class="bnt_quaylai" href="http://localhost:9999/HouseMovingSystem/homeOperator">
                <button>
                    <b>Quay lại trang chủ</b>
                </button>
            </a>
            <% } %>
            <% if (currentUserRoleId == 3) { %>
            <a class="bnt_quaylai" href="http://localhost:9999/HouseMovingSystem/homeStaff">
                <button>
                    <b>Quay lại trang chủ</b>
                </button>
            </a>
            <% } %>
        </div>

    </body>
</html>