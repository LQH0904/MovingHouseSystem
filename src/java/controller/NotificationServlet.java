package controller;

import dao.NotificationDAO;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {
    private NotificationDAO notificationDAO;

    @Override
    public void init() throws ServletException {
        notificationDAO = NotificationDAO.INSTANCE;
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Users user = (Users) req.getSession().getAttribute("acc");
        if (user == null) {
            req.setAttribute("error", "Vui lòng đăng nhập để xem thông báo.");
            req.getRequestDispatcher("page/login/login.jsp").forward(req, resp);
            return;
        }

        List<model.Notification> notifications = notificationDAO.getNotificationsByUserId(user.getUserId());
        req.setAttribute("notifications", notifications);
        req.getRequestDispatcher("notifications.jsp").forward(req, resp);
    }
}