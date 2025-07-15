package dao;

import model.User;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

public class UserDAO1 {

    public User getUserByUsername(String username) throws SQLException {
        String SQL = """
            SELECT u.user_id, u.username, u.password_hash, u.email,
                   u.role_id, r.role_name,
                   u.created_at, u.updated_at, u.status
            FROM [dbo].[Users] u
            JOIN [dbo].[Roles] r ON u.role_id = r.role_id
            WHERE u.username = ?
        """;

        User user = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(SQL)) {

            pstmt.setString(1, username);

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    user = new User(username, hashedPassword, email, role);
                    user.setUserId(rs.getInt("user_id"));
                    user.setUsername(rs.getString("username"));
                    user.setPasswordHash(rs.getString("password_hash"));
                    user.setEmail(rs.getString("email"));
                    user.setRole(rs.getString("role_name"));

                    Timestamp createdAt = rs.getTimestamp("created_at");
                    if (createdAt != null) {
                        user.setCreatedAt(createdAt.toLocalDateTime());
                    }

                    Timestamp updatedAt = rs.getTimestamp("updated_at");
                    if (updatedAt != null) {
                        user.setUpdatedAt(updatedAt.toLocalDateTime());
                    }

                    user.setStatus(rs.getString("status"));
                }
            }
        }

        return user;
    }

}
