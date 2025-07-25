package dao;

import model.StaffLeaveBalance;
import java.sql.*;
import java.util.Calendar;

public class StaffLeaveBalanceDAO {
    private Connection connection;
    
    public StaffLeaveBalanceDAO(Connection connection) {
        this.connection = connection;
    }
    
    // Lấy số ngày nghỉ còn lại của nhân viên
    public StaffLeaveBalance getLeaveBalance(int staffId) throws SQLException {
        int currentYear = Calendar.getInstance().get(Calendar.YEAR);
        return getLeaveBalance(staffId, currentYear);
    }
    
    public StaffLeaveBalance getLeaveBalance(int staffId, int year) throws SQLException {
        String sql = "SELECT * FROM StaffLeaveBalance WHERE staff_id = ? AND year = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            stmt.setInt(2, year);
            ResultSet rs = stmt.executeQuery();
            
            if (rs.next()) {
                return mapRowToStaffLeaveBalance(rs);
            } else {
                // Nếu không có bản ghi, tạo mới
                return createNewLeaveBalance(staffId, year);
            }
        }
    }
    
    // Cập nhật số ngày nghỉ còn lại
    public boolean updateRemainingDays(int staffId, int daysUsed) throws SQLException {
        StaffLeaveBalance balance = getLeaveBalance(staffId);
        int newRemainingDays = balance.getRemainingDays() - daysUsed;
        
        if (newRemainingDays < 0) {
            return false;
        }
        
        String sql = "UPDATE StaffLeaveBalance SET remaining_days = ?, updated_at = GETDATE() " +
                     "WHERE staff_id = ? AND year = ?";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, newRemainingDays);
            stmt.setInt(2, staffId);
            stmt.setInt(3, balance.getYear());
            
            return stmt.executeUpdate() > 0;
        }
    }
    
    // Tạo mới bản ghi số ngày nghỉ
    private StaffLeaveBalance createNewLeaveBalance(int staffId, int year) throws SQLException {
        String sql = "INSERT INTO StaffLeaveBalance (staff_id, year, total_days, remaining_days, updated_at) " +
                     "VALUES (?, ?, 28, 28, GETDATE())";
        
        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, staffId);
            stmt.setInt(2, year);
            
            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating leave balance failed, no rows affected.");
            }
            
            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    StaffLeaveBalance balance = new StaffLeaveBalance();
                    balance.setBalanceId(generatedKeys.getInt(1));
                    balance.setStaffId(staffId);
                    balance.setYear(year);
                    balance.setTotalDays(28);
                    balance.setRemainingDays(28);
                    return balance;
                } else {
                    throw new SQLException("Creating leave balance failed, no ID obtained.");
                }
            }
        }
    }
    
    private StaffLeaveBalance mapRowToStaffLeaveBalance(ResultSet rs) throws SQLException {
        StaffLeaveBalance balance = new StaffLeaveBalance();
        balance.setBalanceId(rs.getInt("balance_id"));
        balance.setStaffId(rs.getInt("staff_id"));
        balance.setYear(rs.getInt("year"));
        balance.setTotalDays(rs.getInt("total_days"));
        balance.setRemainingDays(rs.getInt("remaining_days"));
        balance.setUpdatedAt(rs.getTimestamp("updated_at"));
        return balance;
    }
}