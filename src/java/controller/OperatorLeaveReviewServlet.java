package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;
import utils.DBConnection;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/operator/leave-requests")
public class OperatorLeaveReviewServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            LeaveRequestDAO dao = new LeaveRequestDAO(conn);
            List<LeaveRequest> requests = dao.getAllLeaveRequests();

            req.setAttribute("requests", requests);
            req.getRequestDispatcher("/page/operator/LeaveRequestReview.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}
