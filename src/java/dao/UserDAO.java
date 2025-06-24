package dao;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.logging.Logger;
import java.util.logging.Level;

import model.User;
import model.Role;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import model.StorageUnit;
import model.TransportUnit;
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
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Lấy thông tin người dùng dựa trên email và role_id.
     *
     * @param email Email người dùng
     * @param roleId ID vai trò
     * @return Đối tượng Users nếu tồn tại, null nếu không
     */
    public Users getUser(String email, int roleId) {
        String query = "SELECT user_id, username, email, password_hash, role_id, created_at, updated_at, status "
                + "FROM Users WHERE LOWER(email) = LOWER(?) AND role_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setInt(2, roleId);
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting user: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage(), e);
        }
        return null;
    }

    /**
     * Kiểm tra người dùng dựa trên email và role_id.
     *
     * @param email Email người dùng
     * @param roleId ID vai trò
     * @return Đối tượng Users nếu tồn tại, null nếu không
     */
    public Users checkUserByEmail(String email, int roleId) {
        String query = "SELECT user_id, username, email, password_hash, role_id, created_at, updated_at, status "
                + "FROM Users WHERE LOWER(email) = LOWER(?) AND role_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, email);
            ps.setInt(2, roleId);
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
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking user by email: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage(), e);
        }
        return null;
    }

    /**
     * Cập nhật mật khẩu mới cho người dùng dựa trên email và role_id.
     *
     * @param newPass Mật khẩu mới (hash)
     * @param email Email người dùng
     * @param roleId ID vai trò
     * @return true nếu cập nhật thành công, false nếu thất bại
     */
    public boolean updatePassByEmail(String newPass, String email, int roleId) {
        String query = "UPDATE Users SET password_hash = ?, updated_at = ? WHERE LOWER(email) = LOWER(?) AND role_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setString(1, newPass);
            ps.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            ps.setString(3, email);
            ps.setInt(4, roleId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating password: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage(), e);
        }
        return false;
    }

    public String checkDuplicate(String email, String username, int roleId) {
        String emailQuery = "SELECT 1 FROM users WHERE LOWER(email) = LOWER(?) AND role_id = ?";
        String usernameQuery = "SELECT 1 FROM users WHERE LOWER(username) = LOWER(?)";
        String transportUnitQuery = "SELECT 1 FROM TransportUnits WHERE LOWER(company_name) = LOWER(?)";
        String roleCheckQuery = "SELECT 1 FROM Roles WHERE role_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            // Kiểm tra kết nối cơ sở dữ liệu
            if (conn == null) {
                throw new SQLException("Không thể kết nối đến cơ sở dữ liệu");
            }

            // Kiểm tra roleId hợp lệ
            try (PreparedStatement ps = conn.prepareStatement(roleCheckQuery)) {
                ps.setInt(1, roleId);
                ResultSet rs = ps.executeQuery();
                if (!rs.next()) {
                    LOGGER.log(Level.SEVERE, "Invalid role_id: " + roleId);
                    throw new SQLException("role_id không hợp lệ: " + roleId);
                }
            }

            // Kiểm tra email với role_id
            try (PreparedStatement ps = conn.prepareStatement(emailQuery)) {
                ps.setString(1, email.toLowerCase());
                ps.setInt(2, roleId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    return "email_exists";
                }
            }

            // Kiểm tra username
            if (roleId == 4) {
                // Với role_id = 4, kiểm tra company_name trong TransportUnits
                try (PreparedStatement ps = conn.prepareStatement(transportUnitQuery)) {
                    ps.setString(1, username.toLowerCase());
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        return "username_exists";
                    }
                }
            } else {
                // Với các role_id khác, kiểm tra username trong Users
                try (PreparedStatement ps = conn.prepareStatement(usernameQuery)) {
                    ps.setString(1, username.toLowerCase());
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        return "username_exists";
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking duplicate: SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode() + ", Message=" + e.getMessage(), e);
            throw new RuntimeException("Lỗi kiểm tra trùng lặp: " + e.getMessage(), e);
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

    public int signupAccount2(Users user) {
        String query = "INSERT INTO users (username, email, password_hash, role_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash() != null ? user.getPasswordHash() : "google_oauth");
            ps.setInt(4, user.getRoleId());
            ps.setString(5, user.getStatus());
            Timestamp now = new Timestamp(System.currentTimeMillis());
            ps.setTimestamp(6, now);
            ps.setTimestamp(7, null);
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
            throw new SQLException("Không thể lấy user_id sau khi chèn tài khoản");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error signing up account for email: " + user.getEmail(), e);
            throw new RuntimeException("Error signing up account", e);
        }
    }

    // Lưu thông tin Transport Unit
    public boolean saveTransportUnit(TransportUnit unit, int userId) {
        // Kiểm tra role_id của user
        String roleCheckQuery = "SELECT role_id FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(roleCheckQuery)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt("role_id") != 4) {
                throw new IllegalArgumentException("User must have role_id = 4 (Transport Unit)");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking user role: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            return false;
        }

        // Sửa query để sử dụng transport_unit_id làm khóa chính
        String query = "INSERT INTO TransportUnits (transport_unit_id, company_name, contact_info, location, vehicle_count, capacity, loader, business_certificate, registration_status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'pending', GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            // Kiểm tra dữ liệu đầu vào
            if (unit.getCompanyName() == null || unit.getCompanyName().trim().isEmpty()) {
                throw new IllegalArgumentException("Company name cannot be null or empty");
            }
            if (unit.getVehicleCount() < 0) {
                throw new IllegalArgumentException("Vehicle count cannot be negative");
            }
            if (unit.getCapacity() < 0) {
                throw new IllegalArgumentException("Capacity cannot be negative");
            }
            if (unit.getLoader() < 0) {
                throw new IllegalArgumentException("Loader count cannot be negative");
            }

            ps.setInt(1, userId); // Sử dụng userId làm transport_unit_id
            ps.setString(2, truncate(unit.getCompanyName(), 150));
            ps.setString(3, truncate(unit.getContactInfo(), 255));
            ps.setString(4, truncate(unit.getLocation(), 100));
            ps.setInt(5, unit.getVehicleCount());
            ps.setBigDecimal(6, BigDecimal.valueOf(unit.getCapacity()).setScale(2, RoundingMode.HALF_UP));
            ps.setInt(7, unit.getLoader());
            ps.setString(8, truncate(unit.getBusinessCertificate(), 2000));

            int rows = ps.executeUpdate();
            if (rows == 0) {
                LOGGER.warning("Eror: ");
            }
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException saving TransportUnit: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            return false;
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Invalid input for TransportUnit: " + e.getMessage(), e);
            return false;
        }
    }

    // Lưu thông tin Storage Unit
    public boolean saveStorageUnit(StorageUnit unit, int userId) {
        // Kiểm tra role_id của user
        String roleCheckQuery = "SELECT role_id FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(roleCheckQuery)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt("role_id") != 5) {
                throw new IllegalArgumentException("User must have role_id = 5 (Storage Unit)");
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking user role: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            return false;
        }

        String query = "INSERT INTO StorageUnits (storage_unit_id, warehouse_name, location, business_certificate, area, employee, phone_number, registration_status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, 'pending', GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            // Kiểm tra dữ liệu đầu vào
            if (unit.getWarehouseName() == null || unit.getWarehouseName().trim().isEmpty()) {
                throw new IllegalArgumentException("Warehouse name cannot be null or empty");
            }
            if (unit.getEmployee() < 0) {
                throw new IllegalArgumentException("Employee count cannot be negative");
            }

            ps.setInt(1, userId); // Sử dụng user_id làm storage_unit_id
            ps.setString(2, truncate(unit.getWarehouseName(), 150));
            ps.setString(3, truncate(unit.getLocation(), 255));
            ps.setString(4, truncate(unit.getBusinessCertificate(), 2000));
            ps.setDouble(5, unit.getArea());
            ps.setInt(6, unit.getEmployee());
            ps.setString(7, truncate(unit.getPhoneNumber(), 15));
            int rows = ps.executeUpdate();
            if (rows == 0) {
                LOGGER.warning("No rows affected when inserting StorageUnit for warehouse: " + unit.getWarehouseName());
            }
            return rows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQLException saving StorageUnit: " + e.getMessage() + ", SQLState: " + e.getSQLState() + ", ErrorCode: " + e.getErrorCode(), e);
            return false;
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Invalid input for StorageUnit: " + e.getMessage(), e);
            return false;
        }
    }

    // Hàm hỗ trợ cắt chuỗi để tránh vượt giới hạn độ dài cột
    private String truncate(String value, int maxLength) {
        if (value == null) {
            return null;
        }
        return value.length() > maxLength ? value.substring(0, maxLength) : value;
    }
}