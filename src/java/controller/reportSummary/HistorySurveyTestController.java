package controller.reportSummary;

import dao.HistorySurveyTestDAO;
import model.CustomerSurvey;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HistorySurveyTestController", urlPatterns = {"/HistorySurveyTestController"})
public class HistorySurveyTestController extends HttpServlet {

    private HistorySurveyTestDAO surveyDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        surveyDAO = new HistorySurveyTestDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // Lấy danh sách lịch sử khảo sát
            List<CustomerSurvey> surveyHistory = surveyDAO.getAllSurveyHistory();
            
            // Đưa dữ liệu vào request
            request.setAttribute("surveyHistory", surveyHistory);
            
            // Forward đến JSP
            request.getRequestDispatcher("page/survey/HistorySurveyTest.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Lỗi trong HistorySurveyTestController: " + e.getMessage());
            e.printStackTrace();
            
            request.setAttribute("error", "Có lỗi xảy ra khi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("page/survey/HistorySurveyTest.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "History Survey Test Controller";
    }
}