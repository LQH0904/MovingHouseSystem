package controller;

import dao.NotificationDAO;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet(name = "MarkNotificationReadServlet", urlPatterns = {"/markNotificationRead"})
public class MarkNotificationReadServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(MarkNotificationReadServlet.class.getName());
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = NotificationDAO.INSTANCE;
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("acc");
        if (user == null || (user.getRoleId() != 4 && user.getRoleId() != 5 && user.getRoleId() != 6)) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"error\": \"Bạn không có quyền thực hiện hành động này.\"}");
            return;
        }

        String notificationIdStr = req.getParameter("notificationId");
        try {
            int notificationId = Integer.parseInt(notificationIdStr);
            notificationDAO.markAsRead(notificationId, user.getUserId());
            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().write("{\"success\": true}");
        } catch (NumberFormatException e) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write("{\"error\": \"ID thông báo không hợp lệ.\"}");
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write("{\"error\": \"Lỗi truy vấn database.\"}");
        }
    }
}