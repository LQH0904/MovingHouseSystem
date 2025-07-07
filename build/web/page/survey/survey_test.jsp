
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
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Khảo Sát Khách Hàng - Dịch Vụ Vận Chuyển</title>
        <link rel="stylesheet" href="page/survey/survey_config.css">
    </head>
    <body>
        <div class="survey-container">
            <div class="survey-header">
                <h1>🏠 Khảo Sát Khách Hàng</h1>
                <p>Chia sẻ trải nghiệm của bạn về dịch vụ vận chuyển nhà và nội thất</p>
                <p style="color: black; ">Test phiếu khảo sát khách hàng</p>
            </div>

            <div class="survey-form">
                <form id="surveyForm" action="SurveyTestController" method="post">
                    <!-- Thông tin khách hàng -->
                    <div class="form-section">
                        <h3>👤 Thông Tin Khách Hàng</h3>

                        <!-- Customer Info Card -->
                        <div class="customer-info-card" style="
                             background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                             border-radius: 12px;
                             padding: 20px;
                             margin-bottom: 20px;
                             color: white;
                             box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
                             border: 1px solid rgba(255, 255, 255, 0.2);
                             ">
                            <div style="display: flex; align-items: center; margin-bottom: 15px;">
                                <div style="
                                     background: rgba(255, 255, 255, 0.2);
                                     border-radius: 50%;
                                     width: 50px;
                                     height: 50px;
                                     display: flex;
                                     align-items: center;
                                     justify-content: center;
                                     margin-right: 15px;
                                     font-size: 24px;
                                     ">
                                    👨‍💼
                                </div>
                                <div>
                                    <h4 style="margin: 0; font-size: 18px; font-weight: 600;">
                                        <%= currentUsername %>
                                    </h4>
                                    <p style="margin: 5px 0 0 0; opacity: 0.9; font-size: 14px;">
                                        Khách hàng đã đăng nhập
                                    </p>
                                </div>
                            </div>

                            <div style="
                                 background: rgba(255, 255, 255, 0.1);
                                 border-radius: 8px;
                                 padding: 12px;
                                 backdrop-filter: blur(10px);
                                 ">
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span style="font-weight: 500;">Mã khách hàng:</span>
                                    <span style="
                                          background: rgba(255, 255, 255, 0.2);
                                          padding: 6px 12px;
                                          border-radius: 20px;
                                          font-weight: 600;
                                          font-size: 16px;
                                          ">
                                        <%= currentUserId %>
                                    </span>
                                </div>
                            </div>
                        </div>

                        <!-- Hidden Input (for form submission) -->
                        <input type="hidden" name="user_id" value="<%= currentUserId %>">

                        <!-- Info Note -->
                        <div style="
                             background: #f8f9fa;
                             border-left: 4px solid #28a745;
                             padding: 12px 16px;
                             border-radius: 0 8px 8px 0;
                             margin-top: 15px;
                             ">
                            <div style="display: flex; align-items: center;">
                                <span style="color: #28a745; margin-right: 8px; font-size: 16px;">ℹ️</span>
                                <small style="color: #6c757d; margin: 0;">
                                    Thông tin khách hàng được lấy tự động từ tài khoản đăng nhập
                                </small>
                            </div>
                        </div>
                    </div>

                    <!-- Đánh giá tổng quan -->
                    <div class="form-section">
                        <h3>Đánh Giá Tổng Quan</h3>

                        <div class="form-group">
                            <label>Mức độ hài lòng tổng thể <span class="required">*</span></label>
                            <div class="rating-container">
                                <div class="rating-item">
                                    <input type="radio" id="satisfaction_1" name="overall_satisfaction" value="1" required>
                                    <label for="satisfaction_1">1 - Rất không hài lòng</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="satisfaction_2" name="overall_satisfaction" value="2">
                                    <label for="satisfaction_2">2 - Không hài lòng</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="satisfaction_3" name="overall_satisfaction" value="3">
                                    <label for="satisfaction_3">3 - Bình thường</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="satisfaction_4" name="overall_satisfaction" value="4">
                                    <label for="satisfaction_4">4 - Hài lòng</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="satisfaction_5" name="overall_satisfaction" value="5">
                                    <label for="satisfaction_5">5 - Rất hài lòng</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Bạn có khả năng giới thiệu dịch vụ cho người khác không? <span class="required">*</span></label>
                            <div class="nps-scale">
                                <div class="nps-item">
                                    <input type="radio" id="nps_0" name="recommend_score" value="0" required>
                                    <span>0</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_1" name="recommend_score" value="1">
                                    <span>1</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_2" name="recommend_score" value="2">
                                    <span>2</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_3" name="recommend_score" value="3">
                                    <span>3</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_4" name="recommend_score" value="4">
                                    <span>4</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_5" name="recommend_score" value="5">
                                    <span>5</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_6" name="recommend_score" value="6">
                                    <span>6</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_7" name="recommend_score" value="7">
                                    <span>7</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_8" name="recommend_score" value="8">
                                    <span>8</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_9" name="recommend_score" value="9">
                                    <span>9</span>
                                </div>
                                <div class="nps-item">
                                    <input type="radio" id="nps_10" name="recommend_score" value="10">
                                    <span>10</span>
                                </div>
                            </div>
                            <div class="nps-labels">
                                <span>Hoàn toàn không</span>
                                <span>Chắc chắn sẽ giới thiệu</span>
                            </div>
                        </div>
                    </div>

                    <!-- Đánh giá chi tiết dịch vụ -->
                    <div class="form-section">
                        <h3>Đánh Giá Chi Tiết Dịch Vụ</h3>

                        <div class="form-group">
                            <label>Chăm sóc trong quá trình vận chuyển <span class="required">*</span></label>
                            <div class="rating-container">
                                <div class="rating-item">
                                    <input type="radio" id="transport_1" name="transport_care" value="1" required>
                                    <label for="transport_1">1 - Rất kém</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="transport_2" name="transport_care" value="2">
                                    <label for="transport_2">2 - Kém</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="transport_3" name="transport_care" value="3">
                                    <label for="transport_3">3 - Bình thường</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="transport_4" name="transport_care" value="4">
                                    <label for="transport_4">4 - Tốt</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="transport_5" name="transport_care" value="5">
                                    <label for="transport_5">5 - Rất tốt</label>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>Tính chuyên nghiệp của tư vấn viên <span class="required">*</span></label>
                            <div class="rating-container">
                                <div class="rating-item">
                                    <input type="radio" id="consultant_1" name="consultant_professionalism" value="1" required>
                                    <label for="consultant_1">1 - Rất kém</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="consultant_2" name="consultant_professionalism" value="2">
                                    <label for="consultant_2">2 - Kém</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="consultant_3" name="consultant_professionalism" value="3">
                                    <label for="consultant_3">3 - Bình thường</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="consultant_4" name="consultant_professionalism" value="4">
                                    <label for="consultant_4">4 - Tốt</label>
                                </div>
                                <div class="rating-item">
                                    <input type="radio" id="consultant_5" name="consultant_professionalism" value="5">
                                    <label for="consultant_5">5 - Rất tốt</label>
                                </div>
                            </div>
                        </div>

                        <!-- Expectation -->
                        <div class="form-group">
                            <label for="expectation">Dịch vụ so với mong đợi của bạn <span class="required">*</span></label>
                            <div style="display: flex; align-items: center;">
                                <select id="expectation-list" name="expectation" class="form-control" required style="flex: 1;">
                                    <!-- Options sẽ được load từ JavaScript -->
                                </select>
                            </div>
                        </div>

                        <!-- Packing Quality -->
                        <div class="form-group">
                            <label for="packing_quality">Chất lượng đóng gói <span class="required">*</span></label>
                            <div style="display: flex; align-items: center;">
                                <select id="packing_quality-list" name="packing_quality" class="form-control" required style="flex: 1;">
                                    <!-- Options sẽ được load từ JavaScript -->
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="item_condition">Tình trạng đồ đạc khi nhận <span class="required">*</span></label>
                            <select id="item_condition" name="item_condition" class="form-control" required>
                                <option value="">-- Chọn tình trạng --</option>
                                <option value="Hoàn hảo">Hoàn hảo</option>
                                <option value="Trầy xước nhỏ">Trầy xước nhỏ</option>
                                <option value="Hư hỏng nhẹ">Hư hỏng nhẹ</option>
                                <option value="Hư hỏng nặng">Hư hỏng nặng</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="delivery_timeliness">Tính đúng giờ của việc giao hàng <span class="required">*</span></label>
                            <select id="delivery_timeliness" name="delivery_timeliness" class="form-control" required>
                                <option value="">-- Chọn mức độ --</option>
                                <option value="Đúng giờ">Đúng giờ</option>
                                <option value="Chậm dưới 1h">Chậm dưới 1 giờ</option>
                                <option value="Chậm 1-3h">Chậm 1-3 giờ</option>
                                <option value="Chậm trên 3h">Chậm trên 3 giờ</option>
                            </select>
                        </div>
                    </div>

                    <!-- Quy trình và dịch vụ -->
                    <div class="form-section">
                        <h3>Quy Trình và Dịch Vụ</h3>

                        <div class="form-group">
                            <label for="booking_process">Quy trình đặt dịch vụ <span class="required">*</span></label>
                            <select id="booking_process" name="booking_process" class="form-control" required>
                                <option value="">-- Chọn mức độ --</option>
                                <option value="Rất dễ">Rất dễ</option>
                                <option value="Dễ">Dễ</option>
                                <option value="Bình thường">Bình thường</option>
                                <option value="Khó">Khó</option>
                                <option value="Rất khó">Rất khó</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="response_time">Thời gian phản hồi <span class="required">*</span></label>
                            <select id="response_time" name="response_time" class="form-control" required>
                                <option value="">-- Chọn mức độ --</option>
                                <option value="Rất nhanh">Rất nhanh</option>
                                <option value="Nhanh">Nhanh</option>
                                <option value="Bình thường">Bình thường</option>
                                <option value="Chậm">Chậm</option>
                                <option value="Rất chậm">Rất chậm</option>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="price_transparency">Tính minh bạch của giá cả <span class="required">*</span></label>
                            <select id="price_transparency" name="price_transparency" class="form-control" required>
                                <option value="">-- Chọn mức độ --</option>
                                <option value="Rất rõ ràng">Rất rõ ràng</option>
                                <option value="Rõ ràng">Rõ ràng</option>
                                <option value="Bình thường">Bình thường</option>
                                <option value="Chưa rõ">Chưa rõ</option>
                                <option value="Không rõ">Không rõ</option>
                            </select>
                        </div>
                    </div>

                    <!-- Thông tin cá nhân -->
                    <div class="form-section">
                        <h3>Thông Tin Cá Nhân</h3>

                        <!-- Age Group -->
                        <div class="form-group">
                            <label for="age_group">Độ tuổi <span class="required">*</span></label>
                            <div style="display: flex; align-items: center;">
                                <select id="age_group" name="age_group" class="form-control" required style="flex: 1;">
                                    <!-- Options sẽ được load từ JavaScript -->
                                </select>
                            </div>
                        </div>

                        <!-- Area -->
                        <div class="form-group">
                            <label for="area">Khu vực <span class="required">*</span></label>
                            <div style="display: flex; align-items: center;">
                                <select id="area" name="area" class="form-control" required style="flex: 1;">
                                    <!-- Options sẽ được load từ JavaScript -->
                                </select>
                            </div>
                        </div>

                        <!-- Housing Type -->
                        <div class="form-group">
                            <label for="housing_type">Loại nhà ở <span class="required">*</span></label>
                            <div style="display: flex; align-items: center;">
                                <select id="housing_type" name="housing_type" class="form-control" required style="flex: 1;">
                                    <!-- Options sẽ được load từ JavaScript -->
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="usage_frequency">Tần suất sử dụng dịch vụ <span class="required">*</span></label>
                            <select id="usage_frequency" name="usage_frequency" class="form-control" required>
                                <option value="">-- Chọn tần suất --</option>
                                <option value="Lần đầu">Lần đầu</option>
                                <option value="1-2 lần">1-2 lần</option>
                                <option value="3-5 lần">3-5 lần</option>
                                <option value="Trên 5 lần">Trên 5 lần</option>
                            </select>
                        </div>

                        <!-- Important Factor -->
                        <div class="form-group">
                            <label for="important_factor">Yếu tố quan trọng nhất <span class="required">*</span></label>
                            <div style="display: flex; align-items: center;">
                                <select id="important_factor" name="important_factor" class="form-control" required style="flex: 1;">
                                    <!-- Options sẽ được load từ JavaScript -->
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Góp ý thêm -->
                    <div class="form-section">
                        <h3>Góp Ý Thêm</h3>

                        <div class="form-group">
                            <label for="additional_service">Dịch vụ bổ sung mong muốn</label>
                            <input type="text" id="additional_service" name="additional_service" class="form-control" placeholder="Ví dụ: Dọn dẹp, lắp đặt, bảo hiểm...">
                        </div>

                        <div class="form-group">
                            <label for="feedback">Ý kiến phản hồi</label>
                            <textarea id="feedback" name="feedback" class="form-control" placeholder="Chia sẻ thêm về trải nghiệm của bạn..."></textarea>
                        </div>
                    </div>

                    <!-- Hiển thị thông báo lỗi -->
                    <% String error = (String) request.getAttribute("error"); %>
                    <% if (error != null) { %>
                    <div class="error-message" style="background-color: #f8d7da; color: #721c24; padding: 10px; margin: 10px 0; border: 1px solid #f5c6cb; border-radius: 5px;">
                        ❌ <%= error %>
                    </div>
                    <% } %>

                    <!-- Hiển thị thông báo thành công -->
                    <% String success = (String) request.getAttribute("success"); %>
                    <% if (success != null) { %>
                    <div class="success-message" style="background-color: #d4edda; color: #155724; padding: 15px; margin: 10px 0; border: 1px solid #c3e6cb; border-radius: 5px;">
                        <h3>✅ <%= success %></h3>
                        <p>Ý kiến của bạn rất quan trọng và sẽ giúp chúng tôi cải thiện dịch vụ tốt hơn.</p>
                    </div>
                    <% } %>

                    <!-- 2. Thay đổi nút submit - THÊM name="submit" -->
                    <button type="submit" name="submit" value="submitSurvey" class="submit-btn">
                        🚀 Gửi Khảo Sát
                    </button>
                </form>
            </div>
        </div>
        <div style="margin-top: 40px; display: flex; justify-content: space-around;">
            <a class="bnt_quaylai" href="http://localhost:9999/HouseMovingSystem/customer-survey">
                <button>
                    <b>Quay lại trang trước</b>
                </button>
            </a>
            <a class="bnt_quaylai" href="http://localhost:9999/HouseMovingSystem/HistorySurveyTestController">
                <button>
                    <b>Lịch sử thử khảo sát</b>
                </button>
            </a>
        </div>
        <script>
