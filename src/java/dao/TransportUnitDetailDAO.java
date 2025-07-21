package dao;

import model.TransportUnitDetail;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TransportUnitDetailDAO {
    
    public List<TransportUnitDetail> getAllTransportUnits() {
        List<TransportUnitDetail> list = new ArrayList<>();
        String sql = """
            SELECT 
                t.transport_unit_id,
                u.username,
                u.email,
                t.company_name,
                t.contact_info,
                t.business_certificate,
                t.vehicle_count,
                t.capacity,
                t.loader,
                t.insurance,
                t.registration_status,
                t.created_at,
                u.updated_at
            FROM TransportUnits t
            JOIN Users u ON t.transport_unit_id = u.user_id
            WHERE u.role_id = 4
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                TransportUnitDetail tu = new TransportUnitDetail();
                tu.setTransportUnitId(rs.getInt("transport_unit_id"));
                tu.setUsername(rs.getString("username"));
                tu.setEmail(rs.getString("email"));
                tu.setCompanyName(rs.getString("company_name"));
                tu.setContactInfo(rs.getString("contact_info"));
                tu.setBusinessCertificate(rs.getString("business_certificate"));
                tu.setVehicleCount(rs.getInt("vehicle_count"));
                tu.setCapacity(rs.getDouble("capacity"));
                tu.setLoader(rs.getInt("loader"));
                tu.setInsurance(rs.getString("insurance"));
                tu.setRegistrationStatus(rs.getString("registration_status"));
                tu.setCreatedAt(rs.getTimestamp("created_at"));
                tu.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(tu);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy chi tiết Transport Unit theo ID
     */
    public TransportUnitDetail getTransportUnitById(int transportUnitId) {
        String sql = """
            SELECT 
                t.transport_unit_id,
                u.username,
                u.email,
                t.company_name,
                t.contact_info,
                t.business_certificate,
                t.vehicle_count,
                t.capacity,
                t.loader,
                t.insurance,
                t.registration_status,
                t.created_at,
                u.updated_at
            FROM TransportUnits t
            JOIN Users u ON t.transport_unit_id = u.user_id
            WHERE t.transport_unit_id = ? AND u.role_id = 4
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, transportUnitId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    TransportUnitDetail tu = new TransportUnitDetail();
                    tu.setTransportUnitId(rs.getInt("transport_unit_id"));
                    tu.setUsername(rs.getString("username"));
                    tu.setEmail(rs.getString("email"));
                    tu.setCompanyName(rs.getString("company_name"));
                    tu.setContactInfo(rs.getString("contact_info"));
                    tu.setBusinessCertificate(rs.getString("business_certificate"));
                    tu.setVehicleCount(rs.getInt("vehicle_count"));
                    tu.setCapacity(rs.getDouble("capacity"));
                    tu.setLoader(rs.getInt("loader"));
                    tu.setInsurance(rs.getString("insurance"));
                    tu.setRegistrationStatus(rs.getString("registration_status"));
                    tu.setCreatedAt(rs.getTimestamp("created_at"));
                    tu.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return tu;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Cập nhật trạng thái đăng ký
     */
    public boolean updateRegistrationStatus(int transportUnitId, String status) {
        String sql = "UPDATE TransportUnits SET registration_status = ?, updated_at = CURRENT_TIMESTAMP WHERE transport_unit_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, transportUnitId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
