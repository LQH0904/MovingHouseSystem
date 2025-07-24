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
import java.util.List;

@WebServlet("/staff/leave")
public class StaffLeaveServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");

            Integer staffId = (Integer) request.getSession().getAttribute("user_id");
if (staffId == null) {
    response.sendRedirect(request.getContextPath() + "/login.jsp");
    return;
}

            StaffLeaveBalanceDAO balanceDAO = new StaffLeaveBalanceDAO(conn);
            LeaveRequestDAO requestDAO = new LeaveRequestDAO(conn);

            StaffLeaveBalance balance = balanceDAO.getLeaveBalance(staffId);
            List<LeaveRequest> requestList = requestDAO.getLeaveRequestsByStaff(staffId);
            

            request.setAttribute("balance", balance);
            request.setAttribute("requestList", requestList);
            request.getRequestDispatcher("/webpages/page/staff/leave_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
