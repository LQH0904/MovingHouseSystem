package controller;

import dao.ComplaintDAO;
import model.Complaint;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ReplyComplaintServlet", urlPatterns = {"/replyComplaint"})
public class ReplyComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String issueIdParam = request.getParameter("issueId");

        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                Complaint complaint = complaintDAO.getComplaintById(issueId);

                if (complaint != null) {
                    request.setAttribute("currentComplaint", complaint);
                    request.getRequestDispatcher("/page/operator/replyComplaint.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Complaint not found with ID: " + issueIdParam);
                    request.getRequestDispatcher("/page/operator/replyComplaint.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid complaint ID format in ReplyComplaintServlet doGet: " + issueIdParam);
                request.setAttribute("errorMessage", "Invalid complaint ID format.");
                request.getRequestDispatcher("/page/operator/replyComplaint.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Missing complaint ID.");
            request.getRequestDispatcher("/page/operator/replyComplaint.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String replyContent = request.getParameter("replyContent");

        System.out.println("ReplyComplaintServlet: Received POST request for issueId: " + issueIdParam + ", status: " + status + ", priority: " + priority + ", replyContent: " + replyContent);

        int issueId = -1;
        try {
            if (issueIdParam != null && !issueIdParam.isEmpty()) {
                issueId = Integer.parseInt(issueIdParam);
            }
        } catch (NumberFormatException e) {
            System.err.println("ReplyComplaintServlet: Invalid issue ID format in doPost: " + issueIdParam);
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=ID_khong_hop_le");
            return;
        }

        if (issueId != -1 && status != null && !status.isEmpty() && priority != null && !priority.isEmpty()) {
            boolean success = complaintDAO.updateComplaintStatusAndPriority(issueId, status, priority);

            if (success) {
                System.out.println("ReplyComplaintServlet: Update successful for issueId: " + issueId);
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=success");
            } else {
                System.err.println("ReplyComplaintServlet: Update failed for issueId: " + issueId);
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=cap_nhat_that_bai");
            }
        } else {
            System.err.println("ReplyComplaintServlet: Missing required parameters for update. Issue ID: " + issueIdParam + ", Status: " + status + ", Priority: " + priority);
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=thieu_tham_so");
        }
    }
}