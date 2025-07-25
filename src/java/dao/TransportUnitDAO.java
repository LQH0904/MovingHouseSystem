package dao;

import model.TransportUnit;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class TransportUnitDAO {

    public TransportUnit getByUserId(int userId) throws SQLException {
        TransportUnit unit = null;
        String sql = "SELECT * FROM TransportUnits WHERE transport_unit_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                unit = new TransportUnit(
                    rs.getInt("transport_unit_id"),
                    rs.getString("company_name"),
                    rs.getString("contact_info"),
                    rs.getString("registration_status"),
                    rs.getTimestamp("created_at"),
                    rs.getString("location"),
                    rs.getInt("vehicle_count"),
                    rs.getInt("capacity"),
                    rs.getString("loader"),
                    rs.getString("business_certificate"),
                    rs.getString("insurance")
                );
            }
        }

        return unit;
    }
}
