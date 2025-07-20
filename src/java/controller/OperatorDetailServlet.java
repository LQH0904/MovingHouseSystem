package controller;

import dao.OperatorComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Complaint;
import model.IssueReply;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OperatorDetailServlet", urlPatterns = {"/OperatorDetailServlet"})
public class OperatorDetailServlet extends HttpServlet {

    private OperatorComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new OperatorComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String issueIdParam = request.getParameter("issueId");
        if (issueIdParam == null || issueIdParam.isEmpty()) {
            response.sendRedirect("operatorComplaintList");
            return;
        }

        int issueId = Integer.parseInt(issueIdParam);

        // Lấy chi tiết khiếu nại
        Complaint complaint = complaintDAO.getComplaintById(issueId);

        // Lấy lịch sử phản hồi
        List<IssueReply> replyHistory = complaintDAO.getReplyHistory(issueId);

        request.setAttribute("complaint", complaint);
        request.setAttribute("replyHistory", replyHistory);

        // Lấy thông báo nếu có
        HttpSession session = request.getSession();
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

        request.getRequestDispatcher("/page/operator/OperatorDetail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            int issueId = Integer.parseInt(request.getParameter("issueId"));
            String replyContent = request.getParameter("replyContent");

            HttpSession session = request.getSession();
            Integer staffId = (Integer) session.getAttribute("staffId");

            if (staffId == null) {
                response.sendRedirect("login.jsp");
                return;
            }

            IssueReply reply = new IssueReply();
            reply.setIssueId(issueId);
            reply.setReplierId(staffId);
            reply.setContent(replyContent);

            // Lưu phản hồi
            complaintDAO.addReply(reply);

            session.setAttribute("successMessage", "Phản hồi đã được gửi.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Lỗi khi gửi phản hồi.");
        }

        // Quay lại trang chi tiết
        response.sendRedirect("OperatorDetailServlet?issueId=" + request.getParameter("issueId"));
    }
}
