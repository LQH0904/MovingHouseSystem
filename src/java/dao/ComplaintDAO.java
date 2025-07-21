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

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR i.description LIKE ? OR CAST(i.issue_id AS NVARCHAR) LIKE ?)");
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
        if (startDateStr != null && !startDateStr.isEmpty()) {
            sql.append(" AND i.created_at >= ?");
            params.add(Timestamp.valueOf(startDateStr + " 00:00:00"));
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            sql.append(" AND i.created_at <= ?");
            params.add(Timestamp.valueOf(endDateStr + " 23:59:59"));
        }

        sql.append(" ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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
                            rs.getTimestamp("resolved_at")
                    );
                    complaints.add(complaint);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaints;
    }

    public int getTotalComplaintCount(String searchTerm, String statusFilter, String priorityFilter,
            String startDateStr, String endDateStr, String minIdStr, String maxIdStr) {
        int total = 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Issues i JOIN Users u ON i.user_id = u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

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

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (u.username LIKE ? OR i.description LIKE ? OR CAST(i.issue_id AS NVARCHAR) LIKE ?)");
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
        if (startDateStr != null && !startDateStr.isEmpty()) {
            sql.append(" AND i.created_at >= ?");
            params.add(Timestamp.valueOf(startDateStr + " 00:00:00"));
        }
        if (endDateStr != null && !endDateStr.isEmpty()) {
            sql.append(" AND i.created_at <= ?");
            params.add(Timestamp.valueOf(endDateStr + " 23:59:59"));
        }

        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
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
        }
        return total;
    }

    public Complaint getComplaintById(int issueId) {
        Complaint complaint = null;
        String sql = "SELECT i.issue_id, i.user_id, u.username AS creator_username, i.description, i.status, i.priority, "
                + "i.created_at, i.resolved_at "
                + "FROM Issues i "
                + "JOIN Users u ON i.user_id = u.user_id "
                + "WHERE i.issue_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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
                            rs.getTimestamp("resolved_at")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return complaint;
    }

    public List<IssueReply> getRepliesByIssueId(int issueId) {
        List<IssueReply> replies = new ArrayList<>();
        String sql = "SELECT r.reply_id, r.issue_id, r.sender_id AS replier_id, u.username AS replier_name, r.message AS reply_content, r.replied_at "
                + "FROM IssueReplies r JOIN Users u ON r.sender_id = u.user_id WHERE r.issue_id = ? ORDER BY r.replied_at ASC";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, issueId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    IssueReply reply = new IssueReply();
                    reply.setReplyId(rs.getInt("reply_id"));
                    reply.setIssueId(rs.getInt("issue_id"));
                    reply.setReplierId(rs.getInt("replier_id"));
                    reply.setReplyContent(rs.getString("reply_content"));
                    reply.setRepliedAt(rs.getTimestamp("replied_at"));
                    replies.add(reply);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return replies;
    }

    public boolean updateComplaintStatusAndPriority(int issueId, String status, String priority) {
        String sql = "UPDATE Issues SET status = ?, priority = ?, resolved_at = ? WHERE issue_id = ?";
        try (Connection conn = getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, status);
            pstmt.setString(2, priority);
            if ("resolved".equals(status)) {
                pstmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            } else {
                pstmt.setNull(3, Types.TIMESTAMP);
            }
            pstmt.setInt(4, issueId);

            int rows = pstmt.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public IssueReply getReplyById(int replyId) {
        String sql = "SELECT * FROM IssueReplies WHERE reply_id = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, replyId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                IssueReply reply = new IssueReply();
                reply.setReplyId(rs.getInt("reply_id"));
                reply.setIssueId(rs.getInt("issue_id"));
                reply.setReplierId(rs.getInt("replier_id"));
                reply.setReplyContent(rs.getString("content"));
                reply.setRepliedAt(rs.getTimestamp("created_at"));
                return reply;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
