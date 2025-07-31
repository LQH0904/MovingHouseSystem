package dao;

import model.IssueLog;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public class IssueLogDAO {

    public List<IssueLog> getLogsByIssueId(int issueId) throws SQLException {
        List<IssueLog> logList = new ArrayList<>();
        String SQL = "SELECT log_id, issue_id, action, created_at, created_by, details FROM [dbo].[IssueLogs] WHERE issue_id = ? ORDER BY created_at ASC";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, issueId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    IssueLog log = new IssueLog();
                    log.setLogId(rs.getInt("log_id"));
                    log.setIssueId(rs.getInt("issue_id"));
                    log.setAction(rs.getString("action"));
                    log.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    log.setCreatedBy(rs.getInt("created_by"));
                    log.setDetails(rs.getString("details"));
                    logList.add(log);
                }
            }
        }
        return logList;
    }

    public boolean createIssueLog(IssueLog log) throws SQLException {
        String SQL = "INSERT INTO [dbo].[IssueLogs] (issue_id, action, created_at, created_by, details) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, log.getIssueId());
            pstmt.setString(2, log.getAction());
            pstmt.setTimestamp(3, Timestamp.valueOf(log.getCreatedAt()));
            pstmt.setInt(4, log.getCreatedBy());
            pstmt.setString(5, log.getDetails());
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}
