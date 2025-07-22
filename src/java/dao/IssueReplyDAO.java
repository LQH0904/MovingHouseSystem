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
    public static void main(String[] args) {
         List<IssueReply> l = new IssueReplyDAO().getRepliesByIssueId(80);
         for (IssueReply issueReply : l) {
             System.out.println(issueReply.getContent());
        }
    }
    public List<IssueReply> getRepliesByIssueId(int issueId) {
        List<IssueReply> replies = new ArrayList<>();
        String sql = "SELECT r.reply_id, r.issue_id, r.sender_id, u.username AS replier_name, r.message, r.replied_at "
           + "FROM IssueReplies r JOIN Users u ON r.sender_id = u.user_id WHERE r.issue_id = ? ORDER BY r.replied_at ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IssueReply reply = new IssueReply(
                            rs.getInt("reply_id"),
                            rs.getInt("issue_id"),
                            rs.getInt("sender_id"),
                            rs.getString("message"),
                           rs.getTimestamp("replied_at")
                    );
                    replies.add(reply);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
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
