package dao;

import model.Complaint;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private Connection getConnection() throws SQLException {
        // Đảm bảo DBConnection.getConnection() hoạt động và trả về kết nối hợp lệ
        return DBConnection.getConnection();
    }

    public List<Complaint> getAllComplaints(String searchTerm, String statusFilter, String priorityFilter, int offset, int limit) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at ");
        sql.append("FROM Issues i ");
        sql.append("JOIN Users u ON i.user_id = u.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (u.username LIKE ? OR i.description LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND i.status = ? ");
            params.add(statusFilter);
        }
        if (priorityFilter != null && !priorityFilter.isEmpty()) {
            sql.append("AND i.priority = ? ");
            params.add(priorityFilter);
        }

        sql.append("ORDER BY i.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    stmt.setString(i++, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i++, (Integer) param);
                }
            }
            stmt.setInt(i++, offset);
            stmt.setInt(i++, limit);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Complaint complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
                    complaint.setUsername(rs.getString("username"));
                    complaint.setDescription(rs.getString("description"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setPriority(rs.getString("priority"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaints.add(complaint);
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getAllComplaints: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }

    public int getTotalComplaintCount(String searchTerm, String statusFilter, String priorityFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append("AND (u.username LIKE ? OR i.description LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append("AND i.status = ? ");
            params.add(statusFilter);
        }
        if (priorityFilter != null && !priorityFilter.isEmpty()) {
            sql.append("AND i.priority = ? ");
            params.add(priorityFilter);
        }

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    stmt.setString(i++, (String) param);
                } else if (param instanceof Integer) {
                    stmt.setInt(i++, (Integer) param);
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getTotalComplaintCount: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }

    public Complaint getComplaintById(int issueId) {
        Complaint complaint = null;
        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id " +
                     "WHERE i.issue_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
                    complaint.setUsername(rs.getString("username"));
                    complaint.setDescription(rs.getString("description"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setPriority(rs.getString("priority"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getComplaintById: " + e.getMessage());
            e.printStackTrace();
        }
        return complaint;
    }

    public boolean updateComplaintStatus(int issueId, String status) {
        String sql = "UPDATE Issues SET status = ?, resolved_at = GETDATE() WHERE issue_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, issueId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in updateComplaintStatus for issueId " + issueId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}