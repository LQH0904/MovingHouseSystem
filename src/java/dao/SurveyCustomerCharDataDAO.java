/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.CustomerSurvey;
import utils.DBContext;

/**
 *
 * @author Admin
 */
public class SurveyCustomerCharDataDAO extends DBContext {

    /**
     * Lấy tất cả dữ liệu khảo sát của khách hàng có role là customer (role_id =
     * 6)
     */
    public List<CustomerSurvey> getAllCustomerSurveys() {
        List<CustomerSurvey> surveys = new ArrayList<>();
        String sql = """
            SELECT cs.* FROM CustomerSurvey cs
            INNER JOIN Users u ON cs.user_id = u.user_id
            WHERE u.role_id = 6
            ORDER BY cs.survey_date DESC
            """;

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CustomerSurvey survey = new CustomerSurvey();
                survey.setSurveyId(rs.getInt("survey_id"));
                survey.setSurveyDate(rs.getString("survey_date"));
                survey.setUserId(rs.getInt("user_id"));
                survey.setOverall_satisfaction(rs.getInt("overall_satisfaction"));
                survey.setRecommend_score(rs.getInt("recommend_score"));
                survey.setTransport_care(rs.getInt("transport_care"));
                survey.setConsultant_professionalism(rs.getInt("consultant_professionalism"));
                survey.setExpectation(rs.getString("expectation"));
                survey.setPacking_quality(rs.getString("packing_quality"));
                survey.setItem_condition(rs.getString("item_condition"));
                survey.setDelivery_timeliness(rs.getString("delivery_timeliness"));
                survey.setBooking_process(rs.getString("booking_process"));
                survey.setResponse_time(rs.getString("response_time"));
                survey.setPrice_transparency(rs.getString("price_transparency"));
                survey.setAge_group(rs.getString("age_group"));
                survey.setArea(rs.getString("area"));
                survey.setHousing_type(rs.getString("housing_type"));
                survey.setUsage_frequency(rs.getString("usage_frequency"));
                survey.setImportant_factor(rs.getString("important_factor"));
                survey.setAdditional_service(rs.getString("additional_service"));
                survey.setFeedback(rs.getString("feedback"));

                surveys.add(survey);
            }

            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return surveys;
    }

    /**
     * Lấy dữ liệu khảo sát của customer trong 6 tháng gần nhất
     */
    public List<CustomerSurvey> getCustomerSurveysLast6Months() {
        List<CustomerSurvey> surveys = new ArrayList<>();
        String sql = """
       SELECT cs.* FROM CustomerSurvey cs
       INNER JOIN Users u ON cs.user_id = u.user_id
       WHERE u.role_id = 6 
       AND cs.survey_date >= DATEADD(MONTH, -6, GETDATE())
       ORDER BY cs.survey_date DESC
       """;

        try {
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CustomerSurvey survey = new CustomerSurvey();
                survey.setSurveyId(rs.getInt("survey_id"));
                survey.setSurveyDate(rs.getString("survey_date"));
                survey.setUserId(rs.getInt("user_id"));
                survey.setOverall_satisfaction(rs.getInt("overall_satisfaction"));
                survey.setRecommend_score(rs.getInt("recommend_score"));
                survey.setTransport_care(rs.getInt("transport_care"));
                survey.setConsultant_professionalism(rs.getInt("consultant_professionalism"));
                survey.setExpectation(rs.getString("expectation"));
                survey.setPacking_quality(rs.getString("packing_quality"));
                survey.setItem_condition(rs.getString("item_condition"));
                survey.setDelivery_timeliness(rs.getString("delivery_timeliness"));
                survey.setBooking_process(rs.getString("booking_process"));
                survey.setResponse_time(rs.getString("response_time"));
                survey.setPrice_transparency(rs.getString("price_transparency"));
                survey.setAge_group(rs.getString("age_group"));
                survey.setArea(rs.getString("area"));
                survey.setHousing_type(rs.getString("housing_type"));
                survey.setUsage_frequency(rs.getString("usage_frequency"));
                survey.setImportant_factor(rs.getString("important_factor"));
                survey.setAdditional_service(rs.getString("additional_service"));
                survey.setFeedback(rs.getString("feedback"));

                surveys.add(survey);
            }

            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return surveys;
    }

    /**
     * Lọc dữ liệu khảo sát theo khoảng thời gian
     *
     * @param fromMonth Tháng bắt đầu (định dạng YYYY-MM-DD hoặc null)
     * @param toMonth Tháng kết thúc (định dạng YYYY-MM-DD hoặc null)
     * @return
     */
    public List<CustomerSurvey> getCustomerSurveysByDateRange(String fromMonth, String toMonth) {
        List<CustomerSurvey> surveys = new ArrayList<>();

        StringBuilder sql = new StringBuilder("""
       SELECT cs.* FROM CustomerSurvey cs
       INNER JOIN Users u ON cs.user_id = u.user_id
       WHERE u.role_id = 6
       """);

        // Thêm điều kiện lọc theo thời gian
        if (fromMonth != null && !fromMonth.trim().isEmpty()) {
            sql.append(" AND cs.survey_date >= ?");
        }
        if (toMonth != null && !toMonth.trim().isEmpty()) {
            sql.append(" AND cs.survey_date <= ?");
        }

        sql.append(" ORDER BY cs.survey_date DESC");

        try {
            PreparedStatement ps = conn.prepareStatement(sql.toString());

            int paramIndex = 1;
            if (fromMonth != null && !fromMonth.trim().isEmpty()) {
                // Đảm bảo format ngày đúng YYYY-MM-DD
                ps.setString(paramIndex++, formatDateString(fromMonth));
            }
            if (toMonth != null && !toMonth.trim().isEmpty()) {
                ps.setString(paramIndex++, formatDateString(toMonth));
            }

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                CustomerSurvey survey = new CustomerSurvey();
                survey.setSurveyId(rs.getInt("survey_id"));
                survey.setSurveyDate(rs.getString("survey_date"));
                survey.setUserId(rs.getInt("user_id"));
                survey.setOverall_satisfaction(rs.getInt("overall_satisfaction"));
                survey.setRecommend_score(rs.getInt("recommend_score"));
                survey.setTransport_care(rs.getInt("transport_care"));
                survey.setConsultant_professionalism(rs.getInt("consultant_professionalism"));
                survey.setExpectation(rs.getString("expectation"));
                survey.setPacking_quality(rs.getString("packing_quality"));
                survey.setItem_condition(rs.getString("item_condition"));
                survey.setDelivery_timeliness(rs.getString("delivery_timeliness"));
                survey.setBooking_process(rs.getString("booking_process"));
                survey.setResponse_time(rs.getString("response_time"));
                survey.setPrice_transparency(rs.getString("price_transparency"));
                survey.setAge_group(rs.getString("age_group"));
                survey.setArea(rs.getString("area"));
                survey.setHousing_type(rs.getString("housing_type"));
                survey.setUsage_frequency(rs.getString("usage_frequency"));
                survey.setImportant_factor(rs.getString("important_factor"));
                survey.setAdditional_service(rs.getString("additional_service"));
                survey.setFeedback(rs.getString("feedback"));

                surveys.add(survey);
            }

            rs.close();
            ps.close();

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return surveys;
    }
    private String formatDateString(String dateStr) {
    try {
        // Nếu là format YYYY-MM, chuyển thành YYYY-MM-01
        if (dateStr.matches("\\d{4}-\\d{2}")) {
            return dateStr + "-01";
        }
        // Nếu đã đúng format YYYY-MM-DD, trả về như cũ
        return dateStr;
    } catch (Exception e) {
        return dateStr; // Fallback
    }
}
}
