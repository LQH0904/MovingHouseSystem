/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import utils.DBContext;
import model.StorageReport;
import model.StorageUnit;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.transportReport;

public class StorageReportDataDAO extends DBContext {

    public Vector<StorageReport> getAllStorageReportData() {
        Vector<StorageReport> result = new Vector<>();
        String sql = "SELECT sr.*, su.warehouse_name FROM dbo.StorageReport sr \n"
                + " JOIN dbo.StorageUnits su ON sr.storage_unit_id = su.storage_unit_id\n"
                + " WHERE su.registration_status = 'approved' \n"
                + " ORDER BY sr.report_date DESC";

        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                StorageReport report = new StorageReport(
                        rs.getString("report_date"),
                        rs.getInt("storage_unit_id"),
                        rs.getInt("quantity_on_hand"),
                        rs.getDouble("used_area"),
                        rs.getDouble("total_area"),
                        rs.getInt("order_count"),
                        rs.getInt("inbound_count"),
                        rs.getInt("outbound_count"),
                        rs.getInt("returned_orders"),
                        rs.getDouble("personnel_cost"),
                        rs.getDouble("maintenance_cost"),
                        rs.getDouble("storage_cost_per_unit"),
                        rs.getDouble("profit")
                );

                report.setWarehouseName(rs.getString("warehouse_name"));

                result.add(report);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Lấy dữ liệu báo cáo kho theo các tiêu chí lọc
     *
     * @param storageUnitId ID đơn vị kho (0 nếu không lọc theo ID)
     * @param fromMonth Tháng bắt đầu (định dạng YYYY-MM-DD hoặc null)
     * @param toMonth Tháng kết thúc (định dạng YYYY-MM-DD hoặc null)
     * @param warehouseName Tên kho (null hoặc empty nếu không lọc theo tên)
     * @return Vector chứa danh sách StorageReport đã được lọc
     */
    public Vector<StorageReport> getFilteredStorageReportData(int storageUnitId, String fromMonth, String toMonth, String warehouseName) {
        Vector<StorageReport> result = new Vector<>();
        StringBuilder sql = new StringBuilder();

        sql.append("SELECT sr.*, su.warehouse_name FROM dbo.StorageReport sr ");
        sql.append("JOIN dbo.StorageUnits su ON sr.storage_unit_id = su.storage_unit_id ");
        sql.append("WHERE su.registration_status = 'approved' ");

        Vector<Object> parameters = new Vector<>();

        // Lọc theo storage_unit_id
        if (storageUnitId > 0) {
            sql.append("AND sr.storage_unit_id = ? ");
            parameters.add(storageUnitId);
        }

        // ========== SỬA PHẦN XỬ LÝ THỜI GIAN ==========
        // Lọc theo khoảng thời gian từ tháng
        if (fromMonth != null && !fromMonth.trim().isEmpty()) {
            sql.append("AND sr.report_date >= ? ");
            parameters.add(fromMonth);
        }

        // Lọc theo khoảng thời gian đến tháng - SỬA ĐỂ XỬ LÝ TỐT HƠN
        if (toMonth != null && !toMonth.trim().isEmpty()) {
            // Sử dụng <= thay vì = để bao gồm cả ngày cuối tháng
            // Và sử dụng EOMONTH để lấy ngày cuối tháng chính xác
            if (toMonth.contains("-31") || toMonth.contains("-30") || toMonth.contains("-29") || toMonth.contains("-28")) {
                // Nếu có ngày cụ thể, sử dụng EOMONTH để đảm bảo đúng
                String yearMonth = toMonth.substring(0, 7); // Lấy YYYY-MM
                sql.append("AND sr.report_date <= EOMONTH(?) ");
                parameters.add(yearMonth + "-01");
            } else {
                sql.append("AND sr.report_date <= ? ");
                parameters.add(toMonth);
            }
        }

        // Lọc theo tên kho
        if (warehouseName != null && !warehouseName.trim().isEmpty()) {
            sql.append("AND su.warehouse_name LIKE ? ");
            parameters.add("%" + warehouseName.trim() + "%");
        }

        sql.append("ORDER BY sr.report_date DESC");

        try {
            PreparedStatement pstmt = conn.prepareStatement(sql.toString());

            // Log SQL để debug
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, "SQL Query: " + sql.toString());
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, "Parameters: " + parameters.toString());

            // Set parameters
            for (int i = 0; i < parameters.size(); i++) {
                pstmt.setObject(i + 1, parameters.get(i));
            }

            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                StorageReport report = new StorageReport(
                        rs.getString("report_date"),
                        rs.getInt("storage_unit_id"),
                        rs.getInt("quantity_on_hand"),
                        rs.getDouble("used_area"),
                        rs.getDouble("total_area"),
                        rs.getInt("order_count"),
                        rs.getInt("inbound_count"),
                        rs.getInt("outbound_count"),
                        rs.getInt("returned_orders"),
                        rs.getDouble("personnel_cost"),
                        rs.getDouble("maintenance_cost"),
                        rs.getDouble("storage_cost_per_unit"),
                        rs.getDouble("profit")
                );

                report.setWarehouseName(rs.getString("warehouse_name"));
                result.add(report);
            }

