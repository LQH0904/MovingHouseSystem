package controller.reportSummary;

import dao.SurveyCustomerDAO;
import model.CustomerSurvey;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "SurveyTestController", urlPatterns = {"/SurveyTestController"})
public class SurveyTestController extends HttpServlet {

    private SurveyCustomerDAO surveyDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        surveyDAO = new SurveyCustomerDAO();
        System.out.println("✅ SurveyTestController initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        System.out.println("=== GET REQUEST - Show survey form ===");

        // Show survey form
        request.getRequestDispatcher("page/survey/survey_test.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        System.out.println("=== POST REQUEST - Process survey ===");

        try {
            // Get UserId
            String userIdStr = request.getParameter("user_id");
            System.out.println("Customer ID received: '" + userIdStr + "'");

            if (userIdStr == null || userIdStr.trim().isEmpty()) {
                request.setAttribute("error", "Vui lòng nhập mã khách hàng");
                request.getRequestDispatcher("page/survey/survey_test.jsp").forward(request, response);
                return;
            }

            int userId = Integer.parseInt(userIdStr.trim());
            if (userId <= 0) {
                request.setAttribute("error", "Mã khách hàng phải lớn hơn 0");
                request.getRequestDispatcher("page/survey/survey_test.jsp").forward(request, response);
                return;
            }

            // Create survey object
            CustomerSurvey survey = new CustomerSurvey();
            survey.setUserId(userId);
            survey.setOverall_satisfaction(getIntParam(request, "overall_satisfaction"));
            survey.setRecommend_score(getIntParam(request, "recommend_score"));
            survey.setTransport_care(getIntParam(request, "transport_care"));
            survey.setConsultant_professionalism(getIntParam(request, "consultant_professionalism"));

            survey.setExpectation(request.getParameter("expectation"));
            survey.setPacking_quality(request.getParameter("packing_quality"));
            survey.setItem_condition(request.getParameter("item_condition"));
            survey.setDelivery_timeliness(request.getParameter("delivery_timeliness"));
            survey.setBooking_process(request.getParameter("booking_process"));
            survey.setResponse_time(request.getParameter("response_time"));
            survey.setPrice_transparency(request.getParameter("price_transparency"));
            survey.setAge_group(request.getParameter("age_group"));
            survey.setArea(request.getParameter("area"));
            survey.setHousing_type(request.getParameter("housing_type"));
            survey.setUsage_frequency(request.getParameter("usage_frequency"));
            survey.setImportant_factor(request.getParameter("important_factor"));
            survey.setAdditional_service(request.getParameter("additional_service"));
            survey.setFeedback(request.getParameter("feedback"));

            System.out.println("Survey object created for customer: " + survey.getUserId());

            // Basic validation (browser already validates required fields)
            if (survey.getUserId() <= 0) {
                request.setAttribute("error", "Mã khách hàng không hợp lệ");
                request.getRequestDispatcher("page/survey/survey_test.jsp").forward(request, response);
                return;
            }

            // Save to database
            boolean success = surveyDAO.insertSurvey(survey);

            if (success) {
                request.setAttribute("success", "Cảm ơn bạn đã tham gia khảo sát!");
                System.out.println("✅ Survey saved successfully");

                // Forward thay vì redirect
                request.getRequestDispatcher("page/survey/survey_test.jsp").forward(request, response);
                return;
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi lưu dữ liệu. Vui lòng thử lại.");
                System.err.println("❌ Failed to save survey");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Mã khách hàng phải là số");
            System.err.println("Invalid customer ID format: " + e.getMessage());
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            System.err.println("System error: " + e.getMessage());
            e.printStackTrace();
        }

        // Forward back to form with error
        request.getRequestDispatcher("page/survey/survey_test.jsp").forward(request, response);
    }

    /**
     * Get integer parameter - simple helper
     */
    private int getIntParam(HttpServletRequest request, String paramName) {
        String value = request.getParameter(paramName);
        if (value == null || value.trim().isEmpty()) {
            return 0;
        }
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            System.err.println("Invalid int param " + paramName + ": " + value);
            return 0;
        }
    }

    /**
     * Check if string is empty
     */
    private boolean isEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }

    @Override
    public String getServletInfo() {
        return "Survey Test Controller - Fixed Version";
    }
}
