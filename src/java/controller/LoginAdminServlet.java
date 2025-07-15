package controller;

import dao.LogAdminDAO;
import dao.UserAdminDAO;
import model.UserAdmin;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginAdminServlet")
public class LoginAdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserAdminDAO userAdminDAO = new UserAdminDAO();
    private LogAdminDAO logAdminDAO = new LogAdminDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserAdmin user = userAdminDAO.getUserByUsername(username);

        if (user != null && user.getPassword().equals(password)) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("username", user.getUsername());

            logAdminDAO.logSystemActivity(user.getUserId(), "ADMIN_LOGIN_SUCCESS", "Admin user " + username + " logged in successfully.");

            response.sendRedirect("dashboard.jsp");
        } else {
            logAdminDAO.logSystemActivity(0, "ADMIN_LOGIN_FAILED", "Failed admin login attempt for username: " + username + " (Invalid credentials).");
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("logout".equals(action)) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Integer userId = (Integer) session.getAttribute("userId");
                String username = (String) session.getAttribute("username");
                session.invalidate();

                if (userId != null && userId > 0) {
                    logAdminDAO.logSystemActivity(userId, "ADMIN_LOGOUT", "Admin user " + username + " logged out.");
                } else {
                    logAdminDAO.logSystemActivity(0, "ADMIN_LOGOUT", "Unknown user logged out (session expired/invalid).");
                }
            }
            response.sendRedirect("login.jsp");
        } else {
            response.sendRedirect("login.jsp");
        }
    }
}