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

    private static final int DEFAULT_PAGE_SIZE = 10;
    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        configureRequestEncoding(request, response);

        String action = request.getParameter("action");

        if ("view".equals(action)) {
            handleViewAction(request, response);
            return;
        }

        handleListComplaints(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void configureRequestEncoding(HttpServletRequest request, HttpServletResponse response) {
        try {
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
        } catch (Exception e) {
            log("Error setting character encoding", e);
        }
    }

    private void handleViewAction(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        try {
            int issueId = Integer.parseInt(request.getParameter("issueId"));
            response.sendRedirect(request.getContextPath() + "/viewComplaintDetail?issueId=" + issueId);
        } catch (NumberFormatException e) {
            log("Invalid complaint ID format: " + request.getParameter("issueId"), e);
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet");
        }
    }

    private void handleListComplaints(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        SearchParameters params = extractSearchParameters(request);
        PaginationInfo pagination = calculatePagination(request, params);

        List<Complaint> complaints = complaintDAO.getAllComplaints(
                params.searchTerm, params.statusFilter, params.priorityFilter,
                params.startDateStr, params.endDateStr, params.minIdStr, params.maxIdStr,
                pagination.offset, pagination.recordsPerPage
        );

        enrichComplaintsWithResponderInfo(complaints);

        setupRequestAttributes(request, params, pagination, complaints);
        handleStatusMessages(request);

        request.getRequestDispatcher("/page/staff/ComplaintList.jsp").forward(request, response);
    }

    private SearchParameters extractSearchParameters(HttpServletRequest request) {
        SearchParameters params = new SearchParameters();
        params.searchTerm = request.getParameter("search");
        params.statusFilter = request.getParameter("statusFilter");
        params.priorityFilter = request.getParameter("priorityFilter");
        params.startDateStr = request.getParameter("startDate");
        params.endDateStr = request.getParameter("endDate");
        params.minIdStr = request.getParameter("minId");
        params.maxIdStr = request.getParameter("maxId");
        return params;
    }

    private PaginationInfo calculatePagination(HttpServletRequest request, SearchParameters params) {
        PaginationInfo pagination = new PaginationInfo();
        pagination.currentPage = parsePageNumber(request);
        pagination.recordsPerPage = DEFAULT_PAGE_SIZE;
        pagination.offset = (pagination.currentPage - 1) * pagination.recordsPerPage;
        pagination.totalComplaints = complaintDAO.getTotalComplaintCount(
                params.searchTerm, params.statusFilter, params.priorityFilter,
                params.startDateStr, params.endDateStr, params.minIdStr, params.maxIdStr
        );
        pagination.totalPages = (int) Math.ceil((double) pagination.totalComplaints / pagination.recordsPerPage);
        return pagination;
    }

    private int parsePageNumber(HttpServletRequest request) {
        try {
            return Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private void enrichComplaintsWithResponderInfo(List<Complaint> complaints) {
        for (Complaint c : complaints) {
            String responder = complaintDAO.getResponderName(c.getIssueId());
            c.setResponderName(responder);
            c.setHasReply(complaintDAO.hasReplies(c.getIssueId()));
        }
    }

    private void setupRequestAttributes(HttpServletRequest request, SearchParameters params,
            PaginationInfo pagination, List<Complaint> complaints) {
        request.setAttribute("complaints", complaints);
        request.setAttribute("totalComplaints", pagination.totalComplaints);
        request.setAttribute("totalPages", pagination.totalPages);
        request.setAttribute("currentPage", pagination.currentPage);
        request.setAttribute("searchTerm", params.searchTerm);
        request.setAttribute("statusFilter", params.statusFilter);
        request.setAttribute("priorityFilter", params.priorityFilter);
        request.setAttribute("startDate", params.startDateStr);
        request.setAttribute("endDate", params.endDateStr);
        request.setAttribute("minId", params.minIdStr);
        request.setAttribute("maxId", params.maxIdStr);
    }

    private void handleStatusMessages(HttpServletRequest request) {
        String updateStatus = request.getParameter("updateStatus");
        if (updateStatus != null) {
            switch (updateStatus) {
                case "success":
                    request.setAttribute("updateMessage", "Complaint updated successfully!");
                    request.setAttribute("updateMessageType", "success");
                    break;
                case "success_escalated":
                    request.setAttribute("updateMessage", "Complaint escalated successfully!");
                    request.setAttribute("updateMessageType", "success");
                    break;
                case "error":
                    String errorMessage = request.getParameter("message");
                    request.setAttribute("updateMessage", "Error: "
                            + (errorMessage != null ? errorMessage : "An error occurred while updating the complaint."));
                    request.setAttribute("updateMessageType", "danger");
                    break;
            }
        }
    }

    // Helper classes for parameter grouping
    private static class SearchParameters {

        String searchTerm;
        String statusFilter;
        String priorityFilter;
        String startDateStr;
        String endDateStr;
        String minIdStr;
        String maxIdStr;
    }

    private static class PaginationInfo {

        int currentPage;
        int recordsPerPage;
        int offset;
        int totalComplaints;
        int totalPages;
    }
}
