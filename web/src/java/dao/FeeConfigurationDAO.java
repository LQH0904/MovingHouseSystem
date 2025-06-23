package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.FeeConfiguration;
import utils.DBContext;

public class FeeConfigurationDAO {

    public List<FeeConfiguration> getAllFeeConfigurations() {
        List<FeeConfiguration> list = new ArrayList<>();
        String sql = "SELECT * FROM FeeConfigurations ORDER BY fee_number";

        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                FeeConfiguration config = new FeeConfiguration(
                    rs.getInt("id"),
                    rs.getInt("fee_number"),
                    rs.getString("fee_type"),
                    rs.getString("description")
                );
                list.add(config);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    public void updateFeeConfiguration(FeeConfiguration fee) {
        String sql = "UPDATE FeeConfigurations SET fee_number = ?, fee_type = ?, description = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, fee.getFeeNumber());
            ps.setString(2, fee.getFeeType());
            ps.setString(3, fee.getDescription());
            ps.setInt(4, fee.getId());

            ps.executeUpdate();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
