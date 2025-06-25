package controller;

import dao.OperatorComplaintDAO;
import model.OperatorComplaint;
import model.UserComplaint;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession; // Import HttpSession

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

        HttpSession session = request.getSession();

        // Lấy thông báo thành công từ session và xóa nó
        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage"); // Xóa khỏi session sau khi đọc
        }

        // Lấy thông báo lỗi từ session và xóa nó
        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage"); // Xóa khỏi session sau khi đọc
        }

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

        // Các thông báo từ request parameter không còn cần thiết vì đã dùng session
        // String updateStatus = request.getParameter("updateStatus");
        // ... (bỏ phần này) ...

        request.getRequestDispatcher("/page/operator/OperatorComplaintList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}