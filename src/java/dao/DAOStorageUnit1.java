package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.StorageUnit1;
import utils.DBContext;

public class DAOStorageUnit1 extends DBContext {

    public StorageUnit1 getStorageUnitByUserId(int userId) {
        String sql = "SELECT warehouse_name, location, business_certificate, area, employee, "
                   + "phone_number, registration_status, insurance, floor_plan "
                   + "FROM StorageUnits WHERE storage_unit_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    StorageUnit1 su = new StorageUnit1();
                    su.setWarehouseName(rs.getString("warehouse_name"));
                    su.setLocation(rs.getString("location"));
                    su.setBusinessCertificate(rs.getString("business_certificate"));
                    su.setArea(rs.getString("area"));  // model nhận String
                    su.setEmployee(rs.getInt("employee"));
                    su.setPhoneNumber(rs.getString("phone_number"));
                    su.setRegistrationStatus(rs.getString("registration_status"));
                    su.setInsurance(rs.getString("insurance"));
                    su.setFloorPlan(rs.getString("floor_plan"));
                    return su;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
