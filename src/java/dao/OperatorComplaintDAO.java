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
                    c.setAssignedTo(rs.getObject("assigned_to", Integer.class)); // Sử dụng getObject cho Integer
                    c.setAssignedToUsername(rs.getString("assigned_to_username"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return c;
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
            sql.append("AND (LOWER(u.username) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(u2.username) LIKE ? OR CAST(i.issue_id AS NVARCHAR(MAX)) LIKE ?) "); // Thêm tìm kiếm theo issue_id
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) { // Thêm điều kiện 'all'
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
                ps.setString(index++, likeTerm); // Cho issue_id
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
        }
        return count;
    }

    public boolean assignComplaintToOperator(int issueId, int operatorUserId) {
        String sql = "UPDATE Issues SET assigned_to = ?, status = 'in_progress', resolved_at = NULL WHERE issue_id = ?"; // Đặt resolved_at về NULL khi được giao
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, operatorUserId);
            ps.setInt(2, issueId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Cập nhật trạng thái, mức độ ưu tiên và operator được gán cho một khiếu nại.
     * Lưu ý: Phương thức này KHÔNG lưu replyContent vào DB.
     * Nếu muốn lưu, cần thêm cột reply_content vào bảng Issues.
     */
    public boolean updateOperatorComplaint(int issueId, String status, String priority, Integer assignedTo) {
        StringBuilder sql = new StringBuilder("UPDATE Issues SET status = ?, priority = ?");

        // Cập nhật assigned_to chỉ khi nó được cung cấp (không null)
        if (assignedTo != null) {
            sql.append(", assigned_to = ?");
        } else {
            sql.append(", assigned_to = NULL"); // Đặt assigned_to là NULL nếu không được gán
        }

        // Cập nhật resolved_at nếu trạng thái là 'resolved' hoặc 'closed'
        if ("resolved".equalsIgnoreCase(status) || "closed".equalsIgnoreCase(status)) {
            sql.append(", resolved_at = GETDATE()");
        } else {
            sql.append(", resolved_at = NULL"); // Đảm bảo resolved_at là NULL nếu trạng thái thay đổi
        }

        sql.append(" WHERE issue_id = ?");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            ps.setString(index++, status);
            ps.setString(index++, priority);

            if (assignedTo != null) {
                ps.setInt(index++, assignedTo);
            }
            ps.setInt(index, issueId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("Error updating complaint for operator: " + e.getMessage());
            return false;
        }
    }

    public List<UserComplaint> getOperators() {
        List<UserComplaint> operators = new ArrayList<>();
        // !!! QUAN TRỌNG: Thay thế '2' bằng role_id thực tế của Operator trong database của bạn !!!
        // (Nếu vai trò Operator có role_id khác 2, hãy thay đổi số này)
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
        }
        return operators;
    }
}