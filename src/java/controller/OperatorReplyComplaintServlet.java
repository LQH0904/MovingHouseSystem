package controller;

import dao.ComplaintDAO;
import model.Complaint;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "OperatorReplyComplaintServlet", urlPatterns = {"/OperatorReplyComplaintServlet"})
public class OperatorReplyComplaintServlet extends HttpServlet {

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
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");

        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                Complaint complaint = complaintDAO.getComplaintById(issueId);

                if (complaint != null) {
                    request.setAttribute("currentComplaint", complaint);
                    request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy khiếu nại với ID: " + issueIdParam);
                    request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                System.err.println("Invalid complaint ID format in OperatorReplyComplaintServlet doGet: " + issueIdParam);
                request.setAttribute("errorMessage", "Định dạng ID khiếu nại không hợp lệ.");
                request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Thiếu ID khiếu nại.");
            request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
        }
    }

    // Removed doPost. The form in OperatorReplyComplaint.jsp will submit directly to ReplyComplaintServlet.
    // This servlet is now purely for displaying the complaint details for operators to reply.
}