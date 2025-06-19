package controller;

import dao.UserDAO;
import model.Users;
import model.TransportUnit;
import model.Email;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.PasswordUtils;
import jakarta.servlet.http.Part;
import utils.DBConnection;

@WebServlet(name = "SignUpTransport", urlPatterns = {"/signup_transport"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class SignUpTransport extends HttpServlet {

    private static final int CODE_LENGTH = 6;
    private static final long CODE_EXPIRY_MS = 10 * 60 * 1000;
    private static final Logger LOGGER = Logger.getLogger(SignUpTransport.class.getName());

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String companyName = request.getParameter("company_name");
        String contactInfo = request.getParameter("contact_info");
        String location = request.getParameter("location");
        String vehicleCountStr = request.getParameter("vehicle_count");
        String capacityStr = request.getParameter("capacity");
        String loaderStr = request.getParameter("loader");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        Part filePart = request.getPart("business_certificate");

        Email emailUtil = new Email();

        // Validate inputs
        if (!emailUtil.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (companyName == null || companyName.trim().length() < 3 || companyName.length() > 150) {
            request.setAttribute("error", "Tên công ty phải từ 3 đến 150 ký tự");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (contactInfo != null && (contactInfo.length() < 5 || contactInfo.length() > 255)) {
            request.setAttribute("error", "Thông tin liên hệ không hợp lệ (5-255 ký tự)");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (location != null && (location.length() < 5 || location.length() > 100)) {
            request.setAttribute("error", "Địa chỉ phải từ 5 đến 100 ký tự");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        int vehicleCount, loader;
        double capacity;
        try {
            vehicleCount = Integer.parseInt(vehicleCountStr);
            capacity = Double.parseDouble(capacityStr);
            loader = Integer.parseInt(loaderStr);
            if (vehicleCount < 1 || capacity < 0.1 || loader < 0) {
                request.setAttribute("error", "Số lượng xe, tải trọng hoặc nhân viên không hợp lệ");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số lượng xe, tải trọng hoặc nhân viên không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (filePart == null || filePart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file giấy phép kinh doanh");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        String fileName = filePart.getSubmittedFileName();
        if (!fileName.matches(".*\\.(jpg|jpeg|png)$")) {
            request.setAttribute("error", "File giấy phép phải là định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        UserDAO dao = UserDAO.INSTANCE;
        String duplicate = dao.checkDuplicate(email, companyName);
        if ("email_exists".equals(duplicate)) {
            request.setAttribute("error", "Email đã được sử dụng");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if ("username_exists".equals(duplicate)) {
            request.setAttribute("error", "Tên công ty đã được sử dụng");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        // Handle file upload
        String uploadPath = getServletContext().getRealPath("/img");
        LOGGER.info("Upload path: " + uploadPath);
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            boolean created = uploadDir.mkdirs();
            LOGGER.info("Created upload directory: " + created);
        }
        if (!uploadDir.canWrite()) {
            LOGGER.severe("Upload directory is not writable: " + uploadPath);
            request.setAttribute("error", "Lỗi hệ thống: Không thể lưu file ảnh");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        String newFileName = "business_certificate_" + System.currentTimeMillis() + "_" + fileName;
        String filePath = uploadPath + File.separator + newFileName;

        String hashedPassword = PasswordUtils.hashPassword(password);
        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;

        Users user = new Users();
        user.setUsername(companyName);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(4); // Transport Unit
        user.setStatus("pending");

        TransportUnit transportUnit = new TransportUnit();
        transportUnit.setCompanyName(companyName);
        transportUnit.setContactInfo(contactInfo);
        transportUnit.setBusinessCertificate("/img/" + newFileName);
        transportUnit.setLocation(location);
        transportUnit.setVehicleCount(vehicleCount);
        transportUnit.setCapacity(capacity);
        transportUnit.setLoader(loader);
        transportUnit.setRegistrationStatus("pending");

        Connection conn = null;
        int userId = 0;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Bắt đầu transaction

            // Lưu file ảnh trước khi commit
            filePart.write(filePath);
            LOGGER.info("File saved at: " + filePath);

            // Lưu user và lấy user_id
            userId = dao.signupAccount2(user);
            if (userId == 0) {
                throw new SQLException("Không thể lưu tài khoản người dùng");
            }

            // Lưu Transport Unit với user_id làm user_id
            if (!dao.saveTransportUnit(transportUnit, userId)) {
                throw new SQLException("Không thể lưu thông tin Transport Unit");
            }

            session.setAttribute("pendingUser", user);
            session.setAttribute("pendingTransportUnit", transportUnit);
            session.setAttribute("verificationCode", code);
            session.setAttribute("codeExpiry", expiryTime);

            String subject = "Xác nhận đăng ký Đơn vị Vận chuyển";
            String message = buildEmailContent(companyName, code);

            try {
                emailUtil.sendEmail(subject, message, email);
            } catch (Exception e) {
                LOGGER.warning("Failed to send email: " + e.getMessage());
                // Không ném ngoại lệ để tránh rollback transaction
            }

            conn.commit(); // Commit transaction
            response.sendRedirect(request.getContextPath() + "/signup_transport?action=confirm");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in signup process: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction
                    // Xóa bản ghi Users nếu đã tạo
                    if (userId != 0) {
                        dao.deleteUser(userId);
                    }
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            new File(filePath).delete();
            String errorMsg = e.getSQLState() != null && e.getSQLState().equals("23000") ? 
                "Tài khoản đã được đăng ký làm đơn vị vận chuyển" : 
                "Đăng ký thất bại: " + e.getMessage() + " (SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode() + ")";
            request.setAttribute("error", errorMsg);
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "IOException saving file: " + e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction
                    // Xóa bản ghi Users nếu đã tạo
                    if (userId != 0) {
                        dao.deleteUser(userId);
                    }
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            new File(filePath).delete();
            request.setAttribute("error", "Lỗi lưu file ảnh: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in signup process: " + e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback transaction
                    // Xóa bản ghi Users nếu đã tạo
                    if (userId != 0) {
                        dao.deleteUser(userId);
                    }
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            new File(filePath).delete();
            request.setAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error closing connection: " + ex.getMessage(), ex);
                }
            }
        }
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String inputCode = request.getParameter("code");
        String storedCode = (String) session.getAttribute("verificationCode");
        Long expiryTime = (Long) session.getAttribute("codeExpiry");

        if (storedCode == null || expiryTime == null) {
            request.setAttribute("error", "Phiên xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            session.invalidate();
            request.setAttribute("error", "Mã xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        if (!storedCode.equals(inputCode)) {
            request.setAttribute("error", "Mã xác nhận không đúng");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        // Xác nhận thành công, giữ trạng thái pending chờ admin duyệt
        session.invalidate();
        request.setAttribute("success", "Xác nhận tài khoản thành công! Vui lòng chờ admin duyệt.");
        request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
    }

    private void handleResendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("pendingUser");
        TransportUnit transportUnit = (TransportUnit) session.getAttribute("pendingTransportUnit");

        if (user == null || transportUnit == null) {
            request.setAttribute("error", "Phiên đăng ký đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        Email emailUtil = new Email();
        String subject = "Xác nhận đăng ký Đơn vị Vận chuyển";
        String message = buildEmailContent(transportUnit.getCompanyName(), code);

        try {
            emailUtil.sendEmail(subject, message, user.getEmail());
            request.setAttribute("success", "Mã xác nhận đã được gửi lại!");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error resending email: " + e.getMessage(), e);
            request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        }
    }

    private String buildEmailContent(String companyName, String code) {
        return "<!DOCTYPE html>\n"
                + "<html lang=\"vi\">\n"
                + "<head><meta charset=\"UTF-8\"><title>Mã xác nhận</title></head>\n"
                + "<body style=\"font-family: Arial; background-color: #f4f4f4; margin: 0; padding: 0;\">\n"
                + "  <table style=\"width: 100%; max-width: 600px; margin: 20px auto; background: #fff;\">\n"
                + "    <tr><td style=\"padding: 20px; background: #007bff; color: white; font-size: 20px; text-align: center;\">Xác nhận đăng ký</td></tr>\n"
                + "    <tr><td style=\"padding: 20px;\">\n"
                + "      <p>Xin chào " + companyName + ",</p>\n"
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
                request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error in doGet: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error in doPost: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        }
    }
}