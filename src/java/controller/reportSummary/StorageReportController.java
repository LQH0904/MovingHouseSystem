/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reportSummary;

import dao.StorageReportDataDAO;
import model.StorageReport;
import model.StorageUnit;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Vector;
import java.util.Map;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Admin
 */
@WebServlet(name = "StorageReportController", urlPatterns = {"/StorageReportController"})
public class StorageReportController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StorageReportController.class.getName());

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        String service = request.getParameter("service");

        if (service == null) {
            service = "viewCostAndProfit";
        }

        switch (service) {
            case "viewCostAndProfit":
                showCostAndProfitReport(request, response);
                break;
            case "filterCostAndProfit":
                filterCostAndProfitReport(request, response);
                break;
            case "filterPerformanceActivity":
                filterPerformanceActivityReport(request, response);
                break;
            default:
                showCostAndProfitReport(request, response);
                break;
        }
    }

    /**
     * Hiển thị trang báo cáo chi phí và lợi nhuận
     */
    private void showCostAndProfitReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            StorageReportDataDAO dao = new StorageReportDataDAO();

            // Lấy dữ liệu báo cáo kho
            Vector<StorageReport> storageReports = dao.getAllStorageReportData();

            // Lấy danh sách các kho
            Vector<StorageUnit> storageUnits = dao.getAllStorageUnits();

            // Lấy dữ liệu theo tháng (6 tháng gần nhất)
            Vector<Object[]> monthlyData = dao.getStorageMonthlyReportData();

            // Lấy thống kê theo từng kho
            Vector<Object[]> storageUnitStats = dao.getStorageUnitStatistics();

            // Lấy thống kê tổng quan
            double[] overallStats = dao.getStorageOverallStatistics();

            // ========== THÊM MỚI: Dữ liệu cho hiệu suất hoạt động ==========
            // Lấy dữ liệu tần suất nhập/xuất kho (6 tháng gần nhất)
            Vector<Object[]> inOutFrequencyData = dao.getWarehouseInOutFrequencyData();

            // Lấy dữ liệu tỷ lệ trả hàng
            Vector<Object[]> returnRateData = dao.getWarehouseReturnRateData();

            // Lấy dữ liệu sử dụng không gian
            Vector<Object[]> spaceUtilizationData = dao.getWarehouseSpaceUtilizationData();

            // Lấy dữ liệu thời gian lưu trữ trung bình
            Vector<Object[]> averageStorageDurationData = dao.getAverageStorageDurationData();

            // ========== THÊM MỚI: Chuẩn bị dữ liệu cho biểu đồ theo từng kho ==========
            Map<String, Map<String, Object>> warehouseMonthlyData = prepareWarehouseMonthlyData(storageReports);
            Map<String, Double> warehouseTotalCosts = prepareWarehouseTotalCosts(storageReports);
            Map<String, Double> warehousePersonnelCosts = prepareWarehousePersonnelCosts(storageReports);

            // Debug log
            LOGGER.log(Level.INFO, "CostAndProfitSRController - storageReports size: "
                    + (storageReports != null ? storageReports.size() : "null"));
            LOGGER.log(Level.INFO, "CostAndProfitSRController - storageUnits size: "
                    + (storageUnits != null ? storageUnits.size() : "null"));
            LOGGER.log(Level.INFO, "CostAndProfitSRController - monthlyData size: "
                    + (monthlyData != null ? monthlyData.size() : "null"));
            LOGGER.log(Level.INFO, "CostAndProfitSRController - inOutFrequencyData size: "
                    + (inOutFrequencyData != null ? inOutFrequencyData.size() : "null"));

            // Đặt dữ liệu vào request attributes
            request.setAttribute("storageReports", storageReports);
            request.setAttribute("storageUnits", storageUnits);
            request.setAttribute("monthlyData", monthlyData);
            request.setAttribute("storageUnitStats", storageUnitStats);
            request.setAttribute("overallStats", overallStats);

            // ========== THÊM MỚI: Dữ liệu cho biểu đồ theo từng kho ==========
            request.setAttribute("warehouseMonthlyData", warehouseMonthlyData);
            request.setAttribute("warehouseTotalCosts", warehouseTotalCosts);
            request.setAttribute("warehousePersonnelCosts", warehousePersonnelCosts);

            // ========== THÊM MỚI: Dữ liệu cho hiệu suất hoạt động ==========
            request.setAttribute("inOutFrequencyData", inOutFrequencyData);
            request.setAttribute("returnRateData", returnRateData);
            request.setAttribute("spaceUtilizationData", spaceUtilizationData);
            request.setAttribute("averageStorageDurationData", averageStorageDurationData);

            // Forward đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/lístStorageReport.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in showCostAndProfitReport", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi tải dữ liệu báo cáo chi phí và lợi nhuận: " + e.getMessage());
        }
    }

    /**
     * Lọc báo cáo chi phí và lợi nhuận theo các tiêu chí
     */
    private void filterCostAndProfitReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số filter
            String storageUnitIdStr = request.getParameter("storageUnitId");
            String fromMonth = request.getParameter("fromMonth");
            String toMonth = request.getParameter("toMonth");
            String warehouseName = request.getParameter("warehouseName");

            // Xử lý storage unit ID
            int storageUnitId = 0;
            if (storageUnitIdStr != null && !storageUnitIdStr.trim().isEmpty()) {
                try {
                    storageUnitId = Integer.parseInt(storageUnitIdStr);
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid storage unit ID: " + storageUnitIdStr);
                }
            }

            // Chuyển đổi format tháng cho SQL (từ "2025-01" thành "2025-01-01")
            if (fromMonth != null && !fromMonth.trim().isEmpty()) {
                fromMonth = fromMonth + "-01";
            }
            if (toMonth != null && !toMonth.trim().isEmpty()) {
                toMonth = toMonth + "-31"; // Lấy đến cuối tháng
            }

            StorageReportDataDAO dao = new StorageReportDataDAO();

            // Lấy dữ liệu đã được lọc
            Vector<StorageReport> filteredReports = dao.getFilteredStorageReportData(
                    storageUnitId, fromMonth, toMonth, warehouseName);

            // Lấy danh sách các kho (không thay đổi)
            Vector<StorageUnit> storageUnits = dao.getAllStorageUnits();

            // Lấy dữ liệu theo tháng (6 tháng gần nhất)
            Vector<Object[]> monthlyData = dao.getStorageMonthlyReportData();

            // Lấy thống kê theo từng kho
            Vector<Object[]> storageUnitStats = dao.getStorageUnitStatistics();

            // Lấy thống kê tổng quan
            double[] overallStats = dao.getStorageOverallStatistics();

            // ========== THÊM MỚI: Dữ liệu cho hiệu suất hoạt động (không lọc) ==========
            Vector<Object[]> inOutFrequencyData = dao.getWarehouseInOutFrequencyData();
            Vector<Object[]> returnRateData = dao.getWarehouseReturnRateData();
            Vector<Object[]> spaceUtilizationData = dao.getWarehouseSpaceUtilizationData();
            Vector<Object[]> averageStorageDurationData = dao.getAverageStorageDurationData();

            // ========== THÊM MỚI: Chuẩn bị dữ liệu cho biểu đồ theo từng kho (dựa trên dữ liệu đã lọc) ==========
            Map<String, Map<String, Object>> warehouseMonthlyData = prepareWarehouseMonthlyData(filteredReports);
            Map<String, Double> warehouseTotalCosts = prepareWarehouseTotalCosts(filteredReports);
            Map<String, Double> warehousePersonnelCosts = prepareWarehousePersonnelCosts(filteredReports);

            LOGGER.log(Level.INFO, "Filter parameters - StorageUnitId: " + storageUnitId
                    + ", FromMonth: " + fromMonth + ", ToMonth: " + toMonth
                    + ", WarehouseName: " + warehouseName);
            LOGGER.log(Level.INFO, "Filtered results - Reports: " + filteredReports.size());

            // Đặt dữ liệu vào request attributes
            request.setAttribute("storageReports", filteredReports);
            request.setAttribute("storageUnits", storageUnits);
            request.setAttribute("monthlyData", monthlyData);
            request.setAttribute("storageUnitStats", storageUnitStats);
            request.setAttribute("overallStats", overallStats);

            // ========== THÊM MỚI: Dữ liệu cho biểu đồ theo từng kho ==========
            request.setAttribute("warehouseMonthlyData", warehouseMonthlyData);
            request.setAttribute("warehouseTotalCosts", warehouseTotalCosts);
            request.setAttribute("warehousePersonnelCosts", warehousePersonnelCosts);

            // ========== THÊM MỚI: Dữ liệu cho hiệu suất hoạt động ==========
            request.setAttribute("inOutFrequencyData", inOutFrequencyData);
            request.setAttribute("returnRateData", returnRateData);
            request.setAttribute("spaceUtilizationData", spaceUtilizationData);
            request.setAttribute("averageStorageDurationData", averageStorageDurationData);

            // Giữ lại các giá trị filter đã chọn (chuyển lại format hiển thị)
            String displayFromMonth = "";
            String displayToMonth = "";

            if (fromMonth != null && fromMonth.length() >= 7) {
                displayFromMonth = fromMonth.substring(0, 7);
            }
            if (toMonth != null && toMonth.length() >= 7) {
                displayToMonth = toMonth.substring(0, 7);
            }

            request.setAttribute("selectedStorageUnitId", storageUnitIdStr);
            request.setAttribute("selectedFromMonth", displayFromMonth);
            request.setAttribute("selectedToMonth", displayToMonth);
            request.setAttribute("selectedWarehouseName", warehouseName);

            // Forward đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/lístStorageReport.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in filterCostAndProfitReport", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi lọc dữ liệu báo cáo: " + e.getMessage());
        }
    }

    /**
     * ========== THÊM MỚI: Lọc báo cáo hiệu suất hoạt động ========== Lọc báo
     * cáo hiệu suất hoạt động nhập/xuất kho theo các tiêu chí
     */
    /**
     * ========== CẬP NHẬT: Lọc báo cáo hiệu suất hoạt động ========== Lọc báo
     * cáo hiệu suất hoạt động nhập/xuất kho theo các tiêu chí
     */
    private void filterPerformanceActivityReport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số filter cho hiệu suất hoạt động
            String performanceStorageUnitIdStr = request.getParameter("performanceStorageUnitId");
            String performanceFromMonth = request.getParameter("performanceFromMonth");
            String performanceToMonth = request.getParameter("performanceToMonth");

            // Xử lý storage unit ID
            int performanceStorageUnitId = 0;
            if (performanceStorageUnitIdStr != null && !performanceStorageUnitIdStr.trim().isEmpty()) {
                try {
                    performanceStorageUnitId = Integer.parseInt(performanceStorageUnitIdStr);
                } catch (NumberFormatException e) {
                    LOGGER.log(Level.WARNING, "Invalid performance storage unit ID: " + performanceStorageUnitIdStr);
                }
            }

            StorageReportDataDAO dao = new StorageReportDataDAO();

            // ========== Lấy dữ liệu chi phí và lợi nhuận (không lọc) ==========
            Vector<StorageReport> storageReports = dao.getAllStorageReportData();
            Vector<StorageUnit> storageUnits = dao.getAllStorageUnits();
            Vector<Object[]> monthlyData = dao.getStorageMonthlyReportData();
            Vector<Object[]> storageUnitStats = dao.getStorageUnitStatistics();
            double[] overallStats = dao.getStorageOverallStatistics();

            Map<String, Map<String, Object>> warehouseMonthlyData = prepareWarehouseMonthlyData(storageReports);
            Map<String, Double> warehouseTotalCosts = prepareWarehouseTotalCosts(storageReports);
            Map<String, Double> warehousePersonnelCosts = prepareWarehousePersonnelCosts(storageReports);

            // ========== Lấy dữ liệu hiệu suất hoạt động đã được lọc ==========
            Vector<Object[]> filteredInOutFrequencyData = dao.getFilteredWarehouseInOutFrequencyData(
                    performanceStorageUnitId, performanceFromMonth, performanceToMonth);

            Vector<Object[]> filteredReturnRateData = dao.getFilteredWarehouseReturnRateData(
                    performanceStorageUnitId, performanceFromMonth, performanceToMonth);

            Vector<Object[]> filteredSpaceUtilizationData = dao.getFilteredWarehouseSpaceUtilizationData(
                    performanceStorageUnitId, performanceFromMonth, performanceToMonth);

            Vector<Object[]> filteredMonthlyActivityData = dao.getFilteredMonthlyInOutActivity(
                    performanceStorageUnitId, performanceFromMonth, performanceToMonth);

            // ========== THÊM MỚI: Lấy dữ liệu thời gian lưu kho trung bình đã được lọc ==========
            Vector<Object[]> filteredAverageStorageDurationData = dao.getFilteredAverageStorageDurationData(
                    performanceStorageUnitId, performanceFromMonth, performanceToMonth);

            LOGGER.log(Level.INFO, "Performance Filter parameters - StorageUnitId: " + performanceStorageUnitId
                    + ", FromMonth: " + performanceFromMonth + ", ToMonth: " + performanceToMonth);
            LOGGER.log(Level.INFO, "Filtered Performance results - "
                    + "Frequency: " + filteredInOutFrequencyData.size()
                    + ", ReturnRate: " + filteredReturnRateData.size()
                    + ", SpaceUtilization: " + filteredSpaceUtilizationData.size()
                    + ", MonthlyActivity: " + filteredMonthlyActivityData.size()
                    + ", AverageStorageDuration: " + filteredAverageStorageDurationData.size());

            // ========== Đặt dữ liệu vào request attributes ==========
            // Dữ liệu chi phí và lợi nhuận (không lọc)
            request.setAttribute("storageReports", storageReports);
            request.setAttribute("storageUnits", storageUnits);
            request.setAttribute("monthlyData", monthlyData);
            request.setAttribute("storageUnitStats", storageUnitStats);
            request.setAttribute("overallStats", overallStats);

            request.setAttribute("warehouseMonthlyData", warehouseMonthlyData);
            request.setAttribute("warehouseTotalCosts", warehouseTotalCosts);
            request.setAttribute("warehousePersonnelCosts", warehousePersonnelCosts);

            // Dữ liệu hiệu suất hoạt động đã được lọc
            request.setAttribute("filteredInOutFrequencyData", filteredInOutFrequencyData);
            request.setAttribute("filteredReturnRateData", filteredReturnRateData);
            request.setAttribute("filteredSpaceUtilizationData", filteredSpaceUtilizationData);
            request.setAttribute("filteredMonthlyActivityData", filteredMonthlyActivityData);

            // ========== THÊM MỚI: Dữ liệu thời gian lưu kho trung bình đã được lọc ==========
            request.setAttribute("filteredAverageStorageDurationData", filteredAverageStorageDurationData);

            // Dữ liệu hiệu suất hoạt động gốc (fallback)
            request.setAttribute("inOutFrequencyData", dao.getWarehouseInOutFrequencyData());
            request.setAttribute("returnRateData", dao.getWarehouseReturnRateData());
            request.setAttribute("spaceUtilizationData", dao.getWarehouseSpaceUtilizationData());
            request.setAttribute("averageStorageDurationData", dao.getAverageStorageDurationData());

            // Giữ lại các giá trị filter đã chọn cho hiệu suất hoạt động
            request.setAttribute("selectedPerformanceStorageUnitId", performanceStorageUnitIdStr);
            request.setAttribute("selectedPerformanceFromMonth", performanceFromMonth);
            request.setAttribute("selectedPerformanceToMonth", performanceToMonth);

            // Forward đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/lístStorageReport.jsp");
            dispatcher.forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in filterPerformanceActivityReport", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi lọc dữ liệu hiệu suất hoạt động: " + e.getMessage());
        }
    }

    // ========== THÊM MỚI: Các hàm chuẩn bị dữ liệu cho biểu đồ ==========
    /**
     * Chuẩn bị dữ liệu theo tháng cho từng kho
     */
    private Map<String, Map<String, Object>> prepareWarehouseMonthlyData(Vector<StorageReport> reports) {
        Map<String, Map<String, Object>> result = new HashMap<>();

        for (StorageReport report : reports) {
            // Kiểm tra null và empty cho warehouse name
            String warehouseName = report.getWarehouseName();
            if (warehouseName == null || warehouseName.trim().isEmpty()) {
                warehouseName = "Kho không xác định";
            }

            // Kiểm tra null và empty cho report date
            String reportDate = report.getReportDate();
            if (reportDate == null || reportDate.trim().isEmpty() || reportDate.length() < 7) {
                LOGGER.log(Level.WARNING, "Invalid or empty report date for warehouse: " + warehouseName + ", date: " + reportDate);
                continue; // Bỏ qua bản ghi này
            }

            String monthKey;
            try {
                monthKey = reportDate.substring(0, 7); // "2025-01"
            } catch (StringIndexOutOfBoundsException e) {
                LOGGER.log(Level.WARNING, "Cannot extract month from date: " + reportDate + " for warehouse: " + warehouseName);
                continue; // Bỏ qua bản ghi này
            }

            String key = warehouseName + "_" + monthKey;

            if (!result.containsKey(key)) {
                Map<String, Object> data = new HashMap<>();
                data.put("warehouseName", warehouseName);
                data.put("month", monthKey);
                data.put("maintenanceCost", 0.0);
                data.put("profit", 0.0);
                data.put("storageCost", 0.0);
                data.put("personnelCost", 0.0);
                result.put(key, data);
            }

            Map<String, Object> data = result.get(key);

            // Kiểm tra null cho các giá trị numeric
            double maintenanceCost = report.getMaintenanceCost() != 0.0 ? report.getMaintenanceCost() : 0.0;
            double profit = report.getProfit() != 0.0 ? report.getProfit() : 0.0;
            double storageCost = report.getStorageCostPerUnit() != 0.0 ? report.getStorageCostPerUnit() : 0.0;
            double personnelCost = report.getPersonnelCost() != 0.0 ? report.getPersonnelCost() : 0.0;

            data.put("maintenanceCost", (Double) data.get("maintenanceCost") + maintenanceCost);
            data.put("profit", (Double) data.get("profit") + profit);
            data.put("storageCost", (Double) data.get("storageCost") + storageCost);
            data.put("personnelCost", (Double) data.get("personnelCost") + personnelCost);
        }

        return result;
    }

    /**
     * Chuẩn bị tổng chi phí theo từng kho
     */
    private Map<String, Double> prepareWarehouseTotalCosts(Vector<StorageReport> reports) {
        Map<String, Double> result = new HashMap<>();

        for (StorageReport report : reports) {
            String warehouseName = report.getWarehouseName();
            if (warehouseName == null || warehouseName.trim().isEmpty()) {
                warehouseName = "Kho không xác định";
            }

            // Kiểm tra null cho các giá trị numeric
            double maintenanceCost = report.getMaintenanceCost() != 0.0 ? report.getMaintenanceCost() : 0.0;
            double personnelCost = report.getPersonnelCost() != 0.0 ? report.getPersonnelCost() : 0.0;
            double storageCost = report.getStorageCostPerUnit() != 0.0 ? report.getStorageCostPerUnit() : 0.0;

            double totalCost = maintenanceCost + personnelCost + storageCost;
            result.put(warehouseName, result.getOrDefault(warehouseName, 0.0) + totalCost);
        }

        return result;
    }

    /**
     * Chuẩn bị chi phí nhân sự theo từng kho
     */
    private Map<String, Double> prepareWarehousePersonnelCosts(Vector<StorageReport> reports) {
        Map<String, Double> result = new HashMap<>();

        for (StorageReport report : reports) {
            String warehouseName = report.getWarehouseName();
            if (warehouseName == null || warehouseName.trim().isEmpty()) {
                warehouseName = "Kho không xác định";
            }

            // Kiểm tra null cho giá trị numeric
            double personnelCost = report.getPersonnelCost() != 0.0 ? report.getPersonnelCost() : 0.0;

            result.put(warehouseName, result.getOrDefault(warehouseName, 0.0) + personnelCost);
        }

        return result;
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods">
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý báo cáo chi phí và lợi nhuận kho bãi với hiệu suất hoạt động";
    }
    // </editor-fold>

}
