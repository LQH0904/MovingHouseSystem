// File: src/main/java/dao/ComplaintDAO.java
package dao;

import model.Complaint;
import utils.DBConnection; // Đảm bảo import đúng DBConnection của bạn
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ComplaintDAO {

    private static final Logger LOGGER = Logger.getLogger(ComplaintDAO.class.getName());

    public ComplaintDAO() {
        // Constructor rỗng
    }

    // Phương thức trợ giúp để lấy kết nối
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Phương thức để lấy một khiếu nại theo ID (sử dụng cho cả xem chi tiết và phản hồi)
    public Complaint getComplaintById(int issueId) {
        Complaint complaint = null;
        String sql = "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at, i.escalation_reason, i.escalated_by_user_id " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id " +
                     "WHERE i.issue_id = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
                    complaint.setUserId(rs.getInt("user_id"));
                    complaint.setUsername(rs.getString("username"));
                    complaint.setDescription(rs.getString("description"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setPriority(rs.getString("priority"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                    complaint.setEscalationReason(rs.getString("escalation_reason"));
                    Object escalatedByUserIdObj = rs.getObject("escalated_by_user_id");
                    if (escalatedByUserIdObj != null) {
                        complaint.setEscalatedByUserId(rs.getInt("escalated_by_user_id"));
                    } else {
                        complaint.setEscalatedByUserId(null);
                    }
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in ComplaintDAO.getComplaintById: " + e.getMessage(), e);
        }
        return complaint;
    }

    // Phương thức để cập nhật trạng thái và ưu tiên của khiếu nại (có xử lý escalation_reason và escalated_by_user_id)
    public boolean updateComplaintStatusAndPriority(int issueId, String status, String priority, String escalationReason, Integer escalatedByUserId) {
        String sql;
        if ("resolved".equalsIgnoreCase(status)) {
            sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = GETDATE(), escalation_reason = NULL, escalated_by_user_id = NULL WHERE issue_id = ?";
        } else if ("escalated".equalsIgnoreCase(status)) {
            sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = NULL, escalation_reason = ?, escalated_by_user_id = ? WHERE issue_id = ?";
        } else {
            sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = NULL, escalation_reason = NULL, escalated_by_user_id = NULL WHERE issue_id = ?";
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, priority);

            int paramIndex = 3;
            if ("resolved".equalsIgnoreCase(status)) {
                // No special parameters for resolved
            } else if ("escalated".equalsIgnoreCase(status)) {
                ps.setString(paramIndex++, escalationReason);
                if (escalatedByUserId != null) {
                    ps.setInt(paramIndex++, escalatedByUserId);
                } else {
                    ps.setNull(paramIndex++, java.sql.Types.INTEGER);
                }
            }
            ps.setInt(paramIndex, issueId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in ComplaintDAO.updateComplaintStatusAndPriority for issueId " + issueId + ": " + e.getMessage(), e);
            return false;
        }
    }

    // --- Các phương thức dành cho ComplaintServlet (hiển thị danh sách tổng quát) ---

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
            LOGGER.log(Level.SEVERE, "Database error in getAllComplaints: " + e.getMessage(), e);
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
                }
            }

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error in getTotalComplaintCount: " + e.getMessage(), e);
        }
        return count;
    }

    // --- Các phương thức dành cho OperatorComplaintServlet (chỉ các khiếu nại đã chuyển cấp cao) ---

    // Lấy tất cả khiếu nại CÓ TRẠNG THÁI LÀ 'escalated'
    public List<Complaint> getEscalatedComplaints(String searchTerm, String priorityFilter, int offset, int recordsPerPage) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at, i.escalation_reason, i.escalated_by_user_id " +
                                             "FROM Issues i " +
                                             "JOIN Users u ON i.user_id = u.user_id " +
                                             "WHERE i.status = 'escalated'");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            try {
                int issueId = Integer.parseInt(searchTerm);
                sql.append(" AND i.issue_id = ? ");
                params.add(issueId);
            } catch (NumberFormatException e) {
                sql.append(" AND (u.username LIKE ? OR i.description LIKE ?)");
                params.add("%" + searchTerm + "%");
                params.add("%" + searchTerm + "%");
            }
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            sql.append(" AND i.priority = ?");
            params.add(priorityFilter);
        }

        sql.append(" ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(recordsPerPage);

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(i++, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i++, (Integer) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
                    complaint.setUserId(rs.getInt("user_id"));
                    complaint.setUsername(rs.getString("username"));
                    complaint.setDescription(rs.getString("description"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setPriority(rs.getString("priority"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                    complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                    complaint.setEscalationReason(rs.getString("escalation_reason"));
                    Object escalatedByUserIdObj = rs.getObject("escalated_by_user_id");
                    if (escalatedByUserIdObj != null) {
                        complaint.setEscalatedByUserId(rs.getInt("escalated_by_user_id"));
                    } else {
                        complaint.setEscalatedByUserId(null);
                    }
                    complaints.add(complaint);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in ComplaintDAO.getEscalatedComplaints: " + e.getMessage(), e);
        }
        return complaints;
    }

    // Đếm tổng số khiếu nại CÓ TRẠNG THÁI LÀ 'escalated'
    public int getTotalEscalatedComplaintCount(String searchTerm, String priorityFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE i.status = 'escalated'");

        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            try {
                int issueId = Integer.parseInt(searchTerm);
                sql.append(" AND i.issue_id = ? ");
                params.add(issueId);
            } catch (NumberFormatException e) {
                sql.append(" AND (u.username LIKE ? OR i.description LIKE ?)");
                params.add("%" + searchTerm + "%");
                params.add("%" + searchTerm + "%");
            }
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            sql.append(" AND i.priority = ?");
            params.add(priorityFilter);
        }

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int i = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(i++, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i++, (Integer) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error in ComplaintDAO.getTotalEscalatedComplaintCount: " + e.getMessage(), e);
        }
        return count;
    }
}