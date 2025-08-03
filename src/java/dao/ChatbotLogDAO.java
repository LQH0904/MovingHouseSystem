// dao/ChatbotLogDAO.java
package dao;

import model.ChatbotLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

public class ChatbotLogDAO {
    private Connection conn;

    public ChatbotLogDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Thêm một bản ghi log mới vào database.
     * @param log đối tượng ChatbotLog chứa thông tin cần lưu.
     * @throws SQLException
     */
    public void addLog(ChatbotLog log) throws SQLException {
        String sql = "INSERT INTO ChatbotLogs (user_id, message, response, created_at) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, log.getUserId());
            ps.setString(2, log.getMessage());
            ps.setString(3, log.getResponse());
            // createdAt được truyền từ đối tượng log
            ps.setTimestamp(4, new Timestamp(log.getCreatedAt().getTime()));
            ps.executeUpdate();
        }
    }
}