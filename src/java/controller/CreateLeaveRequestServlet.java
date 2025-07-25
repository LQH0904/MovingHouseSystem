package controller;

import dao.LeaveRequestDAO;
import dao.StaffLeaveBalanceDAO;
import model.LeaveRequest;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/staff/leave/create")
public class CreateLeaveRequestServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");

            int staffId = (int) request.getSession().getAttribute("user_id");

            String reason = request.getParameter("reason");
            String startDateStr = request.getParameter("start_date");
            String endDateStr = request.getParameter("end_date");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);

            long days = (endDate.getTime() - startDate.getTime()) / (1000 * 60 * 60 * 24) + 1;

            StaffLeaveBalanceDAO balanceDAO = new StaffLeaveBalanceDAO(conn);
            int remaining = balanceDAO.getLeaveBalance(staffId).getRemainingDays();

            if (days > remaining) {
                request.setAttribute("error", "Bạn chỉ còn " + remaining + " ngày phép.");
                request.getRequestDispatcher("/webpages/page/staff/leave_list.jsp").forward(request, response);
                return;
            }

            LeaveRequest requestObj = new LeaveRequest(staffId, startDate, endDate, reason);
            LeaveRequestDAO leaveDAO = new LeaveRequestDAO(conn);

            if (leaveDAO.createLeaveRequest(requestObj)) {
                response.sendRedirect(request.getContextPath() + "/staff/leave");
            } else {
                request.setAttribute("error", "Không thể gửi đơn.");
                request.getRequestDispatcher("/webpages/page/staff/leave_list.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
