package controller;

import dao.UserDAO;
import model.Users;
import model.StorageUnit;
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

@WebServlet(name = "SignUpStorage", urlPatterns = {"/signup_storage"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class SignUpStorage extends HttpServlet {

    private static final int CODE_LENGTH = 6;
    private static final long CODE_EXPIRY_MS = 10 * 60 * 1000;
    private static final Logger LOGGER = Logger.getLogger(SignUpStorage.class.getName());

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
        String warehouseName = request.getParameter("warehouse_name");
        String phoneNumber = request.getParameter("phone_number");
        String location = request.getParameter("location");
        String area = request.getParameter("area");
        String employeeStr = request.getParameter("employee");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        Part businessCertificatePart = request.getPart("business_certificate");
        Part floorPlanPart = request.getPart("floor_plan");
        Part insurancePart = request.getPart("insurance");

        Email emailUtil = new Email();

        // Validate inputs
        if (!emailUtil.isValidEmail(email)) {
            request.setAttribute("error", "Email không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (warehouseName == null || warehouseName.trim().length() < 3 || warehouseName.length() > 150) {
            request.setAttribute("error", "Tên kho bãi phải từ 3 đến 150 ký tự");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (phoneNumber == null || !phoneNumber.matches("^[0-9]{10,15}$")) {
            request.setAttribute("error", "Số điện thoại không hợp lệ (10-15 chữ số)");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (location != null && (location.length() < 5 || location.length() > 255)) {
            request.setAttribute("error", "Địa điểm phải từ 5 đến 255 ký tự");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (area != null && (area.length() > 200 || !area.matches("^\\d+(\\.\\d{1,2})?$"))) {
            request.setAttribute("error", "Diện tích không hợp lệ (tối đa 200 ký tự, định dạng số với tối đa 2 chữ số thập phân)");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        int employee;
        try {
            employee = Integer.parseInt(employeeStr);
            if (employee < 0) {
                request.setAttribute("error", "Số nhân viên không hợp lệ");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Số nhân viên không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (password == null || password.length() < 6) {
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (businessCertificatePart == null || businessCertificatePart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file giấy phép kinh doanh");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String businessFileName = businessCertificatePart.getSubmittedFileName();
        if (!businessFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            request.setAttribute("error", "File giấy phép phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (floorPlanPart == null || floorPlanPart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file ảnh mặt bằng kho");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String floorPlanFileName = floorPlanPart.getSubmittedFileName();
        if (!floorPlanFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            request.setAttribute("error", "File mặt bằng kho phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (insurancePart == null || insurancePart.getSize() == 0) {
            request.setAttribute("error", "Vui lòng chọn file giấy tờ bảo hiểm");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String insuranceFileName = insurancePart.getSubmittedFileName();
        if (!insuranceFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            request.setAttribute("error", "File giấy tờ bảo hiểm phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        UserDAO dao = UserDAO.INSTANCE;
        try {
            String duplicate = dao.checkDuplicate(email, warehouseName, 5);
            if ("email_exists".equals(duplicate)) {
                request.setAttribute("error", "Email đã được sử dụng cho vai trò kho bãi");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
            if ("username_exists".equals(duplicate)) {
                request.setAttribute("error", "Tên kho bãi đã được sử dụng");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
        } catch (RuntimeException e) {
            LOGGER.log(Level.SEVERE, "Error checking duplicates: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi kiểm tra trùng lặp: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
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
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
            LOGGER.info("Created temporary directory: " + created);
        }
        if (!tempDir.canWrite()) {
            LOGGER.severe("Temporary directory is not writable: " + tempPath);
            request.setAttribute("error", "Lỗi hệ thống: Không thể lưu trữ file tạm");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String tempBusinessFileName = "temp_business_certificate_" + System.currentTimeMillis() + "_" + businessFileName;
        String tempBusinessFilePath = tempPath + File.separator + tempBusinessFileName;
        String tempFloorPlanFileName = "temp_floor_plan_" + System.currentTimeMillis() + "_" + floorPlanFileName;
        String tempFloorPlanFilePath = tempPath + File.separator + tempFloorPlanFileName;
        String tempInsuranceFileName = "temp_insurance_" + System.currentTimeMillis() + "_" + insuranceFileName;
        String tempInsuranceFilePath = tempPath + File.separator + tempInsuranceFileName;

        try {
            businessCertificatePart.write(tempBusinessFilePath);
            floorPlanPart.write(tempFloorPlanFilePath);
            insurancePart.write(tempInsuranceFilePath);
            LOGGER.info("Temporary files saved at: " + tempBusinessFilePath + ", " + tempFloorPlanFilePath + ", " + tempInsuranceFilePath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "IOException saving temporary files: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi lưu file tạm: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        String hashedPassword = PasswordUtils.hashPassword(password);
        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;

        Users user = new Users();
        user.setUsername(warehouseName);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(5);
        user.setStatus("pending");

        StorageUnit storageUnit = new StorageUnit();
        storageUnit.setWarehouseName(warehouseName);
        storageUnit.setPhoneNumber(phoneNumber);
        storageUnit.setBusinessCertificate("/img/" + tempBusinessFileName.replace("temp_", ""));
        storageUnit.setFloorPlan("/img/" + tempFloorPlanFileName.replace("temp_", ""));
        storageUnit.setInsurance("/img/" + tempInsuranceFileName.replace("temp_", ""));
        storageUnit.setLocation(location);
        storageUnit.setArea(area);
        storageUnit.setEmployee(employee);
        storageUnit.setRegistrationStatus("pending");

        // Lưu thông tin tạm vào session
        session.setAttribute("pendingUser", user);
        session.setAttribute("pendingStorageUnit", storageUnit);
        session.setAttribute("tempBusinessFilePath", tempBusinessFilePath);
        session.setAttribute("tempFloorPlanFilePath", tempFloorPlanFilePath);
        session.setAttribute("tempInsuranceFilePath", tempInsuranceFilePath);
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        String subject = "Xác nhận đăng ký Đơn vị Kho bãi";
        String message = buildEmailContent(warehouseName, code);

        try {
            emailUtil.sendEmail(subject, message, email);
            response.sendRedirect(request.getContextPath() + "/signup_storage?action=confirm");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error sending email: " + e.getMessage(), e);
            new File(tempBusinessFilePath).delete();
            new File(tempFloorPlanFilePath).delete();
            new File(tempInsuranceFilePath).delete();
            request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
        }
    }

    private void handleConfirm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String inputCode = request.getParameter("code");
        String storedCode = (String) session.getAttribute("verificationCode");
        Long expiryTime = (Long) session.getAttribute("codeExpiry");
        Users user = (Users) session.getAttribute("pendingUser");
        StorageUnit storageUnit = (StorageUnit) session.getAttribute("pendingStorageUnit");
        String tempBusinessFilePath = (String) session.getAttribute("tempBusinessFilePath");
        String tempFloorPlanFilePath = (String) session.getAttribute("tempFloorPlanFilePath");
        String tempInsuranceFilePath = (String) session.getAttribute("tempInsuranceFilePath");

        if (storedCode == null || expiryTime == null || user == null || storageUnit == null || 
            tempBusinessFilePath == null || tempFloorPlanFilePath == null || tempInsuranceFilePath == null) {
            if (tempBusinessFilePath != null) new File(tempBusinessFilePath).delete();
            if (tempFloorPlanFilePath != null) new File(tempFloorPlanFilePath).delete();
            if (tempInsuranceFilePath != null) new File(tempInsuranceFilePath).delete();
            session.invalidate();
            request.setAttribute("error", "Phiên xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            new File(tempBusinessFilePath).delete();
            new File(tempFloorPlanFilePath).delete();
            new File(tempInsuranceFilePath).delete();
            session.invalidate();
            request.setAttribute("error", "Mã xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            return;
        }

        if (!storedCode.equals(inputCode)) {
            request.setAttribute("error", "Mã xác nhận không đúng");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            return;
        }

        // Di chuyển file từ /temp sang /img
        String uploadPath = getServletContext().getRealPath("/img");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }
        String finalBusinessFileName = storageUnit.getBusinessCertificate().substring("/img/".length());
        String finalBusinessFilePath = uploadPath + File.separator + finalBusinessFileName;
        String finalFloorPlanFileName = storageUnit.getFloorPlan().substring("/img/".length());
        String finalFloorPlanFilePath = uploadPath + File.separator + finalFloorPlanFileName;
        String finalInsuranceFileName = storageUnit.getInsurance().substring("/img/".length());
        String finalInsuranceFilePath = uploadPath + File.separator + finalInsuranceFileName;
        File tempBusinessFile = new File(tempBusinessFilePath);
        File tempFloorPlanFile = new File(tempFloorPlanFilePath);
        File tempInsuranceFile = new File(tempInsuranceFilePath);
        File finalBusinessFile = new File(finalBusinessFilePath);
        File finalFloorPlanFile = new File(finalFloorPlanFilePath);
        File finalInsuranceFile = new File(finalInsuranceFilePath);

        try {
            if (!tempBusinessFile.renameTo(finalBusinessFile)) {
                throw new IOException("Không thể di chuyển file giấy phép kinh doanh từ " + tempBusinessFilePath + " sang " + finalBusinessFilePath);
            }
            if (!tempFloorPlanFile.renameTo(finalFloorPlanFile)) {
                throw new IOException("Không thể di chuyển file mặt bằng kho từ " + tempFloorPlanFilePath + " sang " + finalFloorPlanFilePath);
            }
            if (!tempInsuranceFile.renameTo(finalInsuranceFile)) {
                throw new IOException("Không thể di chuyển file giấy tờ bảo hiểm từ " + tempInsuranceFilePath + " sang " + finalInsuranceFilePath);
            }
            LOGGER.info("Files moved to: " + finalBusinessFilePath + ", " + finalFloorPlanFilePath + ", " + finalInsuranceFilePath);
        } catch (IOException e) {
            LOGGER.log(Level.SEVERE, "Error moving files: " + e.getMessage(), e);
            tempBusinessFile.delete();
            tempFloorPlanFile.delete();
            tempInsuranceFile.delete();
            session.invalidate();
            request.setAttribute("error", "Lỗi di chuyển file: " + e.getMessage());
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
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

            if (!dao.saveStorageUnit(storageUnit, userId)) {
                throw new SQLException("Không thể lưu thông tin Storage Unit");
            }

            conn.commit();
            session.invalidate();
            request.setAttribute("success", "Xác nhận tài khoản thành công! Vui lòng chờ admin duyệt.");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
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
            finalBusinessFile.delete();
            finalFloorPlanFile.delete();
            finalInsuranceFile.delete();
            session.invalidate();
            request.setAttribute("error", "Đăng ký thất bại: " + (e.getSQLState().equals("23000") ? "Tên kho bãi đã được sử dụng" : e.getMessage()));
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
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
        StorageUnit storageUnit = (StorageUnit) session.getAttribute("pendingStorageUnit");
        String tempBusinessFilePath = (String) session.getAttribute("tempBusinessFilePath");
        String tempFloorPlanFilePath = (String) session.getAttribute("tempFloorPlanFilePath");
        String tempInsuranceFilePath = (String) session.getAttribute("tempInsuranceFilePath");

        if (user == null || storageUnit == null || tempBusinessFilePath == null || tempFloorPlanFilePath == null || tempInsuranceFilePath == null) {
            if (tempBusinessFilePath != null) new File(tempBusinessFilePath).delete();
            if (tempFloorPlanFilePath != null) new File(tempFloorPlanFilePath).delete();
            if (tempInsuranceFilePath != null) new File(tempInsuranceFilePath).delete();
            session.invalidate();
            request.setAttribute("error", "Phiên đăng ký đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        Email emailUtil = new Email();
        String subject = "Xác nhận đăng ký Đơn vị Kho bãi";
        String message = buildEmailContent(storageUnit.getWarehouseName(), code);

        try {
            emailUtil.sendEmail(subject, message, user.getEmail());
            request.setAttribute("success", "Mã xác nhận đã được gửi lại!");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error resending email: " + e.getMessage(), e);
            request.setAttribute("error", "Gửi email thất bại, vui lòng thử lại");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
        }
    }

    private String buildEmailContent(String warehouseName, String code) {
        return "<!DOCTYPE html>\n"
                + "<html lang=\"vi\">\n"
                + "<head><meta charset=\"UTF-8\"><title>Mã xác nhận</title></head>\n"
                + "<body style=\"font-family: Arial; background-color: #f4f4f4; margin: 0; padding: 0;\">\n"
                + "  <table style=\"width: 100%; max-width: 600px; margin: 20px auto; background: #fff;\">\n"
                + "    <tr><td style=\"padding: 20px; background: #007bff; color: white; font-size: 20px; text-align: center;\">Xác nhận đăng ký</td></tr>\n"
                + "    <tr><td style=\"padding: 20px;\">\n"
                + "      <p>Xin chào " + warehouseName + ",</p>\n"
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
                request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error in doGet: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
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
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
        }
    }
}