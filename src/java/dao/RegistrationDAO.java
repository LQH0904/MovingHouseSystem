/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import java.util.List;
import model.RegistrationItem;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import utils.DBConnection;
/**
 *
 * @author Admin
 */
public class RegistrationDAO {
    private DBConnection dbConnection;
    
    public RegistrationDAO() {
        this.dbConnection = new DBConnection();
    }
    
    /**
     * Lấy tất cả đơn đăng kí - chỉ 4 trường cơ bản
     */
    public List<RegistrationItem> getAllRegistrations() {
        List<RegistrationItem> registrations = new ArrayList<>();
        
        String query = """
            SELECT 
                transport_unit_id as id,
                'transport' as type,
                company_name as name,
                registration_status as status
            FROM TransportUnits
            
            UNION ALL
            
            SELECT 
                storage_unit_id as id,
                'storage' as type,
                warehouse_name as name,
                registration_status as status
            FROM StorageUnits
            
            ORDER BY id
        """;
        
        Connection conn = null;
        try {
            conn = dbConnection.getConnection();
            if (conn != null) {
                try (PreparedStatement stmt = conn.prepareStatement(query);
                     ResultSet rs = stmt.executeQuery()) {
                    
                    while (rs.next()) {
                        RegistrationItem item = new RegistrationItem(
                            rs.getInt("id"),
                            rs.getString("type"),
                            rs.getString("name"),
                            rs.getString("status")
                        );
                        registrations.add(item);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error in getAllRegistrations: " + e.getMessage());
        } finally {
            if (conn != null) {
                try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        
        return registrations;
    }
    
    /**
     * Test đơn giản
     */
    public static void main(String[] args) {
        System.out.println("=== DAO TEST ===");
        RegistrationDAO dao = new RegistrationDAO();
        
        try {
            List<RegistrationItem> list = dao.getAllRegistrations();
            System.out.println("Found " + list.size() + " registrations:");
            
            for (RegistrationItem item : list) {
                System.out.printf("ID=%d, Type=%s, Name=%s, Status=%s%n", 
                    item.getId(), item.getType(), item.getName(), item.getRegistrationStatus());
            }
        } catch (Exception e) {
            System.out.println("Error: " + e.getMessage());
        }
        
        System.out.println("=== TEST DONE ===");
    }
}
