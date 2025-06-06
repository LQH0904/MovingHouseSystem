
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.RegisterApplicationDTO;
import utils.DBConnection;
/**
 *
 * @author Admin
 */
public class RegisterApplicationDAO {
    
    public List<RegisterApplicationDTO> getAllApplications() {
        List<RegisterApplicationDTO> applications = new ArrayList<>();

        String query = """
            SELECT ra.application_id, u.username, u.role_id, ra.status_id, ra.note
            FROM RegisterApplications ra
            JOIN Users u ON ra.user_id = u.user_id
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RegisterApplicationDTO app = new RegisterApplicationDTO(
                    rs.getInt("application_id"),
                    rs.getString("username"),
                    rs.getInt("role_id"),
                    rs.getInt("status_id"),
                    rs.getString("note")
                );
                applications.add(app);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return applications;
    }


    
     public static void main(String[] args) {
        RegisterApplicationDAO dao = new RegisterApplicationDAO();
        List<RegisterApplicationDTO> applications = dao.getAllApplications();

        if (applications.isEmpty()) {
            System.out.println("Không có đơn đăng ký nào.");
        } else {
            for (RegisterApplicationDTO app : applications) {
                System.out.println("Application ID: " + app.getApplication_id());
                System.out.println("Username: " + app.getUsername());
                System.out.println("Role ID: " + app.getRole_id());
                System.out.println("Status ID: " + app.getStatus_id());
                System.out.println("Note: " + app.getNote());
                System.out.println("----------------------------------");
            }
        }
    }
    
}
