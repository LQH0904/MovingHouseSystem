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
        
        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");
        String replyContent = request.getParameter("replyContent");

        int issueId = -1;    
        try {
            if (issueIdParam != null && !issueIdParam.isEmpty()) {
                issueId = Integer.parseInt(issueIdParam);
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid issue ID format received in ReplyComplaintServlet doPost: " + issueIdParam);
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&issueId=" + issueIdParam);
            return;    
        }

        if (issueId != -1 && status != null && !status.isEmpty()) {
            // Assume complaintDAO.updateComplaintStatus handles the replyContent if needed
            // If you need to store replyContent, you'll need to modify this method in DAO
            boolean success = complaintDAO.updateComplaintStatus(issueId, status); 

            if (success) {
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=success&issueId=" + issueId);
            } else {
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&issueId=" + issueId);
            }
        } else {
            System.err.println("Missing required parameters for complaint update. Issue ID: " + issueIdParam + ", Status: " + status);
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&issueId=" + issueId);
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling complaint replies and status updates";
    }
}