            rs.close();
            pstmt.close();

            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, "Query result count: " + result.size());

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, "SQL Error in getFilteredStorageReportData", ex);
        }

        return result;
    }

    /**
     * Lấy danh sách tất cả các storage units với đầy đủ thông tin
     *
     * @return Vector chứa danh sách StorageUnit
     */
    public Vector<StorageUnit> getAllStorageUnits() {
        Vector<StorageUnit> result = new Vector<>();
        String sql = "SELECT storage_unit_id, warehouse_name, location, registration_status, "
                + "created_at, business_certificate, area, employee, phone_number "
                + "FROM dbo.StorageUnits WHERE registration_status = 'approved' "
                + "ORDER BY warehouse_name";

        try {
            Statement state = conn.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                StorageUnit unit = new StorageUnit(
                        rs.getInt("storage_unit_id"),
                        rs.getString("warehouse_name"),
                        rs.getString("location"),
                        rs.getString("registration_status"),
                        rs.getString("created_at"),
                        rs.getString("business_certificate"),
                        rs.getDouble("area"),
                        rs.getInt("employee"),
                        rs.getString("phone_number")
                );

                result.add(unit);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Lấy thống kê tổng quan của Storage Report
     *
     * @return double[] - [0]: Tổng nhập kho, [1]: Tổng xuất kho, [2]: Tổng lợi
     * nhuận
     */
    public double[] getStorageOverallStatistics() {
        double[] stats = new double[3];
        String sql = "SELECT "
                + "SUM(inbound_count) as totalInbound, "
                + "SUM(outbound_count) as totalOutbound, "
                + "SUM(profit) as totalProfit "
                + "FROM StorageReport sr "
                + "JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "WHERE su.registration_status = 'approved'";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            if (rs.next()) {
                stats[0] = rs.getDouble("totalInbound");
                stats[1] = rs.getDouble("totalOutbound");
                stats[2] = rs.getDouble("totalProfit");
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return stats;
    }

    /**
     * Lấy dữ liệu báo cáo kho theo tháng (6 tháng có dữ liệu gần nhất trong
     * database)
     *
     * @return Vector<Object[]> - Mỗi Object[] chứa: [year, month, inbound,
     * outbound, profit, utilizationRate]
     */
    public Vector<Object[]> getStorageMonthlyReportData() {
        Vector<Object[]> result = new Vector<>();
        String sql = "SELECT TOP 6 "
                + "YEAR(report_date) as report_year, "
                + "MONTH(report_date) as report_month, "
                + "SUM(inbound_count) as monthlyInbound, "
                + "SUM(outbound_count) as monthlyOutbound, "
                + "SUM(profit) as monthlyProfit, "
                + "AVG(used_area * 100.0 / total_area) as avgUtilizationRate, "
                + "AVG(quantity_on_hand) as avgQuantityOnHand "
                + "FROM StorageReport sr "
                + "JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "WHERE su.registration_status = 'approved' "
                + "GROUP BY YEAR(report_date), MONTH(report_date) "
                + "ORDER BY YEAR(report_date) DESC, MONTH(report_date) DESC";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] monthData = new Object[]{
                    rs.getInt("report_year"), // [0] - Năm
                    rs.getInt("report_month"), // [1] - Tháng  
                    rs.getInt("monthlyInbound"), // [2] - Tổng nhập kho
                    rs.getInt("monthlyOutbound"), // [3] - Tổng xuất kho
                    rs.getDouble("monthlyProfit"), // [4] - Tổng lợi nhuận
                    rs.getDouble("avgUtilizationRate"), // [5] - Tỷ lệ sử dụng kho (%)
                    rs.getInt("avgQuantityOnHand") // [6] - Số lượng hàng tồn kho TB
                };
                result.add(monthData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Lấy thống kê theo từng kho cụ thể
     *
     * @return Vector<Object[]> - [warehouseName, totalInbound, totalOutbound,
     * totalProfit, utilizationRate]
     */
    public Vector<Object[]> getStorageUnitStatistics() {
        Vector<Object[]> result = new Vector<>();
        String sql = "SELECT "
                + "su.warehouse_name, "
                + "su.location, "
                + "SUM(sr.inbound_count) as totalInbound, "
                + "SUM(sr.outbound_count) as totalOutbound, "
                + "SUM(sr.profit) as totalProfit, "
                + "AVG(sr.used_area * 100.0 / sr.total_area) as avgUtilizationRate, "
                + "SUM(sr.order_count) as totalOrders "
                + "FROM StorageReport sr "
                + "JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "WHERE su.registration_status = 'approved' "
                + "GROUP BY su.storage_unit_id, su.warehouse_name, su.location "
                + "ORDER BY totalProfit DESC";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] unitData = new Object[]{
                    rs.getString("warehouse_name"), // [0] - Tên kho
                    rs.getString("location"), // [1] - Địa điểm
                    rs.getInt("totalInbound"), // [2] - Tổng nhập kho
                    rs.getInt("totalOutbound"), // [3] - Tổng xuất kho
                    rs.getDouble("totalProfit"), // [4] - Tổng lợi nhuận
                    rs.getDouble("avgUtilizationRate"), // [5] - Tỷ lệ sử dụng kho TB (%)
                    rs.getInt("totalOrders") // [6] - Tổng số đơn hàng
                };
                result.add(unitData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }


    // ========== THÊM MỚI: Các phương thức cho báo cáo hiệu suất hoạt động nhập/xuất kho ==========
    /**
     * Lấy dữ liệu tần suất nhập/xuất kho theo tháng cho từng kho (6 tháng gần
     * nhất)
     *
     * @return Vector<Object[]> - [warehouseName, year, month, inboundCount,
     * outboundCount, inboundFrequency, outboundFrequency]
     */
    public Vector<Object[]> getWarehouseInOutFrequencyData() {
        Vector<Object[]> result = new Vector<>();
        String sql = "WITH MonthlyData AS ( "
                + "    SELECT "
                + "        su.warehouse_name, "
                + "        YEAR(sr.report_date) as report_year, "
                + "        MONTH(sr.report_date) as report_month, "
                + "        SUM(sr.inbound_count) as total_inbound, "
                + "        SUM(sr.outbound_count) as total_outbound, "
                + "        COUNT(*) as days_in_month "
                + "    FROM StorageReport sr "
                + "    JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "    WHERE su.registration_status = 'approved' "
                + "    GROUP BY su.warehouse_name, YEAR(sr.report_date), MONTH(sr.report_date) "
                + "), "
                + "RankedData AS ( "
                + "    SELECT *, "
                + "        ROW_NUMBER() OVER (ORDER BY report_year DESC, report_month DESC) as rn "
                + "    FROM MonthlyData "
                + ") "
                + "SELECT "
                + "    warehouse_name, "
                + "    report_year, "
                + "    report_month, "
                + "    total_inbound, "
                + "    total_outbound, "
                + "    CAST(total_inbound AS FLOAT) / days_in_month as inbound_frequency, "
                + "    CAST(total_outbound AS FLOAT) / days_in_month as outbound_frequency "
                + "FROM RankedData "
                + "WHERE rn <= 36 "
                + // 6 tháng x 6 kho tối đa
                "ORDER BY report_year DESC, report_month DESC, warehouse_name";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] frequencyData = new Object[]{
                    rs.getString("warehouse_name"), // [0] - Tên kho
                    rs.getInt("report_year"), // [1] - Năm
                    rs.getInt("report_month"), // [2] - Tháng
                    rs.getInt("total_inbound"), // [3] - Tổng nhập kho
                    rs.getInt("total_outbound"), // [4] - Tổng xuất kho
                    rs.getDouble("inbound_frequency"), // [5] - Tần suất nhập (lần/ngày)
                    rs.getDouble("outbound_frequency") // [6] - Tần suất xuất (lần/ngày)
                };
                result.add(frequencyData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Lấy dữ liệu tỷ lệ đơn hàng trả lại theo kho
     *
     * @return Vector<Object[]> - [warehouseName, totalOrders, returnedOrders,
     * returnRate, location]
     */
    public Vector<Object[]> getWarehouseReturnRateData() {
        Vector<Object[]> result = new Vector<>();
        String sql = "SELECT "
                + "    su.warehouse_name, "
                + "    su.location, "
                + "    SUM(sr.order_count) as total_orders, "
                + "    SUM(sr.returned_orders) as total_returned, "
                + "    CASE "
                + "        WHEN SUM(sr.order_count) > 0 THEN "
                + "            CAST(SUM(sr.returned_orders) AS FLOAT) * 100.0 / SUM(sr.order_count) "
                + "        ELSE 0 "
                + "    END as return_rate "
                + "FROM StorageReport sr "
                + "JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "WHERE su.registration_status = 'approved' "
                + "GROUP BY su.storage_unit_id, su.warehouse_name, su.location "
                + "HAVING SUM(sr.order_count) > 0 "
                + "ORDER BY return_rate DESC";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] returnData = new Object[]{
                    rs.getString("warehouse_name"), // [0] - Tên kho
                    rs.getInt("total_orders"), // [1] - Tổng đơn hàng
                    rs.getInt("total_returned"), // [2] - Đơn hàng trả lại
                    rs.getDouble("return_rate"), // [3] - Tỷ lệ trả hàng (%)
                    rs.getString("location") // [4] - Vị trí kho
                };
                result.add(returnData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * ========== THÊM MỚI: Phương thức lấy dữ liệu sử dụng không gian lưu trữ ==========
     * Lấy dữ liệu sử dụng không gian lưu trữ theo kho
     *
     * @return Vector<Object[]> - [warehouseName, avgUsedArea, avgTotalArea,
     * avgUtilizationRate, maxUtilizationRate, minUtilizationRate, location]
     */
    public Vector<Object[]> getWarehouseSpaceUtilizationData() {
        Vector<Object[]> result = new Vector<>();
        String sql = "SELECT "
                + "    su.warehouse_name, "
                + "    su.location, "
                + "    AVG(sr.used_area) as avg_used_area, "
                + "    AVG(sr.total_area) as avg_total_area, "
                + "    AVG(sr.used_area * 100.0 / sr.total_area) as avg_utilization_rate, "
                + "    MAX(sr.used_area * 100.0 / sr.total_area) as max_utilization_rate, "
                + "    MIN(sr.used_area * 100.0 / sr.total_area) as min_utilization_rate "
                + "FROM StorageReport sr "
                + "JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "WHERE su.registration_status = 'approved' "
                + "AND sr.total_area > 0 "
                + "GROUP BY su.storage_unit_id, su.warehouse_name, su.location "
                + "ORDER BY avg_utilization_rate DESC";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] spaceData = new Object[]{
                    rs.getString("warehouse_name"), // [0] - Tên kho
                    rs.getDouble("avg_used_area"), // [1] - Diện tích sử dụng trung bình
                    rs.getDouble("avg_total_area"), // [2] - Tổng diện tích trung bình
                    rs.getDouble("avg_utilization_rate"), // [3] - Tỷ lệ sử dụng trung bình (%)
                    rs.getDouble("max_utilization_rate"), // [4] - Tỷ lệ sử dụng tối đa (%)
                    rs.getDouble("min_utilization_rate"), // [5] - Tỷ lệ sử dụng tối thiểu (%)
                    rs.getString("location") // [6] - Vị trí kho
                };
                result.add(spaceData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
     * Lấy dữ liệu phân tích nguyên nhân trả hàng theo kho
     *
     * @return Vector<Object[]> - [warehouseName, returnReason, returnCount,
     * returnPercentage]
     */
    public Vector<Object[]> getWarehouseReturnReasonAnalysis() {
        Vector<Object[]> result = new Vector<>();
        // Giả lập dữ liệu nguyên nhân trả hàng (trong thực tế sẽ có bảng riêng để lưu trữ)
        String sql = "WITH ReturnData AS ( "
                + "    SELECT "
                + "        su.warehouse_name, "
                + "        sr.returned_orders, "
                + "        CASE "
                + "            WHEN sr.returned_orders <= 50 THEN 'Sai sản phẩm' "
                + "            WHEN sr.returned_orders <= 100 THEN 'Hư hỏng khi vận chuyển' "
                + "            WHEN sr.returned_orders <= 150 THEN 'Không đúng chất lượng' "
                + "            ELSE 'Lý do khác' "
                + "        END as return_reason "
                + "    FROM StorageReport sr "
                + "    JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "    WHERE su.registration_status = 'approved' AND sr.returned_orders > 0 "
                + "), "
                + "ReasonSummary AS ( "
                + "    SELECT "
                + "        warehouse_name, "
                + "        return_reason, "
                + "        SUM(returned_orders) as reason_count "
                + "    FROM ReturnData "
                + "    GROUP BY warehouse_name, return_reason "
                + "), "
                + "WarehouseTotals AS ( "
                + "    SELECT "
                + "        warehouse_name, "
                + "        SUM(reason_count) as total_returns "
                + "    FROM ReasonSummary "
                + "    GROUP BY warehouse_name "
                + ") "
                + "SELECT "
                + "    rs.warehouse_name, "
                + "    rs.return_reason, "
                + "    rs.reason_count, "
                + "    CAST(rs.reason_count AS FLOAT) * 100.0 / wt.total_returns as return_percentage "
                + "FROM ReasonSummary rs "
                + "JOIN WarehouseTotals wt ON rs.warehouse_name = wt.warehouse_name "
                + "ORDER BY rs.warehouse_name, rs.reason_count DESC";

        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] reasonData = new Object[]{
                    rs.getString("warehouse_name"), // [0] - Tên kho
                    rs.getString("return_reason"), // [1] - Nguyên nhân trả hàng
                    rs.getInt("reason_count"), // [2] - Số lượng trả hàng
                    rs.getDouble("return_percentage") // [3] - Tỷ lệ phần trăm
                };
                result.add(reasonData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }

    /**
 * Lấy thống kê hoạt động nhập/xuất kho theo tháng với bộ lọc (6 tháng gần nhất)
 *
 * @param storageUnitId ID đơn vị kho (0 nếu không lọc theo ID)
 * @param fromMonth Tháng bắt đầu (định dạng YYYY-MM hoặc null)
 * @param toMonth Tháng kết thúc (định dạng YYYY-MM hoặc null)
 * @return Vector<Object[]> - [warehouseName, year, month, monthlyInbound, 
 * monthlyOutbound, efficiency]
 */
public Vector<Object[]> getFilteredMonthlyInOutActivity(int storageUnitId, String fromMonth, String toMonth) {
    Vector<Object[]> result = new Vector<>();
    StringBuilder sql = new StringBuilder();
    
    sql.append("WITH MonthlyData AS ( ");
    sql.append("    SELECT ");
    sql.append("        su.warehouse_name, ");
    sql.append("        YEAR(sr.report_date) as report_year, ");
    sql.append("        MONTH(sr.report_date) as report_month, ");
    sql.append("        SUM(sr.inbound_count) as monthly_inbound, ");
    sql.append("        SUM(sr.outbound_count) as monthly_outbound ");
    sql.append("    FROM StorageReport sr ");
    sql.append("    JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id ");
    sql.append("    WHERE su.registration_status = 'approved' ");
    
    Vector<Object> parameters = new Vector<>();
    
    // Lọc theo storage_unit_id
    if (storageUnitId > 0) {
        sql.append("    AND sr.storage_unit_id = ? ");
        parameters.add(storageUnitId);
    }
    
    // Lọc theo khoảng thời gian
    if (fromMonth != null && !fromMonth.trim().isEmpty()) {
        sql.append("    AND sr.report_date >= ? ");
        parameters.add(fromMonth + "-01");
    }
    
    if (toMonth != null && !toMonth.trim().isEmpty()) {
        String endDate = getMonthEndDate(toMonth);
        sql.append("    AND sr.report_date <= ? ");
        parameters.add(endDate);
    }
    
    sql.append("    GROUP BY su.warehouse_name, YEAR(sr.report_date), MONTH(sr.report_date) ");
    sql.append("), ");
    sql.append("RankedData AS ( ");
    sql.append("    SELECT *, ");
    sql.append("        ROW_NUMBER() OVER (ORDER BY report_year DESC, report_month DESC) as rn ");
    sql.append("    FROM MonthlyData ");
    sql.append(") ");
    sql.append("SELECT ");
    sql.append("    warehouse_name, ");
    sql.append("    report_year, ");
    sql.append("    report_month, ");
    sql.append("    monthly_inbound, ");
    sql.append("    monthly_outbound, ");
    sql.append("    CASE ");
    sql.append("        WHEN monthly_inbound > 0 THEN ");
    sql.append("            CAST(monthly_outbound AS FLOAT) / monthly_inbound ");
    sql.append("        ELSE 0 ");
    sql.append("    END as efficiency_ratio ");
    sql.append("FROM RankedData ");
    
    // Nếu không có bộ lọc thời gian, chỉ lấy 6 tháng gần nhất
    if ((fromMonth == null || fromMonth.trim().isEmpty()) && 
        (toMonth == null || toMonth.trim().isEmpty())) {
        sql.append("WHERE rn <= 36 "); // 6 tháng x 6 kho tối đa
    }
    
    sql.append("ORDER BY report_year DESC, report_month DESC, warehouse_name");

    try {
        PreparedStatement pstmt = conn.prepareStatement(sql.toString());

        // Log SQL để debug
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, 
            "Filtered Monthly Activity SQL Query: " + sql.toString());
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, 
            "Parameters: " + parameters.toString());

        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            pstmt.setObject(i + 1, parameters.get(i));
        }

        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            Object[] monthlyData = new Object[]{
                rs.getString("warehouse_name"), // [0] - Tên kho
                rs.getInt("report_year"), // [1] - Năm
                rs.getInt("report_month"), // [2] - Tháng
                rs.getInt("monthly_inbound"), // [3] - Nhập kho tháng
                rs.getInt("monthly_outbound"), // [4] - Xuất kho tháng
                rs.getDouble("efficiency_ratio") // [5] - Tỷ lệ hiệu suất
            };
            result.add(monthlyData);
        }

        rs.close();
        pstmt.close();

        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, 
            "Filtered Monthly Activity Query result count: " + result.size());

    } catch (SQLException ex) {
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, 
            "SQL Error in getFilteredMonthlyInOutActivity", ex);
    }

    return result;
}

    /**
     * Lấy dữ liệu so sánh hiệu suất nhập/xuất giữa các kho
     *
     * @return Vector<Object[]> - [warehouseName, avgInbound, avgOutbound,
     * totalCapacity, utilizationRate, performanceScore]
     */
    public Vector<Object[]> getWarehousePerformanceComparison() {
        Vector<Object[]> result = new Vector<>();
        String sql = "WITH PerformanceData AS ( "
                + "    SELECT "
                + "        su.warehouse_name, "
                + "        su.location, "
                + "        AVG(CAST(sr.inbound_count AS FLOAT)) as avg_inbound, "
                + "        AVG(CAST(sr.outbound_count AS FLOAT)) as avg_outbound, "
                + "        AVG(sr.total_area) as avg_capacity, "
                + "        AVG(sr.used_area * 100.0 / sr.total_area) as avg_utilization, "
                + "        SUM(sr.profit) as total_profit "
                + "    FROM StorageReport sr "
                + "    JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id "
                + "    WHERE su.registration_status = 'approved' "
                + "    GROUP BY su.storage_unit_id, su.warehouse_name, su.location "
                + ") "
                + "SELECT "
                + "    warehouse_name, "
                + "    avg_inbound, "
                + "    avg_outbound, "
                + "    avg_capacity, "
                + "    avg_utilization, "
                + "    -- Tính điểm hiệu suất tổng hợp (0-100) "
                + "    CASE "
                + "        WHEN avg_inbound > 0 THEN "
                + "            (avg_outbound / avg_inbound * 30) + " + //30 % cho tỷ lệ xuất / nhập
        "            (avg_utilization * 0.4) + " +             // 40% cho tỷ lệ sử dụng
        "            (CASE WHEN total_profit > 0 THEN 30 ELSE 0 END) " + // 30% cho lợi nhuận
        "        ELSE 0 " +
                 "    END as performance_score, " +
                 "    location " +
                 "FROM PerformanceData " +
                 "ORDER BY performance_score DESC";
    
        try {
            Statement state = conn.createStatement();
            ResultSet rs = state.executeQuery(sql);

            while (rs.next()) {
                Object[] performanceData = new Object[]{
                    rs.getString("warehouse_name"), // [0] - Tên kho
                    rs.getDouble("avg_inbound"), // [1] - TB nhập kho
                    rs.getDouble("avg_outbound"), // [2] - TB xuất kho
                    rs.getDouble("avg_capacity"), // [3] - Dung lượng TB
                    rs.getDouble("avg_utilization"), // [4] - Tỷ lệ sử dụng TB
                    rs.getDouble("performance_score"), // [5] - Điểm hiệu suất
                    rs.getString("location") // [6] - Vị trí
                };
                result.add(performanceData);
            }

            rs.close();
            state.close();

        } catch (SQLException ex) {
            Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return result;
    }
    
    // ========== THÊM MỚI: Các phương thức lọc dữ liệu hiệu suất hoạt động ==========

/**
 * Lấy dữ liệu tần suất nhập/xuất kho theo kho với bộ lọc
 *
 * @param storageUnitId ID đơn vị kho (0 nếu không lọc theo ID)
 * @param fromMonth Tháng bắt đầu (định dạng YYYY-MM hoặc null)
 * @param toMonth Tháng kết thúc (định dạng YYYY-MM hoặc null)
 * @return Vector<Object[]> - [warehouseName, year, month, inboundCount, outboundCount, inboundFrequency, outboundFrequency]
 */
public Vector<Object[]> getFilteredWarehouseInOutFrequencyData(int storageUnitId, String fromMonth, String toMonth) {
    Vector<Object[]> result = new Vector<>();
    StringBuilder sql = new StringBuilder();
    
    sql.append("WITH MonthlyData AS ( ");
    sql.append("    SELECT ");
    sql.append("        su.warehouse_name, ");
    sql.append("        YEAR(sr.report_date) as report_year, ");
    sql.append("        MONTH(sr.report_date) as report_month, ");
    sql.append("        SUM(sr.inbound_count) as total_inbound, ");
    sql.append("        SUM(sr.outbound_count) as total_outbound, ");
    sql.append("        COUNT(*) as days_in_month ");
    sql.append("    FROM StorageReport sr ");
    sql.append("    JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id ");
    sql.append("    WHERE su.registration_status = 'approved' ");
    
    Vector<Object> parameters = new Vector<>();
    
    // Lọc theo storage_unit_id
    if (storageUnitId > 0) {
        sql.append("    AND sr.storage_unit_id = ? ");
        parameters.add(storageUnitId);
    }
    
    // Lọc theo khoảng thời gian
    if (fromMonth != null && !fromMonth.trim().isEmpty()) {
        sql.append("    AND sr.report_date >= ? ");
        parameters.add(fromMonth + "-01");
    }
    
    if (toMonth != null && !toMonth.trim().isEmpty()) {
        // Xử lý tháng chẵn và tháng 2
        String endDate = getMonthEndDate(toMonth);
        sql.append("    AND sr.report_date <= ? ");
        parameters.add(endDate);
    }
    
    sql.append("    GROUP BY su.warehouse_name, YEAR(sr.report_date), MONTH(sr.report_date) ");
    sql.append(") ");
    sql.append("SELECT ");
    sql.append("    warehouse_name, ");
    sql.append("    report_year, ");
    sql.append("    report_month, ");
    sql.append("    total_inbound, ");
    sql.append("    total_outbound, ");
    sql.append("    CAST(total_inbound AS FLOAT) / days_in_month as inbound_frequency, ");
    sql.append("    CAST(total_outbound AS FLOAT) / days_in_month as outbound_frequency ");
    sql.append("FROM MonthlyData ");
    sql.append("ORDER BY report_year DESC, report_month DESC, warehouse_name");

    try {
        PreparedStatement pstmt = conn.prepareStatement(sql.toString());

        // Log SQL để debug
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, 
            "Filtered Frequency SQL Query: " + sql.toString());
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, 
            "Parameters: " + parameters.toString());

        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            pstmt.setObject(i + 1, parameters.get(i));
        }

        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            Object[] frequencyData = new Object[]{
                rs.getString("warehouse_name"), // [0] - Tên kho
                rs.getInt("report_year"), // [1] - Năm
                rs.getInt("report_month"), // [2] - Tháng
                rs.getInt("total_inbound"), // [3] - Tổng nhập kho
                rs.getInt("total_outbound"), // [4] - Tổng xuất kho
                rs.getDouble("inbound_frequency"), // [5] - Tần suất nhập (lần/ngày)
                rs.getDouble("outbound_frequency") // [6] - Tần suất xuất (lần/ngày)
            };
            result.add(frequencyData);
        }

        rs.close();
        pstmt.close();

        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.INFO, 
            "Filtered Frequency Query result count: " + result.size());

    } catch (SQLException ex) {
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, 
            "SQL Error in getFilteredWarehouseInOutFrequencyData", ex);
    }

    return result;
}

