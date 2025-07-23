package dao;

import model.StorageUnit;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class StorageUnitDAO {

    public StorageUnit getByUserId(int userId) throws SQLException {
        StorageUnit unit = null;
        String sql = "SELECT * FROM StorageUnits WHERE storage_unit_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                unit = new StorageUnit(
                        rs.getInt("storage_unit_id"),
                        rs.getString("warehouse_name"),
                        rs.getString("location"),
                        rs.getString("registration_status"),
                        rs.getString("created_at"),
                        rs.getString("business_certificate"),
                        rs.getDouble("area"),
                        rs.getInt("employee"),
                        rs.getString("phone_number")
                );
            }
        }

        return unit;
    }
}
