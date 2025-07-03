<!DOCTYPE html>
<html lang="vi">
    <head>
        <%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Khảo Sát Khách Hàng - Dịch Vụ Vận Chuyển</title>
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

            .survey-container {
                max-width: 800px;
                margin: 0 auto;
                background: white;
                border-radius: 20px;
                box-shadow: 0 20px 40px rgba(0,0,0,0.1);
                overflow: hidden;
            }

            .survey-header {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
                padding: 40px 30px;
                text-align: center;
            }

            .survey-header h1 {
                font-size: 2.5rem;
                margin-bottom: 10px;
                font-weight: 700;
            }

            .survey-header p {
                font-size: 1.1rem;
                opacity: 0.9;
            }

            .survey-form {
                padding: 40px 30px;
            }

            .form-section {
                margin-bottom: 40px;
                padding: 25px;
                background: #f8fafc;
                border-radius: 15px;
                border-left: 5px solid #4facfe;
            }

            .form-section h3 {
                color: #2d3748;
                margin-bottom: 20px;
                font-size: 1.3rem;
                display: flex;
                align-items: center;
            }

            .form-section h3::before {
                content: "📋";
                margin-right: 10px;
                font-size: 1.5rem;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                font-weight: 600;
                color: #374151;
            }

            .required {
                color: #ef4444;
            }

            .form-control {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e5e7eb;
                border-radius: 10px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: white;
            }

            .form-control:focus {
                outline: none;
                border-color: #4facfe;
                box-shadow: 0 0 0 3px rgba(79, 172, 254, 0.1);
            }

            .rating-container {
                display: flex;
                gap: 15px;
                flex-wrap: wrap;
            }

            .rating-item {
                display: flex;
                align-items: center;
                background: white;
                padding: 10px 15px;
                border-radius: 8px;
                border: 2px solid #e5e7eb;
                transition: all 0.3s ease;
                cursor: pointer;
            }

            .rating-item:hover {
                border-color: #4facfe;
                transform: translateY(-2px);
            }

            .rating-item input[type="radio"] {
                margin-right: 8px;
                accent-color: #4facfe;
            }

            .rating-item input[type="radio"]:checked + label {
                color: #4facfe;
                font-weight: 600;
            }

            .nps-scale {
                display: grid;
                grid-template-columns: repeat(11, 1fr);
                gap: 8px;
                margin-top: 10px;
            }

            .nps-item {
                text-align: center;
                padding: 12px 5px;
                background: white;
                border: 2px solid #e5e7eb;
                border-radius: 8px;
                cursor: pointer;
                transition: all 0.3s ease;
                font-weight: 600;
            }

            .nps-item:hover {
                border-color: #4facfe;
                background: #f0f9ff;
            }

            .nps-item input[type="radio"] {
                display: none;
            }

            .nps-item input[type="radio"]:checked + span {
                color: white;
                background: #4facfe;
                border-radius: 4px;
                padding: 2px 8px;
            }

            .nps-labels {
                display: flex;
                justify-content: space-between;
                margin-top: 10px;
                font-size: 0.9rem;
                color: #6b7280;
            }

            textarea.form-control {
                min-height: 100px;
                resize: vertical;
            }

            .submit-btn {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
                padding: 15px 40px;
                border: none;
                border-radius: 50px;
                font-size: 1.1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.3s ease;
                width: 100%;
                margin-top: 30px;
            }

            .submit-btn:hover {
                transform: translateY(-3px);
                box-shadow: 0 10px 25px rgba(79, 172, 254, 0.3);
            }

            .success-message {
                display: none;
                background: #10b981;
                color: white;
                padding: 20px;
                border-radius: 10px;
                text-align: center;
                margin-top: 20px;
            }

            @media (max-width: 768px) {
                .survey-container {
                    margin: 10px;
                    border-radius: 15px;
                }

                .survey-header {
                    padding: 30px 20px;
                }

                .survey-header h1 {
                    font-size: 2rem;
                }

                .survey-form {
                    padding: 30px 20px;
                }

                .form-section {
                    padding: 20px;
                }

                .rating-container {
                    gap: 10px;
                }

                .nps-scale {
                    grid-template-columns: repeat(6, 1fr);
                }
            }
        </style>
    </head>
    <body>
        <div class="survey-container">
            <div class="survey-header">
                <h1>🏠 Khảo Sát Khách Hàng</h1>
                <p>Chia sẻ trải nghiệm của bạn về dịch vụ vận chuyển nhà và nội thất</p>
            </div>

            <div class="survey-form">
                <form id="surveyForm">
                    <!-- Thông tin khách hàng -->
                    <div class="form-section">
                        <h3>Thông Tin Khách Hàng</h3>
                        <div class="form-group">
                            <label for="customer_id">Mã khách hàng <span class="required">*</span></label>
                            <input type="number" id="customer_id" name="customer_id" class="form-control" required>
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

                        <div class="form-group">
                            <label for="expectation">Dịch vụ so với mong đợi của bạn <span class="required">*</span></label>
                            <select id="expectation-list" name="expectation" class="form-control" required>
                                <!-- Options sẽ được load từ JavaScript -->
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="packing_quality">Chất lượng đóng gói <span class="required">*</span></label>
                            <select id="packing_quality-list" name="packing_quality" class="form-control" required>
                                <!-- Options sẽ được load từ JavaScript -->
                            </select>
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

                        <div class="form-group">
                            <label for="age_group">Độ tuổi <span class="required">*</span></label>
                            <select id="age_group" name="age_group" class="form-control" required>
                                <!-- Options sẽ được load từ JavaScript -->
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="area">Khu vực <span class="required">*</span></label>
                            <select id="area" name="area" class="form-control" required>
                                <!-- Options sẽ được load từ JavaScript -->
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="housing_type">Loại nhà ở <span class="required">*</span></label>
                            <select id="housing_type" name="housing_type" class="form-control" required>
                                <!-- Options sẽ được load từ JavaScript -->
                            </select>
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

                        <div class="form-group">
                            <label for="important_factor">Yếu tố quan trọng nhất <span class="required">*</span></label>
                            <select id="important_factor" name="important_factor" class="form-control" required>
                                <!-- Options sẽ được load từ JavaScript -->
                            </select>
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

                    <button type="submit" class="submit-btn">
                        🚀 Gửi Khảo Sát
                    </button>
                </form>

                <div id="successMessage" class="success-message">
                    <h3>✅ Cảm ơn bạn đã tham gia khảo sát!</h3>
                    <p>Ý kiến của bạn rất quan trọng và sẽ giúp chúng tôi cải thiện dịch vụ tốt hơn.</p>
                </div>
            </div>
        </div>
        <script>
            // Dịch vụ so với mong đợi của bạn
            document.addEventListener('DOMContentLoaded', async function () {
                try {
                    const response = await fetch('expectation.txt');
                    const text = await response.text();
                    const options = text.split('\n').filter(line => line.trim());

                    document.getElementById('expectation-list').innerHTML =
                            `<option value="">-- Chọn mức độ --</option>` +
                            options.map(option =>
                                    `<option value="\${option.trim()}">\${option.trim()}</option>`
                            ).join('');

                } catch (error) {
                    console.error('Lỗi load file:', error);
                }
            });

