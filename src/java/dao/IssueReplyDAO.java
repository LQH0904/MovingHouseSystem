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
        String sql = "SELECT r.reply_id, r.issue_id, r.replier_id, u.username AS replier_name, r.content, r.created_at "
                + "FROM IssueReplies r JOIN Users u ON r.replier_id = u.user_id WHERE r.issue_id = ? ORDER BY r.created_at ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IssueReply reply = new IssueReply(
                            rs.getInt("reply_id"),
                            rs.getInt("issue_id"),
                            rs.getInt("replier_id"),
                            rs.getString("replier_name"),
                            rs.getString("content"),
                            rs.getTimestamp("created_at")
                    );
                    replies.add(reply);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
    }
    public static void main(String[] args) {
        IssueReply ir = new IssueReply();
        ir.setContent("okeee");
        ir.setIssueId(80);
        ir.setReplierId(52);
        
        IssueReplyDAO ir1 = new IssueReplyDAO();
        ir1.addReply(ir);
    }
    public boolean addReply(IssueReply reply) {
        String sql = "INSERT INTO IssueReplies (issue_id, sender_id, message, replied_at) VALUES (?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, reply.getIssueId());
            ps.setInt(2, reply.getReplierId());
            ps.setString(3, reply.getContent());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
      
    }
}
