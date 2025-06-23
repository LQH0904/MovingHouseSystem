package dao;

import java.util.logging.Logger;
import java.util.logging.Level;

import model.User;
import model.Role;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import model.Users;

public class UserDAO {

    private Connection conn;
     public static final UserDAO INSTANCE = new UserDAO();

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    /**
     * Kiểm tra xem username đã tồn tại trong cơ sở dữ liệu hay chưa.
     *
     * @param username Tên người dùng cần kiểm tra
     * @return true nếu tồn tại, false nếu không
     */
    public boolean isUsernameExist(String username) {
        String query = "SELECT 1 FROM users WHERE username = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, null, e);
        }
        return false;
    }

    /**
     * Kiểm tra thông tin đăng nhập theo email và mật khẩu.
     *
     * @param email Email người dùng
     * @param password Mật khẩu (hash)
     * @return Đối tượng Users nếu đăng nhập thành công, null nếu thất bại
     */
    public Users getAccountLoginByEmail(String email, String password) {
        String query = "SELECT * FROM users WHERE email = ? AND password_hash = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password_hash"),
                        rs.getInt("role_id"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Lấy thông tin người dùng theo email (kiểm tra email có tồn tại hay
     * không).
     *
     * @param email Email cần kiểm tra
     * @return Đối tượng Users nếu tìm thấy, null nếu không
     */
    public Users checkUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email.toLowerCase());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password_hash"),
                        rs.getInt("role_id"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            System.err.println("Error in getUserByEmail with email: " + email);
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Trả về đối tượng Users bằng email (hàm này tái sử dụng checkUserByEmail).
     *
     * @param email Email người dùng
     * @return Đối tượng Users nếu tìm thấy, null nếu không
     */
    public Users getUserbyEmail(String email) {
        return checkUserByEmail(email);
    }

    /**
     * Đăng ký tài khoản người dùng mới.
     *
     * @param user Đối tượng Users chứa thông tin đăng ký
     * @return true nếu thêm thành công, false nếu thất bại
     */
    public boolean signupAccount(Users user) {
        String query = "INSERT INTO users (username, email, password_hash, role_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
                ps.setString(1, user.getUsername());
                ps.setString(2, user.getEmail());
                ps.setString(3, user.getPasswordHash() != null ? user.getPasswordHash() : "google_oauth");
                ps.setInt(4, user.getRoleId());
                ps.setString(5, user.getStatus());

                Timestamp now = new Timestamp(System.currentTimeMillis());
                ps.setTimestamp(6, now);
                ps.setTimestamp(7, null);

                int rows = ps.executeUpdate();
                return rows > 0;
            }
        } catch (Exception e) {  // catch cả Exception thay vì chỉ SQLException
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy thông tin người dùng từ email.
     *
     * @param email Email người dùng
     * @return Đối tượng Users nếu tồn tại, null nếu không
     */
    public Users getUserByEmail(String email) {
        String query = "SELECT * FROM users WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Users(
                        rs.getInt("user_id"),
                        rs.getString("username"),
                        rs.getString("email"),
                        rs.getString("password_hash"),
                        rs.getInt("role_id"),
                        rs.getTimestamp("created_at"),
                        rs.getTimestamp("updated_at"),
                        rs.getString("status")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Cập nhật mật khẩu mới cho người dùng dựa trên email.
     *
     * @param newPass Mật khẩu mới (hash)
     * @param email Email người dùng
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updatePassByEmail(String newPass, String email) {
        String query = "UPDATE users SET password_hash = ?, updated_at = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPass);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, email);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public String checkDuplicate(String email, String username) {
        String emailQuery = "SELECT 1 FROM users WHERE LOWER(email) = LOWER(?)";
        String usernameQuery = "SELECT 1 FROM users WHERE LOWER(username) = LOWER(?)";

        try (Connection conn = DBConnection.getConnection()) {

            // Check email
            try (PreparedStatement ps = conn.prepareStatement(emailQuery)) {
                ps.setString(1, email.toLowerCase());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return "email_exists";
                }
            }

            // Check username
            try (PreparedStatement ps = conn.prepareStatement(usernameQuery)) {
                ps.setString(1, username.toLowerCase());
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return "username_exists";
                }
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking duplicate", e);
        }

        return "none";
    }

    public UserDAO() {
        try {
            this.conn = DBConnection.getConnection(); 
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public User getUserById(int userId) {
        User user = null;
        String query = "SELECT u.user_id, u.username, u.password_hash, u.email, u.role_id, u.created_at, u.updated_at, u.status, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);  
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setEmail(rs.getString("email"));

                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    user.setRole(role);  

                    user.setCreatedAt(rs.getDate("created_at"));
                    user.setUpdatedAt(rs.getDate("updated_at"));
                    user.setStatus(rs.getString("status"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return user;
    }

    public List<User> getAllUsers() throws SQLException {
        List<User> userList = new ArrayList<>();
        String query = "SELECT u.user_id, u.username, u.password_hash, u.email, u.role_id, u.created_at, u.updated_at, u.status, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id"; 

        try (Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(query)) {
            while (rs.next()) {
                User user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPasswordHash(rs.getString("password_hash"));
                user.setEmail(rs.getString("email"));

                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                user.setRole(role); 

                user.setCreatedAt(rs.getDate("created_at"));
                user.setUpdatedAt(rs.getDate("updated_at"));
                user.setStatus(rs.getString("status"));
                userList.add(user);
            }
        }

        return userList;
    }

    public List<User> getUsersByRole(int roleId) {
        List<User> users = new ArrayList<>();
        String query = "SELECT u.user_id, u.username, u.password_hash, u.email, u.role_id, u.created_at, u.updated_at, u.status, r.role_name "
                + "FROM Users u "
                + "JOIN Roles r ON u.role_id = r.role_id "
                + "WHERE u.role_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, roleId); 
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    User user = new User();
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setEmail(rs.getString("email"));
                    Role role = new Role();
                    role.setRoleId(rs.getInt("role_id"));
                    role.setRoleName(rs.getString("role_name"));
                    user.setRole(role);
                    user.setStatus(rs.getString("status"));
                    users.add(user);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return users;
    }

    public boolean addUser(User user) {
        String query = "INSERT INTO Users (username, password_hash, email, role_id, created_at, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            java.sql.Timestamp timestamp = new java.sql.Timestamp(new Date().getTime());

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPasswordHash());
            stmt.setString(3, user.getEmail());
            stmt.setInt(4, user.getRole().getRoleId());  
            stmt.setTimestamp(5, timestamp);  
            stmt.setString(6, "active"); 

            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;  
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int userId) {
        String query = "DELETE FROM Users WHERE user_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            int rowsAffected = stmt.executeUpdate();
            return rowsAffected > 0;  
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public List<User> getUsersByPage(int offset, int limit) {
    List<User> userList = new ArrayList<>();
    String query = "SELECT u.user_id, u.username, u.password_hash, u.email, u.role_id, u.created_at, u.updated_at, u.status, r.role_name "
                 + "FROM Users u JOIN Roles r ON u.role_id = r.role_id "
                 + "WHERE u.role_id != 1 " // loại admin
                 + "ORDER BY u.user_id "
                 + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

    try (PreparedStatement stmt = conn.prepareStatement(query)) {
        stmt.setInt(1, offset);
        stmt.setInt(2, limit);
        ResultSet rs = stmt.executeQuery();

        while (rs.next()) {
            User user = new User();
            user.setUserId(rs.getInt("user_id"));
            user.setUsername(rs.getString("username"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setEmail(rs.getString("email"));

            Role role = new Role();
            role.setRoleId(rs.getInt("role_id"));
            role.setRoleName(rs.getString("role_name"));
            user.setRole(role);

            user.setCreatedAt(rs.getDate("created_at"));
            user.setUpdatedAt(rs.getDate("updated_at"));
            user.setStatus(rs.getString("status"));
            userList.add(user);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    return userList;
}

public int countAllUsers() {
    String query = "SELECT COUNT(*) FROM Users WHERE role_id != 1";
    try (PreparedStatement stmt = conn.prepareStatement(query);
         ResultSet rs = stmt.executeQuery()) {
        if (rs.next()) {
            return rs.getInt(1);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return 0;
}
    

}
