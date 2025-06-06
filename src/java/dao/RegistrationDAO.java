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

    // Lấy chi tiết đăng ký
    public RegistrationItem getRegistrationDetail(int id, String type) {
        System.out.println("getRegistrationDetail called with id: " + id + ", type: " + type);
        String query = "";

        if ("transport".equalsIgnoreCase(type)) {
            query = """
                SELECT 
                    transport_unit_id AS id,
                    'transport' AS type,
                    company_name AS name,
                    contact_info,
                    registration_status AS status,
                    created_at
                FROM TransportUnits
                WHERE transport_unit_id = ?
            """;
        } else if ("storage".equalsIgnoreCase(type)) {
            query = """
                SELECT 
                    storage_unit_id AS id,
                    'storage' AS type,
                    warehouse_name AS name,
                    NULL AS contact_info,
                    registration_status AS status,
                    created_at
                FROM StorageUnits
                WHERE storage_unit_id = ?
            """;
        } else {
            System.out.println("Invalid type: " + type);
            return null;
        }

        try (Connection conn = dbConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    RegistrationItem item = new RegistrationItem(
                            rs.getInt("id"),
                            rs.getString("type"),
                            rs.getString("name"),
                            rs.getString("contact_info"),
                            rs.getString("status"),
                            rs.getTimestamp("created_at"),
                            null,
                            null
                    );
                    return item;
                } else {
                    System.out.println("No record found for id: " + id + ", type: " + type);
                }
            }

        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
        }

        return null;
    }

    // Test
    public static void main(String[] args) {
        System.out.println("=== DAO TEST ===");
        RegistrationDAO dao = new RegistrationDAO();

        try {
            List<RegistrationItem> registrations = dao.getAllRegistrations();
            System.out.println("Found " + registrations.size() + " registrations:");

            for (RegistrationItem item : registrations) {
                System.out.printf("ID: %d\n", item.getId());
                System.out.printf("Type: %s\n", item.getType());
                System.out.printf("Name: %s\n", item.getName());

                // Lấy chi tiết cho từng bản ghi
                RegistrationItem detail = dao.getRegistrationDetail(item.getId(), item.getType());

                System.out.printf("Contact Info: %s\n", detail != null ? detail.getContactInfo() : "N/A");
                System.out.printf("Status: %s\n", detail != null ? detail.getRegistrationStatus() : "N/A");
                System.out.printf("Created At: %s\n", detail != null ? detail.getCreatedAt() : "N/A");
                System.out.printf("Username: %s\n", detail != null ? detail.getUsername() : "N/A");
                System.out.printf("Email: %s\n", detail != null ? detail.getEmail() : "N/A");
                System.out.println("---------------------------");
            }

        } catch (Exception e) {
            System.err.println("Error while fetching registrations: " + e.getMessage());
            e.printStackTrace();
        }

        System.out.println("=== TEST DONE ===");
    }
}
