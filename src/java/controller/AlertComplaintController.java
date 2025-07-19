package controller;

import dao.AlertComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.UnitIssueSummary;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AlertComplaintController", urlPatterns = {"/operator/alert-complaint"})
public class AlertComplaintController extends HttpServlet {

    private final AlertComplaintDAO dao = new AlertComplaintDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy danh sách thống kê phản ánh theo đơn vị
        List<UnitIssueSummary> summaryList = dao.getIssueSummaryByUnit();

        // Gửi sang JSP
        request.setAttribute("summaryList", summaryList);
        request.getRequestDispatcher("/page/operator/AlertComplaint.jsp").forward(request, response);
    }
}
