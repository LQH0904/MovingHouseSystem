package controller.reportSummary;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dao.TransportReportDataDAO;
import model.transportReport;
import model.TransportUnit;
import jakarta.servlet.RequestDispatcher;
import java.util.Vector;

/**
 * Servlet xử lý báo cáo hiệu suất vận tải
 * @author Admin
 */
@WebServlet(name = "PerformanceTransportReport", urlPatterns = {"/PerformanceTransportReport"})
public class PerformanceTransportReport extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        
        // Khởi tạo DAO
        TransportReportDataDAO dao = new TransportReportDataDAO();
        
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            
            if (service == null) {
                service = "listTransportReports";
            }
            
            if (service.equals("listTransportReports")) {
                // Lấy các tham số filter - chỉ có 2 tham số
                String transportUnitId = request.getParameter("transportUnitId");
                String year = request.getParameter("year");
                
                // Chuẩn hóa tham số (trim và check empty)
                if (transportUnitId != null) {
                    transportUnitId = transportUnitId.trim();
                    if (transportUnitId.isEmpty()) {
                        transportUnitId = null;
                    }
                }
                
                if (year != null) {
                    year = year.trim();
                    if (year.isEmpty()) {
                        year = null;
                    }
                }
                
                // Log các tham số nhận được
                System.out.println("=== SEARCH PARAMETERS ===");
                System.out.println("transportUnitId: " + transportUnitId);
                System.out.println("year: " + year);
                System.out.println("Request Method: " + request.getMethod());
                System.out.println("Query String: " + request.getQueryString());
                
                Vector<transportReport> reportData;
                
                // Kiểm tra có filter hay không
                boolean hasFilter = (transportUnitId != null) || (year != null);
                
                if (hasFilter) {
                    // Lấy dữ liệu với filter - truyền null cho companyName vì không dùng
                    reportData = dao.getFilteredTransportReportData(transportUnitId, year, null);
                    System.out.println("✅ Using filtered data");
                    System.out.println("Filter criteria: transportUnitId=" + transportUnitId + ", year=" + year);
                } else {
                    // Lấy tất cả dữ liệu
                    reportData = dao.getAllTransportReportData();
                    System.out.println("✅ Using all data (no filters)");
                }
                
                System.out.println("Result count: " + (reportData != null ? reportData.size() : 0));
                
                // Lấy danh sách transport units cho dropdown
                Vector<TransportUnit> transportUnits = dao.getAllActiveTransportUnits();
                
                // Tính thống kê dựa trên dữ liệu hiện tại
                double[] statistics;
                if (reportData != null && !reportData.isEmpty()) {
                    statistics = calculateStatisticsFromReportData(reportData);
                    System.out.println("✅ Statistics calculated from filtered data");
                } else {
                    // Nếu không có dữ liệu, lấy thống kê tổng hoặc trả về 0
                    if (hasFilter) {
                        // Có filter nhưng không có kết quả -> trả về 0
                        statistics = new double[]{0, 0, 0, 0};
                        System.out.println("⚠️ No data found for filter criteria, returning zero statistics");
                    } else {
                        // Không có filter và không có dữ liệu -> lấy từ DB
                        statistics = dao.getOverallStatistics();
                        System.out.println("✅ Statistics loaded from database");
                    }
                }
                
                // Lấy dữ liệu theo tháng cho biểu đồ (optional)
                Vector<Object[]> monthlyData = dao.getMonthlyReportData();
                
                // Debug log chi tiết
                System.out.println("=== DEBUG INFORMATION ===");
                System.out.println("Report Data size: " + (reportData != null ? reportData.size() : "null"));
                System.out.println("Transport Units size: " + (transportUnits != null ? transportUnits.size() : "null"));
                System.out.println("Statistics available: " + (statistics != null));
                System.out.println("Has Filter: " + hasFilter);
                
                if (statistics != null) {
                    System.out.println("Statistics values: [" + 
                        statistics[0] + ", " + 
                        statistics[1] + ", " + 
                        statistics[2] + ", " + 
                        statistics[3] + "]");
                }
                
                // Sample data log
                if (reportData != null && reportData.size() > 0) {
                    System.out.println("=== SAMPLE REPORT DATA ===");
                    for (int i = 0; i < Math.min(3, reportData.size()); i++) {
                        transportReport report = reportData.get(i);
                        System.out.println("Report " + (i+1) + ": " + 
                                         "Unit=" + report.getTransportUnitId() + 
                                         ", Company='" + report.getCompanyName() + "'" +
                                         ", Year=" + report.getReportYear() + 
                                         ", Month=" + report.getReportMonth() + 
                                         ", Shipments=" + report.getTotalShipments() + 
                                         ", Revenue=" + report.getTotalRevenue());
                    }
                }
                
                if (transportUnits != null && transportUnits.size() > 0) {
                    System.out.println("=== SAMPLE TRANSPORT UNITS ===");
                    for (int i = 0; i < Math.min(3, transportUnits.size()); i++) {
                        TransportUnit unit = transportUnits.get(i);
                        System.out.println("Unit " + (i+1) + ": " + 
                                         "ID=" + unit.getTransportUnitId() + 
                                         ", Name='" + unit.getCompanyName() + "'");
                    }
                }
                
                // Set attributes cho JSP
                request.setAttribute("reportData", reportData);
                request.setAttribute("transportUnits", transportUnits);
                request.setAttribute("statistics", statistics);
                request.setAttribute("monthlyData", monthlyData);
                
                // Debug: Kiểm tra attributes
                System.out.println("=== ATTRIBUTES SET ===");
                System.out.println("reportData: " + (request.getAttribute("reportData") != null ? "✅ Set" : "❌ Null"));
                System.out.println("transportUnits: " + (request.getAttribute("transportUnits") != null ? "✅ Set" : "❌ Null"));
                System.out.println("statistics: " + (request.getAttribute("statistics") != null ? "✅ Set" : "❌ Null"));
                
                System.out.println("=== FORWARDING TO JSP ===");
                
                // Forward to JSP
                RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/performanceDetail.jsp");
                dispatcher.forward(request, response);
                
            } else {
                System.out.println("⚠️ Unknown service: " + service + ", redirecting to default");
                response.sendRedirect("PerformanceTransportReport?service=listTransportReports");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ ERROR in PerformanceTransportReport: " + e.getMessage());
            
            // Log stack trace chi tiết
            System.err.println("❌ Stack trace:");
            for (StackTraceElement element : e.getStackTrace()) {
                System.err.println("   at " + element.toString());
            }
            
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Lỗi khi tải dữ liệu báo cáo: " + e.getMessage());
        }
    }
    
    /**
     * Tính thống kê từ dữ liệu báo cáo
     * @param reportData Vector chứa dữ liệu báo cáo
     * @return Array chứa [totalShipments, totalRevenue, onTimePercentage, totalWeight]
     */
    private double[] calculateStatisticsFromReportData(Vector<transportReport> reportData) {
        if (reportData == null || reportData.isEmpty()) {
            return new double[]{0, 0, 0, 0};
        }
        
        double totalShipments = 0;
        double totalRevenue = 0;
        double totalWeight = 0;
        double totalOnTimeShipments = 0;
        
        for (transportReport report : reportData) {
            totalShipments += report.getTotalShipments();
            totalRevenue += report.getTotalRevenue();
            totalWeight += report.getTotalWeight();
            totalOnTimeShipments += report.getOnTimeCount();
        }
        
        // Tính tỷ lệ đúng hạn
        double onTimePercentage = totalShipments > 0 ? (totalOnTimeShipments / totalShipments) * 100 : 0;
        
        System.out.println("📊 Calculated statistics from " + reportData.size() + " reports:");
        System.out.println("- Total Shipments: " + totalShipments);
        System.out.println("- Total Revenue: " + totalRevenue);
        System.out.println("- On-time Percentage: " + onTimePercentage + "%");
        System.out.println("- Total Weight: " + totalWeight);
        
        return new double[]{totalShipments, totalRevenue, onTimePercentage, totalWeight};
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🌐 GET request received");
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("🌐 POST request received");
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Servlet xử lý báo cáo hiệu suất vận tải - Updated Version";
    }
}