// Lấy giá trị được chọn
            function getSelectedExpectation() {
                const select = document.getElementById('expectation-list');
                return select.value;
            }
        </script>
        <script>
            // Chất lượng đóng gói
            document.addEventListener('DOMContentLoaded', async function () {
                try {
                    const response = await fetch('packing_quality.txt');
                    const text = await response.text();
                    const options = text.split('\n').filter(line => line.trim());

                    document.getElementById('packing_quality-list').innerHTML =
                            `<option value="">-- Chọn chất lượng --</option>` +
                            options.map(option =>
                                    `<option value="\${option.trim()}">\${option.trim()}</option>`
                            ).join('');

                } catch (error) {
                    console.error('Lỗi load file:', error);
                }
            });

// Lấy giá trị được chọn
            function getSelectedExpectation() {
                const select = document.getElementById('packing_quality-list');
                return select.value;
            }
        </script>
        <script>
            // Độ tuổi
            document.addEventListener('DOMContentLoaded', async function () {
                try {
                    const response = await fetch('age_group.txt');
                    const text = await response.text();
                    const options = text.split('\n').filter(line => line.trim());

                    document.getElementById('age_group').innerHTML =
                            `<option value="">-- Chọn độ tuổi --</option>` +
                            options.map(option =>
                                    `<option value="\${option.trim()}">\${option.trim()}</option>`
                            ).join('');

                } catch (error) {
                    console.error('Lỗi load file:', error);
                }
            });

// Lấy giá trị được chọn
            function getSelectedExpectation() {
                const select = document.getElementById('age_group');
                return select.value;
            }
        </script>
        <script>
            // Khu vực
            document.addEventListener('DOMContentLoaded', async function () {
                try {
                    const response = await fetch('area.txt');
                    const text = await response.text();
                    const options = text.split('\n').filter(line => line.trim());

                    document.getElementById('area').innerHTML =
                            `<option value="">-- Chọn khu vực --</option>` +
                            options.map(option =>
                                    `<option value="\${option.trim()}">\${option.trim()}</option>`
                            ).join('');

                } catch (error) {
                    console.error('Lỗi load file:', error);
                }
            });

// Lấy giá trị được chọn
            function getSelectedExpectation() {
                const select = document.getElementById('area');
                return select.value;
            }
        </script>
        <script>
            // Loại nhà ở
            document.addEventListener('DOMContentLoaded', async function () {
                try {
                    const response = await fetch('housing_type.txt');
                    const text = await response.text();
                    const options = text.split('\n').filter(line => line.trim());

                    document.getElementById('housing_type').innerHTML =
                            `<option value="">-- Chọn loại nhà --</option>` +
                            options.map(option =>
                                    `<option value="\${option.trim()}">\${option.trim()}</option>`
                            ).join('');

                } catch (error) {
                    console.error('Lỗi load file:', error);
                }
            });

// Lấy giá trị được chọn
            function getSelectedExpectation() {
                const select = document.getElementById('housing_type');
                return select.value;
            }
        </script>
        <script>
            // Yếu tố quan trọng nhất
            document.addEventListener('DOMContentLoaded', async function () {
                try {
                    const response = await fetch('important_factor.txt');
                    const text = await response.text();
                    const options = text.split('\n').filter(line => line.trim());

                    document.getElementById('important_factor').innerHTML =
                            `<option value="">-- Chọn yếu tố --</option>` +
                            options.map(option =>
                                    `<option value="\${option.trim()}">\${option.trim()}</option>`
                            ).join('');

                } catch (error) {
                    console.error('Lỗi load file:', error);
                }
            });

// Lấy giá trị được chọn
            function getSelectedExpectation() {
                const select = document.getElementById('important_factor');
                return select.value;
            }
        </script>
    </body>
</html>