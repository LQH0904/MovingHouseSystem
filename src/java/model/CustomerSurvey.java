/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class CustomerSurvey {
    private  int surveyId;
    private String surveyDate;
    private  int userId;
    private  int overall_satisfaction;
    private  int recommend_score;
    private  int transport_care;
    private  int consultant_professionalism;
    private String expectation;
    private String packing_quality;
    private String item_condition;
    private String delivery_timeliness;
    private String booking_process;
    private String response_time;
    private String price_transparency;
    private String age_group;
    private String area;
    private String housing_type;
    private String usage_frequency;
    private String important_factor;
    private String additional_service;
    private String feedback;

    public CustomerSurvey() {
    }

    public CustomerSurvey(int surveyId, String surveyDate, int userId, int overall_satisfaction, int recommend_score, int transport_care, int consultant_professionalism, String expectation, String packing_quality, String item_condition, String delivery_timeliness, String booking_process, String response_time, String price_transparency, String age_group, String area, String housing_type, String usage_frequency, String important_factor, String additional_service, String feedback) {
        this.surveyId = surveyId;
        this.surveyDate = surveyDate;
        this.userId = userId;
        this.overall_satisfaction = overall_satisfaction;
        this.recommend_score = recommend_score;
        this.transport_care = transport_care;
        this.consultant_professionalism = consultant_professionalism;
        this.expectation = expectation;
        this.packing_quality = packing_quality;
        this.item_condition = item_condition;
        this.delivery_timeliness = delivery_timeliness;
        this.booking_process = booking_process;
        this.response_time = response_time;
        this.price_transparency = price_transparency;
        this.age_group = age_group;
        this.area = area;
        this.housing_type = housing_type;
        this.usage_frequency = usage_frequency;
        this.important_factor = important_factor;
        this.additional_service = additional_service;
        this.feedback = feedback;
    }

    public int getSurveyId() {
        return surveyId;
    }

    public void setSurveyId(int surveyId) {
        this.surveyId = surveyId;
    }

    public String getSurveyDate() {
        return surveyDate;
    }

    public void setSurveyDate(String surveyDate) {
        this.surveyDate = surveyDate;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getOverall_satisfaction() {
        return overall_satisfaction;
    }

    public void setOverall_satisfaction(int overall_satisfaction) {
        this.overall_satisfaction = overall_satisfaction;
    }

    public int getRecommend_score() {
        return recommend_score;
    }

    public void setRecommend_score(int recommend_score) {
        this.recommend_score = recommend_score;
    }

    public int getTransport_care() {
        return transport_care;
    }

    public void setTransport_care(int transport_care) {
        this.transport_care = transport_care;
    }

    public int getConsultant_professionalism() {
        return consultant_professionalism;
    }

    public void setConsultant_professionalism(int consultant_professionalism) {
        this.consultant_professionalism = consultant_professionalism;
    }

    public String getExpectation() {
        return expectation;
    }

    public void setExpectation(String expectation) {
        this.expectation = expectation;
    }

    public String getPacking_quality() {
        return packing_quality;
    }

    public void setPacking_quality(String packing_quality) {
        this.packing_quality = packing_quality;
    }

    public String getItem_condition() {
        return item_condition;
    }

    public void setItem_condition(String item_condition) {
        this.item_condition = item_condition;
    }

    public String getDelivery_timeliness() {
        return delivery_timeliness;
    }

    public void setDelivery_timeliness(String delivery_timeliness) {
        this.delivery_timeliness = delivery_timeliness;
    }

    public String getBooking_process() {
        return booking_process;
    }

    public void setBooking_process(String booking_process) {
        this.booking_process = booking_process;
    }

    public String getResponse_time() {
        return response_time;
    }

    public void setResponse_time(String response_time) {
        this.response_time = response_time;
    }

    public String getPrice_transparency() {
        return price_transparency;
    }

    public void setPrice_transparency(String price_transparency) {
        this.price_transparency = price_transparency;
    }

    public String getAge_group() {
        return age_group;
    }

    public void setAge_group(String age_group) {
        this.age_group = age_group;
    }

    public String getArea() {
        return area;
    }

    public void setArea(String area) {
        this.area = area;
    }

    public String getHousing_type() {
        return housing_type;
    }

    public void setHousing_type(String housing_type) {
        this.housing_type = housing_type;
    }

    public String getUsage_frequency() {
        return usage_frequency;
    }

    public void setUsage_frequency(String usage_frequency) {
        this.usage_frequency = usage_frequency;
    }

    public String getImportant_factor() {
        return important_factor;
    }

    public void setImportant_factor(String important_factor) {
        this.important_factor = important_factor;
    }

    public String getAdditional_service() {
        return additional_service;
    }

    public void setAdditional_service(String additional_service) {
        this.additional_service = additional_service;
    }

    public String getFeedback() {
        return feedback;
    }

    public void setFeedback(String feedback) {
        this.feedback = feedback;
    }

    @Override
    public String toString() {
        return "CustomerSurvey{" + "surveyId=" + surveyId + ", surveyDate=" + surveyDate + ", userId=" + userId + ", overall_satisfaction=" + overall_satisfaction + ", recommend_score=" + recommend_score + ", transport_care=" + transport_care + ", consultant_professionalism=" + consultant_professionalism + ", expectation=" + expectation + ", packing_quality=" + packing_quality + ", item_condition=" + item_condition + ", delivery_timeliness=" + delivery_timeliness + ", booking_process=" + booking_process + ", response_time=" + response_time + ", price_transparency=" + price_transparency + ", age_group=" + age_group + ", area=" + area + ", housing_type=" + housing_type + ", usage_frequency=" + usage_frequency + ", important_factor=" + important_factor + ", additional_service=" + additional_service + ", feedback=" + feedback + '}';
    }

}
