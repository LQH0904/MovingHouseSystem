/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author admin
 */
import model.TransportReport1;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TransportReportDAO {

    private static final Logger LOGGER = Logger.getLogger(TransportReportDAO.class.getName());
    public static final TransportReportDAO INSTANCE = new TransportReportDAO();

    public TransportReport1 getReportById(int reportId) throws SQLException {
        String query = "SELECT * FROM TransportReport WHERE report_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, reportId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                TransportReport1 report = new TransportReport1();
                report.setReportId(rs.getInt("report_id"));
                report.setTransportUnitId(rs.getInt("transport_unit_id"));
                report.setReportYear(rs.getInt("report_year"));
                report.setReportMonth(rs.getInt("report_month"));
                report.setTotalShipments(rs.getInt("total_shipments"));
                report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                report.setPlannedRevenue(rs.getBigDecimal("planned_revenue"));
                report.setTotalWeight(rs.getBigDecimal("total_weight"));
                report.setOnTimeCount(rs.getInt("on_time_count"));
                report.setCancelCount(rs.getInt("cancel_count"));
                report.setDelayCount(rs.getInt("delay_count"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                LOGGER.info("Fetched TransportReport ID: " + reportId);
                return report;
            }
            LOGGER.warning("No TransportReport found for ID: " + reportId);
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching TransportReport ID: " + reportId, e);
            throw e;
        }
    }

    public List<TransportReport1> getRecentReports(int page, int pageSize, String unitName) throws SQLException {
        List<TransportReport1> reports = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT tr.*, tu.company_name " +
                "FROM TransportReport tr " +
                "LEFT JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id " +
                "WHERE tr.created_at >= DATEADD(day, -365, GETDATE())"
        );
        List<Object> params = new ArrayList<>();

        if (unitName != null && !unitName.trim().isEmpty()) {
            query.append(" AND tu.company_name LIKE ?");
            params.add("%" + unitName + "%");
        }

        query.append(" ORDER BY tr.created_at DESC");
        query.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransportReport1 report = new TransportReport1();
                report.setReportId(rs.getInt("report_id"));
                report.setTransportUnitId(rs.getInt("transport_unit_id"));
                report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                report.setPlannedRevenue(rs.getBigDecimal("planned_revenue"));
                report.setDelayCount(rs.getInt("delay_count"));
                report.setCancelCount(rs.getInt("cancel_count"));
                report.setTotalShipments(rs.getInt("total_shipments"));
                report.setReportMonth(rs.getInt("report_month"));
                report.setReportYear(rs.getInt("report_year"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                report.setCompanyName(rs.getString("company_name"));
                reports.add(report);
            }
            LOGGER.info("Lấy được " + reports.size() + " báo cáo vận chuyển gần đây.");
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn báo cáo vận chuyển gần đây: " + e.getMessage());
            throw e;
        }
        return reports;
    }

    public int getTotalRecentReports(String unitName) throws SQLException {
        StringBuilder query = new StringBuilder(
                "SELECT COUNT(*) " +
                "FROM TransportReport tr " +
                "LEFT JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id " +
                "WHERE tr.created_at >= DATEADD(day, -365, GETDATE())"
        );
        List<Object> params = new ArrayList<>();

        if (unitName != null && !unitName.trim().isEmpty()) {
            query.append(" AND tu.company_name LIKE ?");
            params.add("%" + unitName + "%");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return 0;
        } catch (SQLException e) {
            LOGGER.severe("Lỗi đếm báo cáo vận chuyển: " + e.getMessage());
            throw e;
        }
    }

    public List<TransportReport1> getReportsByTransportUnit(int transportUnitId) {
        List<TransportReport1> reports = new ArrayList<>();
        String query = "SELECT * FROM TransportReport WHERE transport_unit_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, transportUnitId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransportReport1 report = new TransportReport1();
                report.setReportId(rs.getInt("report_id"));
                report.setTransportUnitId(rs.getInt("transport_unit_id"));
                report.setReportYear(rs.getInt("report_year"));
                report.setReportMonth(rs.getInt("report_month"));
                report.setTotalShipments(rs.getInt("total_shipments"));
                report.setTotalRevenue(rs.getBigDecimal("total_revenue"));
                report.setPlannedRevenue(rs.getBigDecimal("planned_revenue"));
                report.setTotalWeight(rs.getBigDecimal("total_weight"));
                report.setOnTimeCount(rs.getInt("on_time_count"));
                report.setCancelCount(rs.getInt("cancel_count"));
                report.setDelayCount(rs.getInt("delay_count"));
                report.setCreatedAt(rs.getTimestamp("created_at"));
                reports.add(report);
            }
            LOGGER.info("Fetched " + reports.size() + " TransportReports for transport_unit_id: " + transportUnitId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching TransportReports", e);
        }
        return reports;
    }
}
