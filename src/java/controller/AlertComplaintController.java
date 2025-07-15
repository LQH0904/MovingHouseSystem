package controller;

import dao.AlertComplaintDAO;
import model.AlertComplaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AlertComplaintController", urlPatterns = {"/operator/alert-complaint"})
public class AlertComplaintController extends HttpServlet {

    private static final int PAGE_SIZE = 5;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String unitType = request.getParameter("unitType");
        String issueStatus = request.getParameter("status");
        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }
        int offset = (page - 1) * PAGE_SIZE;

        AlertComplaintDAO dao = new AlertComplaintDAO();
        List<AlertComplaint> complaints = dao.getFilteredUnitComplaints(unitType, issueStatus, offset, PAGE_SIZE);
        int total = dao.countFiltered(unitType, issueStatus);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);

        // Các thống kê theo yêu cầu mới
        int totalUnitsWithComplaints = dao.countUnitsWithComplaints(); // Tổng đơn vị có phản ánh
        int totalComplaints = dao.countAllComplaints(); // Tổng số phản ánh
        int sentWarnings = dao.countUnitsWithWarningsSent(); // Đã cảnh báo
        int notSentWarnings = dao.countUnitsWithWarningsNotSent(); // Chưa cảnh báo

        request.setAttribute("complaints", complaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", total);
        request.setAttribute("unitType", unitType);
        request.setAttribute("status", issueStatus);

        request.setAttribute("totalUnitsWithComplaints", totalUnitsWithComplaints);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("sentWarnings", sentWarnings);
        request.setAttribute("notSentWarnings", notSentWarnings);

        request.getRequestDispatcher("/page/operator/AlertComplaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("sendWarning".equals(action)) {
            int unitId = Integer.parseInt(request.getParameter("unitId"));
            String unitType = request.getParameter("unitType");
            
            AlertComplaintDAO dao = new AlertComplaintDAO();
            dao.markWarningSent(unitId, unitType);
            
            // TODO: Thêm logic gửi email thực tế ở đây
            // EmailService.sendWarningEmail(unitId, unitType);
            
            // Giữ lại các tham số filter và page
            String page = request.getParameter("page");
            String unitTypeFilter = request.getParameter("unitTypeFilter");
            String statusFilter = request.getParameter("statusFilter");
            
            String redirectUrl = request.getContextPath() + "/operator/alert-complaint?";
            if (page != null && !page.isEmpty()) {
                redirectUrl += "page=" + page + "&";
            }
            if (unitTypeFilter != null && !unitTypeFilter.isEmpty()) {
                redirectUrl += "unitType=" + unitTypeFilter + "&";
            }
            if (statusFilter != null && !statusFilter.isEmpty()) {
                redirectUrl += "status=" + statusFilter + "&";
            }
            
            response.sendRedirect(redirectUrl);
            return;
        }
        doGet(request, response);
    }
}
