package dao;

import model.Complaint;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Lấy tất cả khiếu nại với tìm kiếm, lọc và phân trang (cho Staff)
    public List<Complaint> getAllComplaints(String searchTerm, String statusFilter, String priorityFilter, int offset, int limit) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.issue_id, i.user_id, u.username AS creator_username, ");
        sql.append("i.description, i.status, i.priority, i.created_at, i.resolved_at, ");
        sql.append("i.assigned_to, au.username AS assigned_to_username ");
        sql.append("FROM Issues i ");
        sql.append("JOIN Users u ON i.user_id = u.user_id ");
        sql.append("LEFT JOIN Users au ON i.assigned_to = au.user_id ");
        sql.append("WHERE 1=1"); // Mẹo để dễ dàng thêm điều kiện WHERE

        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR i.description LIKE ? OR i.issue_id LIKE ?)");
            String likeTerm = "%" + searchTerm + "%";
            params.add(likeTerm);
            params.add(likeTerm);
            params.add(likeTerm);
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("all")) {
            sql.append(" AND i.status = ?");
            params.add(statusFilter);
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
            sql.append(" AND i.priority = ?");
            params.add(priorityFilter);
        }

        sql.append(" ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Complaint complaint = new Complaint(
                            rs.getInt("issue_id"),
                            rs.getInt("user_id"),
                            rs.getString("creator_username"),
                            rs.getString("description"),
                            rs.getString("status"),
                            rs.getString("priority"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("resolved_at"),
                            (Integer) rs.getObject("assigned_to"), // Sử dụng getObject cho Integer có thể null
                            rs.getString("assigned_to_username")
                    );
                    complaints.add(complaint);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return complaints;
    }

    // Lấy tổng số khiếu nại (cho Staff)
    public int getTotalComplaintCount(String searchTerm, String statusFilter, String priorityFilter) {
        int total = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR i.description LIKE ? OR i.issue_id LIKE ?)");
            String likeTerm = "%" + searchTerm + "%";
            params.add(likeTerm);
            params.add(likeTerm);
            params.add(likeTerm);
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("all")) {
            sql.append(" AND i.status = ?");
            params.add(statusFilter);
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
            sql.append(" AND i.priority = ?");
            params.add(priorityFilter);
        }

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return total;
    }

    // Lấy chi tiết khiếu nại theo ID (cho Staff)
    public Complaint getComplaintById(int issueId) {
        Complaint complaint = null;
        String sql = "SELECT i.issue_id, i.user_id, u.username AS creator_username, i.description, i.status, i.priority, "
                + "i.created_at, i.resolved_at, i.assigned_to, au.username AS assigned_to_username "
                + "FROM Issues i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "LEFT JOIN Users au ON i.assigned_to = au.user_id "
                + "WHERE i.issue_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    complaint = new Complaint(
                            rs.getInt("issue_id"),
                            rs.getInt("user_id"),
                            rs.getString("creator_username"),
                            rs.getString("description"),
                            rs.getString("status"),
                            rs.getString("priority"),
                            rs.getTimestamp("created_at"),
                            rs.getTimestamp("resolved_at"),
                            (Integer) rs.getObject("assigned_to"),
                            rs.getString("assigned_to_username")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return complaint;
    }

    // Cập nhật trạng thái và mức độ ưu tiên của khiếu nại (cho Staff)
    // Lưu ý: Đã loại bỏ escalationReason và escalatedByUserId do không có trong DB của bạn.
    // Nếu bạn muốn hỗ trợ replyContent, bạn cần thêm cột reply_content vào bảng Issues.
    public boolean updateComplaintStatusAndPriority(int issueId, String newStatus, String newPriority, String replyContent, Integer staffId) {
        String sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = GETDATE() WHERE issue_id = ?";
        // Nếu bạn muốn lưu replyContent, bạn cần thêm cột vào DB và chỉnh sửa SQL
        // String sql = "UPDATE Issues SET status = ?, priority = ?, reply_content = ?, resolved_at = GETDATE() WHERE issue_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setString(2, newPriority);
            // Nếu có replyContent: ps.setString(3, replyContent);
            ps.setInt(3, issueId); // Nếu có replyContent: ps.setInt(4, issueId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
            return false;
        }
    }

    // Phương thức thêm khiếu nại mới (nếu bạn cần Staff tạo khiếu nại)
    public boolean addComplaint(Complaint complaint) {
        String sql = "INSERT INTO Issues (user_id, description, status, priority, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, complaint.getUserId());
            ps.setString(2, complaint.getDescription());
            ps.setString(3, complaint.getStatus());
            ps.setString(4, complaint.getPriority());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        complaint.setIssueId(rs.getInt(1));
                    }
                }
                return true;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());
        }
        return false;
    }
}