/**
 * Lấy dữ liệu tỷ lệ đơn hàng trả lại theo kho với bộ lọc
 *
 * @param storageUnitId ID đơn vị kho (0 nếu không lọc theo ID)
 * @param fromMonth Tháng bắt đầu (định dạng YYYY-MM hoặc null)
 * @param toMonth Tháng kết thúc (định dạng YYYY-MM hoặc null)
 * @return Vector<Object[]> - [warehouseName, totalOrders, returnedOrders, returnRate, location]
 */
public Vector<Object[]> getFilteredWarehouseReturnRateData(int storageUnitId, String fromMonth, String toMonth) {
    Vector<Object[]> result = new Vector<>();
    StringBuilder sql = new StringBuilder();
    
    sql.append("SELECT ");
    sql.append("    su.warehouse_name, ");
    sql.append("    su.location, ");
    sql.append("    SUM(sr.order_count) as total_orders, ");
    sql.append("    SUM(sr.returned_orders) as total_returned, ");
    sql.append("    CASE ");
    sql.append("        WHEN SUM(sr.order_count) > 0 THEN ");
    sql.append("            CAST(SUM(sr.returned_orders) AS FLOAT) * 100.0 / SUM(sr.order_count) ");
    sql.append("        ELSE 0 ");
    sql.append("    END as return_rate ");
    sql.append("FROM StorageReport sr ");
    sql.append("JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id ");
    sql.append("WHERE su.registration_status = 'approved' ");
    
    Vector<Object> parameters = new Vector<>();
    
    // Lọc theo storage_unit_id
    if (storageUnitId > 0) {
        sql.append("AND sr.storage_unit_id = ? ");
        parameters.add(storageUnitId);
    }
    
    // Lọc theo khoảng thời gian
    if (fromMonth != null && !fromMonth.trim().isEmpty()) {
        sql.append("AND sr.report_date >= ? ");
        parameters.add(fromMonth + "-01");
    }
    
    if (toMonth != null && !toMonth.trim().isEmpty()) {
        String endDate = getMonthEndDate(toMonth);
        sql.append("AND sr.report_date <= ? ");
        parameters.add(endDate);
    }
    
    sql.append("GROUP BY su.storage_unit_id, su.warehouse_name, su.location ");
    sql.append("HAVING SUM(sr.order_count) > 0 ");
    sql.append("ORDER BY return_rate DESC");

    try {
        PreparedStatement pstmt = conn.prepareStatement(sql.toString());

        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            pstmt.setObject(i + 1, parameters.get(i));
        }

        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            Object[] returnData = new Object[]{
                rs.getString("warehouse_name"), // [0] - Tên kho
                rs.getInt("total_orders"), // [1] - Tổng đơn hàng
                rs.getInt("total_returned"), // [2] - Đơn hàng trả lại
                rs.getDouble("return_rate"), // [3] - Tỷ lệ trả hàng (%)
                rs.getString("location") // [4] - Vị trí kho
            };
            result.add(returnData);
        }

        rs.close();
        pstmt.close();

    } catch (SQLException ex) {
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, 
            "SQL Error in getFilteredWarehouseReturnRateData", ex);
    }

    return result;
}

