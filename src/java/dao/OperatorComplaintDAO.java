package dao;

import model.OperatorComplaint;
import model.UserComplaint;
import model.Complaint;
import model.IssueReply;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OperatorComplaintDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Cập nhật phương thức getFilteredComplaints để thêm lọc theo người phụ trách
    public List<OperatorComplaint> getFilteredComplaints(String searchTerm, String priorityFilter, String assignedToFilter,
            Date fromDate, Date toDate, int offset, int limit) {
        List<OperatorComplaint> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, "
                + "i.created_at, i.resolved_at, i.order_id AS assigned_to, s.full_name AS assigned_to_username "
                + "FROM Issues i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "LEFT JOIN Staff s ON i.order_id = s.staff_id "
                + "WHERE i.status = 'escalated' "
        );

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (i.description LIKE ? OR u.username LIKE ?) ");
        }
        if (priorityFilter != null && !priorityFilter.equals("all")) {
            sql.append("AND i.priority = ? ");
        }
        if (assignedToFilter != null && !assignedToFilter.equals("all")) {
            if (assignedToFilter.equals("unassigned")) {
                sql.append("AND i.order_id IS NULL ");
            } else {
                sql.append("AND s.full_name = ? ");
            }
        }
        if (fromDate != null) {
            sql.append("AND i.created_at >= ? ");
        }
        if (toDate != null) {
            sql.append("AND i.created_at <= ? ");
        }

        sql.append("ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + searchTerm + "%");
                stmt.setString(paramIndex++, "%" + searchTerm + "%");
            }
            if (priorityFilter != null && !priorityFilter.equals("all")) {
                stmt.setString(paramIndex++, priorityFilter);
            }
            if (assignedToFilter != null && !assignedToFilter.equals("all") && !assignedToFilter.equals("unassigned")) {
                stmt.setString(paramIndex++, assignedToFilter);
            }
            if (fromDate != null) {
                stmt.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                stmt.setDate(paramIndex++, toDate);
            }

            stmt.setInt(paramIndex++, offset);
            stmt.setInt(paramIndex, limit);

            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                OperatorComplaint complaint = new OperatorComplaint();
                complaint.setIssueId(rs.getInt("issue_id"));
                complaint.setUserId(rs.getInt("user_id"));
                complaint.setUsername(rs.getString("username"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                complaint.setAssignedTo(rs.getInt("assigned_to"));
                complaint.setAssignedToUsername(rs.getString("assigned_to_username"));
                list.add(complaint);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật phương thức getFilteredComplaintCount để thêm lọc theo người phụ trách
    public int getFilteredComplaintCount(String searchTerm, String priorityFilter, String assignedToFilter,
            Date fromDate, Date toDate) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM Issues i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "LEFT JOIN Staff s ON i.order_id = s.staff_id "
                + "WHERE i.status = 'escalated' "
        );

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (i.description LIKE ? OR u.username LIKE ?) ");
        }
        if (priorityFilter != null && !priorityFilter.equals("all")) {
            sql.append("AND i.priority = ? ");
        }
        if (assignedToFilter != null && !assignedToFilter.equals("all")) {
            if (assignedToFilter.equals("unassigned")) {
                sql.append("AND i.order_id IS NULL ");
            } else {
                sql.append("AND s.full_name = ? ");
            }
        }
        if (fromDate != null) {
            sql.append("AND i.created_at >= ? ");
        }
        if (toDate != null) {
            sql.append("AND i.created_at <= ? ");
        }

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;

            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                stmt.setString(paramIndex++, "%" + searchTerm + "%");
                stmt.setString(paramIndex++, "%" + searchTerm + "%");
            }
            if (priorityFilter != null && !priorityFilter.equals("all")) {
                stmt.setString(paramIndex++, priorityFilter);
            }
            if (assignedToFilter != null && !assignedToFilter.equals("all") && !assignedToFilter.equals("unassigned")) {
                stmt.setString(paramIndex++, assignedToFilter);
            }
            if (fromDate != null) {
                stmt.setDate(paramIndex++, fromDate);
            }
            if (toDate != null) {
                stmt.setDate(paramIndex++, toDate);
            }

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // Giữ nguyên các phương thức cũ
    public List<UserComplaint> getOperators() {
        List<UserComplaint> list = new ArrayList<>();
        String sql = "SELECT staff_id, full_name AS username FROM Staff";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                UserComplaint operator = new UserComplaint();
                operator.setUserId(rs.getInt("staff_id"));
                operator.setUsername(rs.getString("username"));
                list.add(operator);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public Complaint getComplaintById(int issueId) {
        String sql = "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, "
                + "i.created_at, i.resolved_at "
                + "FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE i.issue_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, issueId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Complaint complaint = new Complaint();
                complaint.setIssueId(rs.getInt("issue_id"));
                complaint.setUserId(rs.getInt("user_id"));
                complaint.setUsername(rs.getString("username"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                return complaint;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<IssueReply> getReplyHistory(int issueId) {
        List<IssueReply> list = new ArrayList<>();
        String sql = "SELECT r.reply_id, r.issue_id, r.replier_id, s.full_name AS replier_name, r.content, r.created_at "
                + "FROM IssueReplies r JOIN Staff s ON r.replier_id = s.staff_id "
                + "WHERE r.issue_id = ? ORDER BY r.created_at ASC";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, issueId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                IssueReply reply = new IssueReply();
                reply.setReplyId(rs.getInt("reply_id"));
                reply.setIssueId(rs.getInt("issue_id"));
                reply.setReplierId(rs.getInt("replier_id"));
                reply.setContent(rs.getString("content"));
                reply.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(reply);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void addReply(IssueReply reply) {
        String sql = "INSERT INTO IssueReplies (issue_id, replier_id, content, created_at) VALUES (?, ?, ?, GETDATE())";
        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, reply.getIssueId());
            stmt.setInt(2, reply.getReplierId());
            stmt.setString(3, reply.getContent());
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateComplaintStatusPriorityAssigned(int issueId, String status, String priority, Integer assignedTo) {
        String sql = "UPDATE Issues SET status = ?, priority = ?, order_id = ? WHERE issue_id = ?";

        try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, priority);

            if (assignedTo != null) {
                stmt.setInt(3, assignedTo);
            } else {
                stmt.setNull(3, Types.INTEGER);
            }

            stmt.setInt(4, issueId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
