package controller;

import dao.OperatorComplaintDAO;
import model.OperatorComplaint;
import model.UserComplaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "OperatorComplaintListServlet", urlPatterns = {"/operatorComplaintList"})
public class OperatorComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO complaintDAO;

    private static final int RECORDS_PER_PAGE = 10;

    @Override
    public void init() throws ServletException {
        complaintDAO = new OperatorComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();

        String successMessage = (String) session.getAttribute("successMessage");
        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }

        String errorMessage = (String) session.getAttribute("errorMessage");
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }

        String searchTerm = request.getParameter("searchTerm");
        String priorityFilter = request.getParameter("priorityFilter");
        if (priorityFilter == null || priorityFilter.isEmpty()) {
            priorityFilter = "all";
        }

        String assignedToFilter = request.getParameter("assignedToFilter");
        if (assignedToFilter == null || assignedToFilter.isEmpty()) {
            assignedToFilter = "all";
        }

        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");

        Date fromDate = null;
        Date toDate = null;
        try {
            if (fromDateStr != null && !fromDateStr.isEmpty()) {
                fromDate = Date.valueOf(fromDateStr);
            }
            if (toDateStr != null && !toDateStr.isEmpty()) {
                toDate = Date.valueOf(toDateStr);
            }
        } catch (IllegalArgumentException e) {
            System.err.println("Lỗi định dạng ngày");
        }

        int page = 1;
        if (request.getParameter("page") != null) {
            try {
                page = Integer.parseInt(request.getParameter("page"));
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * RECORDS_PER_PAGE;

        int totalComplaints = complaintDAO.getFilteredComplaintCount(searchTerm, priorityFilter, assignedToFilter, fromDate, toDate);
        int totalPages = (int) Math.ceil((double) totalComplaints / RECORDS_PER_PAGE);

        List<OperatorComplaint> escalatedComplaints = complaintDAO.getFilteredComplaints(
                searchTerm, priorityFilter, assignedToFilter, fromDate, toDate, offset, RECORDS_PER_PAGE
        );

        List<UserComplaint> operators = complaintDAO.getOperators();

        request.setAttribute("escalatedComplaints", escalatedComplaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("assignedToFilter", assignedToFilter);
        request.setAttribute("fromDate", fromDateStr);
        request.setAttribute("toDate", toDateStr);
        request.setAttribute("operators", operators);

        request.getRequestDispatcher("/page/operator/OperatorComplaintList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
