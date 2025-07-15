package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.AlertComplaint;
import utils.DBConnection;

public class AlertComplaintDAO {

    public List<AlertComplaint> getFilteredUnitComplaints(String unitType, String issueStatus, int offset, int limit) {
        List<AlertComplaint> list = new ArrayList<>();

        String sql = """
            SELECT * FROM (
                SELECT 
                    t.unit_id,
                    t.unit_name,
                    t.email,
                    t.address,
                    t.unit_type,
                    t.issue_count,
                    t.warning_sent,
                    ROW_NUMBER() OVER (ORDER BY t.issue_count DESC) as row_num
                FROM (
                    -- Đơn vị vận chuyển
                    SELECT 
                        t.transport_unit_id AS unit_id,
                        t.company_name AS unit_name,
                        u.email AS email,
                        t.location AS address,
                        'TRANSPORT' AS unit_type,
                        COUNT(i.issue_id) AS issue_count,
                        CASE 
                            WHEN EXISTS (
                                SELECT 1 FROM Issues i2 
                                JOIN Orders o2 ON i2.order_id = o2.order_id 
                                WHERE o2.transport_unit_id = t.transport_unit_id 
                                AND i2.warning_sent = 1
                            ) THEN 1 
                            ELSE 0 
                        END AS warning_sent
                    FROM TransportUnits t
                    JOIN Users u ON t.transport_unit_id = u.user_id
                    LEFT JOIN Orders o ON o.transport_unit_id = t.transport_unit_id
                    LEFT JOIN Issues i ON i.order_id = o.order_id
                    GROUP BY t.transport_unit_id, t.company_name, u.email, t.location

                    UNION ALL

                    -- Kho bãi
                    SELECT 
                        s.storage_unit_id AS unit_id,
                        s.warehouse_name AS unit_name,
                        u.email AS email,
                        s.location AS address,
                        'WAREHOUSE' AS unit_type,
                        COUNT(i.issue_id) AS issue_count,
                        CASE 
                            WHEN EXISTS (
                                SELECT 1 FROM Issues i2 
                                JOIN Orders o2 ON i2.order_id = o2.order_id 
                                WHERE o2.storage_unit_id = s.storage_unit_id 
                                AND i2.warning_sent = 1
                            ) THEN 1 
                            ELSE 0 
                        END AS warning_sent
                    FROM StorageUnits s
                    JOIN Users u ON s.storage_unit_id = u.user_id
                    LEFT JOIN Orders o ON o.storage_unit_id = s.storage_unit_id
                    LEFT JOIN Issues i ON i.order_id = o.order_id
                    GROUP BY s.storage_unit_id, s.warehouse_name, u.email, s.location
                ) t
                WHERE t.issue_count > 0
            ) final
            WHERE row_num BETWEEN ? AND ?
        """;

        if (unitType != null && !unitType.isEmpty()) {
            sql = sql.replace("WHERE t.issue_count > 0", "WHERE t.issue_count > 0 AND t.unit_type = '" + unitType + "'");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, offset + 1);
            ps.setInt(2, offset + limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    int issueCount = rs.getInt("issue_count");
                    String currentUnitType = rs.getString("unit_type");
                    String status;
                    if (issueCount > 5) {
                        status = "DANGER";
                    } else if (issueCount >= 2) {
                        status = "WARNING";
                    } else {
                        status = "NORMAL";
                    }

                    if (issueStatus == null || issueStatus.isEmpty() || issueStatus.equals(status)) {
                        AlertComplaint ac = new AlertComplaint();
                        ac.setUnitId(rs.getInt("unit_id"));
                        ac.setUnitName(rs.getString("unit_name"));
                        ac.setEmail(rs.getString("email"));
                        ac.setAddress(rs.getString("address"));
                        ac.setUnitType(currentUnitType);
                        ac.setIssueCount(issueCount);
                        ac.setWarningSent(rs.getBoolean("warning_sent"));
                        ac.setIssueStatus(status);
                        list.add(ac);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public AlertComplaint getUnitById(int unitId, String unitType) {
        String sql = unitType.equals("TRANSPORT") ?
            "SELECT t.transport_unit_id AS unit_id, t.company_name AS unit_name, u.email, t.location AS address, 'TRANSPORT' AS unit_type, " +
            "COUNT(i.issue_id) AS issue_count FROM TransportUnits t " +
            "JOIN Users u ON t.transport_unit_id = u.user_id " +
            "LEFT JOIN Orders o ON o.transport_unit_id = t.transport_unit_id " +
            "LEFT JOIN Issues i ON i.order_id = o.order_id " +
            "WHERE t.transport_unit_id = ? GROUP BY t.transport_unit_id, t.company_name, u.email, t.location "
            :
            "SELECT s.storage_unit_id AS unit_id, s.warehouse_name AS unit_name, u.email, s.location AS address, 'WAREHOUSE' AS unit_type, " +
            "COUNT(i.issue_id) AS issue_count FROM StorageUnits s " +
            "JOIN Users u ON s.storage_unit_id = u.user_id " +
            "LEFT JOIN Orders o ON o.storage_unit_id = s.storage_unit_id " +
            "LEFT JOIN Issues i ON i.order_id = o.order_id " +
            "WHERE s.storage_unit_id = ? GROUP BY s.storage_unit_id, s.warehouse_name, u.email, s.location";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, unitId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    AlertComplaint ac = new AlertComplaint();
                    ac.setUnitId(rs.getInt("unit_id"));
                    ac.setUnitName(rs.getString("unit_name"));
                    ac.setEmail(rs.getString("email"));
                    ac.setAddress(rs.getString("address"));
                    ac.setUnitType(rs.getString("unit_type"));
                    ac.setIssueCount(rs.getInt("issue_count"));
                    ac.setIssueStatus(rs.getInt("issue_count") > 5 ? "DANGER" : rs.getInt("issue_count") >= 2 ? "WARNING" : "NORMAL");
                    return ac;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public void markWarningSent(int unitId, String unitType) {
        String sql = unitType.equals("TRANSPORT") ?
            "UPDATE Issues SET warning_sent = 1 WHERE order_id IN (SELECT o.order_id FROM Orders o WHERE o.transport_unit_id = ?)"
            :
            "UPDATE Issues SET warning_sent = 1 WHERE order_id IN (SELECT o.order_id FROM Orders o WHERE o.storage_unit_id = ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, unitId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int countFiltered(String unitType, String issueStatus) {
        return getFilteredUnitComplaints(unitType, issueStatus, 0, Integer.MAX_VALUE).size();
    }

    public int countUnitsWithComplaints() {
        String sql = """
            SELECT COUNT(*) AS total FROM (
                SELECT t.transport_unit_id AS unit_id
                FROM TransportUnits t
                JOIN Orders o ON o.transport_unit_id = t.transport_unit_id
                JOIN Issues i ON i.order_id = o.order_id
                GROUP BY t.transport_unit_id

                UNION

                SELECT s.storage_unit_id AS unit_id
                FROM StorageUnits s
                JOIN Orders o ON o.storage_unit_id = s.storage_unit_id
                JOIN Issues i ON i.order_id = o.order_id
                GROUP BY s.storage_unit_id
            ) AS units_with_complaints
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countAllComplaints() {
        String sql = "SELECT COUNT(*) AS total FROM Issues";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countUnitsWithWarningsSent() {
        String sql = """
            SELECT COUNT(*) AS total FROM (
                SELECT t.transport_unit_id AS unit_id
                FROM TransportUnits t
                JOIN Orders o ON o.transport_unit_id = t.transport_unit_id
                JOIN Issues i ON i.order_id = o.order_id
                WHERE i.warning_sent = 1
                GROUP BY t.transport_unit_id

                UNION

                SELECT s.storage_unit_id AS unit_id
                FROM StorageUnits s
                JOIN Orders o ON o.storage_unit_id = s.storage_unit_id
                JOIN Issues i ON i.order_id = o.order_id
                WHERE i.warning_sent = 1
                GROUP BY s.storage_unit_id
            ) AS units_with_warnings
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int countUnitsWithWarningsNotSent() {
        String sql = """
            SELECT COUNT(*) AS total FROM (
                SELECT t.transport_unit_id AS unit_id
                FROM TransportUnits t
                JOIN Orders o ON o.transport_unit_id = t.transport_unit_id
                JOIN Issues i ON i.order_id = o.order_id
                WHERE i.warning_sent = 0
                GROUP BY t.transport_unit_id

                UNION

                SELECT s.storage_unit_id AS unit_id
                FROM StorageUnits s
                JOIN Orders o ON o.storage_unit_id = s.storage_unit_id
                JOIN Issues i ON i.order_id = o.order_id
                WHERE i.warning_sent = 0
                GROUP BY s.storage_unit_id
            ) AS units_without_warnings
        """;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt("total");
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
