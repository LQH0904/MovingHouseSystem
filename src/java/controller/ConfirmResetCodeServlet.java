/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * 
 */
@WebServlet(name = "ConfirmResetCodeServlet", urlPatterns = {"/confirmresetcode"})
public class ConfirmResetCodeServlet extends HttpServlet {

    private static final int MAX_ATTEMPTS = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String resetUsername = (String) session.getAttribute("resetUsername");
        if (resetUsername == null) {
            request.setAttribute("error", "Session expired. Please start over.");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            return;
        }
        request.setAttribute("resetUsername", resetUsername);
        request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        String resetCodeInput = request.getParameter("resetcode");
        String code = (String) session.getAttribute("code");
        String email = (String) session.getAttribute("email");
        Integer attemptsLeft = (Integer) session.getAttribute("attemptsLeft");

        // Khởi tạo attemptsLeft nếu null
        if (attemptsLeft == null) {
            attemptsLeft = MAX_ATTEMPTS;
            session.setAttribute("attemptsLeft", attemptsLeft);
        }

        UserDAO ud = new UserDAO();
        String message;
        String check;

        if (code != null && code.equalsIgnoreCase(resetCodeInput)) {
            // Xác thực thành công
            check = "true";
            Users user = ud.checkUserByEmail(email);
            if (user == null) {
                request.setAttribute("message", "User not found");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
                return;
            }

            // Xóa các session attribute liên quan
            session.removeAttribute("code");
            session.removeAttribute("attemptsLeft");
            session.setAttribute("resetUsername", email);
            request.setAttribute("check", check);
            request.getRequestDispatcher("page/login/newpassword.jsp").forward(request, response);
        } else {
            // Mã sai, giảm số lần thử
            attemptsLeft--;
            session.setAttribute("attemptsLeft", attemptsLeft);

            check = "true";
            if (attemptsLeft <= 0) {
                // Hết lần thử, xóa session và yêu cầu gửi lại email
                session.removeAttribute("code");
                session.removeAttribute("email");
                session.removeAttribute("attemptsLeft");
                message = "Bạn đã nhập sai quá nhiều lần. Vui lòng gửi lại email.";
                request.setAttribute("message", message);
                request.setAttribute("step", "enterEmail");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            } else {
                // Còn lần thử, thông báo số lần còn lại
                message = "Mã không đúng! Bạn còn " + attemptsLeft + " lần thử.";
                request.setAttribute("email", email);
                request.setAttribute("check", check);
                request.setAttribute("message", message);
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