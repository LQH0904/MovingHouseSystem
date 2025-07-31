package dao;

import model.UserProfile;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.PasswordUtils;

public class UserProfileDAO {

    private Connection conn = null;
    private PreparedStatement ps = null;
    private ResultSet rs = null;

    public UserProfile getUserProfileByUserId(int userId) {
        UserProfile profile = null;
        String query = "SELECT TOP 1 * FROM UpdateProfile WHERE user_id = ? ORDER BY updated_at DESC";

        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            if (rs.next()) {
                profile = new UserProfile();
                profile.setUpdateId(rs.getInt("update_id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setFirstName(rs.getString("first_name"));
                profile.setLastName(rs.getString("last_name"));
                profile.setEmail(rs.getString("email"));
                profile.setPhoneNumber(rs.getString("phone_number"));
                profile.setDateOfBirth(rs.getDate("date_of_birth"));
                profile.setGender(rs.getString("gender"));
                profile.setCountry(rs.getString("country"));
                profile.setCity(rs.getString("city"));
                profile.setDistrict(rs.getString("district"));
                profile.setStreet(rs.getString("street"));
                profile.setPostalCode(rs.getString("postal_code"));
                profile.setAvatarUrl(rs.getString("avatar_url"));
                profile.setOldPasswordHash(rs.getString("old_password_hash"));
                profile.setNewPasswordHash(rs.getString("new_password_hash"));
                profile.setIsTwoFactorEnabled(rs.getBoolean("is_two_factor_enabled"));
                profile.setFacebookLink(rs.getString("facebook_link"));
                profile.setGoogleLink(rs.getString("google_link"));
                profile.setTwitterLink(rs.getString("twitter_link"));
                profile.setLanguagePreference(rs.getString("language_preference"));
                profile.setThemePreference(rs.getString("theme_preference"));
                profile.setCustomThemeColor(rs.getString("custom_theme_color"));
                profile.setUpdatedAt(rs.getTimestamp("updated_at"));
                profile.setIsDeleted(rs.getBoolean("is_deleted"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            closeResources();
        }
        return profile;
    }

public boolean updateUserProfile(UserProfile profile) {
    String query = "INSERT INTO UpdateProfile (user_id, first_name, last_name, email, phone_number, "
            + "date_of_birth, gender, country, city, district, street, postal_code, avatar_url, "
            + "old_password_hash, new_password_hash, is_two_factor_enabled, facebook_link, google_link, "
            + "twitter_link, language_preference, theme_preference, custom_theme_color, is_deleted, updated_at) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement(query);

        ps.setInt(1, profile.getUserId());
        ps.setString(2, profile.getFirstName());
        ps.setString(3, profile.getLastName());
        ps.setString(4, profile.getEmail());
        ps.setString(5, profile.getPhoneNumber());

        if (profile.getDateOfBirth() != null) {
            ps.setDate(6, new java.sql.Date(profile.getDateOfBirth().getTime()));
        } else {
            ps.setNull(6, java.sql.Types.DATE);
        }

        ps.setString(7, profile.getGender());
        ps.setString(8, profile.getCountry());
        ps.setString(9, profile.getCity());
        ps.setString(10, profile.getDistrict());
        ps.setString(11, profile.getStreet());
        ps.setString(12, profile.getPostalCode());
        ps.setString(13, profile.getAvatarUrl());
        ps.setString(14, profile.getOldPasswordHash());
        ps.setString(15, profile.getNewPasswordHash());

        ps.setBoolean(16, profile.getIsTwoFactorEnabled() != null ? profile.getIsTwoFactorEnabled() : false);
        ps.setString(17, profile.getFacebookLink());
        ps.setString(18, profile.getGoogleLink());
        ps.setString(19, profile.getTwitterLink());
        ps.setString(20, profile.getLanguagePreference());
        ps.setString(21, profile.getThemePreference());
        ps.setString(22, profile.getCustomThemeColor());
        ps.setBoolean(23, profile.getIsDeleted() != null ? profile.getIsDeleted() : false);
        ps.setTimestamp(24, new java.sql.Timestamp(profile.getUpdatedAt().getTime()));

        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0;
    } catch (SQLException e) {
        e.printStackTrace();
        return false;
    } finally {
        closeResources();
    }
}
public String getPasswordHashByUserId(int userId) {
    String query = "SELECT password_hash FROM users WHERE user_id = ? ";
    try {
        conn = DBConnection.getConnection();
        ps = conn.prepareStatement(query);
        ps.setInt(1, userId);
        rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getString("password_hash");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        closeResources();
    }
    return null;
}

    public static void main(String[] args) {
        UserProfileDAO aO = new UserProfileDAO();
        System.out.println(aO.updateUserPassword(52, "1234567", "123456"));
    }
public boolean updateUserPassword(int userId, String oldPassword, String newPassword) {
    String currentHash = getPasswordHashByUserId(userId);
    if (currentHash == null || !PasswordUtils.checkPassword(oldPassword, currentHash)) {
        return false; // Mật khẩu cũ không đúng
    }

    String newHashedPassword = PasswordUtils.hashPassword(newPassword); // Mã hóa mới

    Connection conn = null;
    PreparedStatement ps1 = null;
    PreparedStatement ps2 = null;

    try {
        conn = DBConnection.getConnection();
        conn.setAutoCommit(false); // Bắt đầu transaction

        // 1. UPDATE bản ghi mới nhất trong UpdateProfile
        String updateProfileQuery = 
            "UPDATE UpdateProfile SET old_password_hash = ?, new_password_hash = ?, updated_at = GETDATE() " +
            "WHERE update_id = (" +
            "   SELECT TOP 1 update_id FROM UpdateProfile WHERE user_id = ? ORDER BY updated_at DESC" +
            ")";
        ps1 = conn.prepareStatement(updateProfileQuery);
        ps1.setString(1, currentHash);
        ps1.setString(2, newHashedPassword);
        ps1.setInt(3, userId);
        ps1.executeUpdate();

        // 2. UPDATE mật khẩu trong bảng Users
        String updateUsersQuery = "UPDATE Users SET password_hash = ? WHERE user_id = ?";
        ps2 = conn.prepareStatement(updateUsersQuery);
        ps2.setString(1, newHashedPassword);
        ps2.setInt(2, userId);
        ps2.executeUpdate();

        conn.commit(); // OK
        return true;

    } catch (SQLException e) {
        e.printStackTrace();
        if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
        return false;

    } finally {
        if (ps1 != null) try { ps1.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (ps2 != null) try { ps2.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}



    private void closeResources() {
        try {
            if (rs != null) {
                rs.close();
            }
            if (ps != null) {
                ps.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
