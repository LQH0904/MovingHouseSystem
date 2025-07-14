/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
/**
 *
 * @author admin
 */
package dao;

import model.InventoryReport;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class InventoryReportDAO {

    private static final Logger LOGGER = Logger.getLogger(InventoryReportDAO.class.getName());
    public static final InventoryReportDAO INSTANCE = new InventoryReportDAO();

    public InventoryReport getReportById(int reportId) throws SQLException {
        String query = "SELECT * FROM InventoryReports WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                InventoryReport report = new InventoryReport();
                report.setReportId(rs.getInt("report_id"));
                report.setStorageUnitId(rs.getInt("storage_unit_id"));
                report.setInventoryDetails(rs.getString("inventory_details"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setUpdatedAt(rs.getTimestamp("updated_at"));
                report.setTitle(rs.getString("title"));
                report.setStatus(rs.getString("status"));
                LOGGER.info("Fetched InventoryReport ID: " + reportId);
                return report;
            }
            LOGGER.warning("No InventoryReport found for ID: " + reportId);
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching InventoryReport ID: " + reportId, e);
            throw e;
        }
    }

    public List<InventoryReport> getReportsByStorageUnit(int storageUnitId) {
        List<InventoryReport> reports = new ArrayList<>();
        String query = "SELECT * FROM InventoryReports WHERE storage_unit_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, storageUnitId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryReport report = new InventoryReport();
                report.setReportId(rs.getInt("report_id"));
                report.setStorageUnitId(rs.getInt("storage_unit_id"));
                report.setInventoryDetails(rs.getString("inventory_details"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setUpdatedAt(rs.getTimestamp("updated_at"));
                report.setTitle(rs.getString("title"));
                report.setStatus(rs.getString("status"));
                reports.add(report);
            }
            LOGGER.info("Fetched " + reports.size() + " InventoryReports for storage_unit_id: " + storageUnitId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching InventoryReports", e);
        }
        return reports;
    }

    public List<InventoryReport> getRecentReports(int page, int pageSize, String unitName) throws SQLException {
        List<InventoryReport> reports = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT ir.*, su.warehouse_name "
                + "FROM InventoryReports ir "
                + "LEFT JOIN StorageUnits su ON ir.storage_unit_id = su.storage_unit_id "
                + "WHERE ir.created_at >= DATEADD(day, -365, GETDATE())"
        );
        List<Object> params = new ArrayList<>();

        if (unitName != null && !unitName.trim().isEmpty()) {
            query.append(" AND su.warehouse_name LIKE ?");
            params.add("%" + unitName + "%");
        }

        query.append(" ORDER BY ir.created_at DESC");
        query.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                InventoryReport report = new InventoryReport();
                report.setReportId(rs.getInt("report_id"));
                report.setStorageUnitId(rs.getInt("storage_unit_id"));
                report.setInventoryDetails(rs.getString("inventory_details"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setWarehouseName(rs.getString("warehouse_name"));
                reports.add(report);
            }
            LOGGER.info("Lấy được " + reports.size() + " báo cáo tồn kho gần đây.");
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn báo cáo tồn kho gần đây: " + e.getMessage());
            throw e;
        }
        return reports;
    }

    public int getTotalRecentReports(String unitName) throws SQLException {
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) "
                + "FROM InventoryReports ir "
                + "LEFT JOIN StorageUnits su ON ir.storage_unit_id = su.storage_unit_id "
                + "WHERE ir.created_at >= DATEADD(day, -365, GETDATE())"
        );
        List<Object> params = new ArrayList<>();

        if (unitName != null && !unitName.trim().isEmpty()) {
            query.append(" AND su.warehouse_name LIKE ?");
            params.add("%" + unitName + "%");
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            LOGGER.severe("Lỗi đếm báo cáo tồn kho: " + e.getMessage());
            throw e;
        }
    }

}
