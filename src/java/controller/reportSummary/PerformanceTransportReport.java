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
import model.TransportReport;
import model.TransportUnit;
import jakarta.servlet.RequestDispatcher;
import java.util.Vector;

/**
 * Servlet xử lý báo cáo hiệu suất vận tải
 *
 * @author Admin
 */
@WebServlet(name = "PerformanceTransportReport", urlPatterns = {"/PerformanceTransportReport"})
public class PerformanceTransportReport extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);

        TransportReportDataDAO dao = new TransportReportDataDAO();

        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            String submit = request.getParameter("submit");

            if (service == null) {
                service = "listTransportReports";
            }

            if (service.equals("listTransportReports")) {
                // Lấy các tham số filter
                String transportUnitId = request.getParameter("transportUnitId");
                String year = request.getParameter("year");
                String companyName = request.getParameter("invRTitle");

                // Chuẩn hóa tham số
                if (transportUnitId != null && transportUnitId.trim().isEmpty()) {
                    transportUnitId = null;
                }
                if (year != null && year.trim().isEmpty()) {
                    year = null;
                }
                if (companyName != null && companyName.trim().isEmpty()) {
                    companyName = null;
                }

                System.out.println("=== FILTER PARAMETERS ===");
                System.out.println("transportUnitId: " + transportUnitId);
                System.out.println("year: " + year);
                System.out.println("companyName: " + companyName);
                System.out.println("submit: " + submit);

                Vector<TransportReport> reportData;

                // Kiểm tra có filter hay không
                boolean hasFilter = (transportUnitId != null) || (year != null) || (companyName != null);

                if (hasFilter || "filter".equals(submit)) {
                    // Lấy dữ liệu với filter
                    reportData = dao.getFilteredTransportReportData(transportUnitId, year, companyName);
                    System.out.println("✅ Using filtered data");
                } else {
                    // Lấy tất cả dữ liệu
                    reportData = dao.getAllTransportReportData();
                    System.out.println("✅ Using all data");
                }

                // Lấy danh sách transport units cho dropdown
                Vector<TransportUnit> transportUnits = dao.getAllActiveTransportUnits();

                // Tính thống kê
                double[] statistics;
                if (reportData != null && !reportData.isEmpty()) {
                    statistics = calculateStatisticsFromReportData(reportData);
                } else {
                    statistics = new double[]{0, 0, 0, 0};
                }

                System.out.println("Report Data size: " + (reportData != null ? reportData.size() : "null"));

                // Set attributes cho JSP
                request.setAttribute("reportData", reportData);
                request.setAttribute("transportUnits", transportUnits);
                request.setAttribute("statistics", statistics);
                request.setAttribute("transportReportsData", reportData); // Để JSP có thể dùng
                request.setAttribute("transportUnitData", transportUnits); // Để JSP có thể dùng

                // Forward to JSP
                RequestDispatcher dispatcher = request.getRequestDispatcher("page/operator/reportSummary/performanceDetail.jsp");
                dispatcher.forward(request, response);

            } else {
                response.sendRedirect("PerformanceTransportReport?service=listTransportReports");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("❌ ERROR: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Lỗi khi tải dữ liệu báo cáo: " + e.getMessage());
        }
    }

    /**
     * Tính thống kê từ dữ liệu báo cáo
     *
     * @param reportData Vector chứa dữ liệu báo cáo
     * @return Array chứa [totalShipments, totalRevenue, onTimePercentage,
     * totalWeight]
     */
    private double[] calculateStatisticsFromReportData(Vector<TransportReport> reportData) {
        if (reportData == null || reportData.isEmpty()) {
            return new double[]{0, 0, 0, 0};
        }

        double totalShipments = 0;
        double totalRevenue = 0;
        double totalWeight = 0;
        double totalOnTimeShipments = 0;

        for (TransportReport report : reportData) {
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
