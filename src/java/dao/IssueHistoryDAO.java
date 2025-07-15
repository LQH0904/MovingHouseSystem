package dao;

import model.IssueHistory;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public class IssueHistoryDAO {

    public List<IssueHistory> getHistoryByIssueId(int issueId) throws SQLException {
        List<IssueHistory> historyList = new ArrayList<>();
        String SQL = "SELECT history_id, issue_id, staff_id, action_type, description, created_at FROM [dbo].[IssueHistory] WHERE issue_id = ? ORDER BY created_at ASC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, issueId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    IssueHistory history = new IssueHistory();
                    history.setHistoryId(rs.getInt("history_id"));
                    history.setIssueId(rs.getInt("issue_id"));
                    history.setStaffId(rs.getInt("staff_id"));
                    history.setActionType(rs.getString("action_type"));
                    history.setDescription(rs.getString("description"));
                    history.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    historyList.add(history);
                }
            }
        }
        return historyList;
    }

    public boolean createIssueHistory(IssueHistory history) throws SQLException {
        String SQL = "INSERT INTO [dbo].[IssueHistory] (issue_id, staff_id, action_type, description, created_at) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, history.getIssueId());
            pstmt.setInt(2, history.getStaffId());
            pstmt.setString(3, history.getActionType());
            pstmt.setString(4, history.getDescription());
            pstmt.setTimestamp(5, Timestamp.valueOf(history.getCreatedAt()));
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}
