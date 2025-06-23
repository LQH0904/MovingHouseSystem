package controller;

import dao.OperatorComplaintDAO;
import model.OperatorComplaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "OperatorReplyComplaintServlet", urlPatterns = {"/OperatorReplyComplaintServlet"})
public class OperatorReplyComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO operatorComplaintDAO;

    @Override
    public void init() throws ServletException {
        operatorComplaintDAO = new OperatorComplaintDAO();
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
                OperatorComplaint complaint = operatorComplaintDAO.getComplaintById(issueId);

                if (complaint != null) {
                    request.setAttribute("currentComplaint", complaint);
                    request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy khiếu nại với ID: " + issueId);
                    request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ.");
                request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Thiếu ID khiếu nại.");
            request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
        }
    }
}