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

    private static final int PAGE_SIZE = 10;

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
        // Chưa xử lý gì, chỉ redirect về GET
        doGet(request, response);
    }
}
