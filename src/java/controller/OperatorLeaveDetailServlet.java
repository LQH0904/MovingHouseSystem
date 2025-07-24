package controller;

import dao.LeaveRequestDAO;
import dao.StaffLeaveBalanceDAO;
import model.LeaveRequest;
import model.StaffLeaveBalance;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;

@WebServlet("/operator/leave/detail")
public class OperatorLeaveDetailServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");

            int requestId = Integer.parseInt(request.getParameter("id"));
            LeaveRequestDAO leaveDAO = new LeaveRequestDAO(conn);
            LeaveRequest leaveRequest = leaveDAO.getLeaveRequestById(requestId);

            StaffLeaveBalanceDAO balanceDAO = new StaffLeaveBalanceDAO(conn);
            StaffLeaveBalance balance = balanceDAO.getLeaveBalance(leaveRequest.getStaffId());

            request.setAttribute("request", leaveRequest);
            request.setAttribute("balance", balance);
            request.getRequestDispatcher("/webpages/page/operator/leave_detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");

            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String status = request.getParameter("status");
            String reply = request.getParameter("reply");

            int operatorId = (int) request.getSession().getAttribute("user_id");

            LeaveRequestDAO leaveDAO = new LeaveRequestDAO(conn);
            LeaveRequest leaveRequest = leaveDAO.getLeaveRequestById(requestId);

            boolean updated = leaveDAO.updateLeaveRequestStatus(requestId, status, reply, operatorId);

            if (updated && "approved".equals(status)) {
                long days = (leaveRequest.getEndDate().getTime() - leaveRequest.getStartDate().getTime()) / (1000 * 60 * 60 * 24) + 1;
                StaffLeaveBalanceDAO balanceDAO = new StaffLeaveBalanceDAO(conn);
                balanceDAO.updateRemainingDays(leaveRequest.getStaffId(), (int) days);
            }

            response.sendRedirect(request.getContextPath() + "/operator/leave");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
