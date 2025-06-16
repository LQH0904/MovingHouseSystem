package controller;

import dao.IssueStaffDAO;
import model.IssueStaff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;

@WebServlet("/StaffIssueServlet")
public class StaffIssueServlet extends HttpServlet {

    private IssueStaffDAO issueStaffDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        issueStaffDAO = new IssueStaffDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listIssues(request, response);
                    break;
                case "view":
                    viewIssue(request, response);
                    break;
                default:
                    listIssues(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("reply".equalsIgnoreCase(action)) {
                replyToIssue(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + "/StaffIssueServlet");
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listIssues(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int currentPage = 1;
        if (request.getParameter("page") != null) {
            currentPage = Integer.parseInt(request.getParameter("page"));
        }

        int recordsPerPage = 10;
        int offset = (currentPage - 1) * recordsPerPage;

        String searchTerm = request.getParameter("search");
        String statusFilter = request.getParameter("statusFilter");
        String priorityFilter = request.getParameter("priorityFilter");

        List<IssueStaff> issues = issueStaffDAO.getAllIssues(offset, recordsPerPage, searchTerm, statusFilter, priorityFilter);
        int totalIssues = issueStaffDAO.getTotalIssues(searchTerm, statusFilter, priorityFilter);
        int totalPages = (int) Math.ceil((double) totalIssues / recordsPerPage);

        request.setAttribute("complaints", issues);
        request.setAttribute("totalComplaints", totalIssues);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("statusFilter", statusFilter);
        request.setAttribute("priorityFilter", priorityFilter);

        request.getRequestDispatcher("/page/staff/ComplaintListStaff.jsp").forward(request, response);
    }

    private void viewIssue(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int issueId = 0;
        try {
            issueId = Integer.parseInt(request.getParameter("issueId"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ.");
            request.getRequestDispatcher("/page/staff/ReplyComplaintStaff.jsp").forward(request, response);
            return;
        }

        IssueStaff currentIssue = issueStaffDAO.getIssueById(issueId);

        if (currentIssue == null) {
            request.setAttribute("errorMessage", "Không tìm thấy khiếu nại với ID: " + issueId);
        }
        request.setAttribute("currentComplaint", currentIssue);

        request.getRequestDispatcher("/page/staff/ReplyComplaintStaff.jsp").forward(request, response);
    }

    private void replyToIssue(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int issueId = 0;
        try {
            issueId = Integer.parseInt(request.getParameter("issueId"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ để phản hồi.");
            viewIssue(request, response);
            return;
        }

        String newStatus = request.getParameter("status");
        String newPriority = request.getParameter("priority");
        String replyContent = request.getParameter("replyContent");

        HttpSession session = request.getSession();
        Integer staffId = (Integer) session.getAttribute("staffId");
        String staffUsername = (String) session.getAttribute("staffUsername");

        if (staffId == null || staffUsername == null) {
            request.setAttribute("errorMessage", "Phiên làm việc của nhân viên không hợp lệ. Vui lòng đăng nhập lại.");
            viewIssue(request, response);
            return;
        }

        boolean success = issueStaffDAO.updateIssueStatusAndPriority(issueId, newStatus, newPriority);

        if (success) {
            request.getSession().setAttribute("updateMessage", "Cập nhật khiếu nại #" + issueId + " thành công!");
            request.getSession().setAttribute("updateMessageType", "success");
        } else {
            request.getSession().setAttribute("updateMessage", "Cập nhật khiếu nại #" + issueId + " thất bại.");
            request.getSession().setAttribute("updateMessageType", "danger");
        }
        response.sendRedirect(request.getContextPath() + "/StaffIssueServlet?action=view&issueId=" + issueId);
    }
}