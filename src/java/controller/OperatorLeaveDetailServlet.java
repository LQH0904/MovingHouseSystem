package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;
import model.Users;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/operator/review-leave-request")
public class OperatorLeaveDetailServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        int requestId = Integer.parseInt(req.getParameter("id"));

        try (Connection conn = DBConnection.getConnection()) {
            LeaveRequestDAO dao = new LeaveRequestDAO(conn);
            LeaveRequest request = dao.getLeaveRequestById(requestId);

            if (request == null) {
                req.setAttribute("errorMessage", "Không tìm thấy đơn xin nghỉ.");
                req.getRequestDispatcher("/error.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("leaveRequest", request);
            req.getRequestDispatcher("/page/operator/LeaveReviewDetail.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }

    @Override
    

        protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Users operator = (Users) session.getAttribute("acc");
        int requestId = Integer.parseInt(req.getParameter("requestId"));
        String status = req.getParameter("status"); // approved / rejected
        String reply = req.getParameter("reply");

        try (Connection conn = DBConnection.getConnection()) {
            LeaveRequestDAO dao = new LeaveRequestDAO(conn);
            boolean success = dao.updateLeaveRequestStatus(requestId, status, reply, operator.getUserId());

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/operator/leave-requests");
            } else {
                req.setAttribute("errorMessage", "Cập nhật thất bại.");
                req.getRequestDispatcher("/page/staff/error.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/page/staff/error.jsp").forward(req, resp);
        }
    }
}
