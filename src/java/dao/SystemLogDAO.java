package dao;

import model.SystemLog;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SystemLogDAO {

    public void createSystemLog(SystemLog systemLog) {
        String SQL = "INSERT INTO [dbo].[SystemLogs] (user_id, action, timestamp, details, username) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, systemLog.getUserId());
            pstmt.setString(2, systemLog.getAction());
            pstmt.setTimestamp(3, new Timestamp(systemLog.getTimestamp().getTime()));
            pstmt.setString(4, systemLog.getDetails());
            pstmt.setString(5, systemLog.getUsername());
            pstmt.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(SystemLogDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
}
