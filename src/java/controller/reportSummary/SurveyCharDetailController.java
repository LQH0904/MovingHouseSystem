/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reportSummary;

import dao.SurveyCustomerCharDataDAO;
import model.CustomerSurvey;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author Admin
 */
@WebServlet(name = "SurveyCharDetailController", urlPatterns = {"/SurveyCharDetailController"})
public class SurveyCharDetailController extends HttpServlet {

    private SurveyCustomerCharDataDAO surveyDAO;
    private static final int SURVEYS_PER_PAGE = 6;

    @Override
    public void init() throws ServletException {
        super.init();
        surveyDAO = new SurveyCustomerCharDataDAO();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        try {
            // Lấy parameters cho filter thời gian
            String fromMonth = request.getParameter("fromMonth");
            String toMonth = request.getParameter("toMonth");

            // Lấy parameters cho filter mức độ đánh giá
            String satisfactionLevel = request.getParameter("satisfactionLevel");
            String transportLevel = request.getParameter("transportLevel");
            String consultantLevel = request.getParameter("consultantLevel");

            String pageParam = request.getParameter("page");

            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // Lấy dữ liệu khảo sát theo điều kiện lọc
            List<CustomerSurvey> allSurveys = getSurveysByFilters(
                    fromMonth, toMonth, satisfactionLevel, transportLevel, consultantLevel);

            // Tính toán phân trang
            int totalSurveys = allSurveys.size();
            int totalPages = (int) Math.ceil((double) totalSurveys / SURVEYS_PER_PAGE);

            int startIndex = (currentPage - 1) * SURVEYS_PER_PAGE;
            int endIndex = Math.min(startIndex + SURVEYS_PER_PAGE, totalSurveys);

            List<CustomerSurvey> surveysForPage = allSurveys.subList(startIndex, endIndex);

            // Set attributes cho JSP
            request.setAttribute("surveys", surveysForPage);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalSurveys", totalSurveys);
            request.setAttribute("fromMonth", fromMonth);
            request.setAttribute("toMonth", toMonth);
            request.setAttribute("satisfactionLevel", satisfactionLevel);
            request.setAttribute("transportLevel", transportLevel);
            request.setAttribute("consultantLevel", consultantLevel);

            // Forward đến JSP
            request.getRequestDispatcher("page/operator/reportSummary/SurveyCharDetail.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải dữ liệu khảo sát: " + e.getMessage());
            request.getRequestDispatcher("page/operator/reportSummary/SurveyCharDetail.jsp")
                    .forward(request, response);
        }
    }

    /**
     * Lấy dữ liệu khảo sát theo các điều kiện lọc - KHÔNG ưu tiên
     */
    private List<CustomerSurvey> getSurveysByFilters(String fromMonth, String toMonth,
            String satisfactionLevel, String transportLevel, String consultantLevel) {

        // Bắt đầu với tất cả dữ liệu hoặc filter theo thời gian trước
        List<CustomerSurvey> surveys;

        if ((fromMonth == null || fromMonth.trim().isEmpty())
                && (toMonth == null || toMonth.trim().isEmpty())) {
            surveys = surveyDAO.getAllCustomerSurveys();
        } else {
            surveys = surveyDAO.getCustomerSurveysByDateRange(fromMonth, toMonth);
        }

        // Lọc thêm theo mức độ hài lòng nếu có
        if (satisfactionLevel != null && !satisfactionLevel.trim().isEmpty()) {
            int level = Integer.parseInt(satisfactionLevel);
            surveys = surveys.stream()
                    .filter(survey -> survey.getOverall_satisfaction() == level)
                    .collect(java.util.stream.Collectors.toList());
        }

        // Lọc thêm theo mức độ chăm sóc vận chuyển nếu có
        if (transportLevel != null && !transportLevel.trim().isEmpty()) {
            int level = Integer.parseInt(transportLevel);
            surveys = surveys.stream()
                    .filter(survey -> survey.getTransport_care() == level)
                    .collect(java.util.stream.Collectors.toList());
        }

        // Lọc thêm theo mức độ tư vấn chuyên nghiệp nếu có
        if (consultantLevel != null && !consultantLevel.trim().isEmpty()) {
            int level = Integer.parseInt(consultantLevel);
            surveys = surveys.stream()
                    .filter(survey -> survey.getConsultant_professionalism() == level)
                    .collect(java.util.stream.Collectors.toList());
        }

        return surveys;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Survey Character Detail Controller - Displays customer survey data with filtering and pagination";
    }// </editor-fold>

}
