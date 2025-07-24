package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/operator/leave")
public class OperatorLeaveListServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Connection conn = (Connection) getServletContext().getAttribute("DBConnection");

            LeaveRequestDAO leaveDAO = new LeaveRequestDAO(conn);
            List<LeaveRequest> requestList = leaveDAO.getAllLeaveRequests();

            request.setAttribute("requestList", requestList);
            request.getRequestDispatcher("/webpages/page/operator/leave_list.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500);
        }
    }
}
