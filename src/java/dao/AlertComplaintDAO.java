package dao;

import model.AlertComplaint;
import model.UnitIssueSummary;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class AlertComplaintDAO {

    // 1. Thống kê tổng số phản ánh theo đơn vị
    public List<UnitIssueSummary> getIssueSummaryByUnit() {
        List<UnitIssueSummary> list = new ArrayList<>();
        String sql = """
            SELECT unit_id, unit_type, COUNT(*) AS issue_count
            FROM Issues
            GROUP BY unit_id, unit_type
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int unitId = rs.getInt("unit_id");
                String unitType = rs.getString("unit_type");
                int count = rs.getInt("issue_count");
                list.add(new UnitIssueSummary(unitId, unitType, count));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy danh sách phản ánh theo đơn vị
    public List<AlertComplaint> getIssuesByUnitId(int unitId) {
        List<AlertComplaint> list = new ArrayList<>();
        String sql = "SELECT * FROM Issues WHERE unit_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, unitId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                AlertComplaint ac = new AlertComplaint(
                    rs.getInt("issue_id"),
                    rs.getInt("user_id"),
                    rs.getInt("order_id"),
                    rs.getString("description"),
                    rs.getString("status"),
                    rs.getString("priority"),
                    rs.getString("assigned_to"),
                    rs.getTimestamp("created_at").toLocalDateTime(),
                    rs.getTimestamp("resolved_at") != null ? rs.getTimestamp("resolved_at").toLocalDateTime() : null,
                    rs.getInt("unit_id"),
                    rs.getString("unit_type"),
                    rs.getString("operator_reply")
                );
                list.add(ac);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Thống kê số lượng phản ánh theo ngày
    public List<String[]> getIssueCountByDate(int unitId) {
        List<String[]> stats = new ArrayList<>();
        String sql = """
            SELECT CAST(created_at AS DATE) AS created_date, COUNT(*) AS issue_count
            FROM Issues
            WHERE unit_id = ?
            GROUP BY CAST(created_at AS DATE)
            ORDER BY created_date
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, unitId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                String date = rs.getString("created_date");
                String count = rs.getString("issue_count");
                stats.add(new String[]{date, count});
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return stats;
    }

    // 4. Lấy email của đơn vị từ bảng Users (user_id = unit_id)
    public String getEmailByUnitId(int unitId) {
        String sql = "SELECT email FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, unitId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getString("email");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
