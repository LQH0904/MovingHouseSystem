package dao;

import model.OperatorComplaint;
import model.UserComplaint; // Đã đổi từ model.User sang model.UserComplaint
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
            sql.append("AND (LOWER(u.username) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(u2.username) LIKE ?) ");
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            sql.append("AND LOWER(i.priority) = ? ");
        }
        sql.append("ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(index++, "%" + searchTerm.toLowerCase() + "%");
                ps.setString(index++, "%" + searchTerm.toLowerCase() + "%");
                ps.setString(index++, "%" + searchTerm.toLowerCase() + "%");
            }
            if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
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
            sql.append("AND (LOWER(u.username) LIKE ? OR LOWER(i.description) LIKE ? OR LOWER(u2.username) LIKE ?) ");
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            sql.append("AND LOWER(i.priority) = ? ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int index = 1;
            if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                ps.setString(index++, "%" + searchTerm.toLowerCase() + "%");
                ps.setString(index++, "%" + searchTerm.toLowerCase() + "%");
                ps.setString(index++, "%" + searchTerm.toLowerCase() + "%");
            }
            if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
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
        String sql = "UPDATE Issues SET assigned_to = ?, status = 'in_progress' WHERE issue_id = ?";
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

    public List<UserComplaint> getOperators() { // Đã đổi kiểu trả về
        List<UserComplaint> operators = new ArrayList<>();
        // !!! QUAN TRỌNG: Thay thế '2' bằng role_id thực tế của Operator trong database của bạn !!!
        String sql = "SELECT user_id, username FROM Users WHERE role_id = 2 AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    UserComplaint operator = new UserComplaint(); // Đã đổi đối tượng được tạo
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