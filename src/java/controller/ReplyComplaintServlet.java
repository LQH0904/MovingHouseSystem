package controller;

import dao.ComplaintDAO;
import dao.IssueReplyDAO;
import model.Complaint;
import model.IssueReply;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Users;

@WebServlet(name = "ReplyComplaintServlet", urlPatterns = {"/replyComplaint"})
public class ReplyComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private IssueReplyDAO replyDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        replyDAO = new IssueReplyDAO();
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
                List<IssueReply> replies = replyDAO.getRepliesByIssueId(issueId);

                request.setAttribute("currentComplaint", complaint);
                request.setAttribute("replies", replies);
                request.getRequestDispatcher("/page/staff/replyComplaint.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=ID_khong_hop_le");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=thieu_ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession hs = request.getSession();
        Users user = (Users)hs.getAttribute("acc");
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");
        String replyContent = request.getParameter("replyContent");
        String newStatus = request.getParameter("status");
        String newPriority = request.getParameter("priority");
        System.out.println("okeee");
        System.out.println(issueIdParam + replyContent + newPriority +   newStatus);

        if (issueIdParam == null || replyContent == null || replyContent.trim().isEmpty()
                || newStatus == null || newPriority == null) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=thieu_du_lieu");
            return;
        }

        try {
            int issueId = Integer.parseInt(issueIdParam);

            IssueReply reply = new IssueReply();
            reply.setIssueId(issueId);
            reply.setReplierId(user.getUserId()); // TODO: Lấy từ session
            reply.setContent(replyContent);
            reply.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            boolean success = replyDAO.addReply(reply);
            boolean updateSuccess = complaintDAO.updateComplaintStatusAndPriority(issueId, newStatus, newPriority);
            System.out.println(success + "" + updateSuccess);

            if (success && updateSuccess) {
                response.sendRedirect(request.getContextPath() + "/replyComplaint?issueId=" + issueId);
            } else {
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=them_reply_that_bai");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=ID_khong_hop_le");
        }
    }
}
