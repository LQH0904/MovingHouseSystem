package dao;

import model.AlertComplaint;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlertComplaintDAO {

    public List<AlertComplaint> getUnitIssueSummaryWithFilters(String name, String type, int page, int size) {
        List<AlertComplaint> list = new ArrayList<>();

        String sql = """
            SELECT 
                i.unit_id,
                COALESCE(s.warehouse_name, t.company_name) AS unit_name,
                u.email,
                COUNT(*) AS issue_count,
                i.unit_type
            FROM Issues i
            JOIN Users u ON i.unit_id = u.user_id
            LEFT JOIN StorageUnits s ON i.unit_type = 'Storage' AND i.unit_id = s.storage_unit_id
            LEFT JOIN TransportUnits t ON i.unit_type = 'Transport' AND i.unit_id = t.transport_unit_id
            WHERE (? IS NULL OR COALESCE(s.warehouse_name, t.company_name) LIKE ?)
              AND (? IS NULL OR i.unit_type = ?)
            GROUP BY i.unit_id, COALESCE(s.warehouse_name, t.company_name), u.email, i.unit_type
            ORDER BY issue_count DESC
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, name == null ? null : "%" + name + "%");
            ps.setString(3, type);
            ps.setString(4, type);
            ps.setInt(5, (page - 1) * size);
            ps.setInt(6, size);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                int unitId = rs.getInt("unit_id");
                String unitName = rs.getString("unit_name");
                String email = rs.getString("email");
                int issueCount = rs.getInt("issue_count");
                String unitType = rs.getString("unit_type");

                AlertComplaint ac = new AlertComplaint(unitId, unitName, email, issueCount, unitType);
                list.add(ac);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
    
     public static void main(String[] args) {
        AlertComplaintDAO dao = new AlertComplaintDAO();
        
        // Test không filter, trang 1, mỗi trang 10 bản ghi
        List<AlertComplaint> complaints = dao.getUnitIssueSummaryWithFilters(null, null, 1, 5);

        for (AlertComplaint ac : complaints) {
            System.out.println("Đơn vị ID: " + ac.getUnitId());
            System.out.println("Tên đơn vị: " + ac.getUnitName());
            System.out.println("Email: " + ac.getEmail());
            System.out.println("Loại đơn vị: " + ac.getUnitType());
            System.out.println("Số lượng phản ánh: " + ac.getIssueCount());
            System.out.println("--------------------------");
        }
    }
     
     public int countTotalUnits(String name, String type) {
    String sql = """
        SELECT COUNT(DISTINCT i.unit_id)
        FROM Issues i
        LEFT JOIN StorageUnits s ON i.unit_type = 'Storage' AND i.unit_id = s.storage_unit_id
        LEFT JOIN TransportUnits t ON i.unit_type = 'Transport' AND i.unit_id = t.transport_unit_id
        WHERE (? IS NULL OR COALESCE(s.warehouse_name, t.company_name) LIKE ?)
          AND (? IS NULL OR i.unit_type = ?)
    """;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, name);
        ps.setString(2, name == null ? null : "%" + name + "%");
        ps.setString(3, type);
        ps.setString(4, type);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return 0;
}

     public int countTotalIssues(String name, String type) {
    String sql = """
        SELECT COUNT(*)
        FROM Issues i
        LEFT JOIN StorageUnits s ON i.unit_type = 'Storage' AND i.unit_id = s.storage_unit_id
        LEFT JOIN TransportUnits t ON i.unit_type = 'Transport' AND i.unit_id = t.transport_unit_id
        WHERE (? IS NULL OR COALESCE(s.warehouse_name, t.company_name) LIKE ?)
          AND (? IS NULL OR i.unit_type = ?)
    """;

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, name);
        ps.setString(2, name == null ? null : "%" + name + "%");
        ps.setString(3, type);
        ps.setString(4, type);

        ResultSet rs = ps.executeQuery();
        if (rs.next()) return rs.getInt(1);

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return 0;
}

}
