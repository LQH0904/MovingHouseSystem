
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

    // Lay tat ca don dang ki voi 4 truong 
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
                try (PreparedStatement stmt = conn.prepareStatement(query); ResultSet rs = stmt.executeQuery()) {

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
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }

        return registrations;
    }

    public RegistrationItem getRegistrationDetail(int id, String type) {
        String query = "";
        if ("transport".equalsIgnoreCase(type)) {
            query = """
            SELECT t.transport_unit_id as id,
                    'transport' as type,
                    t.company_name as name, 
                    t.contact_info,
                   t.registration_status as status, 
                    t.created_at, 
                    u.username, 
                    u.email
            FROM TransportUnits t
            LEFT JOIN Users u ON t.user_id = u.user_id
            WHERE t.transport_unit_id = ?
        """;
        } else if ("storage".equalsIgnoreCase(type)) {
            query = """
            SELECT s.storage_unit_id as id,
                    'storage' as type,
                    s.warehouse_name as name, 
                    s.contact_info,
                   s.registration_status as status,
                    s.created_at, 
                    u.username,
                    u.email
            FROM StorageUnits s
            LEFT JOIN Users u ON s.user_id = u.user_id
            WHERE s.storage_unit_id = ?
        """;
        } else {
            return null; // Nếu type không hợp lệ
        }

        try (Connection conn = dbConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return new RegistrationItem(
                            rs.getInt("id"),
                            rs.getString("type"),
                            rs.getString("name"),
                            rs.getString("contact_info"),
                            rs.getString("status"),
                            rs.getTimestamp("created_at"),
                            rs.getString("username"),
                            rs.getString("email")
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void main(String[] args) throws SQLException, Exception {
        System.out.println("=== DAO TEST ===");
        RegistrationDAO dao = new RegistrationDAO();

        try {
        List<RegistrationItem> registrations = dao.getAllRegistrations();
        System.out.println("Found " + registrations.size() + " registrations:");
        
        for (RegistrationItem item : registrations) {
            System.out.printf("ID: %d\n", item.getId());
            System.out.printf("Type: %s\n", item.getType());
            System.out.printf("Name: %s\n", item.getName());
            System.out.printf("Contact Info: %s\n", item.getContactInfo());
            System.out.printf("Status: %s\n", item.getRegistrationStatus());
            System.out.printf("Created At: %s\n", item.getCreatedAt());
            System.out.printf("Username: %s\n", item.getUsername());
            System.out.printf("Email: %s\n", item.getEmail());
            System.out.println("---------------------------");
        }
    } catch (Exception e) {
        System.err.println("Error while fetching registrations: " + e.getMessage());
        e.printStackTrace();
    }
        
//        try {
//            List<RegistrationItem> list = dao.getAllRegistrations();
//            System.out.println("Found " + list.size() + " registrations:");
//
//            for (RegistrationItem item : list) {
//                System.out.printf("ID=%d, Type=%s, Name=%s, Status=%s%n",
//                        item.getId(), item.getType(), item.getName(), item.getRegistrationStatus());
//            }
//        } catch (Exception e) {
//            System.out.println("Error: " + e.getMessage());
//        }
////        
//        System.out.println("=== TEST DONE ===");
    }
}
