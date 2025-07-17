package controller;

import com.cloudinary.Cloudinary;
import com.cloudinary.utils.ObjectUtils;
import dao.UserDAO;
import model.Users;
import model.Email;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.File;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.PasswordUtils;
import jakarta.servlet.http.Part;
import model.TransportUnit1;
import utils.DBConnection;

@WebServlet(name = "SignUpTransport", urlPatterns = {"/signup_transport"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class SignUpTransport extends HttpServlet {

    private static final int CODE_LENGTH = 6;
    private static final long CODE_EXPIRY_MS = 10 * 60 * 1000;
    private static final Logger LOGGER = Logger.getLogger(SignUpTransport.class.getName());
    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        try {
            cloudinary = new Cloudinary(ObjectUtils.asMap(
                "cloud_name", "dnqm0cyxh",
                "secure", true
            ));
            LOGGER.info("Khởi tạo Cloudinary thành công với cloud_name: dnqm0cyxh");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khởi tạo Cloudinary: " + e.getMessage(), e);
            throw new ServletException("Không thể khởi tạo Cloudinary", e);
        }
    }

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
        Part businessCertificatePart = request.getPart("business_certificate");
        Part insurancePart = request.getPart("insurance");

        Email emailUtil = new Email();
        LOGGER.info("Bắt đầu xử lý đăng ký với companyName: " + companyName + ", email: " + email);

        // Validate inputs
        if (!emailUtil.isValidEmail(email)) {
            LOGGER.warning("Email không hợp lệ: " + email);
            request.setAttribute("error", "Email không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (companyName == null || companyName.trim().length() < 3 || companyName.length() > 150) {
            LOGGER.warning("Tên công ty không hợp lệ: " + companyName);
            request.setAttribute("error", "Tên công ty phải từ 3 đến 150 ký tự");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (contactInfo != null && (contactInfo.length() < 5 || contactInfo.length() > 255)) {
            LOGGER.warning("Thông tin liên hệ không hợp lệ: " + contactInfo);
            request.setAttribute("error", "Thông tin liên hệ không hợp lệ (5-255 ký tự)");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (location != null && (location.length() < 5 || location.length() > 100)) {
            LOGGER.warning("Địa chỉ không hợp lệ: " + location);
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
                LOGGER.warning("Số lượng xe, tải trọng hoặc nhân viên không hợp lệ: vehicleCount=" + vehicleCountStr + ", capacity=" + capacityStr + ", loader=" + loaderStr);
                request.setAttribute("error", "Số lượng xe, tải trọng hoặc nhân viên không hợp lệ");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Số lượng xe, tải trọng hoặc nhân viên không hợp lệ: vehicleCount=" + vehicleCountStr + ", capacity=" + capacityStr + ", loader=" + loaderStr);
            request.setAttribute("error", "Số lượng xe, tải trọng hoặc nhân viên không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (password == null || password.length() < 6) {
            LOGGER.warning("Mật khẩu không hợp lệ: dài dưới 6 ký tự");
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (businessCertificatePart == null || businessCertificatePart.getSize() == 0) {
            LOGGER.warning("Không có file giấy phép kinh doanh");
            request.setAttribute("error", "Vui lòng chọn file giấy phép kinh doanh");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        String businessFileName = businessCertificatePart.getSubmittedFileName();
        if (!businessFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            LOGGER.warning("File giấy phép kinh doanh không đúng định dạng: " + businessFileName);
            request.setAttribute("error", "File giấy phép phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (businessCertificatePart.getSize() > 5 * 1024 * 1024) {
            LOGGER.warning("File giấy phép kinh doanh quá lớn: " + businessCertificatePart.getSize() + " bytes");
            request.setAttribute("error", "File giấy phép kinh doanh vượt quá 5MB");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (insurancePart == null || insurancePart.getSize() == 0) {
            LOGGER.warning("Không có file giấy tờ bảo hiểm");
            request.setAttribute("error", "Vui lòng chọn file giấy tờ bảo hiểm");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        String insuranceFileName = insurancePart.getSubmittedFileName();
        if (!insuranceFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            LOGGER.warning("File giấy tờ bảo hiểm không đúng định dạng: " + insuranceFileName);
            request.setAttribute("error", "File giấy tờ bảo hiểm phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }
        if (insurancePart.getSize() > 5 * 1024 * 1024) {
            LOGGER.warning("File giấy tờ bảo hiểm quá lớn: " + insurancePart.getSize() + " bytes");
            request.setAttribute("error", "File giấy tờ bảo hiểm vượt quá 5MB");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        UserDAO dao = UserDAO.INSTANCE;
        try {
            LOGGER.info("Kiểm tra trùng lặp email và companyName...");
            String duplicate = dao.checkDuplicate(email, companyName, 4);
            if ("email_exists".equals(duplicate)) {
                LOGGER.warning("Email đã được sử dụng: " + email);
                request.setAttribute("error", "Email đã được sử dụng cho vai trò vận chuyển");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
            if ("username_exists".equals(duplicate)) {
                LOGGER.warning("Tên công ty đã được sử dụng: " + companyName);
                request.setAttribute("error", "Tên công ty đã được sử dụng");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
            LOGGER.info("Kiểm tra trùng lặp thành công");
        } catch (RuntimeException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kiểm tra trùng lặp: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi kiểm tra trùng lặp: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        // Lưu file tạm thời và tải lên Cloudinary
        String businessCertificateUrl, insuranceUrl;
        try {
            // Tạo thư mục tạm thời
            LOGGER.info("Kiểm tra thư mục tạm...");
            String tempPath = getServletContext().getRealPath("/temp");
            LOGGER.info("Đường dẫn thư mục tạm: " + tempPath);
            File tempDir = new File(tempPath);
            if (!tempDir.exists()) {
                LOGGER.info("Thư mục tạm không tồn tại, đang tạo: " + tempPath);
                if (!tempDir.mkdirs()) {
                    LOGGER.severe("Không thể tạo thư mục tạm: " + tempPath);
                    request.setAttribute("error", "Lỗi hệ thống: Không thể tạo thư mục tạm");
                    request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                    return;
                }
                LOGGER.info("Tạo thư mục tạm thành công: " + tempPath);
            }
            if (!tempDir.canWrite()) {
                LOGGER.severe("Thư mục tạm không thể ghi: " + tempPath);
                request.setAttribute("error", "Lỗi hệ thống: Thư mục tạm không thể ghi");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }
            LOGGER.info("Thư mục tạm sẵn sàng: " + tempPath);

            // Tạo tên file tạm thời
            String tempBusinessFileName = "temp_business_certificate_" + System.currentTimeMillis() + "_" + businessFileName;
            String tempBusinessFilePath = tempPath + File.separator + tempBusinessFileName;
            String tempInsuranceFileName = "temp_insurance_" + System.currentTimeMillis() + "_" + insuranceFileName;
            String tempInsuranceFilePath = tempPath + File.separator + tempInsuranceFileName;

            // Lưu file tạm thời và kiểm tra
            File businessFile = new File(tempBusinessFilePath);
            File insuranceFile = new File(tempInsuranceFilePath);
            try {
                LOGGER.info("Lưu file tạm: " + tempBusinessFilePath + ", " + tempInsuranceFilePath);
                businessCertificatePart.write(tempBusinessFilePath);
                insurancePart.write(tempInsuranceFilePath);

                // Kiểm tra xem file có được lưu thành công không
                if (!businessFile.exists() || businessFile.length() == 0) {
                    throw new IOException("Không thể lưu file giấy phép kinh doanh: " + tempBusinessFilePath);
                }
                if (!insuranceFile.exists() || insuranceFile.length() == 0) {
                    throw new IOException("Không thể lưu file giấy tờ bảo hiểm: " + tempInsuranceFilePath);
                }
                LOGGER.info("Lưu file tạm thành công: " + tempBusinessFilePath + ", " + tempInsuranceFilePath);
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Lỗi lưu file tạm: " + e.getMessage(), e);
                request.setAttribute("error", "Lỗi lưu file tạm: " + e.getMessage());
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }

            // Cloudinary sử dụng upload_preset unsigned
            try {
                LOGGER.info("Bắt đầu tải file lên Cloudinary với upload_preset: upload-image123");
                Map<String, Object> businessUploadResult = cloudinary.uploader().unsignedUpload(businessFile, "upload-image123",
                        ObjectUtils.asMap(
                            "public_id", "business_certificate_" + companyName + "_" + System.currentTimeMillis(),
                            "resource_type", "image",
                            "folder", "upldemo"
                        ));
                LOGGER.info("Phản hồi từ Cloudinary (business_certificate): " + businessUploadResult);
                businessCertificateUrl = (String) businessUploadResult.get("secure_url");
                if (businessCertificateUrl == null || businessCertificateUrl.isEmpty()) {
                    LOGGER.severe("Không nhận được secure_url từ Cloudinary cho giấy phép kinh doanh");
                    throw new IOException("Không nhận được URL từ Cloudinary cho giấy phép kinh doanh");
                }
                LOGGER.info("Tải giấy phép kinh doanh thành công: " + businessCertificateUrl);

                Map<String, Object> insuranceUploadResult = cloudinary.uploader().unsignedUpload(insuranceFile, "upload-image123",
                        ObjectUtils.asMap(
                            "public_id", "insurance_" + companyName + "_" + System.currentTimeMillis(),
                            "resource_type", "image",
                            "folder", "upldemo"
                        ));
                LOGGER.info("Phản hồi từ Cloudinary (insurance): " + insuranceUploadResult);
                insuranceUrl = (String) insuranceUploadResult.get("secure_url");
                if (insuranceUrl == null || insuranceUrl.isEmpty()) {
                    LOGGER.severe("Không nhận được secure_url từ Cloudinary cho giấy tờ bảo hiểm");
                    throw new IOException("Không nhận được URL từ Cloudinary cho giấy tờ bảo hiểm");
                }
                LOGGER.info("Tải giấy tờ bảo hiểm thành công: " + insuranceUrl);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi tải file lên Cloudinary: " + e.getMessage(), e);
                request.setAttribute("error", "Lỗi tải file lên Cloudinary: " + e.getMessage());
                if (businessFile.exists() && !businessFile.delete()) {
                    LOGGER.warning("Không thể xóa file tạm: " + tempBusinessFilePath);
                }
                if (insuranceFile.exists() && !insuranceFile.delete()) {
                    LOGGER.warning("Không thể xóa file tạm: " + tempInsuranceFilePath);
                }
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
                return;
            }

            // Xóa file tạm thời
            if (businessFile.exists() && !businessFile.delete()) {
                LOGGER.warning("Không thể xóa file tạm: " + tempBusinessFilePath);
            }
            if (insuranceFile.exists() && !insuranceFile.delete()) {
                LOGGER.warning("Không thể xóa file tạm: " + tempInsuranceFilePath);
            }
            LOGGER.info("Xóa file tạm thành công");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi xử lý tải ảnh: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi xử lý tải ảnh: " + e.getMessage());
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

        TransportUnit1 transportUnit = new TransportUnit1();
        transportUnit.setCompanyName(companyName);
        transportUnit.setContactInfo(contactInfo);
        transportUnit.setBusinessCertificate(businessCertificateUrl);
        transportUnit.setInsurance(insuranceUrl);
        transportUnit.setLocation(location);
        transportUnit.setVehicleCount(vehicleCount);
        transportUnit.setCapacity(capacity);
        transportUnit.setLoader(loader);
        transportUnit.setRegistrationStatus("pending");

        // Lưu thông tin vào session
        LOGGER.info("Lưu thông tin vào session...");
        session.setAttribute("pendingUser", user);
        session.setAttribute("pendingTransportUnit", transportUnit);
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        String subject = "Xác nhận đăng ký Đơn vị Vận chuyển";
        String message = buildEmailContent(companyName, code);

        try {
            LOGGER.info("Gửi email xác nhận đến: " + email);
            emailUtil.sendEmail(subject, message, email);
            LOGGER.info("Chuyển hướng đến trang xác nhận");
            response.sendRedirect(request.getContextPath() + "/signup_transport?action=confirm");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi email: " + e.getMessage(), e);
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
        TransportUnit1 transportUnit = (TransportUnit1) session.getAttribute("pendingTransportUnit");

        if (storedCode == null || expiryTime == null || user == null || transportUnit == null) {
            LOGGER.warning("Phiên xác nhận đã hết hạn");
            session.invalidate();
            request.setAttribute("error", "Phiên xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            LOGGER.warning("Mã xác nhận đã hết hạn");
            session.invalidate();
            request.setAttribute("error", "Mã xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        if (!storedCode.equals(inputCode)) {
            LOGGER.warning("Mã xác nhận không đúng: " + inputCode);
            request.setAttribute("error", "Mã xác nhận không đúng");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            return;
        }

        // Lưu dữ liệu vào cơ sở dữ liệu
        UserDAO dao = UserDAO.INSTANCE;
        Connection conn = null;
        int userId = 0;
        try {
            LOGGER.info("Kết nối cơ sở dữ liệu...");
            conn = DBConnection.getConnection();
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu");
            }
            conn.setAutoCommit(false);

            LOGGER.info("Lưu tài khoản người dùng...");
            userId = dao.signupAccount2(user);
            if (userId == 0) {
                throw new SQLException("Không thể lưu tài khoản người dùng");
            }

            LOGGER.info("Kiểm tra TransportUnit trước khi lưu: companyName=" + transportUnit.getCompanyName() +
                        ", businessCertificate=" + transportUnit.getBusinessCertificate() +
                        ", insurance=" + transportUnit.getInsurance());
            if (!dao.saveTransportUnit(transportUnit, userId)) {
                throw new SQLException("Không thể lưu thông tin Transport Unit");
            }

            conn.commit();
            LOGGER.info("Lưu dữ liệu thành công, userId: " + userId);
            session.invalidate();
            request.setAttribute("success", "Xác nhận tài khoản thành công! Vui lòng chờ admin duyệt.");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi SQLException trong quá trình xác nhận: Message=" + e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                    if (userId != 0) {
                        dao.deleteUser(userId);
                    }
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi rollback giao dịch: " + ex.getMessage(), ex);
                }
            }
            session.invalidate();
            request.setAttribute("error", "Đăng ký thất bại: " + e.getMessage());
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Lỗi dữ liệu không hợp lệ trong TransportUnit: " + e.getMessage(), e);
            if (conn != null) {
                try {
                    conn.rollback();
                    if (userId != 0) {
                        dao.deleteUser(userId);
                    }
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi rollback giao dịch: " + ex.getMessage(), ex);
                }
            }
            session.invalidate();
            request.setAttribute("error", "Đăng ký thất bại: Dữ liệu không hợp lệ - " + e.getMessage());
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                    LOGGER.info("Đóng kết nối cơ sở dữ liệu");
                } catch (SQLException ex) {
                    LOGGER.log(Level.SEVERE, "Lỗi đóng kết nối: " + ex.getMessage(), ex);
                }
            }
        }
    }

    private void handleResendCode(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("pendingUser");
        TransportUnit1 transportUnit = (TransportUnit1) session.getAttribute("pendingTransportUnit");

        if (user == null || transportUnit == null) {
            LOGGER.warning("Phiên đăng ký đã hết hạn");
            session.invalidate();
            request.setAttribute("error", "Phiên đăng ký đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            return;
        }

        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);
        LOGGER.info("Tạo mã xác nhận mới: " + code);

        Email emailUtil = new Email();
        String subject = "Xác nhận đăng ký Đơn vị Vận chuyển";
        String message = buildEmailContent(transportUnit.getCompanyName(), code);

        try {
            LOGGER.info("Gửi lại email xác nhận đến: " + user.getEmail());
            emailUtil.sendEmail(subject, message, user.getEmail());
            request.setAttribute("success", "Mã xác nhận đã được gửi lại!");
            request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi lại email: " + e.getMessage(), e);
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
            LOGGER.info("Xử lý yêu cầu GET...");
            String action = request.getParameter("action");
            if ("confirm".equals(action)) {
                LOGGER.info("Chuyển hướng đến trang xác nhận");
                request.getRequestDispatcher("/page/login/confirm_transport.jsp").forward(request, response);
            } else {
                LOGGER.info("Chuyển hướng đến trang đăng ký");
                request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Lỗi trong doGet: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            LOGGER.info("Xử lý yêu cầu POST...");
            processRequest(request, response);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Lỗi trong doPost: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup_transport.jsp").forward(request, response);
        }
    }
}