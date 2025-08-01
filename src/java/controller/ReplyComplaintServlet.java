package controller;

import dao.ComplaintDAO;
import dao.IssueReplyDAO;
import dao.UserDAO;
import model.Complaint;
import model.IssueReply;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Email;
import model.User;

@WebServlet(name = "ReplyComplaintServlet", urlPatterns = {"/replyComplaint"})
public class ReplyComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;
    private IssueReplyDAO replyDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
        replyDAO = new IssueReplyDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String issueIdParam = request.getParameter("issueId");
        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                Complaint complaint = complaintDAO.getComplaintById(issueId);
                List<IssueReply> replies = replyDAO.getRepliesByIssueId(issueId);
                for (IssueReply reply : replies) {
                    System.out.println(reply.getContent());
                }

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

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String issueIdParam = request.getParameter("issueId");
        String replyContent = request.getParameter("replyContent");
        String newStatus = request.getParameter("status");
        String newPriority = request.getParameter("priority");

        if (issueIdParam == null || replyContent == null || replyContent.trim().isEmpty()
                || newStatus == null || newPriority == null) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=thieu_du_lieu");
            return;
        }

        try {
            int issueId = Integer.parseInt(issueIdParam);
            Complaint c = complaintDAO.getComplaintById(issueId);
            User a = userDAO.getUserById(c.getUserId());

            IssueReply reply = new IssueReply();
            reply.setIssueId(issueId);
            reply.setReplierId(user.getUserId());
            reply.setContent(replyContent.trim());
            reply.setCreatedAt(new Timestamp(System.currentTimeMillis()));

            Email emailUtil = new Email();
            if (!newStatus.equals("escalated")) {
                try {
                    emailUtil.sendEmail("Phàn hồi khiếu nại", emailUtil.messageReplyToCustomer(newStatus, replyContent), a.getEmail());
                } catch (Exception e) {
                    request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
                    request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
                }
            }

            boolean success = replyDAO.addReply(reply);
            boolean updateSuccess = complaintDAO.updateComplaintStatusAndPriority(issueId, newStatus, newPriority);

            if (success && updateSuccess) {
                response.sendRedirect(request.getContextPath() + "/replyComplaint?issueId=" + issueId);
            } else {
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=them_reply_that_bai");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=ID_khong_hop_le");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=loi_he_thong");
        }
    }
}
