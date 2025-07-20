package dao;

import model.AlertComplaint;
import model.ChartDataPoint;
import utils.DBConnection;
import java.sql.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.WeekFields;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.LinkedHashMap;

public class AlertComplaintDAO {

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

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
        System.out.println("DAO: SQL query for getUnitIssueSummaryWithFilters: " + sql);
        System.out.println("DAO: Params: name=" + name + ", type=" + type + ", page=" + page + ", size=" + size);

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
            System.out.println("DAO: getUnitIssueSummaryWithFilters returned " + list.size() + " records.");
        } catch (SQLException e) {
            System.err.println("DAO: SQLException in getUnitIssueSummaryWithFilters: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public AlertComplaint getUnitDetailsById(int unitId) {
        String sql = "SELECT i.unit_id, COALESCE(s.warehouse_name, t.company_name) AS unit_name, u.email, COUNT(i.issue_id) AS issue_count, i.unit_type FROM Issues i JOIN Users u ON i.unit_id = u.user_id LEFT JOIN StorageUnits s ON i.unit_type = 'Storage' AND i.unit_id = s.storage_unit_id LEFT JOIN TransportUnits t ON i.unit_type = 'Transport' AND i.unit_id = t.transport_unit_id WHERE i.unit_id = ? GROUP BY i.unit_id, COALESCE(s.warehouse_name, t.company_name), u.email, i.unit_type";
        System.out.println("DAO: Attempting to get unit details for unitId: " + unitId);
        System.out.println("DAO: SQL query for getUnitDetailsById: " + sql + " with param: " + unitId);
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, unitId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("DAO: Found unit details for unitId: " + unitId);
                int uId = rs.getInt("unit_id");
                String uName = rs.getString("unit_name");
                String uEmail = rs.getString("email");
                int iCount = rs.getInt("issue_count");
                String uType = rs.getString("unit_type");
                return new AlertComplaint(uId, uName, uEmail, iCount, uType, null);
            } else {
                System.out.println("DAO: No unit found for unitId: " + unitId);
            }
        } catch (SQLException e) {
            System.err.println("DAO: SQLException in getUnitDetailsById for unitId " + unitId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public List<ChartDataPoint> getComplaintChartData(int unitId, String period, int selectedYear, int selectedMonth, int selectedWeek) {
        List<ChartDataPoint> dataPoints = new ArrayList<>();
        String sql = "";
        String groupByClause = "";
        String dateFilter = "";
        List<Object> params = new ArrayList<>();
        params.add(unitId);

        // Use current date/time for defaults if 0 or invalid
        LocalDate now = LocalDate.now();
        if (selectedYear == 0) selectedYear = now.getYear();
        if (selectedMonth == 0) selectedMonth = now.getMonthValue();
        // For week, if 0 or -1, use current week of year. SQL Server DATEPART(week) can return 53.
        // However, if week is 1-4, it means week within month.
        // We'll use the provided selectedWeek directly, assuming it's 1-4 for 'week' period.
        if (selectedWeek == 0 || selectedWeek == -1) selectedWeek = 1; // Default to week 1 if not provided

        switch (period) {
            case "week":
                // Group by day of week for a specific week number within a specific month and year
                // This assumes selectedWeek is 1-4 (week within month)
                dateFilter = " AND YEAR(created_at) = ? AND MONTH(created_at) = ? AND (DATEPART(week, created_at) - DATEPART(week, DATEADD(month, DATEDIFF(month, 0, created_at), 0)) + 1) = ?";
                groupByClause = " DATEPART(weekday, created_at)"; // 1=Sunday, 2=Monday, ..., 7=Saturday
                sql = "SELECT " + groupByClause + " AS label_key, COUNT(issue_id) AS count FROM Issues WHERE unit_id = ? " + dateFilter + " GROUP BY " + groupByClause + " ORDER BY " + groupByClause;
                params.add(selectedYear);
                params.add(selectedMonth);
                params.add(selectedWeek); // Week within month (1-4)
                break;
            case "month":
                // Group by week number within a specific month of a specific year
                dateFilter = " AND YEAR(created_at) = ? AND MONTH(created_at) = ?";
                groupByClause = " (DATEPART(week, created_at) - DATEPART(week, DATEADD(month, DATEDIFF(month, 0, created_at), 0)) + 1)"; // Week in month
                sql = "SELECT " + groupByClause + " AS label_key, COUNT(issue_id) AS count FROM Issues WHERE unit_id = ? " + dateFilter + " GROUP BY " + groupByClause + " ORDER BY " + groupByClause;
                params.add(selectedYear);
                params.add(selectedMonth);
                break;
            case "year":
                // Group by month for a specific year
                dateFilter = " AND YEAR(created_at) = ?";
                groupByClause = " DATEPART(month, created_at)";
                sql = "SELECT " + groupByClause + " AS label_key, COUNT(issue_id) AS count FROM Issues WHERE unit_id = ? " + dateFilter + " GROUP BY " + groupByClause + " ORDER BY " + groupByClause;
                params.add(selectedYear);
                break;
            default:
                // Default to current month if period is invalid or not specified
                return getComplaintChartData(unitId, "month", now.getYear(), now.getMonthValue(), 1); // Default to month view, week 1
        }

        System.out.println("DAO: SQL query for getComplaintChartData (" + period + "): " + sql + " for unitId: " + unitId + ", year: " + selectedYear + ", month: " + selectedMonth + ", week: " + selectedWeek);
        System.out.println("DAO: Params for PreparedStatement: " + params);

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String label = String.valueOf(rs.getInt("label_key"));
                int count = rs.getInt("count");
                dataPoints.add(new ChartDataPoint(label, count));
            }
            System.out.println("DAO: getComplaintChartData returned " + dataPoints.size() + " records for period " + period);
        } catch (SQLException e) {
            System.err.println("DAO: SQLException in getComplaintChartData for unitId " + unitId + ", period " + period + ": " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>(); // Return empty list on error
        }
        return dataPoints;
    }

    public int countTotalUnits(String name, String type) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(DISTINCT i.unit_id) FROM Issues i LEFT JOIN StorageUnits s ON i.unit_type = 'Storage' AND i.unit_id = s.storage_unit_id LEFT JOIN TransportUnits t ON i.unit_type = 'Transport' AND i.unit_id = t.transport_unit_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND COALESCE(s.warehouse_name, t.company_name) LIKE ?");
            params.add("%" + name + "%");
        }
        if (type != null && !type.isEmpty()) {
            sqlBuilder.append(" AND i.unit_type = ?");
            params.add(type);
        }

        System.out.println("DAO: SQL query for countTotalUnits: " + sqlBuilder.toString());
        System.out.print("DAO: Parameters: ");
        for (Object p : params) {
            System.out.print(p + ", ");
        }
        System.out.println();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlBuilder.toString())) {

            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("DAO: countTotalUnits returned: " + count);
                return count;
            }
        } catch (SQLException e) {
            System.err.println("DAO: SQLException in countTotalUnits: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public int countTotalIssues(String name, String type) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM Issues i LEFT JOIN StorageUnits s ON i.unit_type = 'Storage' AND i.unit_id = s.storage_unit_id LEFT JOIN TransportUnits t ON i.unit_type = 'Transport' AND i.unit_id = t.transport_unit_id WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (name != null && !name.isEmpty()) {
            sqlBuilder.append(" AND COALESCE(s.warehouse_name, t.company_name) LIKE ?");
            params.add("%" + name + "%");
        }
        if (type != null && !type.isEmpty()) {
            sqlBuilder.append(" AND i.unit_type = ?");
            params.add(type);
        }

        System.out.println("DAO: SQL query for countTotalIssues: " + sqlBuilder.toString());
        System.out.print("DAO: Parameters: ");
        for (Object p : params) {
            System.out.print(p + ", ");
        }
        System.out.println();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sqlBuilder.toString())) {

            int paramIndex = 1;
            for (Object param : params) {
                ps.setObject(paramIndex++, param);
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("DAO: countTotalIssues returned: " + count);
                return count;
            }
        } catch (SQLException e) {
            System.err.println("DAO: SQLException in countTotalIssues: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public static void main(String[] args) {
        AlertComplaintDAO dao = new AlertComplaintDAO();
        LocalDate now = LocalDate.now();
        System.out.println("\n--- Testing Chart Data (Week - 2025, Month 7, Week 3) ---");
        List<ChartDataPoint> weeklyData = dao.getComplaintChartData(6, "week", 2025, 7, 3); // Week 3 of July 2025
        weeklyData.forEach(dp -> System.out.println("Label: " + dp.getLabel() + ", Count: " + dp.getCount()));

        System.out.println("\n--- Testing Chart Data (Month - current month of current year) ---");
        List<ChartDataPoint> monthlyData = dao.getComplaintChartData(6, "month", now.getYear(), now.getMonthValue(), 1); // Week param doesn't matter for month
        monthlyData.forEach(dp -> System.out.println("Label: " + dp.getLabel() + ", Count: " + dp.getCount()));

        System.out.println("\n--- Testing Chart Data (Year - 2025) ---");
        List<ChartDataPoint> yearlyData = dao.getComplaintChartData(6, "year", 2025, 0, 0);
        yearlyData.forEach(dp -> System.out.println("Label: " + dp.getLabel() + ", Count: " + dp.getCount()));
    }
}
