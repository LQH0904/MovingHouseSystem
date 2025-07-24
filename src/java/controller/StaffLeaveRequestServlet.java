package controller;

import dao.LeaveRequestDAO;
import dao.StaffLeaveBalanceDAO;
import model.LeaveRequest;
import model.StaffLeaveBalance;
import model.User;
import utils.DBConnection;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/staff/leave")
public class StaffLeaveRequestServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            LeaveRequestDAO leaveRequestDAO = new LeaveRequestDAO(conn);
            StaffLeaveBalanceDAO balanceDAO = new StaffLeaveBalanceDAO(conn);

            if ("new".equals(action)) {
                StaffLeaveBalance balance = balanceDAO.getLeaveBalance(user.getUserId());
                request.setAttribute("leaveBalance", balance);
                request.getRequestDispatcher("/page/staff/newLeaveRequest.jsp").forward(request, response);
            } else {
                List<LeaveRequest> requests = leaveRequestDAO.getLeaveRequestsByStaff(user.getUserId());
                StaffLeaveBalance balance = balanceDAO.getLeaveBalance(user.getUserId());
                request.setAttribute("leaveRequests", requests);
                request.setAttribute("leaveBalance", balance);
                request.getRequestDispatcher("/page/staff/leaveRequests.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || user.getRole().getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            LeaveRequestDAO leaveRequestDAO = new LeaveRequestDAO(conn);
            StaffLeaveBalanceDAO balanceDAO = new StaffLeaveBalanceDAO(conn);

            if ("create".equals(action)) {
                String startDateStr = request.getParameter("startDate");
                String endDateStr = request.getParameter("endDate");
                String reason = request.getParameter("reason");

                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                Date startDate = sdf.parse(startDateStr);
                Date endDate = sdf.parse(endDateStr);

                long days = (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24) + 1;
                StaffLeaveBalance balance = balanceDAO.getLeaveBalance(user.getUserId());

                if (days > balance.getRemainingDays()) {
                    request.setAttribute("error", "Số ngày xin nghỉ vượt quá số ngày còn lại.");
                    request.setAttribute("leaveBalance", balance);
                    request.getRequestDispatcher("/page/staff/newLeaveRequest.jsp").forward(request, response);
                    return;
                }

                LeaveRequest newRequest = new LeaveRequest(user.getUserId(), startDate, endDate, reason);
                boolean success = leaveRequestDAO.createLeaveRequest(newRequest);

                if (success) {
                    conn.commit();
                    response.sendRedirect(request.getContextPath() + "/staff/leave");
                } else {
                    conn.rollback();
                    response.sendError(500);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
