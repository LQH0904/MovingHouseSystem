package controller;

import dao.LeaveRequestDAO;
import model.LeaveRequest;
import utils.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.util.List;
import model.Users;

@WebServlet("/staff-leave")
public class LeaveRequestListServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            resp.sendRedirect("login.jsp");
            return;
        }

        Users user = (Users) session.getAttribute("acc");
        int staffId = user.getUserId();

        try (Connection conn = DBConnection.getConnection()) {
            LeaveRequestDAO dao = new LeaveRequestDAO(conn);
            List<LeaveRequest> requests = dao.getLeaveRequestsByStaff(staffId);

            req.setAttribute("requests", requests);
            req.getRequestDispatcher("/page/staff/LeaveRequest.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMessage", e.getMessage());
            req.getRequestDispatcher("/error.jsp").forward(req, resp);
        }
    }
}
