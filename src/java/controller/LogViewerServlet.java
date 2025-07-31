package controller; 

import dao.LogAdminDAO;
import model.SystemLog;
import model.DataChangeLog;
import model.UserAdmin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import model.Users;

@WebServlet("/LogViewerServlet")
public class LogViewerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private LogAdminDAO logAdminDAO = new LogAdminDAO(); 

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users loggedInUser = (Users) session.getAttribute("acc");
        System.out.println(loggedInUser.getRoleId());
                System.out.println(loggedInUser);

        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "login");
            return;
        }

        String action = request.getParameter("action");
        String type = request.getParameter("type"); 

        if ("viewDetail".equals(action)) {
            int logId = Integer.parseInt(request.getParameter("logId"));
            if ("system".equals(type)) {
                SystemLog log = logAdminDAO.getSystemLogById(logId);
                request.setAttribute("logDetail", log);
                request.setAttribute("logType", "system"); // Để JSP biết hiển thị loại log nào
                request.getRequestDispatcher("/page/admin/logDetail.jsp").forward(request, response);
            } else if ("data_change".equals(type)) {
                DataChangeLog log = logAdminDAO.getDataChangeLogById(logId);
                request.setAttribute("logDetail", log);
                request.setAttribute("logType", "data_change"); // Để JSP biết hiển thị loại log nào
                request.getRequestDispatcher("/page/admin/logDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid log type for detail view.");
            }
        } else {
            List<?> logs = null;
            String logTypeTitle = "";

            // Lấy các tham số lọc từ request
            String username = request.getParameter("username");
            String startDate = request.getParameter("startDate");
            String endDate = request.getParameter("endDate");

            if ("system".equals(type)) {
                String actionType = request.getParameter("actionType");
                String detailsKeyword = request.getParameter("detailsKeyword");
                logs = logAdminDAO.getFilteredSystemLogs(username, actionType, detailsKeyword, startDate, endDate);
                logTypeTitle = "System Activities Log";
            } else if ("data_change".equals(type)) {
                String tableName = request.getParameter("tableName");
                String changeType = request.getParameter("changeType");
                logs = logAdminDAO.getFilteredDataChangeLogs(username, tableName, changeType, startDate, endDate);
                logTypeTitle = "Data Change Audit Log";
            } else {
                logs = logAdminDAO.getAllSystemLogs(); 
                logTypeTitle = "System Activities Log";
                type = "system"; 
            }

            request.setAttribute("logs", logs);
            request.setAttribute("logTypeTitle", logTypeTitle);
            request.setAttribute("type", type); 
            request.getRequestDispatcher("/page/admin/viewLogs.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response); 
    }
}