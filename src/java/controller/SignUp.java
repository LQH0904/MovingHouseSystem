package controller;

import dao.UserDAO;
import model.Users;
import model.Email;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.PasswordUtils;
import java.sql.SQLException;


@WebServlet(name = "SignUp", urlPatterns = {"/signup"})
public class SignUp extends HttpServlet {

    private static final int CODE_LENGTH = 6;
    private static final long CODE_EXPIRY_MS = 10 * 60 * 1000;
    private static final Logger LOGGER = Logger.getLogger(SignUpStorage.class.getName());

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        String action = request.getParameter("action");

        if ("confirm".equals(action)) {
            handleConfirm(request, response);
        } else if ("resend".equals(action)) {
            handleResendCode(request, response);
        } else {
            handleSignup(request, response);
        }
    }

    private void handleSignup(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, Exception {
        HttpSession session = request.getSession();
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        Email emailUtil = new Email();

        if (!emailUtil.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
            return;
        }

        if (username == null || username.length() < 3 || username.length() > 20) {
            request.setAttribute("error", "Tên đăng nhập phải từ 3 đến 20 ký tự");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
            return;
        }

        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        try {
            String duplicate = dao.checkDuplicate(email, username, 6);
            if ("email_exists".equals(duplicate)) {
                request.setAttribute("error", "Email đã được sử dụng cho vai trò khách hàng");
                request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
                return;
            } else if ("username_exists".equals(duplicate)) {
                request.setAttribute("error", "Tên đăng nhập đã được sử dụng");
                request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
                return;
            }
        } catch (RuntimeException e) {
            LOGGER.log(Level.SEVERE, "Error checking duplicates: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi kiểm tra trùng lặp: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashPassword(password);
        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;

        Users user = new Users();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(6);
        user.setStatus("active"); // Lưu trực tiếp trạng thái active

        session.setAttribute("pendingUser", user);
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        String subject = "Xác nhận đăng ký tài khoản";
        String message = buildEmailContent(username, code);

        try {
            emailUtil.sendEmail(subject, message, email);
            response.sendRedirect(request.getContextPath() + "/signup?action=confirm");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending email: " + e.getMessage(), e);
            request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
        }
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String inputCode = request.getParameter("code");
        String storedCode = (String) session.getAttribute("verificationCode");
        Long expiryTime = (Long) session.getAttribute("codeExpiry");
        Users user = (Users) session.getAttribute("pendingUser");

        if (storedCode == null || expiryTime == null || user == null) {
            session.invalidate();
            request.setAttribute("error", "Phiên xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            session.invalidate();
            request.setAttribute("error", "Mã xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
            return;
        }

        if (!storedCode.equals(inputCode)) {
            request.setAttribute("error", "Mã xác nhận không đúng");
            request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
            return;
        }

        // Lưu dữ liệu vào cơ sở dữ liệu
        UserDAO dao = new UserDAO();
        try {
            if (!dao.signupAccount(user)) {
                throw new SQLException("Không thể lưu tài khoản người dùng");
            }
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/signup?action=confirm&success=1");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in confirm process: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage(), e);
            session.invalidate();
            request.setAttribute("error", "Đăng ký thất bại: " + (e.getSQLState().equals("23000") ? "Tên đăng nhập đã được sử dụng" : e.getMessage()));
            request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
        }
    }

    private void handleResendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("pendingUser");

        if (user == null) {
            session.invalidate();
            request.setAttribute("error", "Phiên đăng ký đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
            return;
        }

        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        Email emailUtil = new Email();
        String subject = "Xác nhận đăng ký tài khoản";
        String message = buildEmailContent(user.getUsername(), code);

        try {
            emailUtil.sendEmail(subject, message, user.getEmail());
            request.setAttribute("success", "Mã xác nhận đã được gửi lại!");
            request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error resending email: " + e.getMessage(), e);
            request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
        }
    }

    private String buildEmailContent(String username, String code) {
        return "<!DOCTYPE html>\n"
                + "<html lang=\"vi\">\n"
                + "<head><meta charset=\"UTF-8\"><title>Mã xác nhận</title></head>\n"
                + "<body style=\"font-family: Arial; background-color: #f4f4f4; margin: 0; padding: 0;\">\n"
                + "  <table style=\"width: 100%; max-width: 600px; margin: 20px auto; background: #fff;\">\n"
                + "    <tr><td style=\"padding: 20px; background: #007bff; color: white; font-size: 20px; text-align: center;\">Xác nhận đăng ký</td></tr>\n"
                + "    <tr><td style=\"padding: 20px;\">\n"
                + "      <p>Xin chào " + username + ",</p>\n"
                + "      <p>Mã xác nhận của bạn là:</p>\n"
                + "      <p style=\"font-size: 28px; font-weight: bold; color: #007bff;\">" + code + "</p>\n"
                + "      <p>Mã có hiệu lực trong 10 phút.</p>\n"
                + "      <p>Trân trọng,<br>Dịch vụ vận chuyển nhà</p>\n"
                + "    </td></tr>\n"
                + "    <tr><td style=\"padding: 10px; background: #007bff; text-align: center; color: white;\">© 2025 Moving House</td></tr>\n"
                + "  </table>\n"
                + "</body></html>";
    }

    private String generateVerificationCode() {
        Random random = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < CODE_LENGTH; i++) {
            code.append(random.nextInt(10));
        }
        return code.toString();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            if ("confirm".equals(action)) {
                request.getRequestDispatcher("/page/login/confirm.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            Logger.getLogger(SignUp.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            Logger.getLogger(SignUp.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup.jsp").forward(request, response);
        }
    }
}
