package controller; // Changed package to controller as per your file

import dao.ComplaintDAO;
import java.io.IOException;
// import java.io.PrintWriter; // Not needed if redirecting
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet responsible for handling updates to complaint statuses.
 * It receives POST requests, updates the complaint via ComplaintDAO,
 * and redirects back to the complaint detail page.
 */
@WebServlet(name = "ReplyComplaintServlet", urlPatterns = {"/replyComplaint"}) // Changed URL pattern for consistency and readability
public class ReplyComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L; // Recommended for servlets
    private ComplaintDAO complaintDAO; // Declare an instance of ComplaintDAO

    /**
     * Initializes the servlet, creating an instance of ComplaintDAO.
     * This method is called once when the servlet is first loaded.
     */
    @Override
    public void init() throws ServletException {
        super.init(); // Call super.init()
        complaintDAO = new ComplaintDAO(); // Initialize the DAO instance
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     * This method processes the form submission for updating complaint status.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
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
                response.sendRedirect("complaintDetail.jsp?issueId=" + issueId + "&updateStatus=success");
            } else {
                response.sendRedirect("complaintDetail.jsp?issueId=" + issueId + "&updateStatus=error");
            }
        } else {
            System.err.println("Missing required parameters for complaint update. Issue ID: " + issueIdParam + ", Status: " + status);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing required parameters (issueId or status).");
        }
    }

    /**
     * Handles the HTTP <code>GET</code> method.
     * For this servlet, GET requests are not expected to perform data modification.
     * If a GET request comes to this URL, it indicates an incorrect access pattern.
     * You might choose to display an error or redirect to a relevant page.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        System.err.println("GET request to ReplyComplaintServlet is not allowed for data modification.");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported for this operation. Please use POST.");
        
    }

    /**
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet for updating complaint status";
    }
}
