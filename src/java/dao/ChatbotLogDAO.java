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

    // Thêm câu hỏi mới từ Customer (chỉ có userId, question)
//    public void insertLog(int userId, String question) throws SQLException {
//        String sql = "INSERT INTO chatbot_logs (user_id, question, created_at) VALUES (?, ?, NOW())";
//        try (PreparedStatement ps = conn.prepareStatement(sql)) {
//            ps.setInt(1, userId);
//            ps.setString(2, question);
//            ps.executeUpdate();
//        }
//    }

    // Lấy tất cả log
    public List<ChatbotLog> getAllLogs() throws SQLException {
        List<ChatbotLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM chatbot_logs ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                logs.add(extractLog(rs));
            }
        }
        return logs;
    }

    // Lấy log theo userId
    public List<ChatbotLog> getLogsByUserId(int userId) throws SQLException {
        List<ChatbotLog> logs = new ArrayList<>();
        String sql = "SELECT * FROM chatbot_logs WHERE user_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    logs.add(extractLog(rs));
                }
            }
        }
        return logs;
    }

    // Cập nhật phản hồi và nhân viên xử lý
    public void replyToQuestion(int logId, String reply, int staffId) throws SQLException {
        String sql = "UPDATE chatbot_logs SET reply = ?, staff_id = ?, updated_at = NOW() WHERE log_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reply);
            ps.setInt(2, staffId);
            ps.setInt(3, logId);
            ps.executeUpdate();
        }
    }

    // Cập nhật đánh giá của user (review)
    public void updateReview(int logId, String review) throws SQLException {
        String sql = "UPDATE chatbot_logs SET review = ?, updated_at = NOW() WHERE log_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, review);
            ps.setInt(2, logId);
            ps.executeUpdate();
        }
    }

    // Hàm tiện ích: tạo đối tượng ChatbotLog từ ResultSet
    private ChatbotLog extractLog(ResultSet rs) throws SQLException {
        ChatbotLog log = new ChatbotLog();
        log.setLogId(rs.getInt("log_id"));
        log.setUserId(rs.getInt("user_id"));
        log.setQuestion(rs.getString("question"));
        log.setReply(rs.getString("reply"));
        log.setReview(rs.getString("review"));
        log.setStaffId(rs.getInt("staff_id"));
        log.setCreatedAt(rs.getTimestamp("created_at"));
        log.setUpdatedAt(rs.getTimestamp("updated_at"));
        return log;
    }
    // Lấy tất cả câu hỏi cùng tên người dùng
    public List<ChatbotLog> getAllLogsWithUserName() throws SQLException {
        List<ChatbotLog> logs = new ArrayList<>();

        String sql = "SELECT l.log_id, l.user_id, l.message, l.response, l.created_at, l.updated_at, " +
                     "       u.full_name " +
                     "FROM ChatbotLogs l " +
                     "JOIN Users u ON l.user_id = u.user_id " +
                     "ORDER BY l.created_at DESC";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                ChatbotLog log = new ChatbotLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setQuestion(rs.getString("message"));
                log.setReply(rs.getString("response"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                log.setUpdatedAt(rs.getTimestamp("updated_at"));

                // Tạm thời dùng trường review để chứa full name (phục vụ hiển thị)
                log.setReview(rs.getString("full_name"));

                logs.add(log);
            }
        }

        return logs;
    }

    // Cập nhật câu trả lời
    public void updateReply(int logId, String reply, int staffId) throws SQLException {
        String sql = "UPDATE ChatbotLogs SET response = ?, updated_at = GETDATE() WHERE log_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, reply);
            stmt.setInt(2, logId);
            stmt.executeUpdate();
        }
    }

    // Xóa câu hỏi
    public void deleteLog(int logId) throws SQLException {
        String sql = "DELETE FROM ChatbotLogs WHERE log_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, logId);
            stmt.executeUpdate();
        }
    }

    // Chèn câu hỏi mới từ phía khách hàng
    public void insertLog(int userId, String question) throws SQLException {
        String sql = "INSERT INTO ChatbotLogs (user_id, message, created_at) VALUES (?, ?, GETDATE())";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            stmt.setString(2, question);
            stmt.executeUpdate();
        }
    }
    
}
