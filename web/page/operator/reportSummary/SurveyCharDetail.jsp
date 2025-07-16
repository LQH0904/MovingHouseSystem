<%-- 
    Document   : SurveyCharDetail
    Created on : Jul 8, 2025, 9:40:23 PM
    Author     : Admin
--%>

<%@page import="model.CustomerSurvey"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Chi Tiết Khảo Sát Khách Hàng</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/SideBar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/HomePage.css">
        <style>
            .filter-section {
                background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #a855f7 100%);
                color: white;
                padding: 10px 15px;
                border-radius: 20px;
                margin-bottom: 15px;
                box-shadow: 0 10px 40px rgba(99, 102, 241, 0.3);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                position: relative;
                overflow: hidden;
            }
            
            .filter-section::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="25" cy="25" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="75" cy="75" r="1" fill="rgba(255,255,255,0.1)"/><circle cx="50" cy="10" r="0.5" fill="rgba(255,255,255,0.05)"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
                pointer-events: none;
            }
            
            .filter-header {
                display: flex;
                align-items: center;
                margin-bottom:-10px;
                position: relative;
                z-index: 1;
            }
            
            .filter-icon {
                background: rgba(255, 255, 255, 0.2);
                border-radius: 12px;
                padding: 10px;
                margin-right: 15px;
                font-size: 20px;
                display: flex;
                align-items: center;
                justify-content: center;
                width: 45px;
                height: 45px;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            
            .filter-title {
                font-size: 18px;
                font-weight: 700;
                margin: 0;
                text-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            }
            
            .filter-form {
                display: flex;
                gap: 20px;
                align-items: end;
                flex-wrap: wrap;
                position: relative;
                z-index: 1;
                justify-content: center;
            }
            
            @media (max-width: 768px) {
                .filter-form {
                    flex-direction: column;
                    align-items: stretch;
                    gap: 15px;
                }
            }
            
            .filter-group {
                display: flex;
                flex-direction: column;
                gap: 8px;
                min-width: 180px;
                position: relative;
            }
            
            .filter-group label {
                font-weight: 600;
                font-size: 14px;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
                display: flex;
                align-items: center;
                gap: 8px;
            }
            
            .filter-group input {
                padding: 12px 16px;
                border: 2px solid rgba(255, 255, 255, 0.2);
                border-radius: 12px;
                background: rgba(255, 255, 255, 0.15);
                color: white;
                font-size: 14px;
                font-weight: 500;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                backdrop-filter: blur(10px);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            }
            
            .filter-group input:focus {
                outline: none;
                border-color: rgba(255, 255, 255, 0.6);
                background: rgba(255, 255, 255, 0.25);
                box-shadow: 0 0 0 4px rgba(255, 255, 255, 0.1), 0 4px 20px rgba(0, 0, 0, 0.15);
                transform: translateY(-2px);
            }
            
            .filter-group input::placeholder {
                color: rgba(255, 255, 255, 0.7);
            }
            
            .filter-buttons {
                display: flex;
                gap: 12px;
                align-items: end;
            }
            
            .btn {
                padding: 12px 24px;
                border: none;
                border-radius: 12px;
                cursor: pointer;
                font-weight: 600;
                font-size: 14px;
                text-decoration: none;
                display: inline-flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                text-transform: none;
                letter-spacing: 0.5px;
                position: relative;
                overflow: hidden;
            }
            
            .btn::before {
                content: '';
                position: absolute;
                top: 0;
                left: -100%;
                width: 100%;
                height: 100%;
                background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
                transition: left 0.5s;
            }
            
            .btn:hover::before {
                left: 100%;
            }
            
            .btn-filter {
                background: linear-gradient(135deg, #10b981 0%, #059669 100%);
                color: white;
            }
            
            .btn-filter:hover {
                background: linear-gradient(135deg, #059669 0%, #047857 100%);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(16, 185, 129, 0.4);
            }
            
            .btn-reset {
                background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
                color: white;
            }
            
            .btn-reset:hover {
                background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
                transform: translateY(-3px);
                box-shadow: 0 8px 25px rgba(239, 68, 68, 0.4);
            }
            
            .survey-grid {
                display: grid;
                gap: 20px;
                grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
                margin-bottom: 30px;
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
                padding: 15px 20px;
                border-bottom: 1px solid #e2e8f0;
            }
            
            .card-header h3 {
                color: #1e293b;
                font-size: 1.1rem;
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
                margin-bottom: 15px;
            }
            
            .rating-section h4 {
                color: #374151;
                font-size: 0.95rem;
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
                grid-template-columns: 1fr 1fr;
                gap: 8px;
                margin-bottom: 10px;
            }
            
            .rating-item {
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 6px 10px;
                background: #f1f5f9;
                border-radius: 5px;
                font-size: 0.85rem;
            }
            
            .rating-value {
                font-weight: bold;
                color: #4f46e5;
            }
            
            .info-section {
                margin-bottom: 12px;
            }
            
            .info-section h4 {
                color: #374151;
                font-size: 0.9rem;
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
                grid-template-columns: 1fr 1fr;
                gap: 6px;
                font-size: 0.8rem;
            }
            
            .info-item {
                padding: 4px 8px;
                background: #f8fafc;
                border-radius: 4px;
                border-left: 3px solid #e2e8f0;
            }
            
            .feedback-section {
                border-top: 1px solid #e2e8f0;
                padding-top: 15px;
                margin-top: 15px;
            }
            
            .feedback-section h4 {
                color: #374151;
                font-size: 0.9rem;
                margin-bottom: 8px;
                display: flex;
                align-items: center;
            }
            
            .feedback-section h4::before {
                content: "💬";
                margin-right: 8px;
            }
            
            .feedback-text {
                background: #f1f5f9;
                padding: 10px;
                border-radius: 6px;
                font-size: 0.85rem;
                line-height: 1.4;
                color: #475569;
            }
            
            .pagination {
                display: flex;
                justify-content: center;
                align-items: center;
                gap: 10px;
                margin-top: 30px;
                padding: 20px;
            }
            
            .page-btn {
                padding: 8px 12px;
                background: #f1f5f9;
                color: #64748b;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s;
            }
            
            .page-btn:hover {
                background: #e2e8f0;
                color: #334155;
            }
            
            .page-btn.active {
                background: #4f46e5;
                color: white;
            }
            
            .page-btn:disabled {
                background: #f8fafc;
                color: #cbd5e1;
                cursor: not-allowed;
            }
            
            .page-info {
                font-size: 0.9rem;
                color: #64748b;
                margin: 0 15px;
            }
            
            .no-surveys {
                text-align: center;
                padding: 60px 20px;
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
            
            .survey-stats {
                background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
                padding: 15px 20px;
                border-radius: 10px;
                margin-bottom: 20px;
                border: 1px solid #0ea5e9;
            }
            
            .stats-text {
                color: #0c4a6e;
                font-weight: 600;
                text-align: center;
            }
            .cssbuttons-io-button {
                background-image: linear-gradient(19deg, #21D4FD 0%, #B721FF 100%);
                color: white;
                font-family: inherit;
                padding: 0.35em;
                padding-left: 1.2em;
                font-size: 17px;
                border-radius: 10em;
                border: none;
                letter-spacing: 0.05em;
                display: flex;
                align-items: center;
                overflow: hidden;
                position: relative;
                height: 2.8em;
                padding-right: 3.3em;
                cursor: pointer;
                text-transform: uppercase;
                font-weight: 500;
                box-shadow: 0 0 1.6em rgba(183, 33, 255,0.3),0 0 1.6em hsla(191, 98%, 56%, 0.3);
                transition: all 0.6s cubic-bezier(0.23, 1, 0.320, 1);
            }

            .cssbuttons-io-button {
                background: #a370f0;
                color: white;
                font-family: inherit;
                padding: 0.35em;
                padding-left: 1.2em;
                font-size: 17px;
                font-weight: 500;
                border-radius: 0.9em;
                border: none;
                letter-spacing: 0.05em;
                display: flex;
                align-items: center;
                box-shadow: inset 0 0 1.6em -0.6em #714da6;
                overflow: hidden;
                position: relative;
                height: 2.8em;
                padding-right: 3.3em;
                cursor: pointer;
            }

            .cssbuttons-io-button .icon {
                background: white;
                margin-left: 1em;
                position: absolute;
                display: flex;
                align-items: center;
                justify-content: center;
                height: 2.2em;
                width: 2.2em;
                border-radius: 0.7em;
                box-shadow: 0.1em 0.1em 0.6em 0.2em #7b52b9;
                right: 0.3em;
                transition: all 0.3s;
            }

            .cssbuttons-io-button:hover .icon {
                width: calc(100% - 0.6em);
            }

            .cssbuttons-io-button .icon svg {
                width: 1.1em;
                transition: transform 0.3s;
                color: #7b52b9;
            }

            .cssbuttons-io-button:hover .icon svg {
                transform: translateX(0.1em);
            }

            .cssbuttons-io-button:active .icon {
                transform: scale(0.95);
            }

            a:hover{
                text-decoration: none;
            }
            .butt{
                display: flex;
                justify-content: flex-start;
                margin: 20px;
            }
        </style>
    </head>
    <body>
        <div class="parent">
            <div class="div1">
                <jsp:include page="../../../Layout/operator/SideBar.jsp"></jsp:include>
            </div>
            <div class="div2">
                <jsp:include page="../../../Layout/operator/Header.jsp"></jsp:include>
            </div>
            <div class="div3">
                <div style="padding: 20px;">
                    <h2 style="text-align: center; color: #1e293b; margin-bottom: 15px;">
                        📋 Chi Tiết Khảo Sát Khách Hàng
                    </h2>
                    
                    <!-- Bộ lọc thời gian -->
                    <div class="filter-section">
                        <div class="filter-header">
                            <div class="filter-icon">🔍</div>
                            <h3 class="filter-title">Bộ lọc thời gian</h3>
                        </div>
                        <form method="get" action="SurveyCharDetailController" class="filter-form">
                            <div class="filter-group">
                                <label for="fromMonth">
                                    📅 Từ tháng:
                                </label>
                                <input type="month" id="fromMonth" name="fromMonth" 
                                       value="${fromMonth}" placeholder="YYYY-MM">
                            </div>
                            <div class="filter-group">
                                <label for="toMonth">
                                    📅 Đến tháng:
                                </label>
                                <input type="month" id="toMonth" name="toMonth" 
                                       value="${toMonth}" placeholder="YYYY-MM">
                            </div>
                            <div class="filter-buttons">
                                <button type="submit" class="btn btn-filter">
                                    ✨ Lọc dữ liệu
                                </button>
                                <a href="SurveyCharDetailController" class="btn btn-reset">
                                    🗑️ Xóa bộ lọc
                                </a>
                            </div>
                        </form>
                    </div>

                    <%-- Hiển thị thông báo lỗi nếu có --%>
                    <% if (request.getAttribute("errorMessage") != null) { %>
                        <div class="error-message">
                            <%= request.getAttribute("errorMessage") %>
                        </div>
                    <% } %>

                    <%-- Thống kê --%>
                    <% if (request.getAttribute("totalSurveys") != null) { %>
                        <div class="survey-stats">
                            <div class="stats-text">
                                Tổng số khảo sát: <%= request.getAttribute("totalSurveys") %> | 
                                Trang <%= request.getAttribute("currentPage") %> / <%= request.getAttribute("totalPages") %>
                            </div>
                        </div>
                    <% } %>

                    <%-- Danh sách khảo sát --%>
                    <%
                        @SuppressWarnings("unchecked")
                        List<CustomerSurvey> surveys = (List<CustomerSurvey>) request.getAttribute("surveys");
                        
                        if (surveys != null && !surveys.isEmpty()) {
                    %>
                        <div class="survey-grid">
                            <% for (CustomerSurvey survey : surveys) { %>
                                <div class="survey-card">
                                    <div class="card-header">
                                        <h3>Khảo sát #<%= survey.getSurveyId() %> (ID người khảo sát: <%= survey.getUserId() %>)</h3>
                                        <div class="survey-date">📅 <%= survey.getSurveyDate().substring(0, 16).replace("T", " ") %></div>
                                    </div>
                                    
                                    <div class="card-body">
                                        <!-- Đánh giá số -->
                                        <div class="rating-section">
                                            <h4>Điểm đánh giá</h4>
                                            <div class="rating-grid">
                                                <div class="rating-item">
                                                    <span>Hài lòng chung:</span>
                                                    <span class="rating-value"><%= survey.getOverall_satisfaction() %>/5</span>
                                                </div>
                                                <div class="rating-item">
                                                    <span>Điểm giới thiệu:</span>
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

                                        <!-- Thông tin đánh giá chất lượng -->
                                        <div class="info-section">
                                            <h4>Đánh giá chất lượng</h4>
                                            <div class="info-grid">
                                                <div class="info-item">
                                                    <strong>Mong đợi:</strong> <%= survey.getExpectation() != null ? survey.getExpectation() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Đóng gói:</strong> <%= survey.getPacking_quality() != null ? survey.getPacking_quality() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Tình trạng hàng:</strong> <%= survey.getItem_condition() != null ? survey.getItem_condition() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Đúng giờ:</strong> <%= survey.getDelivery_timeliness() != null ? survey.getDelivery_timeliness() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Đặt hàng:</strong> <%= survey.getBooking_process() != null ? survey.getBooking_process() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Phản hồi:</strong> <%= survey.getResponse_time() != null ? survey.getResponse_time() : "N/A" %>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Thông tin khách hàng -->
                                        <div class="info-section">
                                            <h4>Thông tin khách hàng</h4>
                                            <div class="info-grid">
                                                <div class="info-item">
                                                    <strong>Độ tuổi:</strong> <%= survey.getAge_group() != null ? survey.getAge_group() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Khu vực:</strong> <%= survey.getArea() != null ? survey.getArea() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Loại nhà:</strong> <%= survey.getHousing_type() != null ? survey.getHousing_type() : "N/A" %>
                                                </div>
                                                <div class="info-item">
                                                    <strong>Tần suất:</strong> <%= survey.getUsage_frequency() != null ? survey.getUsage_frequency() : "N/A" %>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Phản hồi -->
                                        <% if (survey.getFeedback() != null && !survey.getFeedback().trim().isEmpty()) { %>
                                            <div class="feedback-section">
                                                <h4>Phản hồi của khách hàng</h4>
                                                <div class="feedback-text">
                                                    <%= survey.getFeedback() %>
                                                </div>
                                            </div>
                                        <% } %>
                                    </div>
                                </div>
                            <% } %>
                        </div>

                        <%-- Phân trang --%>
                        <%
                            Integer currentPage = (Integer) request.getAttribute("currentPage");
                            Integer totalPages = (Integer) request.getAttribute("totalPages");
                            String fromMonth = (String) request.getAttribute("fromMonth");
                            String toMonth = (String) request.getAttribute("toMonth");
                            
                            if (totalPages != null && totalPages > 1) {
                        %>
                            <div class="pagination">
                                <%-- Nút Previous --%>
                                <% if (currentPage > 1) { %>
                                    <a href="SurveyCharDetailController?page=<%= currentPage - 1 %><%= (fromMonth != null ? "&fromMonth=" + fromMonth : "") %><%= (toMonth != null ? "&toMonth=" + toMonth : "") %>" 
                                       class="page-btn">← Trước</a>
                                <% } else { %>
                                    <button class="page-btn" disabled>← Trước</button>
                                <% } %>

                                <%-- Hiển thị các trang --%>
                                <% 
                                    int startPage = Math.max(1, currentPage - 2);
                                    int endPage = Math.min(totalPages, currentPage + 2);
                                    
                                    for (int i = startPage; i <= endPage; i++) { 
                                %>
                                    <% if (i == currentPage) { %>
                                        <button class="page-btn active"><%= i %></button>
                                    <% } else { %>
                                        <a href="SurveyCharDetailController?page=<%= i %><%= (fromMonth != null ? "&fromMonth=" + fromMonth : "") %><%= (toMonth != null ? "&toMonth=" + toMonth : "") %>" 
                                           class="page-btn"><%= i %></a>
                                    <% } %>
                                <% } %>

                                <%-- Nút Next --%>
                                <% if (currentPage < totalPages) { %>
                                    <a href="SurveyCharDetailController?page=<%= currentPage + 1 %><%= (fromMonth != null ? "&fromMonth=" + fromMonth : "") %><%= (toMonth != null ? "&toMonth=" + toMonth : "") %>" 
                                       class="page-btn">Sau →</a>
                                <% } else { %>
                                    <button class="page-btn" disabled>Sau →</button>
                                <% } %>

                                <div class="page-info">
                                    Trang <%= currentPage %> / <%= totalPages %>
                                </div>
                            </div>
                        <% } %>

                    <% } else { %>
                        <div class="no-surveys">
                            <h3>📭 Không có dữ liệu khảo sát</h3>
                            <p>Không tìm thấy dữ liệu khảo sát trong khoảng thời gian được chọn.</p>
                        </div>
                    <% } %>
                </div>
                <div class="butt">
                    <a href="http://localhost:9999/HouseMovingSystem/SurveyCustomerCharController?action=page">
                        <button class="cssbuttons-io-button">
                            Quay lại trang biểu đồ
                            <div class="icon">
                                <svg
                                    height="24"
                                    width="24"
                                    viewBox="0 0 24 24"
                                    xmlns="http://www.w3.org/2000/svg"
                                    >
                                <path d="M0 0h24v24H0z" fill="none"></path>
                                <path
                                    d="M16.172 11l-5.364-5.364 1.414-1.414L20 12l-7.778 7.778-1.414-1.414L20 12l-7.778 7.778-1.414-1.414L16.172 13H4v-2z"
                                    fill="currentColor"
                                    ></path>
                                </svg>
                            </div>
                        </button>
                    </a> 
                </div>
            </div>
        </div>    
    </body>
</html>