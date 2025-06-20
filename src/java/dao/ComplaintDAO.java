package dao;

import model.Complaint;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private Connection getConnection() throws SQLException {
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
                }
            }
            stmt.setInt(i++, offset);
            stmt.setInt(i++, limit);

            System.out.println("ComplaintDAO: Executing getAllComplaints SQL: " + sql.toString());
            System.out.println("ComplaintDAO: Parameters: " + params + ", Offset: " + offset + ", Limit: " + limit);

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
                }
            }

            System.out.println("ComplaintDAO: Executing getTotalComplaintCount SQL: " + sql.toString());
            System.out.println("ComplaintDAO: Parameters: " + params);

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
        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at, i.escalation_reason, i.escalated_by_user_id " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id " +
                     "WHERE i.issue_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);
            System.out.println("ComplaintDAO: Executing getComplaintById SQL for issueId: " + issueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
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
            System.err.println("Database error in getComplaintById: " + e.getMessage());
            e.printStackTrace();
        }
        return complaint;
    }

    public boolean updateComplaintStatusAndPriority(int issueId, String status, String priority) {
        System.out.println("ComplaintDAO: Calling old updateComplaintStatusAndPriority. Consider updating callers to use the new method.");
        return updateComplaintStatusAndPriority(issueId, status, priority, null, null);
    }

    public boolean updateComplaintStatusAndPriority(int issueId, String status, String priority, String escalationReason, Integer escalatedByUserId) {
        String sql;
        if ("resolved".equalsIgnoreCase(status)) {
            // Khi resolved, xóa lý do và người chuyển cấp cao
            sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = GETDATE(), escalation_reason = NULL, escalated_by_user_id = NULL WHERE issue_id = ?";
        } else if ("escalated".equalsIgnoreCase(status)) {
            // Khi escalated, cập nhật lý do và người chuyển cấp cao, reset resolved_at
            sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = NULL, escalation_reason = ?, escalated_by_user_id = ? WHERE issue_id = ?";
        } else {
            // Các trạng thái khác, reset resolved_at, lý do và người chuyển cấp cao
            sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = NULL, escalation_reason = NULL, escalated_by_user_id = NULL WHERE issue_id = ?";
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, priority);

            int paramIndex = 3;
            if ("resolved".equalsIgnoreCase(status)) {
                // Không cần thêm tham số
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

            System.out.println("ComplaintDAO: Cập nhật Issue ID " + issueId + " - Trạng thái: " + status + ", Ưu tiên: " + priority +
                               (escalationReason != null ? ", Lý do chuyển cấp cao: " + escalationReason : "") +
                               (escalatedByUserId != null ? ", Người chuyển cấp cao ID: " + escalatedByUserId : "") +
                               ". Số hàng bị ảnh hưởng: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in updateComplaintStatusAndPriority for issueId " + issueId + ": " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<Complaint> getEscalatedComplaints(String searchTerm, String priorityFilter, int offset, int limit) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at, i.escalation_reason, i.escalated_by_user_id ");
        sql.append("FROM Issues i ");
        sql.append("JOIN Users u ON i.user_id = u.user_id ");
        sql.append("WHERE i.status = 'escalated' "); // CHỈ LẤY CÁC KHIẾU NẠI CÓ TRẠNG THÁI 'escalated'

        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            try {
                int issueId = Integer.parseInt(searchTerm);
                sql.append("AND i.issue_id = ? ");
                params.add(issueId);
            } catch (NumberFormatException e) {
                sql.append("AND (u.username LIKE ? OR i.description LIKE ?) ");
                params.add("%" + searchTerm + "%");
                params.add("%" + searchTerm + "%");
            }
        }

        if (priorityFilter != null && !priorityFilter.isEmpty()) {
            sql.append("AND i.priority = ? ");
            params.add(priorityFilter);
        }

        sql.append("ORDER BY i.created_at DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            for (Object param : params) {
                if (param instanceof String) {
                    ps.setString(paramIndex++, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(paramIndex++, (Integer) param);
                }
            }
            ps.setInt(paramIndex++, offset);
            ps.setInt(paramIndex++, limit);


            System.out.println("ComplaintDAO: Executing getEscalatedComplaints SQL: " + sql.toString());
            System.out.println("ComplaintDAO: Parameters: " + params + ", Offset: " + offset + ", Limit: " + limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
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
            System.err.println("Database error in getEscalatedComplaints with filters: " + e.getMessage());
            e.printStackTrace();
        }
        return complaints;
    }

    public int getTotalEscalatedComplaintCount(String searchTerm, String priorityFilter) {
        int count = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE i.status = 'escalated' ");

        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            try {
                int issueId = Integer.parseInt(searchTerm);
                sql.append("AND i.issue_id = ? ");
                params.add(issueId);
            } catch (NumberFormatException e) {
                sql.append("AND (u.username LIKE ? OR i.description LIKE ?) ");
                params.add("%" + searchTerm + "%");
                params.add("%" + searchTerm + "%");
            }
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

            System.out.println("ComplaintDAO: Executing getTotalEscalatedComplaintCount SQL: " + sql.toString());
            System.out.println("ComplaintDAO: Parameters: " + params);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getTotalEscalatedComplaintCount: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
}