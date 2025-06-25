package dao;

import model.OperatorComplaint;
import model.UserComplaint;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OperatorComplaintDAO {

    public OperatorComplaint getComplaintById(int issueId) {
        OperatorComplaint c = null;
        String sql = "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, " +
                     "i.created_at, i.resolved_at, i.assigned_to, u2.username AS assigned_to_username " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id " +
                     "LEFT JOIN Users u2 ON i.assigned_to = u2.user_id " +
                     "WHERE i.issue_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    c = new OperatorComplaint();
                    c.setIssueId(rs.getInt("issue_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setUsername(rs.getString("username"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status"));
                    c.setPriority(rs.getString("priority"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setResolvedAt(rs.getTimestamp("resolved_at"));
                    c.setAssignedTo(rs.getObject("assigned_to", Integer.class));
                    c.setAssignedToUsername(rs.getString("assigned_to_username"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error in getComplaintById: " + e.getMessage());
        }
        return c;
    }

    public List<String> getComplaintReplies(int issueId) {
        List<String> replies = new ArrayList<>();
        String sql = "SELECT cr.reply_content, u.username, cr.replied_at " +
                     "FROM ComplaintReplies cr " +
                     "JOIN Users u ON cr.replied_by_user_id = u.user_id " +
                     "WHERE cr.issue_id = ? ORDER BY cr.replied_at ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String replyContent = rs.getString("reply_content");
                    String repliedBy = rs.getString("username");
                    Timestamp repliedAt = rs.getTimestamp("replied_at");
                    replies.add(String.format("[%s - %s]: %s", repliedAt.toString(), repliedBy, replyContent));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error in getComplaintReplies: " + e.getMessage());
        }
        return replies;
    }

    public List<OperatorComplaint> getEscalatedComplaints(String searchTerm, String priorityFilter, int offset, int limit) {
        List<OperatorComplaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, " +
                "i.created_at, i.resolved_at, i.assigned_to, u2.username AS assigned_to_username " +
                "FROM Issues i " +
                "JOIN Users u ON i.user_id = u.user_id " +
                "LEFT JOIN Users u2 ON i.assigned_to = u2.user_id " +
                "WHERE LOWER(i.status) = 'escalated' ");

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (LOWER(u.username) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(u2.username) LIKE ? OR CAST(i.issue_id AS NVARCHAR(MAX)) LIKE ?) ");
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
            sql.append("AND LOWER(i.priority) = ? ");
        }
        sql.append("ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String likeTerm = "%" + searchTerm.toLowerCase() + "%";
                ps.setString(index++, likeTerm);
                ps.setString(index++, likeTerm);
                ps.setString(index++, likeTerm);
                ps.setString(index++, likeTerm);
            }
            if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
                ps.setString(index++, priorityFilter.toLowerCase());
            }
            ps.setInt(index++, offset);
            ps.setInt(index, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OperatorComplaint c = new OperatorComplaint();
                    c.setIssueId(rs.getInt("issue_id"));
                    c.setUserId(rs.getInt("user_id"));
                    c.setUsername(rs.getString("username"));
                    c.setDescription(rs.getString("description"));
                    c.setStatus(rs.getString("status"));
                    c.setPriority(rs.getString("priority"));
                    c.setCreatedAt(rs.getTimestamp("created_at"));
                    c.setResolvedAt(rs.getTimestamp("resolved_at"));
                    c.setAssignedTo(rs.getObject("assigned_to", Integer.class));
                    c.setAssignedToUsername(rs.getString("assigned_to_username"));
                    list.add(c);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error in getEscalatedComplaints: " + e.getMessage());
        }
        return list;
    }

    public int getTotalEscalatedComplaintCount(String searchTerm, String priorityFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Issues i " +
                "JOIN Users u ON i.user_id = u.user_id " +
                "LEFT JOIN Users u2 ON i.assigned_to = u2.user_id " +
                "WHERE LOWER(i.status) = 'escalated' ");

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (LOWER(u.username) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(u2.username) LIKE ? OR CAST(i.issue_id AS NVARCHAR(MAX)) LIKE ?) ");
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
            sql.append("AND LOWER(i.priority) = ? ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                String likeTerm = "%" + searchTerm.toLowerCase() + "%";
                ps.setString(index++, likeTerm);
                ps.setString(index++, likeTerm);
                ps.setString(index++, likeTerm);
                ps.setString(index++, likeTerm);
            }
            if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
                ps.setString(index++, priorityFilter.toLowerCase());
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error in getTotalEscalatedComplaintCount: " + e.getMessage());
        }
        return count;
    }

    public boolean assignComplaintToOperator(int issueId, int operatorUserId) {
        String sql = "UPDATE Issues SET assigned_to = ?, status = 'in_progress', resolved_at = NULL WHERE issue_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, operatorUserId);
            ps.setInt(2, issueId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error assigning complaint to operator: " + e.getMessage());
            return false;
        }
    }

    public boolean updateComplaintAndAddReply(int issueId, String status, String priority, Integer assignedTo, String replyContent, Integer repliedByUserId) {
        Connection conn = null;
        boolean success = false;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            StringBuilder updateIssueSql = new StringBuilder("UPDATE Issues SET status = ?, priority = ?");
            if (assignedTo != null) {
                updateIssueSql.append(", assigned_to = ?");
            } else {
                updateIssueSql.append(", assigned_to = NULL");
            }

            if ("resolved".equalsIgnoreCase(status) || "closed".equalsIgnoreCase(status)) {
                updateIssueSql.append(", resolved_at = GETDATE()");
            } else {
                updateIssueSql.append(", resolved_at = NULL");
            }
            updateIssueSql.append(" WHERE issue_id = ?");

            try (PreparedStatement psIssue = conn.prepareStatement(updateIssueSql.toString())) {
                int index = 1;
                psIssue.setString(index++, status);
                psIssue.setString(index++, priority);
                if (assignedTo != null) {
                    psIssue.setInt(index++, assignedTo);
                }
                psIssue.setInt(index, issueId);

                int rowsAffectedIssue = psIssue.executeUpdate();
                if (rowsAffectedIssue == 0) {
                    conn.rollback();
                    return false;
                }
            }

            if (replyContent != null && !replyContent.trim().isEmpty()) {
                String insertReplySql = "INSERT INTO ComplaintReplies (issue_id, reply_content, replied_by_user_id) VALUES (?, ?, ?)";
                try (PreparedStatement psReply = conn.prepareStatement(insertReplySql)) {
                    psReply.setInt(1, issueId);
                    psReply.setString(2, replyContent);
                    psReply.setInt(3, repliedByUserId);
                    psReply.executeUpdate();
                }
            }

            conn.commit();
            success = true;

        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error in updateComplaintAndAddReply: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.err.println("Error rolling back transaction: " + ex.getMessage());
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Error closing connection or setting auto-commit: " + e.getMessage());
                }
            }
        }
        return success;
    }

    public List<UserComplaint> getOperators() {
        List<UserComplaint> operators = new ArrayList<>();
        String sql = "SELECT user_id, username FROM Users WHERE role_id = 2 AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserComplaint operator = new UserComplaint();
                    operator.setUserId(rs.getInt("user_id"));
                    operator.setUsername(rs.getString("username"));
                    operators.add(operator);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error in getOperators: " + e.getMessage());
        }
        return operators;
    }
}