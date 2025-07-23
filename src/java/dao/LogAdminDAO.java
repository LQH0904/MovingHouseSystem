package dao;

import model.SystemLog;
import model.DataChangeLog;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;
import java.sql.Timestamp;

public class LogAdminDAO {

    public void logSystemActivity(Integer userId, String action, String details) {
        String sql = "INSERT INTO SystemLogs (user_id, action, timestamp, details) VALUES (?, ?, GETDATE(), ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            if (userId != null && userId > 0) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, action);
            ps.setString(3, details);
            ps.executeUpdate();
            System.out.println("Logged System Activity: " + action + " - " + details);
        } catch (SQLException e) {
            System.err.println("Error logging system activity: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<SystemLog> getAllSystemLogs() {
        List<SystemLog> logs = new ArrayList<>();
        String sql = "SELECT sl.log_id, sl.user_id, sl.action, sl.timestamp, sl.details, u.username "
                + "FROM SystemLogs sl LEFT JOIN Users u ON sl.user_id = u.user_id "
                + "ORDER BY sl.timestamp DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SystemLog log = new SystemLog();
                log.setLogId(rs.getInt("log_id"));
                if (rs.getObject("user_id") != null) {
                    log.setUserId(rs.getInt("user_id"));
                } else {
                    log.setUserId(0);
                }
                log.setAction(rs.getString("action"));
                log.setTimestamp(new Date(rs.getTimestamp("timestamp").getTime()));
                log.setDetails(rs.getString("details"));
                log.setUsername(rs.getString("username"));
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching system logs: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }

    public void logDataChange(String tableName, String recordId, String columnName,
            String oldValue, String newValue, Integer changedByUserId, String changeType) {
        String sql = "INSERT INTO DataChangeLogs (table_name, record_id, column_name, old_value, new_value, changed_by_user_id, change_timestamp, change_type) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, recordId);
            ps.setString(3, columnName);
            ps.setString(4, oldValue);
            ps.setString(5, newValue);

            if (changedByUserId != null && changedByUserId > 0) {
                ps.setInt(6, changedByUserId);
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setString(7, changeType);
            ps.executeUpdate();
            System.out.println("Logged Data Change: " + changeType + " on " + tableName + " ID " + recordId);
        } catch (SQLException e) {
            System.err.println("Error logging data change: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public List<DataChangeLog> getAllDataChangeLogs() {
        List<DataChangeLog> logs = new ArrayList<>();
        String sql = "SELECT dcl.change_id, dcl.table_name, dcl.record_id, dcl.column_name, "
                + "dcl.old_value, dcl.new_value, dcl.changed_by_user_id, dcl.change_timestamp, dcl.change_type, "
                + "u.username FROM DataChangeLogs dcl LEFT JOIN Users u ON dcl.changed_by_user_id = u.user_id "
                + "ORDER BY dcl.change_timestamp DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DataChangeLog log = new DataChangeLog();
                log.setChangeId(rs.getInt("change_id"));
                log.setTableName(rs.getString("table_name"));
                log.setRecordId(rs.getString("record_id"));
                log.setColumnName(rs.getString("column_name"));
                log.voidsetOldValue(rs.getString("old_value"));
                log.setNewValue(rs.getString("new_value"));
                if (rs.getObject("changed_by_user_id") != null) {
                    log.setChangedByUserId(rs.getInt("changed_by_user_id"));
                } else {
                    log.setChangedByUserId(0);
                }
                log.setChangeTimestamp(new Date(rs.getTimestamp("change_timestamp").getTime()));
                log.setChangeType(rs.getString("change_type"));
                log.setChangedByUsername(rs.getString("username"));
                logs.add(log);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching data change logs: " + e.getMessage());
            e.printStackTrace();
        }
        return logs;
    }

    public SystemLog getSystemLogById(int logId) {
        SystemLog log = null;
        String sql = "SELECT sl.log_id, sl.user_id, u.username, sl.action, sl.timestamp, sl.details "
                + "FROM SystemLogs sl LEFT JOIN Users u ON sl.user_id = u.user_id WHERE sl.log_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, logId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                log = new SystemLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setUsername(rs.getString("username"));
                log.setAction(rs.getString("action"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                log.setDetails(rs.getString("details"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Ghi log lỗi chi tiết hơn nếu cần
        }
        return log;
    }

    // Phương thức mới để lấy DataChangeLog theo ID
    public DataChangeLog getDataChangeLogById(int changeId) {
        DataChangeLog log = null;
        String sql = "SELECT dcl.change_id, dcl.table_name, dcl.record_id, dcl.column_name, "
                + "dcl.old_value, dcl.new_value, dcl.changed_by_user_id, u.username AS changed_by_username, "
                + "dcl.change_timestamp, dcl.change_type "
                + "FROM DataChangeLogs dcl LEFT JOIN Users u ON dcl.changed_by_user_id = u.user_id WHERE dcl.change_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, changeId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                log = new DataChangeLog();
                log.setChangeId(rs.getInt("change_id"));
                log.setTableName(rs.getString("table_name"));
                log.setRecordId(rs.getString("record_id"));
                log.setColumnName(rs.getString("column_name"));
                log.voidsetOldValue(rs.getString("old_value")); // Sửa lỗi chính tả nếu có: setOldValue
                log.setNewValue(rs.getString("new_value"));
                log.setChangedByUserId(rs.getInt("changed_by_user_id"));
                log.setChangedByUsername(rs.getString("changed_by_username"));
                log.setChangeTimestamp(rs.getTimestamp("change_timestamp"));
                log.setChangeType(rs.getString("change_type"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Ghi log lỗi chi tiết hơn nếu cần
        }
        return log;
    }

    public List<SystemLog> getFilteredSystemLogs(String username, String actionType, String detailsKeyword,
            String startDate, String endDate) {
        List<SystemLog> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT sl.log_id, sl.user_id, u.username, sl.action, sl.timestamp, sl.details "
                + "FROM SystemLogs sl LEFT JOIN Users u ON sl.user_id = u.user_id WHERE 1=1");

        if (username != null && !username.isEmpty()) {
            sql.append(" AND u.username LIKE ?");
        }
        if (actionType != null && !actionType.isEmpty()) {
            sql.append(" AND sl.action LIKE ?");
        }
        if (detailsKeyword != null && !detailsKeyword.isEmpty()) {
            sql.append(" AND sl.details LIKE ?");
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND sl.timestamp >= ?");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND sl.timestamp <= ?");
        }
        sql.append(" ORDER BY sl.timestamp DESC"); // Sắp xếp mới nhất lên đầu

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (username != null && !username.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + username + "%");
            }
            if (actionType != null && !actionType.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + actionType + "%");
            }
            if (detailsKeyword != null && !detailsKeyword.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + detailsKeyword + "%");
            }
            if (startDate != null && !startDate.isEmpty()) {
                pstmt.setTimestamp(paramIndex++, Timestamp.valueOf(startDate + " 00:00:00"));
            }
            if (endDate != null && !endDate.isEmpty()) {
                pstmt.setTimestamp(paramIndex++, Timestamp.valueOf(endDate + " 23:59:59"));
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                SystemLog log = new SystemLog();
                log.setLogId(rs.getInt("log_id"));
                log.setUserId(rs.getInt("user_id"));
                log.setUsername(rs.getString("username"));
                log.setAction(rs.getString("action"));
                log.setTimestamp(rs.getTimestamp("timestamp"));
                log.setDetails(rs.getString("details"));
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Ghi log lỗi chi tiết hơn nếu cần
        }
        return logs;
    }

    // Phương thức mới để lấy DataChangeLog theo bộ lọc
    public List<DataChangeLog> getFilteredDataChangeLogs(String username, String tableName, String changeType,
            String startDate, String endDate) {
        List<DataChangeLog> logs = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT dcl.change_id, dcl.table_name, dcl.record_id, dcl.column_name, "
                + "dcl.old_value, dcl.new_value, dcl.changed_by_user_id, u.username AS changed_by_username, "
                + "dcl.change_timestamp, dcl.change_type "
                + "FROM DataChangeLogs dcl LEFT JOIN Users u ON dcl.changed_by_user_id = u.user_id WHERE 1=1");

        if (username != null && !username.isEmpty()) {
            sql.append(" AND u.username LIKE ?");
        }
        if (tableName != null && !tableName.isEmpty()) {
            sql.append(" AND dcl.table_name LIKE ?");
        }
        if (changeType != null && !changeType.isEmpty()) {
            sql.append(" AND dcl.change_type = ?");
        }
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND dcl.change_timestamp >= ?");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND dcl.change_timestamp <= ?");
        }
        sql.append(" ORDER BY dcl.change_timestamp DESC"); // Sắp xếp mới nhất lên đầu

        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {

            int paramIndex = 1;
            if (username != null && !username.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + username + "%");
            }
            if (tableName != null && !tableName.isEmpty()) {
                pstmt.setString(paramIndex++, "%" + tableName + "%");
            }
            if (changeType != null && !changeType.isEmpty()) {
                pstmt.setString(paramIndex++, changeType);
            }
            if (startDate != null && !startDate.isEmpty()) {
                pstmt.setTimestamp(paramIndex++, Timestamp.valueOf(startDate + " 00:00:00"));
            }
            if (endDate != null && !endDate.isEmpty()) {
                pstmt.setTimestamp(paramIndex++, Timestamp.valueOf(endDate + " 23:59:59"));
            }

            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                DataChangeLog log = new DataChangeLog();
                log.setChangeId(rs.getInt("change_id"));
                log.setTableName(rs.getString("table_name"));
                log.setRecordId(rs.getString("record_id"));
                log.setColumnName(rs.getString("column_name"));
                log.setOldValue(rs.getString("old_value"));
                log.setNewValue(rs.getString("new_value"));
                log.setChangedByUserId(rs.getInt("changed_by_user_id"));
                log.setChangedByUsername(rs.getString("changed_by_username"));
                log.setChangeTimestamp(rs.getTimestamp("change_timestamp"));
                log.setChangeType(rs.getString("change_type"));
                logs.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return logs;
    }

   
}