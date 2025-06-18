package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.OperationPolicy;
import utils.DBConnection;

public class OperationPolicyDAO {

    public OperationPolicy getPolicy() {
        String sql = "SELECT * FROM OperationPolicies";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new OperationPolicy(rs.getInt("id"), rs.getString("content"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updatePolicy(String content) {
        String sql = "UPDATE OperationPolicies SET content = ? WHERE id = 1";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<OperationPolicy> getAllPolicies() {
        List<OperationPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM OperationPolicies";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                OperationPolicy policy = new OperationPolicy(
                        rs.getInt("id"),
                        rs.getString("content")
                );
                list.add(policy);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

}
