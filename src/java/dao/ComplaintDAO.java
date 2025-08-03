package dao;

import model.Complaint;
import model.IssueReply;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Lấy danh sách khiếu nại với các bộ lọc
    public List<Complaint> getAllComplaints(String searchTerm, String statusFilter, String priorityFilter,
            String startDateStr, String endDateStr, String minIdStr, String maxIdStr,
            int offset, int limit) {
        List<Complaint> complaints = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT i.issue_id, i.user_id, u.username AS creator_username, ");
        sql.append("i.description, i.status, i.priority, i.created_at, i.resolved_at ");
        sql.append("FROM Issues i ");
        sql.append("JOIN Users u ON i.user_id = u.user_id ");
        sql.append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Thêm các điều kiện lọc
        addIdFilterConditions(sql, params, minIdStr, maxIdStr);
        addSearchCondition(sql, params, searchTerm);
        addStatusFilter(sql, params, statusFilter);
        addPriorityFilter(sql, params, priorityFilter);
        addDateFilters(sql, params, startDateStr, endDateStr);

        sql.append(" ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            setParameters(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    complaints.add(mapComplaintFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    // Đếm tổng số khiếu nại với bộ lọc
    public int getTotalComplaintCount(String searchTerm, String statusFilter, String priorityFilter,
            String startDateStr, String endDateStr, String minIdStr, String maxIdStr) {
        int total = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        // Thêm các điều kiện lọc
        addIdFilterConditions(sql, params, minIdStr, maxIdStr);
        addSearchCondition(sql, params, searchTerm);
        addStatusFilter(sql, params, statusFilter);
        addPriorityFilter(sql, params, priorityFilter);
        addDateFilters(sql, params, startDateStr, endDateStr);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            setParameters(ps, params);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return total;
    }

    // Lấy thông tin khiếu nại theo ID
    public Complaint getComplaintById(int issueId) {
        String sql = "SELECT i.issue_id, i.user_id, u.username AS creator_username, i.description, i.status, i.priority, "
                + "i.created_at, i.resolved_at "
                + "FROM Issues i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.issue_id = ?";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapComplaintFromResultSet(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy danh sách phản hồi theo issueId
    public List<IssueReply> getRepliesByIssueId(int issueId) {
        List<IssueReply> replies = new ArrayList<>();
        String sql = "SELECT r.reply_id, r.issue_id, r.sender_id AS replier_id, "
                + "u.username AS replier_name, r.message AS reply_content, "
                + "r.replied_at, r.message_for_issue "
                + "FROM IssueReplies r JOIN Users u ON r.sender_id = u.user_id "
                + "WHERE r.issue_id = ? ORDER BY r.replied_at ASC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    replies.add(mapIssueReplyFromResultSet(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
    }

    // Kiểm tra xem issue đã có phản hồi chưa
    public boolean hasReplies(int issueId) {
        String sql = "SELECT COUNT(*) FROM IssueReplies WHERE issue_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Lấy tên người phản hồi gần nhất
    public String getResponderName(int issueId) {
        String sql = "SELECT TOP 1 u.username FROM IssueReplies r "
                + "JOIN Users u ON r.sender_id = u.user_id "
                + "WHERE r.issue_id = ? ORDER BY r.replied_at DESC";

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("username");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật trạng thái và mức độ ưu tiên của khiếu nại
    public boolean updateComplaintStatusAndPriority(int issueId, String status, String priority) {
        String sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = ? WHERE issue_id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

            pstmt.setString(1, status);
            pstmt.setString(2, priority);
            pstmt.setTimestamp(3, "resolved".equals(status) ? new Timestamp(System.currentTimeMillis()) : null);
            pstmt.setInt(4, issueId);

            return pstmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Các phương thức hỗ trợ
    private Complaint mapComplaintFromResultSet(ResultSet rs) throws SQLException {
        Complaint complaint = new Complaint();
        complaint.setIssueId(rs.getInt("issue_id"));
        complaint.setUserId(rs.getInt("user_id"));
        complaint.setUsername(rs.getString("creator_username"));
        complaint.setDescription(rs.getString("description"));
        complaint.setStatus(rs.getString("status"));
        complaint.setPriority(rs.getString("priority"));
        complaint.setCreatedAt(rs.getTimestamp("created_at"));
        complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
        return complaint;
    }

    private IssueReply mapIssueReplyFromResultSet(ResultSet rs) throws SQLException {
    IssueReply reply = new IssueReply();
    reply.setReplyId(rs.getInt("reply_id"));
    reply.setIssueId(rs.getInt("issue_id"));
    reply.setReplierId(rs.getInt("replier_id"));
    reply.setReplierName(rs.getString("replier_name")); // Thêm dòng này
    reply.setReplyContent(rs.getString("reply_content"));
    reply.setRepliedAt(rs.getTimestamp("replied_at"));
    reply.setMessage_for_issue(rs.getString("message_for_issue"));
    return reply;
}

    private void addIdFilterConditions(StringBuilder sql, List<Object> params, String minIdStr, String maxIdStr) {
        if (minIdStr != null && !minIdStr.trim().isEmpty()) {
            try {
                int minId = Integer.parseInt(minIdStr);
                sql.append(" AND i.issue_id >= ?");
                params.add(minId);
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }
        if (maxIdStr != null && !maxIdStr.trim().isEmpty()) {
            try {
                int maxId = Integer.parseInt(maxIdStr);
                sql.append(" AND i.issue_id <= ?");
                params.add(maxId);
            } catch (NumberFormatException e) {
                // Ignore invalid input
            }
        }
    }

    private void addSearchCondition(StringBuilder sql, List<Object> params, String searchTerm) {
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR i.description LIKE ? OR CAST(i.issue_id AS NVARCHAR) LIKE ?)");
            String likeTerm = "%" + searchTerm + "%";
            params.add(likeTerm);
            params.add(likeTerm);
            params.add(likeTerm);
        }
    }

    private void addStatusFilter(StringBuilder sql, List<Object> params, String statusFilter) {
        if (statusFilter != null && !statusFilter.trim().isEmpty() && !statusFilter.equals("all")) {
            sql.append(" AND i.status = ?");
            params.add(statusFilter);
        }
    }

    private void addPriorityFilter(StringBuilder sql, List<Object> params, String priorityFilter) {
        if (priorityFilter != null && !priorityFilter.trim().isEmpty() && !priorityFilter.equals("all")) {
            sql.append(" AND i.priority = ?");
            params.add(priorityFilter);
        }
    }

    private void addDateFilters(StringBuilder sql, List<Object> params, String startDateStr, String endDateStr) {
        if (startDateStr != null && !startDateStr.isEmpty()) {
            sql.append(" AND i.created_at >= ?");
            params.add(Timestamp.valueOf(startDateStr + " 00:00:00"));
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            sql.append(" AND i.created_at <= ?");
            params.add(Timestamp.valueOf(endDateStr + " 23:59:59"));
        }
    }

    private void setParameters(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }
    
}
