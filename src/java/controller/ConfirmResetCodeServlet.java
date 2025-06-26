/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

@WebServlet(name = "ConfirmResetCodeServlet", urlPatterns = {"/confirmresetcode"})
public class ConfirmResetCodeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ConfirmResetCodeServlet.class.getName());
    private static final int MAX_ATTEMPTS = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        Integer roleId = (Integer) session.getAttribute("role_id");

        if (email == null || roleId == null) {
            request.setAttribute("message", "Phiên đã hết hạn. Vui lòng bắt đầu lại.");
            request.setAttribute("step", "enterEmail");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
        } else {
            request.setAttribute("email", email);
            request.setAttribute("role_id", roleId);
            request.setAttribute("step", "enterCode");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetCodeInput = request.getParameter("resetcode");
        String code = (String) session.getAttribute("code");
        String email = (String) session.getAttribute("email");
        Integer roleId = (Integer) session.getAttribute("role_id");
        Integer attemptsLeft = (Integer) session.getAttribute("attemptsLeft");

        if (email == null || roleId == null) {
            request.setAttribute("message", "Phiên đã hết hạn. Vui lòng bắt đầu lại.");
            request.setAttribute("step", "enterEmail");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            return;
        }

        if (attemptsLeft == null) {
            attemptsLeft = MAX_ATTEMPTS;
            session.setAttribute("attemptsLeft", attemptsLeft);
        }

        UserDAO dao = UserDAO.INSTANCE;

        if (code != null && code.equalsIgnoreCase(resetCodeInput)) {
            // Xác thực thành công
            Users user = dao.checkUserByEmail(email, roleId);
            if (user == null) {
                request.setAttribute("message", "Tài khoản không tồn tại");
                request.setAttribute("step", "enterEmail");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
                return;
            }

            // Lưu thông tin để đặt mật khẩu mới
            session.removeAttribute("code");
            session.removeAttribute("attemptsLeft");
            session.setAttribute("resetUsername", email);
            session.setAttribute("resetRoleId", roleId);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
        } else {
            // Mã sai, giảm số lần thử
            attemptsLeft--;
            session.setAttribute("attemptsLeft", attemptsLeft);

            if (attemptsLeft <= 0) {
                // Hết lần thử, xóa session
                session.removeAttribute("code");
                session.removeAttribute("email");
                session.removeAttribute("role_id");
                session.removeAttribute("attemptsLeft");
                request.setAttribute("message", "Bạn đã nhập sai quá nhiều lần. Vui lòng gửi lại email.");
                request.setAttribute("step", "enterEmail");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            } else {
                // Còn lần thử, thông báo số lần còn lại
                request.setAttribute("message", "Mã không đúng! Bạn còn " + attemptsLeft + " lần thử.");
                request.setAttribute("email", email);
                request.setAttribute("role_id", roleId);
                request.setAttribute("step", "enterCode");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Confirm Reset Code Servlet";
    }
}