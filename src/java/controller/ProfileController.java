package controller;

import dao.UserProfileDAO;
import model.UserProfile;
import java.io.IOException;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;

@WebServlet(name = "ProfileController", urlPatterns = {"/profile"})
public class ProfileController extends HttpServlet {

    private UserProfileDAO profileDAO;
    private boolean complete = false;

    @Override
    public void init() throws ServletException {
        super.init();
        profileDAO = new UserProfileDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("acc");
        if (user == null) {
            response.sendRedirect("/HouseMovingSystem/login");
            return;
        }

        UserProfile profile = profileDAO.getUserProfileByUserId(user.getUserId());
        request.setAttribute("profile", profile);

        if (request.getParameter("action") != null && !complete) {
            request.getRequestDispatcher("page/staff/update-info.jsp").forward(request, response);
            return;
        }
        complete = false;
        request.getRequestDispatcher("page/staff/profile.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("acc");

        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");

        if ("updateBasicInfo".equals(action)) {
            updateBasicInfo(request, response, user.getUserId());
        } else if ("updatePassword".equals(action)) {
            updatePassword(request, response, user.getUserId());
        } else if ("updateTheme".equals(action)) {
            updateTheme(request, response, user.getUserId());
        } else if ("updateAvatar".equals(action)) {
            updateAvatar(request, response, user.getUserId());
        }
    }

    private void updateBasicInfo(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        // Lấy thông tin từ form
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String dateOfBirthStr = request.getParameter("dateOfBirth");
        String gender = request.getParameter("gender");
        String country = request.getParameter("country");
        String city = request.getParameter("city");
        String district = request.getParameter("district");
        String street = request.getParameter("street");
        String postalCode = request.getParameter("postalCode");

        if (firstName == null || firstName.trim().isEmpty()
                || lastName == null || lastName.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ họ và tên");
            complete = true;
            doGet(request, response);
            return;
        }

        try {
            UserProfile profile = new UserProfile();
            UserProfile profile1 = profileDAO.getUserProfileByUserId(userId);
            profile.setUserId(userId);
            profile.setFirstName(firstName);
            profile.setLastName(lastName);
            profile.setEmail(email);
            profile.setPhoneNumber(phoneNumber);

            // Xử lý ngày sinh
            if (dateOfBirthStr != null && !dateOfBirthStr.isEmpty()) {
                profile.setDateOfBirth(java.sql.Date.valueOf(dateOfBirthStr));
            } else {
                profile.setDateOfBirth(profile1.getDateOfBirth());
            }

            profile.setGender(gender);
            profile.setCountry(country);
            profile.setCity(city);
            profile.setDistrict(district);
            profile.setStreet(street);
            profile.setPostalCode(postalCode);
            profile.setAvatarUrl(profile1.getAvatarUrl());
            profile.setCustomThemeColor(profile1.getCustomThemeColor());
            profile.setFacebookLink(profile1.getFacebookLink());
            profile.setGoogleLink(profile1.getGoogleLink());
            profile.setLanguagePreference(profile1.getLanguagePreference());
            profile.setNewPasswordHash(profile1.getNewPasswordHash());
            profile.setOldPasswordHash(profile1.getOldPasswordHash());
            profile.setTwitterLink(profile1.getTwitterLink());
            profile.setThemePreference(profile1.getThemePreference());
            profile.setUpdatedAt(new Date());

            boolean success = profileDAO.updateUserProfile(profile);

            if (success) {
                request.setAttribute("successMessage", "Cập nhật thông tin thành công!");
                // Cập nhật lại thông tin profile trong session nếu cần
                UserProfile updatedProfile = profileDAO.getUserProfileByUserId(userId);
                request.setAttribute("profile", updatedProfile);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        complete = true;
        doGet(request, response);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        // Kiểm tra validation
        if (oldPassword == null || oldPassword.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ mật khẩu cũ và mật khẩu mới");
            complete = true;
            doGet(request, response);
            return;
        }

        boolean success = profileDAO.updateUserPassword(userId, oldPassword, newPassword);

        if (success) {
            request.setAttribute("successMessage", "Cập nhật mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Mật khẩu cũ không đúng hoặc có lỗi khi cập nhật.");
        }
        complete = true;
        doGet(request, response);
    }

    private void updateTheme(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String theme = request.getParameter("theme");
        String language = request.getParameter("language");
        String customColor = request.getParameter("customColor");

        try {
            UserProfile profile = new UserProfile();
            profile.setUserId(userId);
            profile.setThemePreference(theme);
            profile.setLanguagePreference(language);
            profile.setCustomThemeColor(customColor);
            profile.setUpdatedAt(new Date());

            boolean success = profileDAO.updateUserProfile(profile);

            if (success) {
                request.setAttribute("successMessage", "Cập nhật giao diện thành công!");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật giao diện");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        doGet(request, response);
    }

    private void updateAvatar(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        // In a real app, you would handle file upload here
        String avatarUrl = request.getParameter("avatarUrl");

        // Kiểm tra validation
        if (avatarUrl == null || avatarUrl.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ảnh đại diện");
            complete = true;
            doGet(request, response);
            return;
        }

        try {
            UserProfile profile = new UserProfile();
            profile.setUserId(userId);
            profile.setAvatarUrl(avatarUrl);
            profile.setUpdatedAt(new Date());

            boolean success = profileDAO.updateUserProfile(profile);

            if (success) {
                request.setAttribute("successMessage", "Cập nhật ảnh đại diện thành công!");
                // Cập nhật lại thông tin profile trong session nếu cần
                UserProfile updatedProfile = profileDAO.getUserProfileByUserId(userId);
                request.setAttribute("profile", updatedProfile);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi cập nhật ảnh đại diện");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
        }

        doGet(request, response);
    }
}
