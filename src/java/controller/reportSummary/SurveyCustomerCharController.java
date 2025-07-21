package controller.reportSummary;

import dao.SurveyCustomerCharDataDAO;
import model.CustomerSurvey;
import com.google.gson.Gson;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;

@WebServlet(name = "SurveyCustomerCharController", urlPatterns = {"/SurveyCustomerCharController"})
public class SurveyCustomerCharController extends HttpServlet {

    private SurveyCustomerCharDataDAO surveyDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        surveyDAO = new SurveyCustomerCharDataDAO();
        gson = new Gson();
        System.out.println("✅ SurveyCustomerCharController initialized");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        // Nếu action là "page", hiển thị JSP
        if ("page".equals(action)) {
            request.getRequestDispatcher("page/operator/reportSummary/SurveyCustomerChar.jsp")
                    .forward(request, response);
            return;
        }

        // Nếu không có action hoặc action khác, trả về dữ liệu JSON
        response.setContentType("application/json;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        String fromMonth = request.getParameter("fromMonth");
        String toMonth = request.getParameter("toMonth");

        try {
            List<CustomerSurvey> surveys;

            // Nếu không có bộ lọc -> lấy dữ liệu 6 tháng gần nhất
            if ((fromMonth == null || fromMonth.trim().isEmpty())
                    && (toMonth == null || toMonth.trim().isEmpty())) {
                surveys = surveyDAO.getCustomerSurveysLast6Months();
            } else {
                // Có bộ lọc -> lấy dữ liệu theo khoảng thời gian
                surveys = surveyDAO.getCustomerSurveysByDateRange(fromMonth, toMonth);
            }

            // Tạo dữ liệu cho biểu đồ
            Map<String, Object> chartData = createChartData(surveys);

            PrintWriter out = response.getWriter();
            out.print(gson.toJson(chartData));

        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            PrintWriter out = response.getWriter();
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("message", "Lỗi server: " + e.getMessage());
            out.print(gson.toJson(error));
        }
    }

    /**
     * Tạo dữ liệu cho tất cả biểu đồ
     */
    private Map<String, Object> createChartData(List<CustomerSurvey> surveys) {
        Map<String, Object> result = new HashMap<>();

        if (surveys.isEmpty()) {
            result.put("success", false);
            result.put("message", "Không có dữ liệu khảo sát");
            return result;
        }

        result.put("success", true);
        result.put("totalSurveys", surveys.size());

        // === GAUGE CHARTS (1-5 rating) ===
        result.put("overallSatisfaction", createGaugeData(surveys, "overall_satisfaction"));
        result.put("transportCare", createGaugeData(surveys, "transport_care"));
        result.put("consultantProfessionalism", createGaugeData(surveys, "consultant_professionalism"));

        // === PIE CHARTS with padAngle (ECharts) ===
        result.put("itemCondition", createPieData(surveys, "item_condition"));
        result.put("deliveryTimeliness", createPieData(surveys, "delivery_timeliness"));
        result.put("bookingProcess", createPieData(surveys, "booking_process"));

        // === RADAR CHARTS (Chart.js) ===
        result.put("responseTime", createRadarData(surveys, "response_time"));
        result.put("importantFactor", createRadarData(surveys, "important_factor"));
        result.put("usageFrequency", createRadarData(surveys, "usage_frequency"));

        // Thêm dữ liệu khác
        result.put("recommendScore", createRecommendChart(surveys));

        return result;
    }

    /**
     * Tạo dữ liệu cho Gauge Chart (rating 1-5)
     */
    private Map<String, Object> createGaugeData(List<CustomerSurvey> surveys, String type) {
        Map<String, Integer> counts = new HashMap<>();
        counts.put("1", 0);
        counts.put("2", 0);
        counts.put("3", 0);
        counts.put("4", 0);
        counts.put("5", 0);

        for (CustomerSurvey survey : surveys) {
            int rating = 0;
            switch (type) {
                case "overall_satisfaction":
                    rating = survey.getOverall_satisfaction();
                    break;
                case "transport_care":
                    rating = survey.getTransport_care();
                    break;
                case "consultant_professionalism":
                    rating = survey.getConsultant_professionalism();
                    break;
            }

            if (rating >= 1 && rating <= 5) {
                counts.put(String.valueOf(rating), counts.get(String.valueOf(rating)) + 1);
            }
        }

        // Tính điểm trung bình
        double average = surveys.stream()
                .mapToInt(s -> {
                    switch (type) {
                        case "overall_satisfaction":
                            return s.getOverall_satisfaction();
                        case "transport_care":
                            return s.getTransport_care();
                        case "consultant_professionalism":
                            return s.getConsultant_professionalism();
                        default:
                            return 0;
                    }
                })
                .average()
                .orElse(0.0);

        Map<String, Object> result = new HashMap<>();
        result.put("type", "gauge");
        result.put("counts", counts);
        result.put("average", Math.round(average * 10.0) / 10.0);
        result.put("total", surveys.size());

        return result;
    }