// Load dữ liệu từ file config
            async function loadSelectOptions(fileName, selectId, defaultOption) {
                try {
                    const response = await fetch(`survey-config/file/\${fileName.replace('.txt', '')}`);
                    const result = await response.json();

                    const select = document.getElementById(selectId);
                    if (result.success) {
                        select.innerHTML = `<option value="">\${defaultOption}</option>` +
                                result.data.map(option => `<option value="\${option}">\${option}</option>`).join('');
                    } else {
                        // Fallback data nếu không load được file
                        const fallbackData = {
                            'expectation': ['Vượt mong đợi', 'Đúng mong đợi', 'Dưới mong đợi'],
                            'packing_quality': ['Rất tốt', 'Tốt', 'Trung bình', 'Kém', 'Rất kém'],
                            'age_group': ['18-25', '26-35', '36-45', '46-55', 'Trên 55'],
                            'area': ['Hà Nội', 'TP. Hồ Chí Minh', 'Đà Nẵng', 'Hải Phòng', 'Cần Thơ'],
                            'housing_type': ['Chung cư', 'Nhà riêng', 'Văn phòng', 'Khác'],
                            'important_factor': ['Giá cả', 'Chất lượng', 'Tốc độ', 'Uy tín', 'Bảo hiểm']
                        };
                        const options = fallbackData[fileName.replace('.txt', '')] || [];
                        select.innerHTML = `<option value="">\${defaultOption}</option>` +
                                options.map(option => `<option value="\${option}">\${option}</option>`).join('');
                    }
                } catch (error) {
                    console.error(`Lỗi load \${fileName}:`, error);
                }
            }

