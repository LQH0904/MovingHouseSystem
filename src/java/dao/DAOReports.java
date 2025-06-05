/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import utils.DBContext;
import entity.Reports;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author Admin
 */
public class DAOReports extends DBContext{
    public Vector<Reports> getReports(String sql) {
        Vector<Reports> vector = new Vector<Reports>();

        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int reportId = rs.getInt("report_id");
                String reportType = rs.getString("report_type");
                int generatedBy = rs.getInt("generated_by");
                String data = rs.getString("data");
                String createdAt = rs.getString("created_at");
                String title = rs.getString("title");
                Reports report = new Reports(reportId, reportType, generatedBy, data, createdAt, title);
                vector.add(report);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOInventoryReports.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vector;
    }
}