/**
 * Lấy dữ liệu sử dụng không gian lưu trữ theo kho với bộ lọc
 *
 * @param storageUnitId ID đơn vị kho (0 nếu không lọc theo ID)
 * @param fromMonth Tháng bắt đầu (định dạng YYYY-MM hoặc null)
 * @param toMonth Tháng kết thúc (định dạng YYYY-MM hoặc null)
 * @return Vector<Object[]> - [warehouseName, avgUsedArea, avgTotalArea, avgUtilizationRate, maxUtilizationRate, minUtilizationRate, location]
 */
public Vector<Object[]> getFilteredWarehouseSpaceUtilizationData(int storageUnitId, String fromMonth, String toMonth) {
    Vector<Object[]> result = new Vector<>();
    StringBuilder sql = new StringBuilder();
    
    sql.append("SELECT ");
    sql.append("    su.warehouse_name, ");
    sql.append("    su.location, ");
    sql.append("    AVG(sr.used_area) as avg_used_area, ");
    sql.append("    AVG(sr.total_area) as avg_total_area, ");
    sql.append("    AVG(sr.used_area * 100.0 / sr.total_area) as avg_utilization_rate, ");
    sql.append("    MAX(sr.used_area * 100.0 / sr.total_area) as max_utilization_rate, ");
    sql.append("    MIN(sr.used_area * 100.0 / sr.total_area) as min_utilization_rate ");
    sql.append("FROM StorageReport sr ");
    sql.append("JOIN StorageUnits su ON sr.storage_unit_id = su.storage_unit_id ");
    sql.append("WHERE su.registration_status = 'approved' ");
    sql.append("AND sr.total_area > 0 ");
    
    Vector<Object> parameters = new Vector<>();
    
    // Lọc theo storage_unit_id
    if (storageUnitId > 0) {
        sql.append("AND sr.storage_unit_id = ? ");
        parameters.add(storageUnitId);
    }
    
    // Lọc theo khoảng thời gian
    if (fromMonth != null && !fromMonth.trim().isEmpty()) {
        sql.append("AND sr.report_date >= ? ");
        parameters.add(fromMonth + "-01");
    }
    
    if (toMonth != null && !toMonth.trim().isEmpty()) {
        String endDate = getMonthEndDate(toMonth);
        sql.append("AND sr.report_date <= ? ");
        parameters.add(endDate);
    }
    
    sql.append("GROUP BY su.storage_unit_id, su.warehouse_name, su.location ");
    sql.append("ORDER BY avg_utilization_rate DESC");

    try {
        PreparedStatement pstmt = conn.prepareStatement(sql.toString());

        // Set parameters
        for (int i = 0; i < parameters.size(); i++) {
            pstmt.setObject(i + 1, parameters.get(i));
        }

        ResultSet rs = pstmt.executeQuery();

        while (rs.next()) {
            Object[] spaceData = new Object[]{
                rs.getString("warehouse_name"), // [0] - Tên kho
                rs.getDouble("avg_used_area"), // [1] - Diện tích sử dụng trung bình
                rs.getDouble("avg_total_area"), // [2] - Tổng diện tích trung bình
                rs.getDouble("avg_utilization_rate"), // [3] - Tỷ lệ sử dụng trung bình (%)
                rs.getDouble("max_utilization_rate"), // [4] - Tỷ lệ sử dụng tối đa (%)
                rs.getDouble("min_utilization_rate"), // [5] - Tỷ lệ sử dụng tối thiểu (%)
                rs.getString("location") // [6] - Vị trí kho
            };
            result.add(spaceData);
        }

        rs.close();
        pstmt.close();

    } catch (SQLException ex) {
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.SEVERE, 
            "SQL Error in getFilteredWarehouseSpaceUtilizationData", ex);
    }

    return result;
}

/**
 * Hàm hỗ trợ tính toán ngày cuối tháng (xử lý tháng chẵn và tháng 2)
 *
 * @param monthYear Chuỗi định dạng YYYY-MM
 * @return Chuỗi ngày cuối tháng định dạng YYYY-MM-DD
 */
private String getMonthEndDate(String monthYear) {
    try {
        String[] parts = monthYear.split("-");
        int year = Integer.parseInt(parts[0]);
        int month = Integer.parseInt(parts[1]);
        
        int lastDay;
        switch (month) {
            case 2: // Tháng 2
                // Kiểm tra năm nhuận
                if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
                    lastDay = 29; // Năm nhuận
                } else {
                    lastDay = 28; // Năm thường
                }
                break;
            case 4: case 6: case 9: case 11: // Tháng chẵn có 30 ngày
                lastDay = 30;
                break;
            default: // Tháng lẻ có 31 ngày
                lastDay = 31;
                break;
        }
        
        return String.format("%04d-%02d-%02d", year, month, lastDay);
        
    } catch (Exception e) {
        Logger.getLogger(StorageReportDataDAO.class.getName()).log(Level.WARNING, 
            "Error calculating month end date for: " + monthYear, e);
        return monthYear + "-31"; // Fallback
    }
}
}