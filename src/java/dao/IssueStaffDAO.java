package dao;

import model.IssueStaff;
import utils.DBConnection; 
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class IssueStaffDAO {

    private static final String SELECT_ISSUES_PAGINATED =
            "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at " +
            "FROM [dbo].[Issues] i " +
            "JOIN [dbo].[Users] u ON i.user_id = u.user_id " +
            "WHERE 1=1 ";

    private static final String COUNT_ISSUES =
            "SELECT COUNT(i.issue_id) FROM [dbo].[Issues] i " +
            "JOIN [dbo].[Users] u ON i.user_id = u.user_id " +
            "WHERE 1=1 ";

    private static final String SELECT_ISSUE_BY_ID =
            "SELECT i.issue_id, i.user_id, u.username, i.description, i.status, i.priority, i.created_at, i.resolved_at " +
            "FROM [dbo].[Issues] i " +
            "JOIN [dbo].[Users] u ON i.user_id = u.user_id " +
            "WHERE i.issue_id = ?";

    private static final String UPDATE_ISSUE_STATUS_AND_PRIORITY =
            "UPDATE [dbo].[Issues] SET status = ?, priority = ?, resolved_at = ? " +
            "WHERE issue_id = ?";

   

    public int getTotalIssues(String searchTerm, String statusFilter, String priorityFilter) throws SQLException {
        int total = 0;
        StringBuilder query = new StringBuilder(COUNT_ISSUES);
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query.append("AND (u.username LIKE ? OR i.description LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            query.append("AND i.status = ? ");
            params.add(statusFilter);
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            query.append("AND i.priority = ? ");
            params.add(priorityFilter);
        }

        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    total = rs.getInt(1);
                }
            }
        }
        return total;
    }

    public List<IssueStaff> getAllIssues(int offset, int noOfRecords, String searchTerm, String statusFilter, String priorityFilter) throws SQLException {
        List<IssueStaff> issues = new ArrayList<>();
        StringBuilder query = new StringBuilder(SELECT_ISSUES_PAGINATED);
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            query.append("AND (u.username LIKE ? OR i.description LIKE ?) ");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }
        if (statusFilter != null && !statusFilter.trim().isEmpty()) {
            query.append("AND i.status = ? ");
            params.add(statusFilter);
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            query.append("AND i.priority = ? ");
            params.add(priorityFilter);
        }

        query.append("ORDER BY i.created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(noOfRecords);

        try (Connection conn = DBConnection.getConnection(); // Sử dụng DBConnection
             PreparedStatement pstmt = conn.prepareStatement(query.toString())) {

            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    IssueStaff issue = new IssueStaff();
                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setUserId(rs.getInt("user_id"));
                    issue.setUsername(rs.getString("username"));
                    issue.setDescription(rs.getString("description"));
                    issue.setStatus(rs.getString("status"));
                    issue.setPriority(rs.getString("priority"));
                    issue.setCreatedAt(rs.getTimestamp("created_at"));
                    issue.setResolvedAt(rs.getTimestamp("resolved_at"));
                    issues.add(issue);
                }
            }
        }
        return issues;
    }

    public IssueStaff getIssueById(int issueId) throws SQLException {
        IssueStaff issue = null;
        try (Connection conn = DBConnection.getConnection(); // Sử dụng DBConnection
             PreparedStatement pstmt = conn.prepareStatement(SELECT_ISSUE_BY_ID)) {
            pstmt.setInt(1, issueId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    issue = new IssueStaff();
                    issue.setIssueId(rs.getInt("issue_id"));
                    issue.setUserId(rs.getInt("user_id"));
                    issue.setUsername(rs.getString("username"));
                    issue.setDescription(rs.getString("description"));
                    issue.setStatus(rs.getString("status"));
                    issue.setPriority(rs.getString("priority"));
                    issue.setCreatedAt(rs.getTimestamp("created_at"));
                    issue.setResolvedAt(rs.getTimestamp("resolved_at"));
                }
            }
        }
        return issue;
    }

    public boolean updateIssueStatusAndPriority(int issueId, String newStatus, String newPriority) throws SQLException {
        Timestamp resolvedAt = null;
        if ("resolved".equalsIgnoreCase(newStatus)) {
            resolvedAt = new Timestamp(System.currentTimeMillis());
        }

        try (Connection conn = DBConnection.getConnection(); // Sử dụng DBConnection
             PreparedStatement pstmt = conn.prepareStatement(UPDATE_ISSUE_STATUS_AND_PRIORITY)) {
            pstmt.setString(1, newStatus);
            pstmt.setString(2, newPriority);
            pstmt.setTimestamp(3, resolvedAt);
            pstmt.setInt(4, issueId);
            return pstmt.executeUpdate() > 0;
        }
    }
}