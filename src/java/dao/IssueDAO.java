// File: src/main/java/com/yourpackage/dao/IssueDAO.java

package dao; // Đảm bảo đúng package của bạn

import model.Issue; // Đảm bảo đúng package của bạn cho Issue
import utils.DBConnection; // Import lớp DBConnection của bạn

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class IssueDAO {

    private static final Logger LOGGER = Logger.getLogger(IssueDAO.class.getName());

    public Issue getIssueById(int issueId) {
        Issue issue = null;
        // SQL query để lấy thông tin issue và username từ bảng Users
        String sql = "SELECT i.issue_id, i.user_id, u.username, i.order_id, i.description, i.status, " +
                     "i.priority, i.assigned_to, i.created_at, i.resolved_at, " +
                     "i.escalation_reason, i.escalated_by_user_id " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id " +
                     "WHERE i.issue_id = ?";

        // Sử dụng try-with-resources để đảm bảo Connection, PreparedStatement, ResultSet được đóng tự động
        try (Connection conn = DBConnection.getConnection(); // Lấy kết nối từ lớp DBConnection của bạn
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId); // Đặt giá trị cho tham số issue_id

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    issue = new Issue();
                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setUserId(rs.getInt("user_id"));
                    issue.setUsername(rs.getString("username")); // Đặt username từ bảng Users
                    issue.setOrderId(rs.getObject("order_id", Integer.class)); // Sử dụng getObject cho cột có thể NULL
                    issue.setDescription(rs.getString("description"));
                    issue.setStatus(rs.getString("status"));
                    issue.setPriority(rs.getString("priority"));
                    issue.setAssignedTo(rs.getObject("assigned_to", Integer.class));
                    issue.setCreatedAt(rs.getTimestamp("created_at"));
                    issue.setResolvedAt(rs.getTimestamp("resolved_at"));
                    issue.setEscalationReason(rs.getString("escalation_reason"));
                    issue.setEscalatedByUserId(rs.getObject("escalated_by_user_id", Integer.class));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy khiếu nại theo ID: " + issueId, e);
            // Bạn có thể chọn ném lại một custom exception hoặc trả về null tùy theo cách bạn muốn xử lý lỗi
        }
        return issue;
    }

    public boolean updateIssue(Issue issue) {
        String sql = "UPDATE Issues SET status = ?, priority = ?, escalation_reason = ?, resolved_at = ? " +
                     "WHERE issue_id = ?";
        
        try (Connection conn = DBConnection.getConnection(); // Lấy kết nối từ lớp DBConnection của bạn
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, issue.getStatus());
            ps.setString(2, issue.getPriority());
            // Đảm bảo escalationReason không bị null nếu status không phải 'escalated'
            ps.setString(3, issue.getEscalationReason()); 
            ps.setTimestamp(4, issue.getResolvedAt()); // resolved_at có thể là null

            ps.setInt(5, issue.getIssueId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật khiếu nại với ID: " + issue.getIssueId(), e);
            return false;
        }
    }

    // Bạn có thể thêm các phương thức DAO khác tại đây (ví dụ: getAllIssues, createIssue, deleteIssue, v.v.)
}