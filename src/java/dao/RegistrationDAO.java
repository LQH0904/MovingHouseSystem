package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.RegistrationItem;
import utils.DBConnection;

public class RegistrationDAO {

    private DBConnection dbConnection;

    public RegistrationDAO() {
        this.dbConnection = new DBConnection();
    }

    // Lấy tất cả đăng ký (4 trường cơ bản)
    public List<RegistrationItem> getAllRegistrations() {
        List<RegistrationItem> registrations = new ArrayList<>();

        String query = """
            SELECT 
                transport_unit_id AS id,
                'transport' AS type,
                company_name AS name,
                registration_status AS status
            FROM TransportUnits

            UNION ALL

            SELECT 
                storage_unit_id AS id,
                'storage' AS type,
                warehouse_name AS name,
                registration_status AS status
            FROM StorageUnits

            ORDER BY id
        """;

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query);
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

        } catch (SQLException e) {
            System.err.println("Error in getAllRegistrations: " + e.getMessage());
        }

        return registrations;
    }
    
    // Trong class RegistrationDAO
public RegistrationItem getRegistrationByIdAndType(int id, String type) {
    String query;
    if ("transport".equalsIgnoreCase(type)) {
        query = """
            SELECT 
                transport_unit_id AS id,
                'transport' AS type,
                company_name AS name,
                registration_status AS status
            FROM TransportUnits
            WHERE transport_unit_id = ?
        """;
    } else if ("storage".equalsIgnoreCase(type)) {
        query = """
            SELECT 
                storage_unit_id AS id,
                'storage' AS type,
                warehouse_name AS name,
                registration_status AS status
            FROM StorageUnits
            WHERE storage_unit_id = ?
        """;
    } else {
        return null;
    }

    try (Connection conn = dbConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(query)) {

        stmt.setInt(1, id);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return new RegistrationItem(
                        rs.getInt("id"),
                        rs.getString("type"),
                        rs.getString("name"),
                        rs.getString("status")
                );
            }
        }

    } catch (SQLException e) {
        System.err.println("Error in getRegistrationByIdAndType: " + e.getMessage());
    }

    return null;
}

    
    public static void main(String[] args) {
        RegistrationDAO dao = new RegistrationDAO();

    
    int testIdTransport = 1; 
    String testTypeTransport = "transport";

    RegistrationItem itemTransport = dao.getRegistrationByIdAndType(testIdTransport, testTypeTransport);
    if (itemTransport != null) {
        System.out.println("Transport unit found:");
        System.out.printf("ID: %d | Type: %s | Name: %s | Status: %s%n",
                itemTransport.getId(), itemTransport.getType(), itemTransport.getName(), itemTransport.getRegistrationStatus());
    } else {
        System.out.println("No transport unit found with ID " + testIdTransport);
    }

    
    int testIdStorage = 1; 
    String testTypeStorage = "storage";

    RegistrationItem itemStorage = dao.getRegistrationByIdAndType(testIdStorage, testTypeStorage);
    if (itemStorage != null) {
        System.out.println("Storage unit found:");
        System.out.printf("ID: %d | Type: %s | Name: %s | Status: %s%n",
                itemStorage.getId(), itemStorage.getType(), itemStorage.getName(), itemStorage.getRegistrationStatus());
    } else {
        System.out.println("No storage unit found with ID " + testIdStorage);
    }

    // Test với loại không hợp lệ
    RegistrationItem itemInvalid = dao.getRegistrationByIdAndType(1, "invalidType");
    if (itemInvalid == null) {
        System.out.println("Invalid type test passed, no data returned.");
    }
    }

    
    
}
