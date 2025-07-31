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
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/submit-leave-request")
public class SubmitLeaveRequestServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Users user = (Users) session.getAttribute("acc");
            int staffId = user.getUserId();

            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String reason = request.getParameter("reason");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = sdf.parse(startDateStr);
            Date endDate = sdf.parse(endDateStr);

            long diffMillis = endDate.getTime() - startDate.getTime();
            int numberOfDays = (int) ((diffMillis / (1000 * 60 * 60 * 24)) + 1);

            LeaveRequest leaveRequest = new LeaveRequest(staffId, startDate, endDate, reason);
            leaveRequest.setStatus("pending");
            leaveRequest.setNumberOfDaysOff(numberOfDays);

            try (Connection conn = DBConnection.getConnection()) {
                LeaveRequestDAO dao = new LeaveRequestDAO(conn);
                boolean success = dao.createLeaveRequest(leaveRequest);

                if (success) {
                    response.sendRedirect(request.getContextPath() + "/staff-leave");
                } else {
                    request.setAttribute("mess", "Gửi đơn thất bại, vui lòng thử lại.");
                    request.getRequestDispatcher("/page/staff/LeaveRequest.jsp").forward(request, response);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/page/staff/error.jsp").forward(request, response);
        }
    }
}
