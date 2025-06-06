
package dao;




import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;
import utils.DBConnection;

/**
 *
 * @author admin
 */
public class UserDAO {

    public static final UserDAO INSTANCE = new UserDAO();

    private static final Logger LOGGER = Logger.getLogger(UserDAO.class.getName());

    public UserDAO() {
    }

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

}
