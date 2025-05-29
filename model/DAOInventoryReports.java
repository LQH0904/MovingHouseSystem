/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

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
public class DAOInventoryReports extends DBContext{
    
    
    public Vector<InventoryReports> getInventoryReports(String sql){
        Vector<InventoryReports> vector = new Vector<InventoryReports>();
        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int reporId = rs.getInt("reporId"),
                    storageunitId = rs.getInt("storageunitId");
                String inventoryDetails = rs.getString("inventoryDetails"),
                       createdAt = rs.getString("createdAt"),
                       updatedAt = rs.getString("updatedAt"),
                       title = rs.getString("title");
                InventoryReports invR = new InventoryReports(reporId, storageunitId, inventoryDetails, createdAt, updatedAt, title);
                vector.add(invR);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOInventoryReports.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vector;
    }
}
