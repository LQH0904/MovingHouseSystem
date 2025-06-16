package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.RegisterApplication;
import model.RegisterApplicationDetail;
import utils.DBConnection;

public class RegisterApplicationDAO {
    
       public List<RegisterApplication> getApplicationsPaginated(String keyword, int offset, int limit) {
        List<RegisterApplication> applications = new ArrayList<>();

        String query = """
            SELECT ra.application_id, u.username, u.role_id, ra.status_id, ra.note
            FROM RegisterApplications ra
            JOIN Users u ON ra.user_id = u.user_id
            WHERE u.username LIKE ?
            ORDER BY ra.application_id DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            ps.setInt(2, offset);
            ps.setInt(3, limit);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RegisterApplication app = new RegisterApplication(
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

    public List<RegisterApplication> getAllApplications(String keyword) {
    List<RegisterApplication> applications = new ArrayList<>();

    String query = """
        SELECT ra.application_id, u.username, u.role_id, ra.status_id, ra.note
        FROM RegisterApplications ra
        JOIN Users u ON ra.user_id = u.user_id
        WHERE u.username LIKE ?
        ORDER BY ra.application_id DESC
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setString(1, "%" + keyword + "%");
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            RegisterApplication app = new RegisterApplication(
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

    public int countApplications(String keyword) {
        String query = """
        SELECT COUNT(*) AS total
        FROM RegisterApplications ra
        JOIN Users u ON ra.user_id = u.user_id
        WHERE u.username LIKE ?
    """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setString(1, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    public List<RegisterApplication> getAllApplications() {
        List<RegisterApplication> applications = new ArrayList<>();

        String query = """
            SELECT ra.application_id, u.username, u.role_id, ra.status_id, ra.note
            FROM RegisterApplications ra
            JOIN Users u ON ra.user_id = u.user_id
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                RegisterApplication app = new RegisterApplication(
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

    public RegisterApplicationDetail getApplicationDetailById(int applicationId) {
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

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, applicationId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RegisterApplicationDetail dto = new RegisterApplicationDetail();
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
    
    public List<RegisterApplication> getApplicationsByStatusPaginated(String keyword, int statusId, int offset, int limit) {
    List<RegisterApplication> applications = new ArrayList<>();

    String query = """
        SELECT ra.application_id, u.username, u.role_id, ra.status_id, ra.note
        FROM RegisterApplications ra
        JOIN Users u ON ra.user_id = u.user_id
        WHERE u.username LIKE ? AND ra.status_id = ?
        ORDER BY ra.application_id DESC
        OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setString(1, "%" + keyword + "%");
        ps.setInt(2, statusId);
        ps.setInt(3, offset);
        ps.setInt(4, limit);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            RegisterApplication app = new RegisterApplication(
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
    
    public int countApplicationsByStatus(String keyword, int statusId) {
    String query = """
        SELECT COUNT(*) AS total
        FROM RegisterApplications ra
        JOIN Users u ON ra.user_id = u.user_id
        WHERE u.username LIKE ? AND ra.status_id = ?
    """;

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(query)) {

        ps.setString(1, "%" + keyword + "%");
        ps.setInt(2, statusId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            return rs.getInt("total");
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return 0;
}


    

    public static void main(String[] args) {

         RegisterApplicationDAO dao = new RegisterApplicationDAO();

        String keyword = "huy";  // từ khóa tìm kiếm username
        int statusId = 2;           // ví dụ: Pending (1), Approved (2), Rejected (3)
        int page = 1;
        int limit = 5;
        int offset = (page - 1) * limit;

        // ✅ Test lấy danh sách có lọc theo status
        List<RegisterApplication> list = dao.getApplicationsByStatusPaginated(keyword, statusId, offset, limit);

        System.out.println("Kết quả lọc statusId = " + statusId + " và từ khóa = '" + keyword + "':");
        for (RegisterApplication app : list) {
            System.out.println(
                "ID: " + app.getApplication_id()+
                ", Username: " + app.getUsername() +
                ", RoleId: " + app.getRole_id()+
                ", StatusId: " + app.getStatus_id()+
                ", Note: " + app.getNote()
            );
        }

        // ✅ Test đếm số lượng theo status
        int total = dao.countApplicationsByStatus(keyword, statusId);
        System.out.println("Tổng số kết quả: " + total);
        
    }

}
