package controller;

import dao.IssueReplyDAO;
import dao.OperatorComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Complaint;
import model.IssueReply;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OperatorHistoryServlet", urlPatterns = {"/OperatorHistoryServlet"})
public class OperatorHistoryServlet extends HttpServlet {

    private OperatorComplaintDAO complaintDAO;
    private IssueReplyDAO aO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new OperatorComplaintDAO();
        aO = new IssueReplyDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Lấy issueId từ URL
        String issueIdParam = request.getParameter("issueId");

        if (issueIdParam == null || issueIdParam.isEmpty()) {
            response.sendRedirect("operatorComplaintList");
            return;
        }

        try {
            int issueId = Integer.parseInt(issueIdParam);

            // Lấy thông tin khiếu nại
            Complaint complaint = complaintDAO.getComplaintById(issueId);

            // Lấy lịch sử phản hồi từ DAO
            List<IssueReply> replyHistory = aO.getRepliesByIssueId(issueId);

            // Đưa dữ liệu vào request để hiển thị lên JSP
            request.setAttribute("complaint", complaint);
            request.setAttribute("replyHistory", replyHistory);

            // Chuyển hướng sang trang JSP hiển thị
            request.getRequestDispatcher("/page/operator/operatorhistory.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendRedirect("operatorComplaintList");
        }
    }
}
