package dao;

import utils.DBConnection;
import model.UnitInfo;
import model.UnitStatistics;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UnitRegistrationDAO {

    public List<UnitInfo> getAllUnits() {
        List<UnitInfo> units = new ArrayList<>();
        String storageQuery = """
            SELECT u.user_id, s.warehouse_name AS name, 'storage' AS type, 
                   s.registration_status
            FROM Users u
            JOIN StorageUnits s ON u.user_id = s.storage_unit_id
        """;

        String transportQuery = """
            SELECT u.user_id, t.company_name AS name, 'transport' AS type, 
                   t.registration_status
            FROM Users u
            JOIN TransportUnits t ON u.user_id = t.transport_unit_id
        """;

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement()) {

            // Query Storage Units
            ResultSet rs = stmt.executeQuery(storageQuery);
            while (rs.next()) {
                UnitInfo unit = new UnitInfo();
                unit.setUnitId(rs.getInt("user_id"));
                unit.setName(rs.getString("name"));
                unit.setType("storage");
                unit.setStatus(rs.getString("registration_status"));
                units.add(unit);
            }

            // Query Transport Units
            rs = stmt.executeQuery(transportQuery);
            while (rs.next()) {
                UnitInfo unit = new UnitInfo();
                unit.setUnitId(rs.getInt("user_id"));
                unit.setName(rs.getString("name"));
                unit.setType("transport");
                unit.setStatus(rs.getString("registration_status"));
                units.add(unit);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return units;
    }
    
    public UnitStatistics getUnitStatistics() {
    UnitStatistics stats = new UnitStatistics();

    String sql = """
        SELECT
            (SELECT COUNT(*) FROM StorageUnits) +
            (SELECT COUNT(*) FROM TransportUnits) AS total_units,
            
            (SELECT COUNT(*) FROM StorageUnits) AS total_storage,
            (SELECT COUNT(*) FROM TransportUnits) AS total_transport,
            
            (
                SELECT COUNT(*) FROM StorageUnits WHERE registration_status = 'approved'
            ) + (
                SELECT COUNT(*) FROM TransportUnits WHERE registration_status = 'approved'
            ) AS total_approved,
            
            (
                SELECT COUNT(*) FROM StorageUnits WHERE registration_status = 'pending'
            ) + (
                SELECT COUNT(*) FROM TransportUnits WHERE registration_status = 'pending'
            ) AS total_pending,
            
            (
                SELECT COUNT(*) FROM StorageUnits WHERE registration_status = 'rejected'
            ) + (
                SELECT COUNT(*) FROM TransportUnits WHERE registration_status = 'rejected'
            ) AS total_rejected
        """;

    try (Connection conn = DBConnection.getConnection();
         Statement stmt = conn.createStatement();
         ResultSet rs = stmt.executeQuery(sql)) {

        if (rs.next()) {
            stats.setTotalUnits(rs.getInt("total_units"));
            stats.setTotalStorage(rs.getInt("total_storage"));
            stats.setTotalTransport(rs.getInt("total_transport"));
            stats.setTotalApproved(rs.getInt("total_approved"));
            stats.setTotalPending(rs.getInt("total_pending"));
            stats.setTotalRejected(rs.getInt("total_rejected"));
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return stats;
}
    
    public static void main(String[] args) {
        UnitRegistrationDAO dao = new UnitRegistrationDAO();
        List<UnitInfo> unitList = dao.getAllUnits();
        UnitStatistics stats = dao.getUnitStatistics();
System.out.println("=== Thống kê ===");
System.out.println("Tổng đơn vị: " + stats.getTotalUnits());
System.out.println("Kho bãi: " + stats.getTotalStorage());
System.out.println("Vận chuyển: " + stats.getTotalTransport());
System.out.println("Approved: " + stats.getTotalApproved());
System.out.println("Pending: " + stats.getTotalPending());
System.out.println("Rejected: " + stats.getTotalRejected());


        System.out.println("Danh sách đơn vị đăng ký:");
        for (UnitInfo unit : unitList) {
            System.out.println("Mã đơn vị: " + unit.getUnitId());
            System.out.println("Tên đơn vị: " + unit.getName());
            System.out.println("Loại đơn vị: " + unit.getType());
            System.out.println("Trạng thái: " + unit.getStatus());
            System.out.println("----------------------------");
        }

        System.out.println("Tổng số đơn vị: " + unitList.size());
    }

}
