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
            request.setAttribute("error", "File giấy phép phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        UserDAO dao = UserDAO.INSTANCE;
        try {
            String duplicate = dao.checkDuplicate(email, companyName, 4);
            if ("email_exists".equals(duplicate)) {
                request.setAttribute("error", "Email đã được sử dụng cho vai trò vận chuyển");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
            if ("username_exists".equals(duplicate)) {
                request.setAttribute("error", "Tên công ty đã được sử dụng");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
        } catch (RuntimeException e) {
            LOGGER.log(Level.SEVERE, "Error checking duplicates: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi kiểm tra trùng lặp: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        // Lưu file tạm thời vào thư mục /temp
        String tempPath = getServletContext().getRealPath("/temp");
        File tempDir = new File(tempPath);
        if (!tempDir.exists()) {
            boolean created = tempDir.mkdirs();
            if (!created) {
                LOGGER.severe("Failed to create temporary directory: " + tempPath);
                request.setAttribute("error", "Lỗi hệ thống: Không thể tạo thư mục tạm");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
            LOGGER.info("Created temporary directory: " + created);
        }
        if (!tempDir.canWrite()) {
            LOGGER.severe("Temporary directory is not writable: " + tempPath);
            request.setAttribute("error", "Lỗi hệ thống: Không thể lưu trữ file tạm");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        String tempFileName = "temp_business_certificate_" + System.currentTimeMillis() + "_" + fileName;
        String tempFilePath = tempPath + File.separator + tempFileName;

        try {
            filePart.write(tempFilePath);
            LOGGER.info("Temporary file saved at: " + tempFilePath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "IOException saving temporary file: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi lưu file tạm: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashPassword(password);
        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;

        Users user = new Users();
        user.setUsername(companyName);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(4);
        user.setStatus("pending");

        TransportUnit transportUnit = new TransportUnit();
        transportUnit.setCompanyName(companyName);
        transportUnit.setContactInfo(contactInfo);
        transportUnit.setBusinessCertificate("/img/" + tempFileName.replace("temp_", ""));
        transportUnit.setLocation(location);
        transportUnit.setVehicleCount(vehicleCount);
        transportUnit.setCapacity(capacity);
        transportUnit.setLoader(loader);
        transportUnit.setRegistrationStatus("pending");

        // Lưu thông tin tạm vào session
        session.setAttribute("pendingUser", user);
        session.setAttribute("pendingTransportUnit", transportUnit);
        session.setAttribute("tempFilePath", tempFilePath);
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        String subject = "Xác nhận đăng ký Đơn vị Vận chuyển";
        String message = buildEmailContent(companyName, code);

        try {
            emailUtil.sendEmail(subject, message, email);
            response.sendRedirect(request.getContextPath() + "/signup_transport?action=confirm");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending email: " + e.getMessage(), e);
            new File(tempFilePath).delete();
            request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        }
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String inputCode = request.getParameter("code");
        String storedCode = (String) session.getAttribute("verificationCode");
        Long expiryTime = (Long) session.getAttribute("codeExpiry");
        Users user = (Users) session.getAttribute("pendingUser");
        TransportUnit transportUnit = (TransportUnit) session.getAttribute("pendingTransportUnit");
        String tempFilePath = (String) session.getAttribute("tempFilePath");

        if (storedCode == null || expiryTime == null || user == null || transportUnit == null || tempFilePath == null) {
            new File(tempFilePath).delete();
            session.invalidate();
            request.setAttribute("error", "Phiên xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            new File(tempFilePath).delete();
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

        // Di chuyển file từ /temp sang /img
        String uploadPath = getServletContext().getRealPath("/img");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String finalFileName = transportUnit.getBusinessCertificate().substring("/img/".length());
        String finalFilePath = uploadPath + File.separator + finalFileName;
        File tempFile = new File(tempFilePath);
        File finalFile = new File(finalFilePath);

        try {
            if (!tempFile.renameTo(finalFile)) {
                throw new IOException("Không thể di chuyển file từ " + tempFilePath + " sang " + finalFilePath);
            }
            LOGGER.info("File moved to: " + finalFilePath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error moving file: " + e.getMessage(), e);
            tempFile.delete();
            session.invalidate();
            request.setAttribute("error", "Lỗi di chuyển file: " + e.getMessage());
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        // Lưu dữ liệu vào cơ sở dữ liệu
        UserDAO dao = UserDAO.INSTANCE;
        Connection conn = null;
        int userId = 0;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu");
            }
            conn.setAutoCommit(false);

            userId = dao.signupAccount2(user);
            if (userId == 0) {
                throw new SQLException("Không thể lưu tài khoản người dùng");
            }

            if (!dao.saveTransportUnit(transportUnit, userId)) {
                throw new SQLException("Không thể lưu thông tin Transport Unit");
            }

            conn.commit();
            session.invalidate();
            request.setAttribute("success", "Xác nhận tài khoản thành công! Vui lòng chờ admin duyệt.");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException in confirm process: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                    if (userId != 0) {
                        dao.deleteUser(userId);
                    }
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            finalFile.delete();
            session.invalidate();
            request.setAttribute("error", "Đăng ký thất bại: " + (e.getSQLState().equals("23000") ? "Tên công ty đã được sử dụng" : e.getMessage()));
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
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

    private void handleResendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("pendingUser");
        TransportUnit transportUnit = (TransportUnit) session.getAttribute("pendingTransportUnit");
        String tempFilePath = (String) session.getAttribute("tempFilePath");

        if (user == null || transportUnit == null || tempFilePath == null) {
            new File(tempFilePath).delete();
            session.invalidate();
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