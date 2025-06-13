package controller; // Đảm bảo package này đúng với package của bạn

import dao.ComplaintDAO;
import model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ComplaintServlet") // Đảm bảo mapping này đúng
public class ComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new ComplaintDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("view")) {
            int issueId = 0;
            try {
                issueId = Integer.parseInt(request.getParameter("issueId"));
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet");
                return;
            }

            Complaint currentComplaint = complaintDAO.getComplaintById(issueId);
            request.setAttribute("currentComplaint", currentComplaint);
            // Đảm bảo đường dẫn này đúng với vị trí file ReplyComplaint.jsp của bạn trong WEB-INF/views/
            request.getRequestDispatcher("/page/operator/replyComplaint.jsp").forward(request, response);
        } else {
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("statusFilter");
            String priorityFilter = request.getParameter("priorityFilter");

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

            int totalComplaints = complaintDAO.getTotalComplaintCount(searchTerm, statusFilter, priorityFilter);
            int totalPages = (int) Math.ceil((double) totalComplaints / recordsPerPage);

            List<Complaint> complaints = complaintDAO.getAllComplaints(searchTerm, statusFilter, priorityFilter, offset, recordsPerPage);

            request.setAttribute("complaints", complaints);
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("priorityFilter", priorityFilter);

            // Đảm bảo đường dẫn này đúng với vị trí file ComplaintList.jsp của bạn trong WEB-INF/views/
            request.getRequestDispatcher("/page/operator/complaintList.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int issueId = 0;
        try {
            issueId = Integer.parseInt(request.getParameter("issueId"));
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=Invalid_Issue_ID");
            return;
        }
        String newStatus = request.getParameter("status");
        String replyContent = request.getParameter("replyContent");

        boolean success = complaintDAO.updateComplaintStatus(issueId, newStatus);

        if (success) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?action=view&issueId=" + issueId + "&updateStatus=error");
        }
    }
}