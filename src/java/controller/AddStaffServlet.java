package controller;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Users;
import model.Email;
import model.PasswordUtils;

import java.io.IOException;
import java.util.Random;

@WebServlet("/AddStaffServlet")
public class AddStaffServlet extends HttpServlet {

    private static final int GENERATED_PASSWORD_LENGTH = 8;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");

        if (username == null || email == null || username.trim().isEmpty() || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ tên người dùng và email.");
            request.getRequestDispatcher("/page/staff/addStaff.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        String duplicate = dao.checkDuplicate(email, username, 3); // roleId = 3 (staff)

        if ("email_exists".equals(duplicate)) {
            request.setAttribute("error", "Email đã tồn tại cho vai trò nhân viên.");
            request.getRequestDispatcher("/page/staff/addStaff.jsp").forward(request, response);
            return;
        } else if ("username_exists".equals(duplicate)) {
            request.setAttribute("error", "Tên đăng nhập đã tồn tại.");
            request.getRequestDispatcher("/page/staff/addStaff.jsp").forward(request, response);
            return;
        }

        // Sinh mật khẩu ngẫu nhiên và mã hóa
        String rawPassword = generateRandomPassword(GENERATED_PASSWORD_LENGTH);
        String hashedPassword = PasswordUtils.hashPassword(rawPassword);

        // Tạo đối tượng user
        Users user = new Users();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(3); // Staff
        user.setStatus("active");

        boolean created = dao.signupAccount(user);

        if (created) {
            try {
                // Gửi email chào mừng
                Email emailUtil = new Email();
                String subject = "Thông báo tuyển dụng nhân viên";
                String message = buildStaffWelcomeEmail(username, rawPassword);
                emailUtil.sendEmail(subject, message, email);

                // Chuyển hướng về danh sách người dùng
                response.sendRedirect(request.getContextPath() + "/UserListServlet");
                return;

            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Tạo nhân viên thành công nhưng gửi email thất bại.");
                request.getRequestDispatcher("/page/staff/addStaff.jsp").forward(request, response);
                return;
            }
        } else {
            request.setAttribute("error", "Không thể thêm nhân viên, vui lòng thử lại.");
            request.getRequestDispatcher("/page/staff/addStaff.jsp").forward(request, response);
        }
    }

    private String generateRandomPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@#";
        Random rnd = new Random();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }

    private String buildStaffWelcomeEmail(String username, String rawPassword) {
        return "<!DOCTYPE html>\n"
                + "<html lang=\"vi\">\n"
                + "<head><meta charset=\"UTF-8\"><title>Chào mừng</title></head>\n"
                + "<body style=\"font-family: Arial; background-color: #f4f4f4; margin: 0; padding: 0;\">\n"
                + "<table style=\"width: 100%; max-width: 600px; margin: 20px auto; background: #fff;\">\n"
                + "  <tr><td style=\"padding: 20px; background: #28a745; color: white; font-size: 20px; text-align: center;\">Chào mừng đến với hệ thống</td></tr>\n"
                + "  <tr><td style=\"padding: 20px;\">\n"
                + "    <p>Xin chào " + username + ",</p>\n"
                + "    <p>Chúc mừng bạn đã trở thành nhân viên chính thức của hệ thống.</p>\n"
                + "    <p>Hãy sử dụng địa chỉ email này để đăng nhập.</p>\n"
                + "    <p><b>Mật khẩu của bạn là:</b></p>\n"
                + "    <p style=\"font-size: 24px; font-weight: bold; color: #dc3545;\">" + rawPassword + "</p>\n"
                + "    <p>Vui lòng đổi mật khẩu sau khi đăng nhập lần đầu.</p>\n"
                + "    <p>Trân trọng,<br>Hệ thống chuyển nhà</p>\n"
                + "  </td></tr>\n"
                + "  <tr><td style=\"padding: 10px; background: #28a745; text-align: center; color: white;\">© 2025 Moving House</td></tr>\n"
                + "</table>\n"
                + "</body></html>";
    }
}
