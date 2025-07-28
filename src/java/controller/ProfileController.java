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

        UserProfile profile = new UserProfile();
        UserProfile profile1 = profileDAO.getUserProfileByUserId(userId);
        profile.setUserId(userId);
        profile.setFirstName(request.getParameter("firstName"));
        profile.setLastName(request.getParameter("lastName"));
        profile.setEmail(request.getParameter("email"));
        profile.setPhoneNumber(request.getParameter("phoneNumber"));
        profile.setDateOfBirth(java.sql.Date.valueOf(request.getParameter("dateOfBirth")));
        profile.setGender(request.getParameter("gender"));
        profile.setCountry(request.getParameter("country"));
        profile.setCity(request.getParameter("city"));
        profile.setDistrict(request.getParameter("district"));
        profile.setStreet(request.getParameter("street"));
        profile.setPostalCode(request.getParameter("postalCode"));
        profile.setAvatarUrl(profile1.getAvatarUrl());
        profile.setCustomThemeColor(profile1.getCustomThemeColor());
        profile.setFacebookLink(profile1.getFacebookLink());
        profile.setGoogleLink(profile.getGoogleLink());
        profile.setLanguagePreference(profile1.getLanguagePreference());
        profile.setNewPasswordHash(profile1.getNewPasswordHash());
        profile.setOldPasswordHash(profile1.getOldPasswordHash());
        profile.setTwitterLink(profile1.getTwitterLink());
        profile.setThemePreference(profile1.getThemePreference());
        profile.setUpdatedAt(new Date());

        boolean success = profileDAO.updateUserProfile(profile);

        if (success) {
            request.setAttribute("message", "Cập nhật thông tin thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật thông tin");
        }
        complete = true;

        doGet(request, response);
    }

    private void updatePassword(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");

        boolean success = profileDAO.updateUserPassword(userId, oldPassword, newPassword);

        if (success) {
            request.setAttribute("message", "Cập nhật mật khẩu thành công!");
        } else {
            request.setAttribute("error", "Mật khẩu cũ không đúng hoặc có lỗi khi cập nhật.");
        }
        complete = true;
        doGet(request, response);
    }

    private void updateTheme(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        UserProfile profile = new UserProfile();
        profile.setUserId(userId);
        profile.setThemePreference(request.getParameter("theme"));
        profile.setLanguagePreference(request.getParameter("language"));
        profile.setCustomThemeColor(request.getParameter("customColor"));
        profile.setUpdatedAt(new Date());

        boolean success = profileDAO.updateUserProfile(profile);

        if (success) {
            request.setAttribute("message", "Cập nhật giao diện thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật giao diện");
        }

        doGet(request, response);
    }

    private void updateAvatar(HttpServletRequest request, HttpServletResponse response, int userId)
            throws ServletException, IOException {

        // In a real app, you would handle file upload here
        String avatarUrl = request.getParameter("avatarUrl");

        UserProfile profile = new UserProfile();
        profile.setUserId(userId);
        profile.setAvatarUrl(avatarUrl);
        profile.setUpdatedAt(new Date());

        boolean success = profileDAO.updateUserProfile(profile);

        if (success) {
            request.setAttribute("message", "Cập nhật ảnh đại diện thành công!");
        } else {
            request.setAttribute("error", "Có lỗi xảy ra khi cập nhật ảnh đại diện");
        }

        doGet(request, response);
    }
}
