package dao;

import model.AlertRule;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlertRuleDAO extends DBContext {

    public List<AlertRule> getAllAlerts() {
        List<AlertRule> list = new ArrayList<>();
        String sql = "SELECT * FROM alert_rules ORDER BY created_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new AlertRule(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("alert_message"),
                        rs.getString("created_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertAlert(AlertRule alert) {
        String sql = "INSERT INTO alert_rules (user_id, alert_message) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, alert.getUserId());
            ps.setString(2, alert.getAlertMessage());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