// Khởi tạo khi trang load
            document.addEventListener('DOMContentLoaded', function () {
                // Load các select options
                loadSelectOptions('expectation.txt', 'expectation-list', '-- Chọn mức độ --');
                loadSelectOptions('packing_quality.txt', 'packing_quality-list', '-- Chọn chất lượng --');
                loadSelectOptions('age_group.txt', 'age_group', '-- Chọn độ tuổi --');
                loadSelectOptions('area.txt', 'area', '-- Chọn khu vực --');
                loadSelectOptions('housing_type.txt', 'housing_type', '-- Chọn loại nhà --');
                loadSelectOptions('important_factor.txt', 'important_factor', '-- Chọn yếu tố --');



                // Hiệu ứng cho rating và NPS
                document.querySelectorAll('.rating-item, .nps-item').forEach(item => {
                    item.addEventListener('click', function () {
                        const input = this.querySelector('input[type="radio"]');
                        if (input) {
                            // Bỏ selected khỏi các item cùng nhóm
                            document.querySelectorAll(`input[name="\${input.name}"]`).forEach(radio => {
                                radio.closest('.rating-item, .nps-item').classList.remove('selected');
                            });
                            // Thêm selected cho item hiện tại
                            this.classList.add('selected');
                            input.checked = true;
                        }
                    });
                });
            });

        </script>
    </body>
</html>