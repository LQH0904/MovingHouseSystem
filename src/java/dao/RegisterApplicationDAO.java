
package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.RegisterApplicationDTO;
import model.RegisterApplicationDetailDTO;
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
    
    public RegisterApplicationDetailDTO getApplicationDetailById(int applicationId) {
    String query = """
        SELECT 
            ra.application_id,
            u.username,
            u.email,
            r.role_name,
            s.status_name,
            u.created_at,
            u.status,
            ra.note
        FROM RegisterApplications ra
        JOIN Users u ON ra.user_id = u.user_id
        JOIN Roles r ON u.role_id = r.role_id
        JOIN ApplicationStatus s ON ra.status_id = s.status_id
        WHERE ra.application_id = ?
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setInt(1, applicationId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            RegisterApplicationDetailDTO dto = new RegisterApplicationDetailDTO();
            dto.setApplicationId(rs.getInt("application_id"));
            dto.setUsername(rs.getString("username"));
            dto.setEmail(rs.getString("email"));
            dto.setRoleName(rs.getString("role_name"));
            dto.setStatusName(rs.getString("status_name"));
            dto.setCreatedAt(rs.getTimestamp("created_at"));
            dto.setUserStatus(rs.getString("status"));
            dto.setNote(rs.getString("note"));
            return dto;
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    System.out.println("Không tìm thấy application với ID=" + applicationId);
    return null;
}



    
     public static void main(String[] args) {
        RegisterApplicationDAO dao = new RegisterApplicationDAO();

        int applicationId = 2; // Bạn có thể thay đổi ID này để test

        RegisterApplicationDetailDTO dto = dao.getApplicationDetailById(applicationId);

        if (dto != null) {
            System.out.println("==== Chi tiết đơn đăng ký ====");
            System.out.println("Application ID: " + dto.getApplicationId());
            System.out.println("Username      : " + dto.getUsername());
            System.out.println("Email         : " + dto.getEmail());
            System.out.println("Role          : " + dto.getRoleName());
            System.out.println("Status Name   : " + dto.getStatusName());
            System.out.println("Created At    : " + dto.getCreatedAt());
            System.out.println("User Status   : " + dto.getUserStatus());
            System.out.println("Note          : " + dto.getNote());
        } else {
            System.out.println("Không tìm thấy application với ID = " + applicationId);
        }
    }
    
    
}
