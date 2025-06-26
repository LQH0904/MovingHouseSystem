/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.Email;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ForgotPassServlet", urlPatterns = {"/forgot"})
public class ForgotPassServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ForgotPassServlet.class.getName());
    private static final int MAX_ATTEMPTS = 3;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String codeSession = (String) session.getAttribute("code");

        if (codeSession == null) {
            // Bước 1: Chưa gửi mail, xử lý gửi mail
            String emailInput = request.getParameter("email");
            String roleIdStr = request.getParameter("role_id");
            int roleId;

            try {
                roleId = Integer.parseInt(roleIdStr);
                if (roleId < 1 || roleId > 6) {
                    request.setAttribute("message", "Vai trò không hợp lệ");
                    request.setAttribute("step", "enterEmail");
                    request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                request.setAttribute("message", "Vai trò không hợp lệ");
                request.setAttribute("step", "enterEmail");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
                return;
            }

            UserDAO dao = UserDAO.INSTANCE;
            Email handleEmail = new Email();
            Users user = dao.checkUserByEmail(emailInput, roleId);

            if (user != null) {
                // Tạo mã khôi phục
                Random random = new Random();
                Integer code = 100000 + random.nextInt(900000);
                String codeStr = code.toString();

                // Gửi email
                String subject = handleEmail.subjectForgotPass();
                String msgEmail = handleEmail.messageForgotPass(user.getUsername(), code);
                try {
                    handleEmail.sendEmail(subject, msgEmail, emailInput);
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error sending email: " + e.getMessage(), e);
                    request.setAttribute("message", "Gửi email thất bại, vui lòng thử lại");
                    request.setAttribute("step", "enterEmail");
                    request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
                    return;
                }

                // Lưu thông tin vào session
                session.setAttribute("code", codeStr);
                session.setAttribute("email", emailInput);
                session.setAttribute("role_id", roleId);
                session.setAttribute("attemptsLeft", MAX_ATTEMPTS);

                // Chuyển sang bước nhập mã
                request.setAttribute("email", emailInput);
                request.setAttribute("role_id", roleId);
                request.setAttribute("step", "enterCode");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            } else {
                request.setAttribute("message", "Email hoặc vai trò không đúng");
                request.setAttribute("step", "enterEmail");
                request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
            }
        } else {
            // Bước 2: Đã gửi mail, chuyển sang xác nhận mã
            request.setAttribute("email", session.getAttribute("email"));
            request.setAttribute("role_id", session.getAttribute("role_id"));
            request.setAttribute("step", "enterCode");
            request.getRequestDispatcher("page/login/forgot.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Forgot Password Servlet";
    }
}

