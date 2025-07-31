package controller.reportSummary;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CustomerSurveyController", urlPatterns = {"/customer-survey"})
public class CustomerSurveyController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward đến trang cấu hình survey options
        request.getRequestDispatcher("page/survey/SurveyCustomer.jsp").forward(request, response);
    }
}