package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.OperationPolicy;
import utils.DBConnection;

public class OperationPolicyDAO {

    public OperationPolicy getPolicy() {
        String sql = "SELECT * FROM OperationPolicies WHERE id = 1";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return new OperationPolicy(
                    rs.getInt("id"),
                    rs.getInt("policy_number"),
                    rs.getString("policy_title"),
                    rs.getString("policy_content")  // ✅ sửa ở đây
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updatePolicy(OperationPolicy p) {
        String sql = "UPDATE OperationPolicies SET policy_title = ?, policy_content = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, p.getPolicyTitle());
            ps.setString(2, p.getPolicyContent());
            ps.setInt(3, p.getId());
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<OperationPolicy> getAllPolicies() {
        List<OperationPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM OperationPolicies ORDER BY policy_number";
        try (Connection conn = DBConnection.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                OperationPolicy policy = new OperationPolicy(
                    rs.getInt("id"),
                    rs.getInt("policy_number"),
                    rs.getString("policy_title"),
                    rs.getString("policy_content")  // ✅ sửa ở đây
                );
                list.add(policy);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
