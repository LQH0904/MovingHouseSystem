/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import entity.UserDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;
import model.Email;
import model.Users;

/**
 *
 * 
 */
@WebServlet(name = "ForgotPassServlet", urlPatterns = {"/forgot"})
public class ForgotPassServlet extends HttpServlet {

    private static final int MAX_ATTEMPTS = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        // Kiểm tra xem session đã có code chưa
        String codeSession = (String) session.getAttribute("code");
        Integer attemptsLeft = (Integer) session.getAttribute("attemptsLeft");

        if (codeSession == null) {
            // Bước 1: Chưa gửi mail, xử lý gửi mail

            String emailInput = request.getParameter("email");
            UserDAO ud = new UserDAO();
            Email handleEmail = new Email();

            Users user = ud.checkUserByEmail(emailInput);

            if (user != null) {
                // Tạo code mới
                Random random = new Random();
                Integer code = 100000 + random.nextInt(900000);
                String codeStr = code.toString();

                // Gửi mail
                String subject = handleEmail.subjectForgotPass();
                String msgEmail = handleEmail.messageForgotPass(user.getUsername(), code);
                handleEmail.sendEmail(subject, msgEmail, emailInput);

                // Lưu code, email, số lần thử vào session
                session.setAttribute("code", codeStr);
                session.setAttribute("email", emailInput);
                session.setAttribute("attemptsLeft", MAX_ATTEMPTS);

                // Chuyển bước sang nhập code
                request.setAttribute("email", emailInput);
                request.setAttribute("step", "enterCode");
                request.getRequestDispatcher("forgot.jsp").forward(request, response);

            } else {
                // Email không tồn tại
                request.setAttribute("message", "Email không tồn tại!");
                request.setAttribute("step", "enterEmail");
                request.getRequestDispatcher("forgot.jsp").forward(request, response);
            }

        } else {
            // Bước 2: Đã gửi mail, đang xác nhận code

            String codeInput = request.getParameter("resetcode");
            String email = (String) session.getAttribute("email");

            if (attemptsLeft == null) {
                attemptsLeft = MAX_ATTEMPTS;
            }

            if (codeSession.equals(codeInput)) {
                // Code đúng, xóa session
                session.removeAttribute("code");
                session.removeAttribute("email");
                session.removeAttribute("attemptsLeft");

                // Giả sử bạn muốn chuyển sang trang đổi mật khẩu là newpassword.jsp
                request.setAttribute("message", "Code verified! Please reset your password.");
                request.getRequestDispatcher("newpassword.jsp").forward(request, response);

            } else {
                // Code sai, giảm số lần còn lại
                attemptsLeft--;
                session.setAttribute("attemptsLeft", attemptsLeft);

                if (attemptsLeft <= 0) {
                    // Hết lần thử, xóa session
                    session.removeAttribute("code");
                    session.removeAttribute("email");
                    session.removeAttribute("attemptsLeft");

                    request.setAttribute("message", "Bạn đã nhập sai quá nhiều lần. Vui lòng gửi lại email để nhận mã mới.");
                    request.setAttribute("step", "enterEmail");
                    request.getRequestDispatcher("forgot.jsp").forward(request, response);

                } else {
                    // Còn lần thử, thông báo còn lại
                    request.setAttribute("message", "Mã không đúng! Bạn còn " + attemptsLeft + " lần thử.");
                    request.setAttribute("email", email);
                    request.setAttribute("step", "enterCode");
                    request.getRequestDispatcher("forgot.jsp").forward(request, response);
                }
            }
        }
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Servlet";
    }
}
