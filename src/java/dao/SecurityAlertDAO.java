package dao;

import model.SecurityAlert;
import java.sql.*;
import java.util.*;
import utils.DBConnection;

public class SecurityAlertDAO {
    private Connection conn;

    public SecurityAlertDAO() {
        try {
            conn = DBConnection.getConnection();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<SecurityAlert> getAllAlerts() {
        List<SecurityAlert> list = new ArrayList<>();
        String sql = "SELECT * FROM SecurityAlert ORDER BY createdAt DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                SecurityAlert a = new SecurityAlert();
                a.setId(rs.getInt("id"));
                a.setTitle(rs.getString("title"));
                a.setDescription(rs.getString("description"));
                a.setLevel(rs.getString("level"));
                a.setStatus(rs.getString("status"));
                a.setIpAddress(rs.getString("ipAddress"));
                a.setUserEmail(rs.getString("userEmail"));
                a.setCreatedAt(rs.getTimestamp("createdAt"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertAlert(SecurityAlert alert) {
        String sql = "INSERT INTO SecurityAlert (title, description, level, status, ipAddress, userEmail) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, alert.getTitle());
            ps.setString(2, alert.getDescription());
            ps.setString(3, alert.getLevel());
            ps.setString(4, alert.getStatus());
            ps.setString(5, alert.getIpAddress());
            ps.setString(6, alert.getUserEmail());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateStatus(int id, String status) {
        String sql = "UPDATE SecurityAlert SET status = ? WHERE id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
