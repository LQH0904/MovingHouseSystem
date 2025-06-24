package controller;

import dao.OperatorComplaintDAO;
import model.OperatorComplaint;
import model.UserComplaint; // Đã đổi từ model.User sang model.UserComplaint
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OperatorComplaintListServlet", urlPatterns = {"/operatorComplaintList"})
public class OperatorComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO complaintDAO;

    private static final int RECORDS_PER_PAGE = 5;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new OperatorComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String searchTerm = request.getParameter("searchTerm");
        String priorityFilter = request.getParameter("priorityFilter");

        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        int offset = (page - 1) * RECORDS_PER_PAGE;

        int totalComplaints = complaintDAO.getTotalEscalatedComplaintCount(searchTerm, priorityFilter);
        int totalPages = (int) Math.ceil((double) totalComplaints / RECORDS_PER_PAGE);

        List<OperatorComplaint> escalatedComplaints = complaintDAO.getEscalatedComplaints(searchTerm, priorityFilter, offset, RECORDS_PER_PAGE);
        List<UserComplaint> operators = complaintDAO.getOperators(); 

        request.setAttribute("escalatedComplaints", escalatedComplaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("operators", operators);

        String updateStatus = request.getParameter("updateStatus");
        if ("success_escalated".equals(updateStatus)) {
            request.setAttribute("successMessage", "Khiếu nại đã được chuyển cấp cao thành công!");
        } else if ("success".equals(updateStatus)) {
            request.setAttribute("successMessage", "Phản hồi đã được gửi thành công!");
        } else if ("error".equals(updateStatus)) {
            String errorMessageParam = request.getParameter("message");
            if (errorMessageParam != null && !errorMessageParam.isEmpty()) {
                request.setAttribute("errorMessage", "Có lỗi xảy ra: " + errorMessageParam.replace("_", " "));
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật khiếu nại.");
            }
        }

        request.getRequestDispatcher("/page/operator/OperatorComplaintList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}