package controller;

import dao.ComplaintDAO;
import model.IssueReply;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewReplyDetailServlet", urlPatterns = {"/ViewReplyDetailServlet"})
public class ViewReplyDetailServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String replyIdParam = request.getParameter("issueId");
        System.out.println(replyIdParam);
        int replyId = 0;
        try {
            replyId = Integer.parseInt(replyIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet");
            return;
        }

        List<IssueReply> reply = complaintDAO.getRepliesByIssueId(replyId);  // cần tạo trong ComplaintDAO

        if (reply == null) {
            request.setAttribute("errorMessage", "Không tìm thấy phản hồi.");
        } else {
            request.setAttribute("reply", reply);
        }

        request.getRequestDispatcher("/page/staff/viewReplyDetail.jsp").forward(request, response);
    }
}
