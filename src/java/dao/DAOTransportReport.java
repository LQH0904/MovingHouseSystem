// 2. Fixed DAOTransportReport.java
package dao;

import utils.DBContext;
import model.TransportReport;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DAOTransportReport extends DBContext {
    
    // FIXED: Method to get transport reports with company names
    public Vector<TransportReport> getTransportReportWithCompanyName(String sql) {
        Vector<TransportReport> vector = new Vector<TransportReport>();
        
        try {
            System.out.println("=== DEBUG DAO ===");
            System.out.println("Executing SQL: " + sql);
            
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            
            int count = 0;
            while (rs.next()) {
                count++;
                
                int reportId = rs.getInt("report_id");
                int transportUnitId = rs.getInt("transport_unit_id");
                int reportYear = rs.getInt("report_year");
                int reportMonth = rs.getInt("report_month");
                int totalShipments = rs.getInt("total_shipments");
                
                // FIXED: Get decimal values properly
                double totalRevenue = rs.getDouble("total_revenue");
                double plannedRevenue = rs.getDouble("planned_revenue");
                double totalWeight = rs.getDouble("total_weight");
                
                int onTimeCount = rs.getInt("on_time_count");
                int cancelCount = rs.getInt("cancel_count");
                int delayCount = rs.getInt("delay_count");
                String createdAt = rs.getString("created_at");
                
                // FIXED: Get company name from joined table
                String companyName = rs.getString("company_name");
                
                // Create transportReport object with company name
                TransportReport report = new TransportReport(reportId, transportUnitId, reportYear, reportMonth, 
                    totalShipments, totalRevenue, plannedRevenue, totalWeight, 
                    onTimeCount, cancelCount, delayCount, createdAt);
                
                // Set company name (you might need to add this field to transportReport model)
                report.setCompanyName(companyName);
                
                vector.add(report);
                
                if (count == 1) {
                    System.out.println("First record: " + report.toString());
                }
            }
            
            System.out.println("Total records found: " + count);
            
        } catch (SQLException ex) {
            System.err.println("SQL Error in getTransportReportWithCompanyName: " + ex.getMessage());
            ex.printStackTrace();
            Logger.getLogger(DAOTransportReport.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return vector;
    }
    
    // Keep the original method for backward compatibility
    public Vector<TransportReport> getTransportReport(String sql) {
        Vector<TransportReport> vector = new Vector<TransportReport>();
        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int reportId = rs.getInt("report_id");
                int transportUnitId = rs.getInt("transport_unit_id");
                int reportYear = rs.getInt("report_year");
                int reportMonth = rs.getInt("report_month");
                int totalShipments = rs.getInt("total_shipments");
                
                double totalRevenue = rs.getDouble("total_revenue");
                double plannedRevenue = rs.getDouble("planned_revenue");
                double totalWeight = rs.getDouble("total_weight");
                
                int onTimeCount = rs.getInt("on_time_count");
                int cancelCount = rs.getInt("cancel_count");
                int delayCount = rs.getInt("delay_count");
                String createdAt = rs.getString("created_at");
                
                TransportReport report = new TransportReport(reportId, transportUnitId, reportYear, reportMonth, 
                    totalShipments, totalRevenue, plannedRevenue, totalWeight, 
                    onTimeCount, cancelCount, delayCount, createdAt);
                vector.add(report);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTransportReport.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vector;
    }
}
