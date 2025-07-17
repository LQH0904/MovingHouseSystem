package dao;

import model.Issue;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class IssueDAO {

    public int createIssue(Issue issue) throws SQLException {
        String SQL = "INSERT INTO [dbo].[Issues] (user_id, order_id, description, status, priority, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        int generatedId = -1;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, issue.getUserId());
            pstmt.setInt(2, issue.getOrderId());
            pstmt.setString(3, issue.getDescription());
            pstmt.setString(4, issue.getStatus());
            pstmt.setString(5, issue.getPriority());
            pstmt.setTimestamp(6, Timestamp.valueOf(issue.getCreatedAt()));

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        }
        return generatedId;
    }

    public Issue getIssueById(int issueId) throws SQLException {
        String SQL = "SELECT issue_id, user_id, order_id, description, status, priority, created_at, resolved_at FROM [dbo].[Issues] WHERE issue_id = ?";
        Issue issue = null;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, issueId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    issue = new Issue();
                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setUserId(rs.getInt("user_id"));
                    issue.setOrderId(rs.getInt("order_id"));
                    issue.setDescription(rs.getString("description"));
                    issue.setStatus(rs.getString("status"));
                    issue.setPriority(rs.getString("priority"));
                    issue.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    if (rs.getTimestamp("resolved_at") != null) {
                        issue.setResolvedAt(rs.getTimestamp("resolved_at").toLocalDateTime());
                    }
                }
            }
        }
        return issue;
    }

    public List<Issue> getIssuesByUserId(int userId) throws SQLException {
        List<Issue> issues = new ArrayList<>();
        String SQL = "SELECT issue_id, user_id, order_id, description, status, priority, created_at, resolved_at FROM [dbo].[Issues] WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, userId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Issue issue = new Issue();
                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setUserId(rs.getInt("user_id"));
                    issue.setOrderId(rs.getInt("order_id"));
                    issue.setDescription(rs.getString("description"));
                    issue.setStatus(rs.getString("status"));
                    issue.setPriority(rs.getString("priority"));
                    issue.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    if (rs.getTimestamp("resolved_at") != null) {
                        issue.setResolvedAt(rs.getTimestamp("resolved_at").toLocalDateTime());
                    }
                    issues.add(issue);
                }
            }
        }
        return issues;
    }

    public List<Issue> getFilteredIssues(String status, String priority, Integer orderId, Integer userId, LocalDateTime startDate, LocalDateTime endDate) throws SQLException {
        List<Issue> issues = new ArrayList<>();
        StringBuilder SQL = new StringBuilder("SELECT issue_id, user_id, order_id, description, status, priority, created_at, resolved_at FROM [dbo].[Issues] WHERE 1=1");

        List<Object> params = new ArrayList<>();

        if (status != null && !status.isEmpty()) {
            SQL.append(" AND status = ?");
            params.add(status);
        }
        if (priority != null && !priority.isEmpty()) {
            SQL.append(" AND priority = ?");
            params.add(priority);
        }
        if (orderId != null && orderId > 0) {
            SQL.append(" AND order_id = ?");
            params.add(orderId);
        }
        if (userId != null && userId > 0) {
            SQL.append(" AND user_id = ?");
            params.add(userId);
        }
        if (startDate != null) {
            SQL.append(" AND created_at >= ?");
            params.add(Timestamp.valueOf(startDate));
        }
        if (endDate != null) {
            SQL.append(" AND created_at <= ?");
            params.add(Timestamp.valueOf(endDate));
        }

        SQL.append(" ORDER BY created_at DESC");

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    pstmt.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    pstmt.setInt(i + 1, (Integer) param);
                } else if (param instanceof Timestamp) {
                    pstmt.setTimestamp(i + 1, (Timestamp) param);
                }
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    Issue issue = new Issue();
                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setUserId(rs.getInt("user_id"));
                    issue.setOrderId(rs.getInt("order_id"));
                    issue.setDescription(rs.getString("description"));
                    issue.setStatus(rs.getString("status"));
                    issue.setPriority(rs.getString("priority"));
                    issue.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    if (rs.getTimestamp("resolved_at") != null) {
                        issue.setResolvedAt(rs.getTimestamp("resolved_at").toLocalDateTime());
                    }
                    issues.add(issue);
                }
            }
        }
        return issues;
    }

    public boolean updateIssueStatus(int issueId, String newStatus) throws SQLException {
        String SQL = "UPDATE [dbo].[Issues] SET status = ? WHERE issue_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, newStatus);
            pstmt.setInt(2, issueId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }

    // ✅ Hàm mới: Cập nhật status, priority và resolved_at nếu status = resolved
    public boolean updateStatusPriority(int issueId, String newStatus, String newPriority) throws SQLException {
        String SQL;
        if ("resolved".equalsIgnoreCase(newStatus)) {
            SQL = "UPDATE [dbo].[Issues] SET status = ?, priority = ?, resolved_at = ? WHERE issue_id = ?";
        } else {
            SQL = "UPDATE [dbo].[Issues] SET status = ?, priority = ? WHERE issue_id = ?";
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setString(1, newStatus);
            pstmt.setString(2, newPriority);
            if ("resolved".equalsIgnoreCase(newStatus)) {
                pstmt.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()));
                pstmt.setInt(4, issueId);
            } else {
                pstmt.setInt(3, issueId);
            }
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}
