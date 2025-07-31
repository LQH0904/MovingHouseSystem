package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import model.TransportUnit1;
import utils.DBContext;

public class DAOTransportUnit1 extends DBContext {

    public TransportUnit1 getTransportUnitByUserId(int userId) {
        String query = "SELECT company_name, contact_info, location, vehicle_count, capacity, loader, "
                     + "business_certificate, registration_status, insurance "
                     + "FROM TransportUnits WHERE transport_unit_id = ?";

        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    TransportUnit1 tu = new TransportUnit1();
                    tu.setCompanyName(rs.getString("company_name"));
                    tu.setContactInfo(rs.getString("contact_info"));
                    tu.setLocation(rs.getString("location"));
                    tu.setVehicleCount(rs.getInt("vehicle_count"));
                    tu.setCapacity(rs.getDouble("capacity"));
                    tu.setLoader(rs.getInt("loader"));
                    tu.setBusinessCertificate(rs.getString("business_certificate"));
                    tu.setRegistrationStatus(rs.getString("registration_status"));
                    tu.setInsurance(rs.getString("insurance"));
                    return tu;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
