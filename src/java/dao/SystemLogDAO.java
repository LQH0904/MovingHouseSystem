package dao;

import model.SystemLog;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

public class SystemLogDAO {

    public boolean createSystemLog(SystemLog systemLog) throws SQLException {
        String SQL = "INSERT INTO [dbo].[SystemLogs] (user_id, action, timestamp, details) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, systemLog.getUserId());
            pstmt.setString(2, systemLog.getAction());
            pstmt.setTimestamp(3, new Timestamp(systemLog.getTimestamp().getTime()));
            pstmt.setString(4, systemLog.getDetails());
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}
