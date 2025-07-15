
package dao;

import com.fasterxml.jackson.databind.ObjectMapper;
import model.UserAdmin;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.List;
import java.util.ArrayList;

public class UserAdminDAO {

    private LogAdminDAO logAdminDAO = new LogAdminDAO();
    private ObjectMapper objectMapper = new ObjectMapper();

    public UserAdmin getUserByUsername(String username) {
        String sql = "SELECT user_id, username, password, role_name FROM Users WHERE username = ?";
        UserAdmin user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new UserAdmin();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public String getUsernameById(int userId) {
        String username = null;
        String sql = "SELECT username FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    username = rs.getString("username");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return username;
    }

    public UserAdmin getUserById(int userId) {
        String sql = "SELECT user_id, username, password, role_name FROM Users WHERE user_id = ?";
        UserAdmin user = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    user = new UserAdmin();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setRole(rs.getString("role_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public boolean createUser(UserAdmin user, int loggedInUserId) {
        String sql = "INSERT INTO Users (username, password, role_name, created_at) VALUES (?, ?, ?, GETDATE())";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                int newUserId = 0;
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        newUserId = generatedKeys.getInt(1);
                        user.setUserId(newUserId);
                    }
                }
                logAdminDAO.logSystemActivity(loggedInUserId, "CREATE_USER", "Created new user: " + user.getUsername() + " (ID: " + newUserId + ") with role: " + user.getRole());

                try {
                    String newUserJson = objectMapper.writeValueAsString(user);
                    logAdminDAO.logDataChange("Users", String.valueOf(newUserId), null, null, newUserJson, loggedInUserId, "INSERT");
                } catch (Exception e) {
                    System.err.println("Error converting user to JSON for DataChangeLog: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean updateUser(UserAdmin user, int loggedInUserId) {
        UserAdmin oldUser = getUserById(user.getUserId());
        if (oldUser == null) {
            return false;
        }

        String sql = "UPDATE Users SET username = ?, password = ?, role_name = ? WHERE user_id = ?";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setInt(4, user.getUserId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                logAdminDAO.logSystemActivity(loggedInUserId, "UPDATE_USER_PROFILE", "Updated user profile for: " + user.getUsername() + " (ID: " + user.getUserId() + ")");

                try {
                    String oldUserJson = objectMapper.writeValueAsString(oldUser);
                    UserAdmin updatedUser = getUserById(user.getUserId());
                    String newUserJson = objectMapper.writeValueAsString(updatedUser);
                    logAdminDAO.logDataChange("Users", String.valueOf(user.getUserId()), null, oldUserJson, newUserJson, loggedInUserId, "UPDATE");
                } catch (Exception e) {
                    System.err.println("Error converting user to JSON for DataChangeLog: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean deleteUser(int userIdToDelete, int loggedInUserId) {
        UserAdmin userToDelete = getUserById(userIdToDelete);
        if (userToDelete == null) {
            return false;
        }

        String sql = "DELETE FROM Users WHERE user_id = ?";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userIdToDelete);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                logAdminDAO.logSystemActivity(loggedInUserId, "DELETE_USER", "Deleted user: " + userToDelete.getUsername() + " (ID: " + userIdToDelete + ")");

                try {
                    String deletedUserJson = objectMapper.writeValueAsString(userToDelete);
                    logAdminDAO.logDataChange("Users", String.valueOf(userIdToDelete), null, deletedUserJson, null, loggedInUserId, "DELETE");
                } catch (Exception e) {
                    System.err.println("Error converting user to JSON for DataChangeLog: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public List<UserAdmin> getAllUsers() {
        List<UserAdmin> users = new ArrayList<>();
        String sql = "SELECT user_id, username, password, role_name FROM Users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                UserAdmin user = new UserAdmin();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role_name"));
                users.add(user);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }
}