    /**
     * Tạo dữ liệu cho Pie Chart with padAngle (ECharts)
     */
    private Map<String, Object> createPieData(List<CustomerSurvey> surveys, String field) {
        Map<String, Integer> counts = new HashMap<>();

        for (CustomerSurvey survey : surveys) {
            String value = getFieldValue(survey, field);
            if (value != null && !value.trim().isEmpty()) {
                counts.put(value, counts.getOrDefault(value, 0) + 1);
            }
        }

        // Tạo data cho ECharts Pie
        List<Map<String, Object>> pieData = new ArrayList<>();
        String[] colors = {
            "#ff6b6b", "#4ecdc4", "#45b7d1", "#96ceb4", "#ffeaa7", "#dda0dd", "#98d8c8",
            "#ff9f43", "#7bed9f", "#5352ed", "#ff6348", "#2ed573", "#ff4757", "#3742fa",
            "#f39c12", "#e74c3c", "#9b59b6", "#1abc9c", "#34495e", "#e67e22", "#95a5a6",
            "#fd79a8", "#fdcb6e", "#6c5ce7", "#a29bfe", "#74b9ff", "#00b894", "#00cec9"
        };
        int colorIndex = 0;

        for (Map.Entry<String, Integer> entry : counts.entrySet()) {
            Map<String, Object> item = new HashMap<>();
            item.put("name", entry.getKey());
            item.put("value", entry.getValue());
            item.put("itemStyle", Map.of("color", colors[colorIndex % colors.length]));
            pieData.add(item);
            colorIndex++;
        }

        Map<String, Object> result = new HashMap<>();
        result.put("type", "pie");
        result.put("data", pieData);
        result.put("total", surveys.size());

        return result;
    }

    /**
     * Tạo dữ liệu cho Radar Chart (Chart.js)
     */
    private Map<String, Object> createRadarData(List<CustomerSurvey> surveys, String field) {
        Map<String, Integer> counts = new HashMap<>();

        for (CustomerSurvey survey : surveys) {
            String value = getFieldValue(survey, field);
            if (value != null && !value.trim().isEmpty()) {
                counts.put(value, counts.getOrDefault(value, 0) + 1);
            }
        }

        // Sắp xếp theo số lượng giảm dần
        List<Map.Entry<String, Integer>> sortedEntries = new ArrayList<>(counts.entrySet());
        sortedEntries.sort(Map.Entry.<String, Integer>comparingByValue().reversed());

        List<String> labels = new ArrayList<>();
        List<Integer> data = new ArrayList<>();

        for (Map.Entry<String, Integer> entry : sortedEntries) {
            labels.add(entry.getKey());
            data.add(entry.getValue());
        }

        Map<String, Object> result = new HashMap<>();
        result.put("type", "radar");
        result.put("labels", labels);
        result.put("data", data);
        result.put("total", surveys.size());

        return result;
    }

    /**
     * Tạo dữ liệu cho biểu đồ recommend (0-10)
     */
    private Map<String, Object> createRecommendChart(List<CustomerSurvey> surveys) {
        Map<String, Integer> counts = new HashMap<>();

        // Nhóm theo khoảng: 0-6 (Detractors), 7-8 (Passives), 9-10 (Promoters)
        int detractors = 0, passives = 0, promoters = 0;

        for (CustomerSurvey survey : surveys) {
            int score = survey.getRecommend_score();
            if (score >= 0 && score <= 6) {
                detractors++;
            } else if (score >= 7 && score <= 8) {
                passives++;
            } else if (score >= 9 && score <= 10) {
                promoters++;
            }
        }

        // Tính NPS
        double nps = surveys.size() > 0
                ? ((double) (promoters - detractors) / surveys.size() * 100) : 0;

        Map<String, Object> result = new HashMap<>();
        result.put("labels", Arrays.asList("Detractors (0-6)", "Passives (7-8)", "Promoters (9-10)"));
        result.put("data", Arrays.asList(detractors, passives, promoters));
        result.put("nps", Math.round(nps * 10.0) / 10.0);
        result.put("colors", Arrays.asList("#ff6384", "#ffcd56", "#36a2eb"));

        return result;
    }

    /**
     * Lấy giá trị field từ survey object
     */
    private String getFieldValue(CustomerSurvey survey, String field) {
        switch (field) {
            case "packing_quality":
                return survey.getPacking_quality();
            case "item_condition":
                return survey.getItem_condition();
            case "delivery_timeliness":
                return survey.getDelivery_timeliness();
            case "booking_process":
                return survey.getBooking_process();
            case "response_time":
                return survey.getResponse_time();
            case "important_factor":
                return survey.getImportant_factor();
            case "usage_frequency":
                return survey.getUsage_frequency();
            case "expectation":
                return survey.getExpectation();
            case "price_transparency":
                return survey.getPrice_transparency();
            case "age_group":
                return survey.getAge_group();
            case "area":
                return survey.getArea();
            case "housing_type":
                return survey.getHousing_type();
            default:
                return null;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Survey Customer Chart Data Controller";
    }
}
