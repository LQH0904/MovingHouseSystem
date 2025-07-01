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
import java.util.List;

@WebServlet(name = "OperatorComplaintListServlet", urlPatterns = {"/operatorComplaintList"})
public class OperatorComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO complaintDAO;

    private static final int RECORDS_PER_PAGE = 10;
    private static final String UPDATED_ISSUE_IDS_SESSION_ATTR = "updatedIssueIds"; 

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
        
        List<Integer> updatedIssueIds = (List<Integer>) session.getAttribute(UPDATED_ISSUE_IDS_SESSION_ATTR);
        if (updatedIssueIds != null) {
            request.setAttribute(UPDATED_ISSUE_IDS_SESSION_ATTR, updatedIssueIds);
            session.removeAttribute(UPDATED_ISSUE_IDS_SESSION_ATTR); // XÓA KHỎI SESSION SAU KHI DÙNG
        }

        // Nhận ID khiếu nại cần highlight từ request parameter
        String highlightIdParam = request.getParameter("highlightId");
        if (highlightIdParam != null && !highlightIdParam.trim().isEmpty()) {
            try {
                int highlightId = Integer.parseInt(highlightIdParam);
                request.setAttribute("highlightedComplaintId", highlightId);
            } catch (NumberFormatException e) {
                System.err.println("Invalid highlightId parameter: " + highlightIdParam);
            }
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

        List<OperatorComplaint> escalatedComplaints = complaintDAO.getEscalatedComplaints(
                searchTerm, priorityFilter, offset, RECORDS_PER_PAGE
        );
        List<UserComplaint> operators = complaintDAO.getOperators();

        request.setAttribute("escalatedComplaints", escalatedComplaints);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalComplaints", totalComplaints);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("priorityFilter", priorityFilter);
        request.setAttribute("operators", operators);

        request.getRequestDispatcher("/page/operator/OperatorComplaintList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}