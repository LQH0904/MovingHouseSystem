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
import model.StorageUnit1;
import utils.DBConnection;

@WebServlet(name = "SignUpStorage", urlPatterns = {"/signup_storage"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 1024 * 1024 * 5, maxRequestSize = 1024 * 1024 * 5 * 5)
public class SignUpStorage extends HttpServlet {

    private static final int CODE_LENGTH = 6;
    private static final long CODE_EXPIRY_MS = 10 * 60 * 1000;
    private static final Logger LOGGER = Logger.getLogger(SignUpStorage.class.getName());
    private Cloudinary cloudinary;

    @Override
    public void init() throws ServletException {
        // Khởi tạo Cloudinary với cloud_name cho unsigned preset
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
        LOGGER.info("Bắt đầu xử lý đăng ký với warehouseName: " + warehouseName + ", email: " + email);

        // Xác thực đầu vào
        if (!emailUtil.isValidEmail(email)) {
            LOGGER.warning("Email không hợp lệ: " + email);
            request.setAttribute("error", "Email không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (warehouseName == null || warehouseName.trim().length() < 3 || warehouseName.length() > 150) {
            LOGGER.warning("Tên kho bãi không hợp lệ: " + warehouseName);
            request.setAttribute("error", "Tên kho bãi phải từ 3 đến 150 ký tự");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (phoneNumber == null || !phoneNumber.matches("^[0-9]{10,15}$")) {
            LOGGER.warning("Số điện thoại không hợp lệ: " + phoneNumber);
            request.setAttribute("error", "Số điện thoại không hợp lệ (10-15 chữ số)");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (location != null && (location.length() < 5 || location.length() > 255)) {
            LOGGER.warning("Địa điểm không hợp lệ: " + location);
            request.setAttribute("error", "Địa điểm phải từ 5 đến 255 ký tự");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (area != null && (area.length() > 200 || !area.matches("^\\d+(\\.\\d{1,2})?$"))) {
            LOGGER.warning("Diện tích không hợp lệ: " + area);
            request.setAttribute("error", "Diện tích không hợp lệ (tối đa 200 ký tự, định dạng số với tối đa 2 chữ số thập phân)");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        int employee;
        try {
            employee = Integer.parseInt(employeeStr);
            if (employee < 0) {
                LOGGER.warning("Số nhân viên không hợp lệ: " + employeeStr);
                request.setAttribute("error", "Số nhân viên không hợp lệ");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Số nhân viên không hợp lệ: " + employeeStr);
            request.setAttribute("error", "Số nhân viên không hợp lệ");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (password == null || password.length() < 6) {
            LOGGER.warning("Mật khẩu không hợp lệ: dài dưới 6 ký tự");
            request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (businessCertificatePart == null || businessCertificatePart.getSize() == 0) {
            LOGGER.warning("Không có file giấy phép kinh doanh");
            request.setAttribute("error", "Vui lòng chọn file giấy phép kinh doanh");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String businessFileName = businessCertificatePart.getSubmittedFileName();
        if (!businessFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            LOGGER.warning("File giấy phép kinh doanh không đúng định dạng: " + businessFileName);
            request.setAttribute("error", "File giấy phép phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (floorPlanPart == null || floorPlanPart.getSize() == 0) {
            LOGGER.warning("Không có file mặt bằng kho");
            request.setAttribute("error", "Vui lòng chọn file ảnh mặt bằng kho");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String floorPlanFileName = floorPlanPart.getSubmittedFileName();
        if (!floorPlanFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            LOGGER.warning("File mặt bằng kho không đúng định dạng: " + floorPlanFileName);
            request.setAttribute("error", "File mặt bằng kho phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        if (insurancePart == null || insurancePart.getSize() == 0) {
            LOGGER.warning("Không có file giấy tờ bảo hiểm");
            request.setAttribute("error", "Vui lòng chọn file giấy tờ bảo hiểm");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }
        String insuranceFileName = insurancePart.getSubmittedFileName();
        if (!insuranceFileName.matches(".*\\.(jpg|jpeg|png)$")) {
            LOGGER.warning("File giấy tờ bảo hiểm không đúng định dạng: " + insuranceFileName);
            request.setAttribute("error", "File giấy tờ bảo hiểm phải có định dạng .jpg, .jpeg hoặc .png");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        UserDAO dao = UserDAO.INSTANCE;
        try {
            LOGGER.info("Kiểm tra trùng lặp email và warehouseName...");
            String duplicate = dao.checkDuplicate(email, warehouseName, 5);
            if ("email_exists".equals(duplicate)) {
                LOGGER.warning("Email đã được sử dụng: " + email);
                request.setAttribute("error", "Email đã được sử dụng cho vai trò kho bãi");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
            if ("username_exists".equals(duplicate)) {
                LOGGER.warning("Tên kho bãi đã được sử dụng: " + warehouseName);
                request.setAttribute("error", "Tên kho bãi đã được sử dụng");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
            LOGGER.info("Kiểm tra trùng lặp thành công");
        } catch (RuntimeException e) {
            LOGGER.log(Level.SEVERE, "Lỗi kiểm tra trùng lặp: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi kiểm tra trùng lặp: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        // Tải file lên Cloudinary
        String businessCertificateUrl, floorPlanUrl, insuranceUrl;
        try {
            // Tạo thư mục tạm thời
            LOGGER.info("Kiểm tra thư mục tạm...");
            String tempPath = getServletContext().getRealPath("/temp");
            File tempDir = new File(tempPath);
            if (!tempDir.exists()) {
                LOGGER.info("Thư mục tạm không tồn tại, đang tạo: " + tempPath);
                if (!tempDir.mkdirs()) {
                    LOGGER.severe("Không thể tạo thư mục tạm: " + tempPath);
                    request.setAttribute("error", "Lỗi hệ thống: Không thể tạo thư mục tạm");
                    request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                    return;
                }
                LOGGER.info("Tạo thư mục tạm thành công: " + tempPath);
            }
            if (!tempDir.canWrite()) {
                LOGGER.severe("Thư mục tạm không thể ghi: " + tempPath);
                request.setAttribute("error", "Lỗi hệ thống: Thư mục tạm không thể ghi");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }
            LOGGER.info("Thư mục tạm sẵn sàng: " + tempPath);

            // Tạo tên file tạm thời
            String tempBusinessFileName = "temp_business_certificate_" + System.currentTimeMillis() + "_" + businessFileName;
            String tempBusinessFilePath = tempPath + File.separator + tempBusinessFileName;
            String tempFloorPlanFileName = "temp_floor_plan_" + System.currentTimeMillis() + "_" + floorPlanFileName;
            String tempFloorPlanFilePath = tempPath + File.separator + tempFloorPlanFileName;
            String tempInsuranceFileName = "temp_insurance_" + System.currentTimeMillis() + "_" + insuranceFileName;
            String tempInsuranceFilePath = tempPath + File.separator + tempInsuranceFileName;

            // Lưu file tạm thời và kiểm tra
            File businessFile = new File(tempBusinessFilePath);
            File floorPlanFile = new File(tempFloorPlanFilePath);
            File insuranceFile = new File(tempInsuranceFilePath);
            try {
                LOGGER.info("Lưu file tạm: " + tempBusinessFilePath + ", " + tempFloorPlanFilePath + ", " + tempInsuranceFilePath);
                businessCertificatePart.write(tempBusinessFilePath);
                floorPlanPart.write(tempFloorPlanFilePath);
                insurancePart.write(tempInsuranceFilePath);

                // Kiểm tra xem file có được lưu thành công không
                if (!businessFile.exists() || businessFile.length() == 0) {
                    throw new IOException("Không thể lưu file giấy phép kinh doanh: " + tempBusinessFilePath);
                }
                if (!floorPlanFile.exists() || floorPlanFile.length() == 0) {
                    throw new IOException("Không thể lưu file mặt bằng kho: " + tempFloorPlanFilePath);
                }
                if (!insuranceFile.exists() || insuranceFile.length() == 0) {
                    throw new IOException("Không thể lưu file giấy tờ bảo hiểm: " + tempInsuranceFilePath);
                }
                LOGGER.info("Lưu file tạm thành công: " + tempBusinessFilePath + ", " + tempFloorPlanFilePath + ", " + tempInsuranceFilePath);
            } catch (IOException e) {
                LOGGER.log(Level.SEVERE, "Lỗi lưu file tạm: " + e.getMessage(), e);
                request.setAttribute("error", "Lỗi lưu file tạm: " + e.getMessage());
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }

            //  Cloudinary sử dụng upload_preset unsigned
            try {
                LOGGER.info("Bắt đầu tải file lên Cloudinary với upload_preset: upload-image123");
                Map<String, Object> businessUploadResult = cloudinary.uploader().unsignedUpload(businessFile, "upload-image123",
                        ObjectUtils.asMap(
                                "public_id", "business_certificate_" + warehouseName + "_" + System.currentTimeMillis(),
                                "resource_type", "image",
                                "folder", "upldemo"
                        ));
                businessCertificateUrl = (String) businessUploadResult.get("secure_url");
                if (businessCertificateUrl == null || businessCertificateUrl.isEmpty()) {
                    LOGGER.severe("Không nhận được secure_url từ Cloudinary cho giấy phép kinh doanh");
                    throw new IOException("Không nhận được URL từ Cloudinary cho giấy phép kinh doanh");
                }
                LOGGER.info("Tải giấy phép kinh doanh thành công: " + businessCertificateUrl);

                Map<String, Object> floorPlanUploadResult = cloudinary.uploader().unsignedUpload(floorPlanFile, "upload-image123",
                        ObjectUtils.asMap(
                                "public_id", "floor_plan_" + warehouseName + "_" + System.currentTimeMillis(),
                                "resource_type", "image",
                                "folder", "upldemo"
                        ));
                floorPlanUrl = (String) floorPlanUploadResult.get("secure_url");
                if (floorPlanUrl == null || floorPlanUrl.isEmpty()) {
                    LOGGER.severe("Không nhận được secure_url từ Cloudinary cho mặt bằng kho");
                    throw new IOException("Không nhận được URL từ Cloudinary cho mặt bằng kho");
                }
                LOGGER.info("Tải mặt bằng kho thành công: " + floorPlanUrl);

                Map<String, Object> insuranceUploadResult = cloudinary.uploader().unsignedUpload(insuranceFile, "upload-image123",
                        ObjectUtils.asMap(
                                "public_id", "insurance_" + warehouseName + "_" + System.currentTimeMillis(),
                                "resource_type", "image",
                                "folder", "upldemo"
                        ));
                insuranceUrl = (String) insuranceUploadResult.get("secure_url");
                if (insuranceUrl == null || insuranceUrl.isEmpty()) {
                    LOGGER.severe("Không nhận được secure_url từ Cloudinary cho giấy tờ bảo hiểm");
                    throw new IOException("Không nhận được URL từ Cloudinary cho giấy tờ bảo hiểm");
                }
                LOGGER.info("Tải giấy tờ bảo hiểm thành công: " + insuranceUrl);
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Lỗi tải file lên Cloudinary: " + e.getMessage(), e);
                request.setAttribute("error", "Lỗi tải file lên Cloudinary: " + e.getMessage());
                // Xóa file tạm trước khi trả về lỗi
                if (businessFile.exists() && !businessFile.delete()) {
                    LOGGER.warning("Không thể xóa file tạm: " + tempBusinessFilePath);
                }
                if (floorPlanFile.exists() && !floorPlanFile.delete()) {
                    LOGGER.warning("Không thể xóa file tạm: " + tempFloorPlanFilePath);
                }
                if (insuranceFile.exists() && !insuranceFile.delete()) {
                    LOGGER.warning("Không thể xóa file tạm: " + tempInsuranceFilePath);
                }
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
                return;
            }

            // Xóa file tạm thời
            if (businessFile.exists() && !businessFile.delete()) {
                LOGGER.warning("Không thể xóa file tạm: " + tempBusinessFilePath);
            }
            if (floorPlanFile.exists() && !floorPlanFile.delete()) {
                LOGGER.warning("Không thể xóa file tạm: " + tempFloorPlanFilePath);
            }
            if (insuranceFile.exists() && !insuranceFile.delete()) {
                LOGGER.warning("Không thể xóa file tạm: " + tempInsuranceFilePath);
            }
            LOGGER.info("Xóa file tạm thành công");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi xử lý tải ảnh: " + e.getMessage(), e);
            request.setAttribute("error", "Lỗi xử lý tải ảnh: " + e.getMessage());
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        // Tạo đối tượng Users và StorageUnit
        LOGGER.info("Tạo đối tượng Users và StorageUnit...");
        String hashedPassword = PasswordUtils.hashPassword(password);
        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;

        Users user = new Users();
        user.setUsername(warehouseName);
        user.setEmail(email);
        user.setPasswordHash(hashedPassword);
        user.setRoleId(5);
        user.setStatus("pending");

        StorageUnit1 storageUnit = new StorageUnit1();
        storageUnit.setWarehouseName(warehouseName);
        storageUnit.setPhoneNumber(phoneNumber);
        storageUnit.setBusinessCertificate(businessCertificateUrl);
        storageUnit.setFloorPlan(floorPlanUrl);
        storageUnit.setInsurance(insuranceUrl);
        storageUnit.setLocation(location);
        storageUnit.setArea(area);
        storageUnit.setEmployee(employee);
        storageUnit.setRegistrationStatus("pending");

        // Lưu vào session
        LOGGER.info("Lưu thông tin vào session...");
        session.setAttribute("pendingUser", user);
        session.setAttribute("pendingStorageUnit", storageUnit);
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);

        String subject = "Xác nhận đăng ký Đơn vị Kho bãi";
        String message = buildEmailContent(warehouseName, code);

        try {
            LOGGER.info("Gửi email xác nhận đến: " + email);
            emailUtil.sendEmail(subject, message, email);
            LOGGER.info("Chuyển hướng đến trang xác nhận");
            response.sendRedirect(request.getContextPath() + "/signup_storage?action=confirm");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi email: " + e.getMessage(), e);
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
        StorageUnit1 storageUnit = (StorageUnit1) session.getAttribute("pendingStorageUnit");

        if (storedCode == null || expiryTime == null || user == null || storageUnit == null) {
            LOGGER.warning("Phiên xác nhận đã hết hạn");
            session.invalidate();
            request.setAttribute("error", "Phiên xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            return;
        }

        if (System.currentTimeMillis() > expiryTime) {
            LOGGER.warning("Mã xác nhận đã hết hạn");
            session.invalidate();
            request.setAttribute("error", "Mã xác nhận đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            return;
        }

        if (!storedCode.equals(inputCode)) {
            LOGGER.warning("Mã xác nhận không đúng: " + inputCode);
            request.setAttribute("error", "Mã xác nhận không đúng");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            return;
        }

        // Lưu vào cơ sở dữ liệu
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

            LOGGER.info("Kiểm tra StorageUnit trước khi lưu: warehouseName=" + storageUnit.getWarehouseName()
                    + ", businessCertificate=" + storageUnit.getBusinessCertificate()
                    + ", floorPlan=" + storageUnit.getFloorPlan()
                    + ", insurance=" + storageUnit.getInsurance());
            if (!dao.saveStorageUnit(storageUnit, userId)) {
                throw new SQLException("Không thể lưu thông tin Storage Unit");
            }

            conn.commit();
            LOGGER.info("Lưu dữ liệu thành công, userId: " + userId);
            session.invalidate();
            request.setAttribute("success", "Xác nhận tài khoản thành công! Vui lòng chờ admin duyệt.");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
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
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Lỗi dữ liệu không hợp lệ trong StorageUnit: " + e.getMessage(), e);
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
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
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
        StorageUnit1 storageUnit = (StorageUnit1) session.getAttribute("pendingStorageUnit");

        if (user == null || storageUnit == null) {
            LOGGER.warning("Phiên đăng ký đã hết hạn");
            session.invalidate();
            request.setAttribute("error", "Phiên đăng ký đã hết hạn, vui lòng đăng ký lại");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            return;
        }

        String code = generateVerificationCode();
        long expiryTime = System.currentTimeMillis() + CODE_EXPIRY_MS;
        session.setAttribute("verificationCode", code);
        session.setAttribute("codeExpiry", expiryTime);
        LOGGER.info("Tạo mã xác nhận mới: " + code);

        Email emailUtil = new Email();
        String subject = "Xác nhận đăng ký Đơn vị Kho bãi";
        String message = buildEmailContent(storageUnit.getWarehouseName(), code);

        try {
            LOGGER.info("Gửi lại email xác nhận đến: " + user.getEmail());
            emailUtil.sendEmail(subject, message, user.getEmail());
            request.setAttribute("success", "Mã xác nhận đã được gửi lại!");
            request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi gửi lại email: " + e.getMessage(), e);
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
                LOGGER.info("Chuyển hướng đến trang xác nhận");
                request.getRequestDispatcher("/page/login/confirm_storage.jsp").forward(request, response);
            } else {
                LOGGER.info("Chuyển hướng đến trang đăng ký");
                request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Lỗi trong doGet: " + ex.getMessage(), ex);
            request.setAttribute("error", "Lỗi hệ thống");
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
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
            request.getRequestDispatcher("/page/login/signup_storage.jsp").forward(request, response);
        }
    }
}
