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
import java.io.PrintWriter;
import java.util.Vector;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * Controller xử lý chi tiết báo cáo Storage với tính năng lọc và xuất Excel
 * @author Admin
 */
@WebServlet(name = "StorageReportDetailController", urlPatterns = {"/StorageReportDetailController"})
public class StorageReportDetailController extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(StorageReportDetailController.class.getName());

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
            service = "listStorageReports";
        }
        
        switch (service) {
            case "listStorageReports":
                showStorageReportsList(request, response);
                break;
            case "filterStorageReports":
                filterStorageReports(request, response);
                break;
            case "exportExcel":
                exportStorageReportsToHTMLExcel(request, response);
                break;
            default:
                showStorageReportsList(request, response);
                break;
        }
    }
    
    /**
     * Hiển thị danh sách báo cáo Storage
     */
    private void showStorageReportsList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            StorageReportDataDAO dao = new StorageReportDataDAO();
            
            // Lấy tất cả dữ liệu báo cáo Storage
            Vector<StorageReport> storageReports = dao.getAllStorageReportData();
            
            // Lấy danh sách các Storage Units để hiển thị trong dropdown
            Vector<StorageUnit> storageUnits = dao.getAllStorageUnits();
            
            // Lấy thống kê tổng quan
            double[] overallStats = dao.getStorageOverallStatistics();
            
            LOGGER.log(Level.INFO, "StorageReportDetailController - storageReports size: " + 
                     (storageReports != null ? storageReports.size() : "null"));
            LOGGER.log(Level.INFO, "StorageReportDetailController - storageUnits size: " + 
                     (storageUnits != null ? storageUnits.size() : "null"));
            
            // Đặt dữ liệu vào request attributes
            request.setAttribute("storageReports", storageReports);
            request.setAttribute("storageUnits", storageUnits);
            request.setAttribute("overallStats", overallStats);
            
            // Forward đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/StorageReportDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in showStorageReportsList", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi khi tải dữ liệu báo cáo Storage: " + e.getMessage());
        }
    }
    
    /**
     * Lọc báo cáo Storage theo các tiêu chí
     */
    private void filterStorageReports(HttpServletRequest request, HttpServletResponse response)
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
            
            // Lấy danh sách các storage units (không thay đổi)
            Vector<StorageUnit> storageUnits = dao.getAllStorageUnits();
            
            // Lấy thống kê tổng quan
            double[] overallStats = dao.getStorageOverallStatistics();
            
            LOGGER.log(Level.INFO, "Filter parameters - StorageUnitId: " + storageUnitId + 
                     ", FromMonth: " + fromMonth + ", ToMonth: " + toMonth + 
                     ", WarehouseName: " + warehouseName);
            LOGGER.log(Level.INFO, "Filtered results - Reports: " + filteredReports.size());
            
            // Đặt dữ liệu vào request attributes
            request.setAttribute("storageReports", filteredReports);
            request.setAttribute("storageUnits", storageUnits);
            request.setAttribute("overallStats", overallStats);
            
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
            RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/StorageReportDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in filterStorageReports", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi khi lọc dữ liệu báo cáo Storage: " + e.getMessage());
        }
    }
    
    /**
     * Xuất báo cáo Storage ra file HTML Excel (không cần thư viện POI)
     */
    private void exportStorageReportsToHTMLExcel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Lấy các tham số filter (giống như trong filterStorageReports)
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
                    LOGGER.log(Level.WARNING, "Invalid storage unit ID for export: " + storageUnitIdStr);
                }
            }
            
            // Chuyển đổi format tháng cho SQL
            if (fromMonth != null && !fromMonth.trim().isEmpty()) {
                fromMonth = fromMonth + "-01";
            }
            if (toMonth != null && !toMonth.trim().isEmpty()) {
                toMonth = toMonth + "-31";
            }
            
            StorageReportDataDAO dao = new StorageReportDataDAO();
            
            // Lấy dữ liệu theo bộ lọc
            Vector<StorageReport> storageReports;
            if (storageUnitId > 0 || (fromMonth != null && !fromMonth.trim().isEmpty()) || 
                (toMonth != null && !toMonth.trim().isEmpty()) || 
                (warehouseName != null && !warehouseName.trim().isEmpty())) {
                // Có bộ lọc
                storageReports = dao.getFilteredStorageReportData(storageUnitId, fromMonth, toMonth, warehouseName);
            } else {
                // Không có bộ lọc, lấy tất cả
                storageReports = dao.getAllStorageReportData();
            }
            
            // Thiết lập response cho file Excel HTML
            response.setContentType("application/vnd.ms-excel; charset=UTF-8");
            response.setCharacterEncoding("UTF-8");
            response.setHeader("Content-Disposition", "attachment; filename=Storage_Reports_" + 
                             new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date()) + ".xls");
            
            PrintWriter writer = response.getWriter();
            
            // Bắt đầu HTML Excel XML
            writer.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
            writer.println("<?mso-application progid=\"Excel.Sheet\"?>");
            writer.println("<Workbook xmlns=\"urn:schemas-microsoft-com:office:spreadsheet\"");
            writer.println(" xmlns:o=\"urn:schemas-microsoft-com:office:office\"");
            writer.println(" xmlns:x=\"urn:schemas-microsoft-com:office:excel\"");
            writer.println(" xmlns:ss=\"urn:schemas-microsoft-com:office:spreadsheet\"");
            writer.println(" xmlns:html=\"http://www.w3.org/TR/REC-html40\">");
            
            // Định nghĩa các styles
            writer.println("<Styles>");
            
            // Style cho tiêu đề chính
            writer.println("<Style ss:ID=\"Title\">");
            writer.println("<Font ss:Bold=\"1\" ss:Size=\"16\"/>");
            writer.println("<Alignment ss:Horizontal=\"Center\"/>");
            writer.println("</Style>");
            
            // Style cho header
            writer.println("<Style ss:ID=\"Header\">");
            writer.println("<Font ss:Bold=\"1\" ss:Size=\"12\" ss:Color=\"#000000\"/>");
            writer.println("<Interior ss:Color=\"#CCE5FF\" ss:Pattern=\"Solid\"/>");
            writer.println("<Borders>");
            writer.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("</Borders>");
            writer.println("<Alignment ss:Horizontal=\"Center\"/>");
            writer.println("</Style>");
            
            // Style cho dữ liệu thường
            writer.println("<Style ss:ID=\"Data\">");
            writer.println("<Borders>");
            writer.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("</Borders>");
            writer.println("</Style>");
            
            // Style cho số
            writer.println("<Style ss:ID=\"Number\">");
            writer.println("<NumberFormat ss:Format=\"#,##0.00\"/>");
            writer.println("<Borders>");
            writer.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("</Borders>");
            writer.println("</Style>");
            
            // Style cho số nguyên
            writer.println("<Style ss:ID=\"Integer\">");
            writer.println("<NumberFormat ss:Format=\"#,##0\"/>");
            writer.println("<Borders>");
            writer.println("<Border ss:Position=\"Bottom\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Left\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Right\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("<Border ss:Position=\"Top\" ss:LineStyle=\"Continuous\" ss:Weight=\"1\"/>");
            writer.println("</Borders>");
            writer.println("</Style>");
            
            writer.println("</Styles>");
            
            // Bắt đầu Worksheet
            writer.println("<Worksheet ss:Name=\"Báo cáo Storage\">");
            writer.println("<Table>");
            
            // Tiêu đề chính
            writer.println("<Row>");
            writer.println("<Cell ss:MergeAcross=\"14\" ss:StyleID=\"Title\">");
            writer.println("<Data ss:Type=\"String\">BÁO CÁO CHI TIẾT STORAGE REPORTS</Data>");
            writer.println("</Cell>");
            writer.println("</Row>");
            
            // Thông tin thời gian xuất
            writer.println("<Row>");
            writer.println("<Cell ss:MergeAcross=\"14\">");
            writer.println("<Data ss:Type=\"String\">Thời gian xuất: " + 
                          new SimpleDateFormat("dd/MM/yyyy HH:mm:ss").format(new Date()) + "</Data>");
            writer.println("</Cell>");
            writer.println("</Row>");
            
            // Thông tin bộ lọc
            writer.println("<Row>");
            writer.println("<Cell ss:MergeAcross=\"14\">");
            StringBuilder filterInfo = new StringBuilder("Bộ lọc: ");
            if (storageUnitId > 0) filterInfo.append("Storage Unit ID: ").append(storageUnitId).append("; ");
            if (fromMonth != null && !fromMonth.trim().isEmpty()) filterInfo.append("Từ tháng: ").append(fromMonth.substring(0, 7)).append("; ");
            if (toMonth != null && !toMonth.trim().isEmpty()) filterInfo.append("Đến tháng: ").append(toMonth.substring(0, 7)).append("; ");
            if (warehouseName != null && !warehouseName.trim().isEmpty()) filterInfo.append("Tên kho: ").append(warehouseName).append("; ");
            if (filterInfo.toString().equals("Bộ lọc: ")) filterInfo.append("Tất cả dữ liệu");
            writer.println("<Data ss:Type=\"String\">" + escapeXML(filterInfo.toString()) + "</Data>");
            writer.println("</Cell>");
            writer.println("</Row>");
            
            // Dòng trống
            writer.println("<Row></Row>");
            
            // Header row
            writer.println("<Row>");
            String[] headers = {
                "STT", "Ngày báo cáo", "Tên kho", "ID Storage Unit", "Số lượng tồn kho",
                "Diện tích sử dụng", "Tổng diện tích", "Số đơn hàng", "Nhập kho",
                "Xuất kho", "Đơn trả lại", "Chi phí nhân sự", "Chi phí bảo trì",
                "Chi phí lưu kho/đơn vị", "Lợi nhuận"
            };
            
            for (String header : headers) {
                writer.println("<Cell ss:StyleID=\"Header\"><Data ss:Type=\"String\">" + escapeXML(header) + "</Data></Cell>");
            }
            writer.println("</Row>");
            
            // Data rows
            int stt = 1;
            for (StorageReport report : storageReports) {
                writer.println("<Row>");
                
                // STT
                writer.println("<Cell ss:StyleID=\"Data\"><Data ss:Type=\"Number\">" + stt++ + "</Data></Cell>");
                
                // Ngày báo cáo
                writer.println("<Cell ss:StyleID=\"Data\"><Data ss:Type=\"String\">" + 
                              escapeXML(report.getReportDate()) + "</Data></Cell>");
                
                // Tên kho
                writer.println("<Cell ss:StyleID=\"Data\"><Data ss:Type=\"String\">" + 
                              escapeXML(report.getWarehouseName() != null ? report.getWarehouseName() : "") + "</Data></Cell>");
                
                // ID Storage Unit
                writer.println("<Cell ss:StyleID=\"Data\"><Data ss:Type=\"Number\">" + 
                              report.getStorageUnitId() + "</Data></Cell>");
                
                // Số lượng tồn kho
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getQuantityOnHand()) + "</Data></Cell>");
                
                // Diện tích sử dụng
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getUsedArea()) + "</Data></Cell>");
                
                // Tổng diện tích
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getTotalArea()) + "</Data></Cell>");
                
                // Số đơn hàng
                writer.println("<Cell ss:StyleID=\"Integer\"><Data ss:Type=\"Number\">" + 
                              String.format("%.0f", report.getOrderCount()) + "</Data></Cell>");
                
                // Nhập kho
                writer.println("<Cell ss:StyleID=\"Integer\"><Data ss:Type=\"Number\">" + 
                              String.format("%.0f", report.getInboundCount()) + "</Data></Cell>");
                
                // Xuất kho
                writer.println("<Cell ss:StyleID=\"Integer\"><Data ss:Type=\"Number\">" + 
                              String.format("%.0f", report.getOutboundCount()) + "</Data></Cell>");
                
                // Đơn trả lại
                writer.println("<Cell ss:StyleID=\"Integer\"><Data ss:Type=\"Number\">" + 
                              String.format("%.0f", report.getReturnedOrders()) + "</Data></Cell>");
                
                // Chi phí nhân sự
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getPersonnelCost()) + "</Data></Cell>");
                
                // Chi phí bảo trì
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getMaintenanceCost()) + "</Data></Cell>");
                
                // Chi phí lưu kho/đơn vị
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getStorageCostPerUnit()) + "</Data></Cell>");
                
                // Lợi nhuận
                writer.println("<Cell ss:StyleID=\"Number\"><Data ss:Type=\"Number\">" + 
                              String.format("%.2f", report.getProfit()) + "</Data></Cell>");
                
                writer.println("</Row>");
            }
            
            writer.println("</Table>");
            writer.println("</Worksheet>");
            writer.println("</Workbook>");
            
            writer.flush();
            writer.close();
            
            LOGGER.log(Level.INFO, "HTML Excel file exported successfully with " + storageReports.size() + " records");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in exportStorageReportsToHTMLExcel", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi khi xuất file Excel: " + e.getMessage());
        }
    }
    
    /**
     * Escape các ký tự đặc biệt trong XML
     */
    private String escapeXML(String value) {
        if (value == null) return "";
        
        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&apos;");
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
        return "Servlet xử lý chi tiết báo cáo Storage với tính năng lọc và xuất Excel";
    }
    // </editor-fold>

}