package controller;

import dao.ComplaintDAO;
import model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ComplaintServlet")
public class ComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action != null && action.equals("view")) {
            int issueId = 0;
            try {
                issueId = Integer.parseInt(request.getParameter("issueId"));
            } catch (NumberFormatException e) {
                System.err.println("ComplaintServlet: Định dạng ID khiếu nại không hợp lệ cho hành động xem: " + request.getParameter("issueId"));
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet");
                return;
            }

            // Chuyển sang Servlet chi tiết mới
            response.sendRedirect(request.getContextPath() + "/viewComplaintDetail?issueId=" + issueId);
            return;
        } else {
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("statusFilter");
            String priorityFilter = request.getParameter("priorityFilter");

            // Lấy thêm tham số ngày bắt đầu và kết thúc
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");

            int currentPage = 1;
            if (request.getParameter("page") != null) {
                try {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            int recordsPerPage = 10;
            int offset = (currentPage - 1) * recordsPerPage;

            // Gọi DAO với filter ngày
            int totalComplaints = complaintDAO.getTotalComplaintCount(searchTerm, statusFilter, priorityFilter, startDateStr, endDateStr);
            int totalPages = (int) Math.ceil((double) totalComplaints / recordsPerPage);

            List<Complaint> complaints = complaintDAO.getAllComplaints(searchTerm, statusFilter, priorityFilter, startDateStr, endDateStr, offset, recordsPerPage);

            request.setAttribute("complaints", complaints);
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("priorityFilter", priorityFilter);

            // Giữ lại giá trị ngày để load lại form
            request.setAttribute("startDate", startDateStr);
            request.setAttribute("endDate", endDateStr);

            String updateStatus = request.getParameter("updateStatus");
            if ("success".equals(updateStatus)) {
                request.setAttribute("updateMessage", "Cập nhật khiếu nại thành công!");
                request.setAttribute("updateMessageType", "success");
            } else if ("success_escalated".equals(updateStatus)) {
                request.setAttribute("updateMessage", "Khiếu nại đã được chuyển cấp thành công!");
                request.setAttribute("updateMessageType", "success");
            } else if ("error".equals(updateStatus)) {
                String errorMessage = request.getParameter("message");
                if (errorMessage == null) {
                    errorMessage = "Có lỗi xảy ra khi cập nhật khiếu nại.";
                }
                request.setAttribute("updateMessage", "Lỗi: " + errorMessage);
                request.setAttribute("updateMessageType", "danger");
            }

            request.getRequestDispatcher("/page/staff/ComplaintList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
