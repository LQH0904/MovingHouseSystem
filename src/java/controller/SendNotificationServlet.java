package controller;

import dao.UserDAO;
import dao.NotificationDAO;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "SendNotificationServlet", urlPatterns = {"/sendNotification"})
public class SendNotificationServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(SendNotificationServlet.class.getName());
    private UserDAO userDAO;
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        userDAO = UserDAO.INSTANCE;
        notificationDAO = NotificationDAO.INSTANCE;
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("acc");
        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
            req.setAttribute("error", "Chỉ Admin hoặc Operator có quyền truy cập chức năng này.");
            req.getRequestDispatcher("page/login/login.jsp").forward(req, resp);
            return;
        }

        String roleIdStr = req.getParameter("roleId");
        if (roleIdStr != null) {
            try {
                int roleId = Integer.parseInt(roleIdStr);
                List<Users> users = userDAO.getUsersByRole2(roleId);
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write(new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(users));
            } catch (NumberFormatException e) {
                resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                resp.getWriter().write("{\"error\": \"Invalid role ID\"}");
            }
            return;
        }

        req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Users user = (Users) req.getSession().getAttribute("acc");
            if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
                req.setAttribute("error", "Chỉ Admin hoặc Operator có quyền truy cập chức năng này.");
                req.getRequestDispatcher("page/login/login.jsp").forward(req, resp);
                return;
            }

            String userIdStr = req.getParameter("userId");
            String message = req.getParameter("message");
            String notificationType = req.getParameter("notificationType");
            String orderIdStr = req.getParameter("orderId");

            if (userIdStr == null || message == null || message.trim().isEmpty()) {
                req.setAttribute("error", "Vui lòng chọn người dùng và nhập nội dung thông báo.");
                req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
                return;
            }

            int userId;
            try {
                userId = Integer.parseInt(userIdStr);
            } catch (NumberFormatException e) {
                req.setAttribute("error", "ID người dùng không hợp lệ.");
                req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
                return;
            }

            Integer orderId = null;
            if (orderIdStr != null && !orderIdStr.trim().isEmpty()) {
                try {
                    orderId = Integer.parseInt(orderIdStr);
                } catch (NumberFormatException e) {
                    req.setAttribute("error", "ID đơn hàng không hợp lệ.");
                    req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
                    return;
                }
            }

            // Gửi thông báo
            notificationDAO.createNotification(userId, message, notificationType.isEmpty() ? null : notificationType, orderId);
            websocket.NotificationWebSocketServer.broadcast(message, notificationType.isEmpty() ? null : notificationType, orderId, userId);

            // Gửi cho Admin
            int adminId = userDAO.getAdminUserId();
            if (adminId != -1) {
                websocket.NotificationWebSocketServer.broadcast(message, notificationType.isEmpty() ? null : notificationType, orderId, adminId);
            } else {
                LOGGER.warning("No active admin found to send notification.");
            }

            req.setAttribute("message", "Thông báo đã được gửi thành công.");
            req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
        } catch (SQLException e) {
            LOGGER.severe("Database error: " + e.getMessage());
            req.setAttribute("error", "Lỗi truy vấn database: " + e.getMessage());
            req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("Processing error: " + e.getMessage());
            req.setAttribute("error", "Lỗi xử lý: " + e.getMessage());
            req.getRequestDispatcher("sendNotification.jsp").forward(req, resp);
        }
    }
}
