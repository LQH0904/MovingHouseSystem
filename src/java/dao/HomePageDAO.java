package dao;

import utils.DBContext;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;
import java.util.HashMap;

/**
 *
 * @author Admin
 */
public class HomePageDAO extends DBContext {

    /**
     * Lấy tổng số user
     */
    public int getTotalUserCount() {
        int total = 0;
        String sql = "SELECT COUNT(*) as total FROM Users";
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            if (rs.next()) {
                total = rs.getInt("total");
            }
            rs.close();
            state.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return total;
    }

    /**
     * Lấy số user theo role
     */
    public Map<String, Integer> getUserCountByRole() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT r.role_name, COUNT(u.user_id) as count "
                + "FROM Roles r LEFT JOIN Users u ON r.role_id = u.role_id "
                + "GROUP BY r.role_name";
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                result.put(rs.getString("role_name"), rs.getInt("count"));
            }
            rs.close();
            state.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy số lượng issue theo trạng thái
     */
    public Map<String, Integer> getIssueCountByStatus() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT status, COUNT(issue_id) as count "
                + "FROM Issues "
                + "GROUP BY status "
                + "ORDER BY count DESC";
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                result.put(rs.getString("status"), rs.getInt("count"));
            }
            rs.close();
            state.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy 5 người dùng đầu tiên với trạng thái
     */
    public Map<String, String> getTop5UsersWithStatus() {
        Map<String, String> result = new HashMap<>();
        String sql = "SELECT TOP 5 u.username, i.status "
                + "FROM Issues i "
                + "INNER JOIN Users u ON i.user_id = u.user_id "
                + "ORDER BY i.created_at DESC";
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                result.put(rs.getString("username"), rs.getString("status"));
            }
            rs.close();
            state.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return result;
    }

    /**
     * Lấy roleId theo roleName
     *
     * @return Map với key là roleName, value là roleId
     */
    public Map<String, Integer> getRoleIds() {
        Map<String, Integer> result = new HashMap<>();
        String sql = "SELECT role_id, role_name FROM Roles";
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                String roleName = rs.getString("role_name");
                int roleId = rs.getInt("role_id");
                result.put(roleName, roleId);
            }
            rs.close();
            state.close();
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return result;
    }
}
