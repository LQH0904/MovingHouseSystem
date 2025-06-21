/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;
import utils.DBContext;
import model.transportUnit;
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
public class DAOTransportUnit extends DBContext{
    public Vector<transportUnit> getReports(String sql) {
        Vector<transportUnit> vector = new Vector<transportUnit>();

        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);
            while (rs.next()) {
                int transportUnitId = rs.getInt("transport_unit_id");
                String companyName = rs.getString("company_name");
                String contactInfo = rs.getString("contact_info");
                String registrationStatus = rs.getString("registration_status");
                String createdAt = rs.getString("created_at");
                String location = rs.getString("location");
                int vehicleCount = rs.getInt("vehicle_count");
                int capacity = rs.getInt("capacity");
                
                transportUnit transportUnit = new transportUnit(transportUnitId, companyName, contactInfo, registrationStatus, createdAt, location, vehicleCount, capacity);
                vector.add(transportUnit);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DAOTransportUnit.class.getName()).log(Level.SEVERE, null, ex);
        }
        return vector;
    }
}
