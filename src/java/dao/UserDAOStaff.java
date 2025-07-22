package dao;

import java.sql.*;
import model.UserStaff;
import utils.DBConnection;

public class UserDAOStaff {

    public UserStaff getUserById(int userId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        UserStaff user = null;
        if (rs.next()) {
            user = new UserStaff(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("email"),
                rs.getString("status"),
                rs.getString("avatar_url"),
                rs.getString("phone"),
                rs.getString("address")
            );
        }
        rs.close();
        ps.close();
        conn.close();
        return user;
    }

    public void updateUser(UserStaff user) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE Users SET username = ?, email = ?, status = ?, avatar_url = ?, phone = ?, address = ?, updated_at = GETDATE() WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, user.getUsername());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getStatus());
        ps.setString(4, user.getAvatarUrl());
        ps.setString(5, user.getPhone());
        ps.setString(6, user.getAddress());
        ps.setInt(7, user.getUserId());
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    public void updatePassword(int userId, String newHash) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE Users SET password_hash = ?, updated_at = GETDATE() WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, newHash);
        ps.setInt(2, userId);
        ps.executeUpdate();
        ps.close();
        conn.close();
    }

    public String getPasswordHashById(int userId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT password_hash FROM Users WHERE user_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();
        String hash = null;
        if (rs.next()) {
            hash = rs.getString("password_hash");
        }
        rs.close();
        ps.close();
        conn.close();
        return hash;
    }
}
