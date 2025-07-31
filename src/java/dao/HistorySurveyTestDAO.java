package dao;

import model.CustomerSurvey;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class HistorySurveyTestDAO {
    
    private DBContext dbContext;
    
    public HistorySurveyTestDAO() {
        this.dbContext = new DBContext();
    }
    
    /**
     * Lấy toàn bộ lịch sử khảo sát khách hàng (cho Staff, Operator, Admin)
     * Chỉ lấy dữ liệu của user không phải Customer (role_id != 6)
     * Sắp xếp theo ngày từ gần nhất đến xa nhất
     */
    public List<CustomerSurvey> getAllSurveyHistory() {
        List<CustomerSurvey> surveys = new ArrayList<>();
        
        String sql = "SELECT cs.* FROM CustomerSurvey cs " +
                    "JOIN Users u ON cs.user_id = u.user_id " +
                    "WHERE u.role_id != 6 " +
                    "ORDER BY cs.survey_date DESC";
        
        try {
            ResultSet rs = dbContext.getData(sql);
            while (rs.next()) {
                CustomerSurvey survey = new CustomerSurvey();
                survey.setSurveyId(rs.getInt("survey_id"));
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
                survey.setSurveyDate(rs.getString("survey_date"));
                
                surveys.add(survey);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy lịch sử khảo sát: " + e.getMessage());
        }
        
        return surveys;
    }
}