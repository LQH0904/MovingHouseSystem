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
                    rs.getString("policy_content")  
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
                    rs.getString("policy_content")  
                );
                list.add(policy);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    
    
    
    
    public void insertPolicy(OperationPolicy p) {
    String sql = "INSERT INTO OperationPolicies (policy_number, policy_title, policy_content) VALUES (?, ?, ?)";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, p.getPolicyNumber());
        ps.setString(2, p.getPolicyTitle());
        ps.setString(3, p.getPolicyContent());
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
    
    public int getNextPolicyNumber() {
    String sql = "SELECT MAX(policy_number) AS max_num FROM OperationPolicies";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        if (rs.next()) {
            return rs.getInt("max_num") + 1;
 }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return 1;
}
    
    
    
    
    public OperationPolicy getById(int id) {
    String sql = "SELECT * FROM OperationPolicies WHERE id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return new OperationPolicy(
                rs.getInt("id"),
                rs.getInt("policy_number"),
                rs.getString("policy_title"),
                rs.getString("policy_content")
            );
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
    public void deleteById(int id) {
    String sql = "DELETE FROM OperationPolicies WHERE id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setInt(1, id);
        ps.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    }
}
}
