package dao;

import model.IssueReply;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class IssueReplyDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    public List<IssueReply> getRepliesByIssueId(int issueId) {
        List<IssueReply> replies = new ArrayList<>();
        String sql = "SELECT r.reply_id, r.issue_id, r.sender_id AS replier_id, "
                + "u.username AS replier_name, r.message AS reply_content, "
                + "r.replied_at, r.message_for_issue, i.user_id AS customer_id "
                + "FROM IssueReplies r "
                + "JOIN Users u ON r.sender_id = u.user_id "
                + "JOIN Issues i ON r.issue_id = i.issue_id "
                + "WHERE r.issue_id = ? ORDER BY r.replied_at ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IssueReply reply = mapCompleteReplyFromResultSet(rs);
                    replies.add(reply);
                }
            }
        } catch (SQLException e) {
            handleDatabaseError(e);
        }
        return replies;
    }

    private IssueReply mapCompleteReplyFromResultSet(ResultSet rs) throws SQLException {
        IssueReply reply = new IssueReply();
        reply.setReplyId(rs.getInt("reply_id"));
        reply.setIssueId(rs.getInt("issue_id"));
        reply.setReplierId(rs.getInt("replier_id"));
        reply.setReplierName(rs.getString("replier_name"));  
        reply.setReplyContent(rs.getString("reply_content"));
        reply.setRepliedAt(rs.getTimestamp("replied_at"));
        reply.setMessage_for_issue(rs.getString("message_for_issue"));
        reply.setCustomerId(rs.getInt("customer_id"));
        return reply;
    }

    private void handleDatabaseError(SQLException e) {
        // Có thể thêm logging chi tiết ở đây
        System.err.println("Database error occurred: " + e.getMessage());
        e.printStackTrace();
    }

    public boolean addReply(IssueReply reply) {
        String sql = "INSERT INTO IssueReplies (issue_id, sender_id, message, replied_at, message_for_issue) "
                + "VALUES (?, ?, ?, GETDATE(), ?)";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, reply.getIssueId());
            ps.setInt(2, reply.getReplierId());
            ps.setString(3, reply.getContent());
            ps.setString(4, reply.getMessage_for_issue());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            handleDatabaseError(e);
            return false;
        }
    }
}
