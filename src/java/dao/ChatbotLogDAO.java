// dao/ChatbotLogDAO.java
package dao;

import model.ChatbotLog;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ChatbotLogDAO {
    private Connection conn;

    public ChatbotLogDAO(Connection conn) {
        this.conn = conn;
    }

    /**
     * Lấy tất cả log, kèm theo tên của người dùng từ bảng Users.
     * @return Danh sách các đối tượng ChatbotLog.
     * @throws SQLException
     */
    public List<ChatbotLog> getAllLogsWithUsername() throws SQLException {
        List<ChatbotLog> logs = new ArrayList<>();
        String sql = "SELECT c.log_id, c.user_id, u.username, c.message, c.response, c.created_at " +
                     "FROM ChatbotLogs c " +
                     "JOIN Users u ON c.user_id = u.user_id " +
                     "ORDER BY c.created_at DESC";

        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                ChatbotLog log = new ChatbotLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setUsername(rs.getString("username")); // Lấy tên người dùng
                log.setMessage(rs.getString("message"));
                log.setResponse(rs.getString("response"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                logs.add(log);
            }
        }
        return logs;
    }

    /**
     * Cập nhật câu trả lời cho một log cụ thể.
     * @param logId ID của log cần cập nhật.
     * @param newResponse Nội dung câu trả lời mới.
     * @return true nếu cập nhật thành công, false nếu thất bại.
     * @throws SQLException
     */
    public boolean updateResponse(int logId, String newResponse) throws SQLException {
        String sql = "UPDATE ChatbotLogs SET response = ? WHERE log_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newResponse);
            ps.setInt(2, logId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Phương thức addLog của bạn giữ nguyên
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
    
    public int getTotalLogCount() throws SQLException {
        String sql = "SELECT COUNT(*) FROM ChatbotLogs";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }
    public List<ChatbotLog> getLogsByPage(int page, int pageSize) throws SQLException {
        List<ChatbotLog> logs = new ArrayList<>();
        // SQL Server 2012+ syntax for pagination
        String sql = "SELECT c.log_id, c.user_id, u.username, c.message, c.response, c.created_at " +
                     "FROM ChatbotLogs c " +
                     "JOIN Users u ON c.user_id = u.user_id " +
                     "ORDER BY c.created_at DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ChatbotLog log = new ChatbotLog();
                    log.setLogId(rs.getInt("log_id"));
                    log.setUserId(rs.getInt("user_id"));
                    log.setUsername(rs.getString("username"));
                    log.setMessage(rs.getString("message"));
                    log.setResponse(rs.getString("response"));
                    log.setCreatedAt(rs.getTimestamp("created_at"));
                    logs.add(log);
                }
            }
        }
        return logs;
    }
    public List<ChatbotLog> getLogsByUserId(int userId) throws SQLException {
    List<ChatbotLog> logs = new ArrayList<>();
    String sql = "SELECT log_id, user_id, message, response, created_at FROM ChatbotLogs WHERE user_id = ? ORDER BY created_at ASC";
    try (PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, userId);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ChatbotLog log = new ChatbotLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setMessage(rs.getString("message"));
                log.setResponse(rs.getString("response"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                logs.add(log);
            }
        }
    }
    return logs;
}
}