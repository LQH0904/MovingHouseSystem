package dao;

import model.CustomerSurvey;
import utils.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.io.*;
import java.nio.charset.StandardCharsets;

public class SurveyCustomerDAO {

    private DBContext dbContext;

    public SurveyCustomerDAO() {
        this.dbContext = new DBContext();
    }

    /**
     * Insert survey response vào bảng CustomerSurvey
     */
    public boolean insertSurvey(CustomerSurvey survey) {
        if (dbContext == null || dbContext.conn == null) {
            return false;
        }

        String sql = "INSERT INTO CustomerSurvey (" +
            "user_id, overall_satisfaction, recommend_score, transport_care, " +
            "consultant_professionalism, expectation, packing_quality, item_condition, " +
            "delivery_timeliness, booking_process, response_time, price_transparency, " +
            "age_group, area, housing_type, usage_frequency, important_factor, " +
            "additional_service, feedback, survey_date) " +
            "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,GETDATE())";

        try {
            PreparedStatement ps = dbContext.conn.prepareStatement(sql);

            ps.setInt(1, survey.getUserId());
            ps.setInt(2, survey.getOverall_satisfaction());
            ps.setInt(3, survey.getRecommend_score());
            ps.setInt(4, survey.getTransport_care());
            ps.setInt(5, survey.getConsultant_professionalism());
            ps.setString(6, survey.getExpectation());
            ps.setString(7, survey.getPacking_quality());
            ps.setString(8, survey.getItem_condition());
            ps.setString(9, survey.getDelivery_timeliness());
            ps.setString(10, survey.getBooking_process());
            ps.setString(11, survey.getResponse_time());
            ps.setString(12, survey.getPrice_transparency());
            ps.setString(13, survey.getAge_group());
            ps.setString(14, survey.getArea());
            ps.setString(15, survey.getHousing_type());
            ps.setString(16, survey.getUsage_frequency());
            ps.setString(17, survey.getImportant_factor());
            ps.setString(18, survey.getAdditional_service());
            ps.setString(19, survey.getFeedback());

            int result = ps.executeUpdate();
            ps.close();
            return result > 0;

        } catch (SQLException e) {
            System.err.println("❌ SQL Error in insertSurvey: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Kiểm tra kết nối database
     */
    public boolean testConnection() {
        try {
            if (dbContext == null) {
                return false;
            }
            if (dbContext.conn == null) {
                return false;
            }
            if (dbContext.conn.isClosed()) {
                return false;
            }
            return true;
        } catch (SQLException e) {
            return false;
        }
    }

    /**
     * Lấy tất cả survey responses
     */
    public List<CustomerSurvey> getAllSurveys() {
        List<CustomerSurvey> surveys = new ArrayList<>();

        if (!testConnection()) {
            return surveys;
        }

        String sql = "SELECT * FROM CustomerSurvey ORDER BY survey_date DESC";

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

                surveys.add(survey);
            }
        } catch (SQLException e) {
            // Log error if needed
        }

        return surveys;
    }
}
