package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.AlertComplaint;
import utils.DBConnection;

public class AlertComplaintDAO {

    public List<AlertComplaint> getAllUnitComplaints() {
        List<AlertComplaint> list = new ArrayList<>();

        String sql = """
            -- Đơn vị vận chuyển
            SELECT 
                t.transport_unit_id AS unit_id,
                t.company_name AS unit_name,
                u.email AS email,
                t.location AS address,
                'TRANSPORT' AS unit_type,
                COUNT(i.issue_id) AS issue_count
            FROM TransportUnits t
            JOIN Users u ON t.transport_unit_id = u.user_id
            LEFT JOIN Orders o ON o.transport_unit_id = t.transport_unit_id
            LEFT JOIN Issues i ON i.order_id = o.order_id
            GROUP BY t.transport_unit_id, t.company_name, u.email, t.location

            UNION ALL

            -- Kho bãi
            SELECT 
                s.storage_unit_id AS unit_id,
                s.warehouse_name AS unit_name,
                u.email AS email,
                s.location AS address,
                'WAREHOUSE' AS unit_type,
                COUNT(i.issue_id) AS issue_count
            FROM StorageUnits s
            JOIN Users u ON s.storage_unit_id = u.user_id
            LEFT JOIN Orders o ON o.storage_unit_id = s.storage_unit_id
            LEFT JOIN Issues i ON i.order_id = o.order_id
            GROUP BY s.storage_unit_id, s.warehouse_name, u.email, s.location;
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                AlertComplaint ac = new AlertComplaint();
                ac.setUnitId(rs.getInt("unit_id"));
                ac.setUnitName(rs.getString("unit_name"));
                ac.setEmail(rs.getString("email"));
                ac.setAddress(rs.getString("address"));
                ac.setUnitType(rs.getString("unit_type"));
                ac.setIssueCount(rs.getInt("issue_count"));

                // Trạng thái phản ánh: Bình thường (<2), Cảnh báo (2–5), Nguy hiểm (>5)
                if (ac.getIssueCount() < 2) {
                    ac.setIssueStatus("✅ Bình thường");
                } else if (ac.getIssueCount() <= 5) {
                    ac.setIssueStatus("⚠️ Cảnh báo");
                } else {
                    ac.setIssueStatus("🔥 Nguy hiểm");
                }

                list.add(ac);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // Hàm test nhanh
    public static void main(String[] args) {
        AlertComplaintDAO dao = new AlertComplaintDAO();
        List<AlertComplaint> list = dao.getAllUnitComplaints();

        System.out.printf("%-5s %-30s %-10s %-12s %-25s %-15s\n", 
            "ID", "Tên Đơn Vị", "Loại", "Số PA", "Email", "Trạng Thái");

        for (AlertComplaint ac : list) {
            System.out.printf("%-5d %-30s %-10s %-12d %-25s %-15s\n",
                ac.getUnitId(),
                ac.getUnitName(),
                ac.getUnitType(),
                ac.getIssueCount(),
                ac.getEmail(),
                ac.getIssueStatus()
            );
        }
    }
}
