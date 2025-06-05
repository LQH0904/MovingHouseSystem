/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import entity.InventoryReports;
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
public class DAOInventoryReports extends DBContext {

    public Vector<InventoryReports> getInventoryReports(String sql) {
        Vector<InventoryReports> vector = new Vector<InventoryReports>();

        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int reportId = rs.getInt("report_id");
                int storageUnitId = rs.getInt("storage_unit_id");
                String details = rs.getString("inventory_details");
                String createdAt = rs.getString("created_at");
                String updatedAt = rs.getString("updated_at");
                String title = rs.getString("title");
                InventoryReports invR = new InventoryReports(reportId, storageUnitId, details, createdAt, updatedAt, title);
                vector.add(invR);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOInventoryReports.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vector;
    }
}
