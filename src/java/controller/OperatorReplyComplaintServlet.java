package controller;

import dao.ComplaintDAO;
import dao.OperatorComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Complaint;
import model.IssueReply;
import model.UserComplaint;
import java.io.IOException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

@WebServlet(name = "OperatorReplyComplaintServlet", urlPatterns = {"/OperatorReplyComplaintServlet"})
public class OperatorReplyComplaintServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(OperatorReplyComplaintServlet.class.getName());
    private OperatorComplaintDAO operatorComplaintDAO;

    @Override
    public void init() throws ServletException {
        operatorComplaintDAO = new OperatorComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setCharacterEncoding("UTF-8");
ComplaintDAO aO = new ComplaintDAO();
        HttpSession session = request.getSession();
        try {
            String issueIdParam = request.getParameter("issueId");
            if (issueIdParam == null || issueIdParam.isEmpty()) {
                session.setAttribute("errorMessage", "Thiếu thông tin ID khiếu nại");
                response.sendRedirect(request.getContextPath() + "/operatorComplaintList");
                return;
            }

            int issueId = Integer.parseInt(issueIdParam);
            Complaint complaint = operatorComplaintDAO.getComplaintById(issueId);
            
            if (complaint == null) {
                session.setAttribute("errorMessage", "Không tìm thấy khiếu nại với ID: " + issueId);
                response.sendRedirect(request.getContextPath() + "/operatorComplaintList");
                return;
            }

            List<IssueReply> replyHistory = aO.getRepliesByIssueId(issueId);
            List<UserComplaint> operators = operatorComplaintDAO.getOperators();

            request.setAttribute("complaint", complaint);
            request.setAttribute("replyHistory", replyHistory);
            request.setAttribute("operators", operators);

            // Transfer session messages to request
            transferSessionMessagesToRequest(session, request);

            request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid complaint ID format", e);
            session.setAttribute("errorMessage", "ID khiếu nại không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/operatorComplaintList");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing request", e);
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/operatorComplaintList");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        String issueIdParam = request.getParameter("issueId");
        String redirectUrl = request.getContextPath() + "/OperatorReplyComplaintServlet?issueId=" + issueIdParam;

        try {
            Users u = (Users)session.getAttribute("acc");
            Integer staffId = u.getUserId();
            if (staffId == null) {
                session.setAttribute("errorMessage", "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.");
                response.sendRedirect(request.getContextPath() + "/login.jsp");
                return;
            }

            if (issueIdParam == null || issueIdParam.isEmpty()) {
                session.setAttribute("errorMessage", "Thiếu thông tin ID khiếu nại");
                response.sendRedirect(request.getContextPath() + "/operatorComplaintList");
                return;
            }

            int issueId = Integer.parseInt(issueIdParam);
            String replyContent = request.getParameter("replyContent");
            String status = request.getParameter("status");
            String priority = request.getParameter("priority");
            String assignedToStr = request.getParameter("assignedTo");

            if (replyContent == null || replyContent.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Nội dung phản hồi không được để trống");
                response.sendRedirect(redirectUrl);
                return;
            }

            // Create and save reply
            IssueReply reply = new IssueReply();
            reply.setIssueId(issueId);
            reply.setReplierId(staffId);
            reply.setContent(replyContent.trim());

            // Parse assignedTo
            Integer assignedTo = (assignedToStr != null && !assignedToStr.isEmpty()) 
                    ? Integer.parseInt(assignedToStr) : null;

            // Save to database
            operatorComplaintDAO.addReply(reply);
            operatorComplaintDAO.updateComplaintStatusPriorityAssigned(issueId, status, priority, assignedTo);

            session.setAttribute("successMessage", "Gửi phản hồi thành công!");

        } catch (NumberFormatException e) {
            logger.log(Level.WARNING, "Invalid number format", e);
            session.setAttribute("errorMessage", "Dữ liệu đầu vào không hợp lệ");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Error processing reply", e);
            session.setAttribute("errorMessage", "Lỗi hệ thống: " + e.getMessage());
        }

        response.sendRedirect(redirectUrl);
    }

    private void transferSessionMessagesToRequest(HttpSession session, HttpServletRequest request) {
        String successMessage = (String) session.getAttribute("successMessage");
        String errorMessage = (String) session.getAttribute("errorMessage");

        if (successMessage != null) {
            request.setAttribute("successMessage", successMessage);
            session.removeAttribute("successMessage");
        }
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
            session.removeAttribute("errorMessage");
        }
    }
}