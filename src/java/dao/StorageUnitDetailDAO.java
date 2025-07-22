package dao;

import model.StorageUnitDetail;
import utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class StorageUnitDetailDAO {
    
    public List<StorageUnitDetail> getAllStorageUnits() {
        List<StorageUnitDetail> list = new ArrayList<>();
        String sql = """
            SELECT 
                s.storage_unit_id,
                u.username,
                u.email,
                s.warehouse_name,
                s.location,
                s.business_certificate,
                s.area,
                s.employee,
                s.phone_number,
                s.insurance,
                s.floor_plan,
                s.registration_status,
                s.created_at,
                u.updated_at
            FROM StorageUnits s
            JOIN Users u ON s.storage_unit_id = u.user_id
            WHERE u.role_id = 5
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                StorageUnitDetail su = new StorageUnitDetail();
                su.setStorageUnitId(rs.getInt("storage_unit_id"));
                su.setUsername(rs.getString("username"));
                su.setEmail(rs.getString("email"));
                su.setWarehouseName(rs.getString("warehouse_name"));
                su.setLocation(rs.getString("location"));
                su.setBusinessCertificate(rs.getString("business_certificate"));
                su.setArea(rs.getDouble("area"));
                su.setEmployee(rs.getInt("employee"));
                su.setPhoneNumber(rs.getString("phone_number"));
                su.setInsurance(rs.getString("insurance"));
                su.setFloorPlan(rs.getString("floor_plan"));
                su.setRegistrationStatus(rs.getString("registration_status"));
                su.setCreatedAt(rs.getTimestamp("created_at"));
                su.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(su);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    /**
     * Lấy chi tiết Storage Unit theo ID
     */
    public StorageUnitDetail getStorageUnitById(int storageUnitId) {
        String sql = """
            SELECT 
                s.storage_unit_id,
                u.username,
                u.email,
                s.warehouse_name,
                s.location,
                s.business_certificate,
                s.area,
                s.employee,
                s.phone_number,
                s.insurance,
                s.floor_plan,
                s.registration_status,
                s.created_at,
                u.updated_at
            FROM StorageUnits s
            JOIN Users u ON s.storage_unit_id = u.user_id
            WHERE s.storage_unit_id = ? AND u.role_id = 5
        """;
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, storageUnitId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    StorageUnitDetail su = new StorageUnitDetail();
                    su.setStorageUnitId(rs.getInt("storage_unit_id"));
                    su.setUsername(rs.getString("username"));
                    su.setEmail(rs.getString("email"));
                    su.setWarehouseName(rs.getString("warehouse_name"));
                    su.setLocation(rs.getString("location"));
                    su.setBusinessCertificate(rs.getString("business_certificate"));
                    su.setArea(rs.getDouble("area"));
                    su.setEmployee(rs.getInt("employee"));
                    su.setPhoneNumber(rs.getString("phone_number"));
                    su.setInsurance(rs.getString("insurance"));
                    su.setFloorPlan(rs.getString("floor_plan"));
                    su.setRegistrationStatus(rs.getString("registration_status"));
                    su.setCreatedAt(rs.getTimestamp("created_at"));
                    su.setUpdatedAt(rs.getTimestamp("updated_at"));
                    return su;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
 * Cập nhật trạng thái phê duyệt của đơn vị lưu trữ
 */
public boolean updateApprovalStatus(int storageUnitId, String newRegistrationStatus, String newUserStatus) {
    String updateStorageSql = "UPDATE StorageUnits SET registration_status = ? WHERE storage_unit_id = ?";
    String updateUserSql = "UPDATE Users SET status = ?, updated_at = GETDATE() WHERE user_id = ?";
    
    try (Connection conn = DBConnection.getConnection()) {
        conn.setAutoCommit(false); // Bắt đầu transaction

        try (
            PreparedStatement psStorage = conn.prepareStatement(updateStorageSql);
            PreparedStatement psUser = conn.prepareStatement(updateUserSql)
        ) {
            // Update bảng StorageUnits
            psStorage.setString(1, newRegistrationStatus);
            psStorage.setInt(2, storageUnitId);
            psStorage.executeUpdate();

            // Update bảng Users
            psUser.setString(1, newUserStatus);
            psUser.setInt(2, storageUnitId); // Vì storage_unit_id chính là user_id
            psUser.executeUpdate();

            conn.commit();
            return true;
        } catch (SQLException e) {
            conn.rollback();
            e.printStackTrace();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return false;
}

public static void main(String[] args) {
        StorageUnitDetailDAO dao = new StorageUnitDetailDAO();

        int testStorageUnitId = 6; // 👈 Thay bằng ID thật trong CSDL để test

//        // Test từ chối đơn vị
//        boolean rejected = dao.updateApprovalStatus(testStorageUnitId, "rejected", "inactive");
//        if (rejected) {
//            System.out.println("❌ Đã từ chối đơn vị thành công.");
//        } else {
//            System.out.println("⚠️ Từ chối đơn vị thất bại.");
//        }

        // Test phê duyệt đơn vị
        boolean approved = dao.updateApprovalStatus(testStorageUnitId, "approved", "active");
        if (approved) {
            System.out.println("✅ Đã phê duyệt đơn vị thành công.");
        } else {
            System.out.println("⚠️ Phê duyệt đơn vị thất bại.");
        }
    }

    
}
