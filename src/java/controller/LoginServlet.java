/*
 * Click nbsp://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbsp://SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.SystemLogDAO;
import dao.UserDAO;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;
import listener.SessionTracker;
import model.PasswordUtils;
import model.SystemLog;
import model.UserSessionInfo;

/**
 *
 * @author admin
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false); // Không tạo session mới nếu chưa tồn tại
        if (session != null && session.getAttribute("acc") != null) {
            Users user = (Users) session.getAttribute("acc");
            switch (user.getRoleId()) {
                case 1: // Admin
                    response.sendRedirect(request.getContextPath() + "/admin/system-performance");
                    break;
                case 2: // Operator
                    response.sendRedirect(request.getContextPath() + "/homeOperator");
                    break;
                case 3: // Staff
                    response.sendRedirect(request.getContextPath() + "/homeStaff");
                    break;
                case 4: // Transport Unit
                    response.sendRedirect(request.getContextPath() + "/notifications");
                    break;
                case 5: // Storage Unit
                    response.sendRedirect(request.getContextPath() + "/notifications");
                    break;
                case 6: // Customer
                    response.sendRedirect(request.getContextPath() + "/notifications");
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/orderList");
                    break;
            }
            return;
        }
        request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleIdStr = request.getParameter("role_id");

        int roleId;
        try {
            roleId = Integer.parseInt(roleIdStr);
            if (roleId < 1 || roleId > 6) {
                request.setAttribute("mess", "Vai trò không hợp lệ");
                request.setAttribute("email", email);
                request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("mess", "Vai trò không hợp lệ");
            request.setAttribute("email", email);
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
            return;
        }

        UserDAO dao = UserDAO.INSTANCE;
        Users user = dao.getUser(email, roleId);

        if (user == null) {
            request.setAttribute("mess", "Email, mật khẩu hoặc vai trò không đúng");
            request.setAttribute("email", email);
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
            return;
        }

        boolean passwordMatch = false;
        try {
            passwordMatch = PasswordUtils.checkPassword(password, user.getPasswordHash());
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Error checking password for user: " + email + ": " + e.getMessage(), e);
            request.setAttribute("mess", "Lỗi kiểm tra mật khẩu");
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
            return;
        }

        if (!passwordMatch) {
            request.setAttribute("mess", "Email, mật khẩu hoặc vai trò không đúng");
            request.setAttribute("email", email);
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
            return;
        }

        if (!"active".equalsIgnoreCase(user.getStatus())) {
            request.setAttribute("mess", "Tài khoản chưa được kích hoạt hoặc bị khóa");
            request.setAttribute("email", email);
            request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
            return;
        }

        // Tạo session mới
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }
        HttpSession newSession = request.getSession(true);
        newSession.setAttribute("acc", user);
        newSession.setAttribute("username", user.getUsername());
        newSession.setAttribute("email", user.getEmail());
        //Create Log
        SystemLogDAO aO = new SystemLogDAO();
        SystemLog log = new SystemLog();
        log.setUserId(user.getUserId());
        log.setUsername(user.getUsername());
        log.setAction("Login");
        log.setDetails(user.getUsername() + "Đăng nhập");
        aO.createSystemLog(log);
        
        //Duy : check log login user
        UserSessionInfo sessionInfo = new UserSessionInfo(user.getUsername(), LocalDateTime.now());
        newSession.setAttribute("sessionInfo", sessionInfo);
        // ✅ Ghi log luôn khi login
        SessionTracker.sessionLogs.add(sessionInfo);

        // Chuyển hướng dựa trên vai trò
        switch (user.getRoleId()) {
            case 1: // Admin
                response.sendRedirect(request.getContextPath() + "/admin/system-performance");
                break;
            case 2: // Operator
                response.sendRedirect(request.getContextPath() + "/homeOperator");
                break;
            case 3: // Staff
                response.sendRedirect(request.getContextPath() + "/homeStaff");
                break;
            case 4: // Transport Unit
                response.sendRedirect(request.getContextPath() + "/notifications");
                break;
            case 5: // Storage Unit
                response.sendRedirect(request.getContextPath() + "/notifications");
                break;
            case 6: // Customer
                response.sendRedirect(request.getContextPath() + "/notifications");
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/orderList");
                break;
        }
    }

    @Override
    public String getServletInfo() {
        return "Login processing servlet";
    }
}
