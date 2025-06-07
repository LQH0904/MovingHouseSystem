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

    /**
     * Handles GET requests - displays the reply form
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String issueIdParam = request.getParameter("issueId");
        
        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                Complaint complaint = complaintDAO.getComplaintById(issueId);
                
                if (complaint != null) {
                    // Forward to the JSP page with the correct path
                    request.getRequestDispatcher("/page/operator/replyComplaint.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Complaint not found");
                }
            } catch (NumberFormatException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid complaint ID");
            }
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing complaint ID");
        }
    }

    /**
     * Handles POST requests - processes the form submission
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");

        int issueId = -1; 
        try {
            if (issueIdParam != null && !issueIdParam.isEmpty()) {
                issueId = Integer.parseInt(issueIdParam);
            }
        } catch (NumberFormatException e) {
            System.err.println("Invalid issue ID format received: " + issueIdParam);
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid Complaint ID format.");
            return; 
        }

        if (issueId != -1 && status != null && !status.isEmpty()) {
            boolean success = complaintDAO.updateComplaintStatus(issueId, status);

            if (success) {
                // Redirect to the servlet with GET method to show the updated form
                response.sendRedirect("replyComplaint?issueId=" + issueId + "&updateStatus=success");
            } else {
                response.sendRedirect("replyComplaint?issueId=" + issueId + "&updateStatus=error");
            }
        } else {
            System.err.println("Missing required parameters for complaint update. Issue ID: " + issueIdParam + ", Status: " + status);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters (issueId or status).");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet for handling complaint replies and status updates";
    }
}