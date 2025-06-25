/*
 * DAO class để xử lý dữ liệu cho Transport Report
 * Lấy dữ liệu từ cả TransportReport và TransportUnits tables
 */
package dao;

import utils.DBContext;
import model.transportReport;
import model.TransportUnit;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TransportReportDataDAO extends DBContext {
    
    /**
     * Lấy tất cả dữ liệu Transport Report với thông tin Transport Unit
     * @return Vector chứa transportReport objects với thông tin company name
     */
    public Vector<transportReport> getAllTransportReportData() {
        Vector<transportReport> result = new Vector<>();
        String sql = "SELECT tr.*, tu.company_name " +
                     "FROM TransportReport tr " +
                     "JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id " +
                     "WHERE tu.registration_status = 'approved' " +
                     "ORDER BY tr.report_year DESC, tr.report_month DESC";
        
        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            
            while (rs.next()) {
                transportReport report = new transportReport(
                    rs.getInt("report_id"),
                    rs.getInt("transport_unit_id"),
                    rs.getInt("report_year"),
                    rs.getInt("report_month"),
                    rs.getInt("total_shipments"),
                    rs.getDouble("total_revenue"),
                    rs.getDouble("planned_revenue"),
                    rs.getDouble("total_weight"),
                    rs.getInt("on_time_count"),
                    rs.getInt("cancel_count"),
                    rs.getInt("delay_count"),
                    rs.getString("created_at")
                );
                
                // Set company name từ join table
                report.setCompanyName(rs.getString("company_name"));
                result.add(report);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TransportReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return result;
    }
    
    /**
     * Lấy dữ liệu Transport Report với filter
     */
    public Vector<transportReport> getFilteredTransportReportData(String transportUnitId, String year, String companyName) {
        Vector<transportReport> result = new Vector<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT tr.*, tu.company_name ");
        sql.append("FROM TransportReport tr ");
        sql.append("JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id ");
        sql.append("WHERE tu.registration_status = 'approved' ");
        
        // Thêm điều kiện filter
        if (transportUnitId != null && !transportUnitId.trim().isEmpty()) {
            sql.append("AND tr.transport_unit_id = ").append(transportUnitId).append(" ");
        }
        
        if (year != null && !year.trim().isEmpty()) {
            sql.append("AND tr.report_year = ").append(year).append(" ");
        }
        
        if (companyName != null && !companyName.trim().isEmpty()) {
            sql.append("AND tu.company_name LIKE '%").append(companyName).append("%' ");
        }
        
        sql.append("ORDER BY tr.report_year DESC, tr.report_month DESC");
        
        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql.toString());
            
            while (rs.next()) {
                transportReport report = new transportReport(
                    rs.getInt("report_id"),
                    rs.getInt("transport_unit_id"),
                    rs.getInt("report_year"),
                    rs.getInt("report_month"),
                    rs.getInt("total_shipments"),
                    rs.getDouble("total_revenue"),
                    rs.getDouble("planned_revenue"),
                    rs.getDouble("total_weight"),
                    rs.getInt("on_time_count"),
                    rs.getInt("cancel_count"),
                    rs.getInt("delay_count"),
                    rs.getString("created_at")
                );
                
                report.setCompanyName(rs.getString("company_name"));
                result.add(report);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TransportReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return result;
    }
    
    /**
     * Lấy danh sách tất cả Transport Units đang active
     */
    public Vector<TransportUnit> getAllActiveTransportUnits() {
        Vector<TransportUnit> result = new Vector<>();
        String sql = "SELECT * FROM TransportUnits WHERE registration_status = 'approved' ORDER BY company_name";
        
        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            
            while (rs.next()) {
                TransportUnit unit = new TransportUnit(
                    rs.getInt("transport_unit_id"),
                    rs.getString("company_name"),
                    rs.getString("contact_info"),
                    rs.getString("registration_status"),
                    rs.getString("created_at"),
                    rs.getString("location"),
                    rs.getInt("vehicle_count"),
                    rs.getDouble("capacity"),
                    rs.getInt("loader"),
                    rs.getString("business_certificate")
                );
                result.add(unit);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TransportReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return result;
    }
    
    /**
     * Lấy thống kê tổng quan
     */
    public double[] getOverallStatistics() {
        double[] stats = new double[4];
        String sql = "SELECT " +
                     "SUM(total_shipments) as totalShipments, " +
                     "SUM(total_revenue) as totalRevenue, " +
                     "SUM(on_time_count) as totalOnTime, " +
                     "SUM(total_weight) as totalWeight " +
                     "FROM TransportReport tr " +
                     "JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id " +
                     "WHERE tu.registration_status = 'approved'";
        
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            
            if (rs.next()) {
                stats[0] = rs.getDouble("totalShipments");
                stats[1] = rs.getDouble("totalRevenue");
                double totalOnTime = rs.getDouble("totalOnTime");
                stats[2] = stats[0] > 0 ? (totalOnTime / stats[0]) * 100 : 0; // Tỷ lệ đúng hạn
                stats[3] = rs.getDouble("totalWeight");
            }
        } catch (SQLException ex) {
            Logger.getLogger(TransportReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return stats;
    }
    
    /**
     * Lấy dữ liệu báo cáo theo tháng (6 tháng gần nhất)
     */
    public Vector<Object[]> getMonthlyReportData() {
        Vector<Object[]> result = new Vector<>();
        String sql = "SELECT TOP 6 report_year, report_month, " +
                     "SUM(total_shipments) as monthlyShipments, " +
                     "SUM(total_revenue) as monthlyRevenue, " +
                     "SUM(planned_revenue) as monthlyPlannedRevenue, " +
                     "SUM(on_time_count) as monthlyOnTime, " +
                     "SUM(cancel_count) as monthlyCancel, " +
                     "SUM(delay_count) as monthlyDelay " +
                     "FROM TransportReport tr " +
                     "JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id " +
                     "WHERE tu.registration_status = 'approved' " +
                     "GROUP BY report_year, report_month " +
                     "ORDER BY report_year DESC, report_month DESC";
        
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);
            
            while (rs.next()) {
                Object[] monthData = new Object[]{
                    rs.getInt("report_year"),
                    rs.getInt("report_month"),
                    rs.getInt("monthlyShipments"),
                    rs.getDouble("monthlyRevenue"),
                    rs.getDouble("monthlyPlannedRevenue"),
                    rs.getInt("monthlyOnTime"),
                    rs.getInt("monthlyCancel"),
                    rs.getInt("monthlyDelay")
                };
                result.add(monthData);
            }
        } catch (SQLException ex) {
            Logger.getLogger(TransportReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return result;
    }
}