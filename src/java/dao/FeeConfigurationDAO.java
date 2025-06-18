package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.FeeConfiguration;
import utils.DBContext;

public class FeeConfigurationDAO {

    public FeeConfiguration getFeeConfig() {
        String sql = "SELECT * FROM FeeConfigurations";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new FeeConfiguration(rs.getInt("id"), rs.getString("content"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateFeeConfiguration(String content) {
        String sql = "UPDATE FeeConfigurations SET content = ? WHERE id = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public FeeConfiguration getFeeConfiguration() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    
}
