package controller;

import dao.ComplaintDAO;
import model.Complaint;
import model.IssueReply;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewComplaintDetail")
public class ViewComplaintDetailServlet extends HttpServlet {

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
        int issueId = 0;
        try {
            issueId = Integer.parseInt(issueIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet");
            return;
        }

        Complaint complaint = complaintDAO.getComplaintById(issueId);
        List<IssueReply> replies = complaintDAO.getRepliesByIssueId(issueId);

        if (complaint == null) {
            request.setAttribute("errorMessage", "Không tìm thấy khiếu nại.");
        } else {
            request.setAttribute("complaint", complaint);
            request.setAttribute("replies", replies);
        }

        request.getRequestDispatcher("/page/staff/viewComplaintDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
