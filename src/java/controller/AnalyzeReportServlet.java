package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import dao.InventoryReportDAO;
import dao.TransportReportDAO;
import dao.OrderDAO;
import dao.NotificationDAO;
import dao.UserDAO;
import model.InventoryDetails;
import model.AlertItem;
import model.Orders;
import model.Issue;
import model.Users;
import websocket.NotificationWebSocketServer;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet(name = "AnalyzeReportServlet", urlPatterns = {"/analyz"})
public class AnalyzeReportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(AnalyzeReportServlet.class.getName());
    private InventoryReportDAO reportDAO;
    private TransportReportDAO transportReportDAO;
    private OrderDAO orderDAO;
    private NotificationDAO notificationDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        reportDAO = InventoryReportDAO.INSTANCE;
        transportReportDAO = TransportReportDAO.INSTANCE;
        orderDAO = OrderDAO.INSTANCE;
        notificationDAO = NotificationDAO.INSTANCE;
        userDAO = UserDAO.INSTANCE;
        NotificationWebSocketServer.getInstance();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("getReports".equals(action)) {
            String reportType = req.getParameter("reportType");
            int page = req.getParameter("page") != null ? Integer.parseInt(req.getParameter("page")) : 1;
            int pageSize = req.getParameter("pageSize") != null ? Integer.parseInt(req.getParameter("pageSize")) : 10;
            String unitName = req.getParameter("unitName");

            try {
                Map<String, Object> response = new HashMap<>();
                if ("inventory".equals(reportType)) {
                    List<?> reports = reportDAO.getRecentReports(page, pageSize, unitName);
                    int totalReports = reportDAO.getTotalRecentReports(unitName);
                    response.put("reports", reports);
                    response.put("totalReports", totalReports);
                    LOGGER.info("Lấy được " + reports.size() + " báo cáo tồn kho, tổng số: " + totalReports);
                } else if ("transport".equals(reportType)) {
                    List<?> reports = transportReportDAO.getRecentReports(page, pageSize, unitName);
                    int totalReports = transportReportDAO.getTotalRecentReports(unitName);
                    response.put("reports", reports);
                    response.put("totalReports", totalReports);
                    LOGGER.info("Lấy được " + reports.size() + " báo cáo vận chuyển, tổng số: " + totalReports);
                }
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write(new ObjectMapper().writeValueAsString(response));
            } catch (SQLException e) {
                LOGGER.severe("Lỗi truy vấn danh sách báo cáo: " + e.getMessage());
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"error\": \"Lỗi truy vấn danh sách báo cáo: " + e.getMessage() + "\"}");
            }
        } else if ("getUnanalyzedIds".equals(action)) {
            String reportType = req.getParameter("reportType");
            String unitName = req.getParameter("unitName");
            try {
                Map<String, Object> response = new HashMap<>();
                if ("inventory".equals(reportType) || "transport".equals(reportType)) {
                    List<Integer> unanalyzedIds = notificationDAO.getUnanalyzedReportIds(reportType, unitName);
                    response.put("unanalyzedIds", unanalyzedIds);
                    response.put("count", unanalyzedIds.size());
                    LOGGER.info("Lấy được " + unanalyzedIds.size() + " " + reportType + " report IDs chưa phân tích");
                } else if ("orders".equals(reportType)) {
                    List<Integer> unanalyzedIds = notificationDAO.getUnanalyzedOrderIds();
                    response.put("unanalyzedIds", unanalyzedIds);
                    response.put("count", unanalyzedIds.size());
                    LOGGER.info("Lấy được " + unanalyzedIds.size() + " order IDs chưa phân tích");
                } else {
                    response.put("error", "Loại báo cáo không hợp lệ.");
                }
                resp.setContentType("application/json; charset=UTF-8");
                resp.getWriter().write(new ObjectMapper().writeValueAsString(response));
            } catch (SQLException e) {
                LOGGER.severe("Lỗi lấy danh sách ID chưa phân tích: " + e.getMessage());
                resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                resp.getWriter().write("{\"error\": \"Lỗi truy vấn danh sách ID chưa phân tích: " + e.getMessage() + "\"}");
            }
        } else {
            req.getRequestDispatcher("analyzeReport.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            Users user = (Users) req.getSession().getAttribute("acc");
            if (user == null) {
                req.setAttribute("error", "Vui lòng đăng nhập để sử dụng chức năng này.");
                req.getRequestDispatcher("page/login/login.jsp").forward(req, resp);
                return;
            }

            String reportType = req.getParameter("reportType");
            String[] reportIds = req.getParameterValues("reportIds");
            int userId = user.getUserId();
            int roleId = user.getRoleId();

            boolean canAnalyze = (roleId == 1 || roleId == 2);
            if (!canAnalyze) {
                req.setAttribute("error", "Chỉ Admin hoặc Operator có quyền phân tích báo cáo này.");
                req.getRequestDispatcher("analyzeReport.jsp").forward(req, resp);
                return;
            }

            int analyzedCount = 0;
            if ("inventory".equals(reportType)) {
                if (reportIds != null) {
                    for (String id : reportIds) {
                        int reportId = Integer.parseInt(id);
                        if (!notificationDAO.hasReportBeenAnalyzed("inventory", reportId)) {
                            analyzeInventoryReport(reportId);
                            analyzedCount++;
                        } else {
                            LOGGER.info("Báo cáo tồn kho ID " + reportId + " đã được phân tích, bỏ qua.");
                        }
                    }
                } else {
                    List<model.InventoryReport> reports = reportDAO.getRecentReports(1, Integer.MAX_VALUE, null);
                    for (model.InventoryReport report : reports) {
                        if (!notificationDAO.hasReportBeenAnalyzed("inventory", report.getReportId())) {
                            analyzeInventoryReport(report.getReportId());
                            analyzedCount++;
                        }
                    }
                }
            } else if ("transport".equals(reportType)) {
                if (reportIds != null) {
                    for (String id : reportIds) {
                        int reportId = Integer.parseInt(id);
                        if (!notificationDAO.hasReportBeenAnalyzed("transport", reportId)) {
                            analyzeTransportReport(reportId);
                            analyzedCount++;
                        } else {
                            LOGGER.info("Báo cáo vận chuyển ID " + reportId + " đã được phân tích, bỏ qua.");
                        }
                    }
                } else {
                    List<model.TransportReport> reports = transportReportDAO.getRecentReports(1, Integer.MAX_VALUE, null);
                    for (model.TransportReport report : reports) {
                        if (!notificationDAO.hasReportBeenAnalyzed("transport", report.getReportId())) {
                            analyzeTransportReport(report.getReportId());
                            analyzedCount++;
                        }
                    }
                }
            } else if ("orders".equals(reportType)) {
                analyzedCount = analyzeOrders();
            } else {
                req.setAttribute("error", "Loại báo cáo không hợp lệ.");
                req.getRequestDispatcher("analyzeReport.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("message", "Phân tích thành công! Đã tạo thông báo cho " + analyzedCount + " báo cáo/đơn hàng.");
            req.getRequestDispatcher("analyzeReport.jsp").forward(req, resp);
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage());
            req.setAttribute("error", "Lỗi truy vấn cơ sở dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("analyzeReport.jsp").forward(req, resp);
        } catch (Exception e) {
            LOGGER.severe("Lỗi xử lý báo cáo: " + e.getMessage());
            req.setAttribute("error", "Lỗi xử lý báo cáo: " + e.getMessage());
            req.getRequestDispatcher("analyzeReport.jsp").forward(req, resp);
        }
    }

    private void analyzeInventoryReport(int reportId) throws SQLException, IOException {
        if (notificationDAO.hasReportBeenAnalyzed("inventory", reportId)) {
            LOGGER.info("Báo cáo tồn kho ID " + reportId + " đã được phân tích, bỏ qua.");
            return;
        }

        var report = reportDAO.getReportById(reportId);
        if (report == null) {
            LOGGER.warning("Không tìm thấy báo cáo tồn kho với ID: " + reportId);
            return;
        }

        int storageUnitUserId = report.getStorageUnitId();
        int adminUserId = notificationDAO.getAdminUserId();

        if (!notificationDAO.isUserIdValid(storageUnitUserId)) {
            LOGGER.warning("Invalid storage_unit_id (user_id): " + storageUnitUserId + " for report ID: " + reportId);
            return;
        }

        // Tạo thông báo để đánh dấu báo cáo đã phân tích (thay "info" bằng "reminder")
        String analyzedMessage = "Báo cáo tồn kho ID " + reportId + " đã được phân tích.";
        if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "reminder", analyzedMessage)) {
            notificationDAO.createNotification(storageUnitUserId, analyzedMessage, "reminder", null);
            NotificationWebSocketServer.broadcast(analyzedMessage, "reminder", null, storageUnitUserId);
            LOGGER.info("Created analysis confirmation notification for inventory report ID: " + reportId + ", user_id: " + storageUnitUserId);
        }

        // Kiểm tra thời gian cập nhật báo cáo
        Timestamp now = new Timestamp(System.currentTimeMillis());
        long daysSinceUpdate = (now.getTime() - report.getCreatedAt().getTime()) / (1000 * 60 * 60 * 24);
        if (daysSinceUpdate >= 30) {
            String message = "Báo cáo tồn kho ID " + reportId + " đã quá 30 ngày chưa được cập nhật. Vui lòng kiểm tra.";
            if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "reminder", message)) {
                notificationDAO.createNotification(storageUnitUserId, message, "reminder", null);
                NotificationWebSocketServer.broadcast(message, "reminder", null, storageUnitUserId);
                LOGGER.info("Created reminder notification for inventory report ID: " + reportId + ", user_id: " + storageUnitUserId);
            }
        }

        if (report.getInventoryDetails() != null && report.getInventoryDetails().startsWith("{")) {
            ObjectMapper mapper = new ObjectMapper();
            try {
                InventoryDetails details = mapper.readValue(report.getInventoryDetails(), InventoryDetails.class);
                int totalCapacity = 1000; // Giả định dung lượng kho tối đa
                int currentStock = details.getAlerts().stream().mapToInt(AlertItem::getRemainingQuantity).sum();

                // Kiểm tra kho gần đầy
                if (currentStock >= totalCapacity * 0.9) {
                    String message = "Báo cáo tồn kho ID " + reportId + ": Kho hiện tại đã đạt 90% dung lượng (" + currentStock + "/" + totalCapacity + "). Cần sắp xếp lại hoặc chuyển hàng.";
                    if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "warning", message)) {
                        notificationDAO.createNotification(storageUnitUserId, message, "warning", null);
                        NotificationWebSocketServer.broadcast(message, "warning", null, storageUnitUserId);
                        LOGGER.info("Created warning notification for inventory report ID: " + reportId + ", user_id: " + storageUnitUserId);
                    }
                }

                // Kiểm tra từng mặt hàng
                for (AlertItem item : details.getAlerts()) {
                    // Hàng tồn thấp
                    if (item.getRemainingQuantity() < item.getAlertThreshold()) {
                        String message = "Báo cáo tồn kho ID " + reportId + ": Hàng tồn kho " + item.getProduct() + " (mã: " + item.getCode() + ") thấp dưới ngưỡng (" + item.getRemainingQuantity() + "/" + item.getAlertThreshold() + ").";
                        if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "warning", message)) {
                            notificationDAO.createNotification(storageUnitUserId, message, "warning", null);
                            NotificationWebSocketServer.broadcast(message, "warning", null, storageUnitUserId);
                            LOGGER.info("Created low stock warning for product: " + item.getProduct() + ", report ID: " + reportId);
                        }
                    }
                    // Hàng tồn cực thấp
                    if (item.getRemainingQuantity() < item.getAlertThreshold() * 0.1) {
                        String message = "Báo cáo tồn kho ID " + reportId + ": Hàng tồn kho " + item.getProduct() + " (mã: " + item.getCode() + ") cực thấp, chỉ còn " + item.getRemainingQuantity() + " so với ngưỡng " + item.getAlertThreshold() + ". Cần nhập hàng ngay!";
                        if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "urgent", message)) {
                            notificationDAO.createNotification(storageUnitUserId, message, "urgent", null);
                            NotificationWebSocketServer.broadcast(message, "urgent", null, storageUnitUserId);
                            LOGGER.info("Created urgent low stock warning for product: " + item.getProduct() + ", report ID: " + reportId);
                        }
                    }
                    // Kho đầy đủ
                    if (item.getRemainingQuantity() > item.getAlertThreshold() * 1.5) {
                        String message = "Báo cáo tồn kho ID " + reportId + ": Hàng tồn kho " + item.getProduct() + " (mã: " + item.getCode() + ") đạt mức đầy đủ (" + item.getRemainingQuantity() + "/" + item.getAlertThreshold() + "). Tốt lắm!";
                        if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "reward", message)) {
                            notificationDAO.createNotification(storageUnitUserId, message, "reward", null);
                            NotificationWebSocketServer.broadcast(message, "reward", null, storageUnitUserId);
                            LOGGER.info("Created reward notification for product: " + item.getProduct() + ", report ID: " + reportId);
                        }
                    }
                    // Gợi ý tối ưu kho
                    String message = "Báo cáo tồn kho ID " + reportId + ": Gợi ý: Tối ưu hóa kho hàng cho sản phẩm " + item.getProduct() + " để duy trì mức tồn kho hợp lý.";
                    if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "suggestion", message)) {
                        notificationDAO.createNotification(storageUnitUserId, message, "suggestion", null);
                        NotificationWebSocketServer.broadcast(message, "suggestion", null, storageUnitUserId);
                        LOGGER.info("Created suggestion notification for product: " + item.getProduct() + ", report ID: " + reportId);
                    }
                }

                // Gợi ý từ báo cáo
                if (details.getRecommendation() != null && !details.getRecommendation().isEmpty()) {
                    String message = "Báo cáo tồn kho ID " + reportId + ": Gợi ý cho kho: " + details.getRecommendation();
                    if (!notificationDAO.isDuplicateNotification(storageUnitUserId, null, "suggestion", message)) {
                        notificationDAO.createNotification(storageUnitUserId, message, "suggestion", null);
                        NotificationWebSocketServer.broadcast(message, "suggestion", null, storageUnitUserId);
                        LOGGER.info("Created recommendation notification for report ID: " + reportId);
                    }
                }

                // Thông báo cho Admin nếu tồn kho tổng thể thấp
                if (currentStock < totalCapacity * 0.2 && adminUserId != -1) {
                    String message = "Báo cáo tồn kho ID " + reportId + ": Tồn kho tổng thể tại kho dưới 20% (" + currentStock + "/" + totalCapacity + "). Cần nhập hàng mới.";
                    if (!notificationDAO.isDuplicateNotification(adminUserId, null, "reminder", message)) {
                        notificationDAO.createNotification(adminUserId, message, "reminder", null);
                        NotificationWebSocketServer.broadcast(message, "reminder", null, adminUserId);
                        LOGGER.info("Created low stock reminder for admin, report ID: " + reportId);
                    }
                }
            } catch (com.fasterxml.jackson.databind.exc.UnrecognizedPropertyException e) {
                LOGGER.severe("Lỗi phân tích JSON InventoryDetails: " + e.getMessage());
                throw new IOException("Lỗi phân tích JSON: " + e.getMessage(), e);
            }
        } else {
            LOGGER.warning("Dữ liệu chi tiết tồn kho không hợp lệ cho báo cáo ID: " + reportId);
        }
    }

    private void analyzeTransportReport(int reportId) throws SQLException {
        if (notificationDAO.hasReportBeenAnalyzed("transport", reportId)) {
            LOGGER.info("Báo cáo vận chuyển ID " + reportId + " đã được phân tích, bỏ qua.");
            return;
        }

        var report = transportReportDAO.getReportById(reportId);
        if (report == null) {
            LOGGER.warning("Không tìm thấy báo cáo vận chuyển với ID: " + reportId);
            return;
        }

        int transportUnitUserId = report.getTransportUnitId();
        int adminUserId = notificationDAO.getAdminUserId();

        if (!notificationDAO.isUserIdValid(transportUnitUserId)) {
            LOGGER.warning("Invalid transport_unit_id (user_id): " + transportUnitUserId + " for report ID: " + reportId);
            return;
        }

        // Tạo thông báo để đánh dấu báo cáo đã phân tích
        String analyzedMessage = "Báo cáo vận chuyển ID " + reportId + " đã được phân tích.";
        if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "reminder", analyzedMessage)) {
            notificationDAO.createNotification(transportUnitUserId, analyzedMessage, "reminder", null);
            NotificationWebSocketServer.broadcast(analyzedMessage, "reminder", null, transportUnitUserId);
            LOGGER.info("Created analysis confirmation notification for transport report ID: " + reportId + ", user_id: " + transportUnitUserId);
        }

        // Kiểm tra thời gian cập nhật báo cáo
        Timestamp now = new Timestamp(System.currentTimeMillis());
        long daysSinceUpdate = (now.getTime() - report.getCreatedAt().getTime()) / (1000 * 60 * 60 * 24);
        if (daysSinceUpdate >= 30) {
            String message = "Báo cáo vận chuyển ID " + reportId + " đã quá 30 ngày chưa được cập nhật. Vui lòng kiểm tra.";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "reminder", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "reminder", null);
                NotificationWebSocketServer.broadcast(message, "reminder", null, transportUnitUserId);
                LOGGER.info("Created reminder notification for transport report ID: " + reportId + ", user_id: " + transportUnitUserId);
            }
        }

        // Doanh thu vượt kế hoạch
        BigDecimal revenueDiffPercent = report.getTotalRevenue()
                .subtract(report.getPlannedRevenue())
                .divide(report.getPlannedRevenue(), 4, BigDecimal.ROUND_HALF_UP)
                .multiply(BigDecimal.valueOf(100));
        if (revenueDiffPercent.compareTo(BigDecimal.valueOf(5)) >= 0) {
            String message = "Báo cáo vận chuyển ID " + reportId + ": Đơn vị vận chuyển " + report.getCompanyName() + " đạt doanh thu vượt " + revenueDiffPercent + "% so với kế hoạch tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Xuất sắc!";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "reward", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "reward", null);
                NotificationWebSocketServer.broadcast(message, "reward", null, transportUnitUserId);
                LOGGER.info("Created reward notification for transport report ID: " + reportId);
            }
        }

        // Doanh thu thấp hơn kế hoạch
        if (revenueDiffPercent.compareTo(BigDecimal.valueOf(-5)) <= 0) {
            String message = "Báo cáo vận chuyển ID " + reportId + ": Doanh thu đơn vị vận chuyển " + report.getCompanyName() + " thấp hơn " + revenueDiffPercent.abs() + "% so với kế hoạch tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Cần cải thiện!";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "warning", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "warning", null);
                NotificationWebSocketServer.broadcast(message, "warning", null, transportUnitUserId);
                LOGGER.info("Created warning notification for low revenue, report ID: " + reportId);
            }
        }

        // Tỷ lệ giao hàng trễ
        double delayRate = (double) report.getDelayCount() / report.getTotalShipments() * 100;
        if (delayRate >= 10 && delayRate < 20) {
            String message = "Báo cáo vận chuyển ID " + reportId + ": Tỷ lệ giao hàng trễ của đơn vị " + report.getCompanyName() + " đạt " + String.format("%.2f", delayRate) + "% trong tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Cần chú ý!";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "warning", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "warning", null);
                NotificationWebSocketServer.broadcast(message, "warning", null, transportUnitUserId);
                LOGGER.info("Created warning notification for delay rate, report ID: " + reportId);
            }
        }
        if (delayRate >= 20) {
            String message = "Báo cáo vận chuyển ID " + reportId + ": Tỷ lệ giao hàng trễ của đơn vị " + report.getCompanyName() + " vượt quá " + String.format("%.2f", delayRate) + "% trong tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Cần xử lý ngay!";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "urgent", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "urgent", null);
                NotificationWebSocketServer.broadcast(message, "urgent", null, transportUnitUserId);
                LOGGER.info("Created urgent notification for high delay rate, report ID: " + reportId);
            }
        }

        // Số đơn hủy
        if (report.getCancelCount() >= 5 && report.getCancelCount() < 10) {
            String message = "Báo cáo vận chuyển ID " + reportId + ": Đơn vị vận chuyển " + report.getCompanyName() + " có " + report.getCancelCount() + " đơn hàng bị hủy trong tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Đề nghị xem xét quy trình.";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "suggestion", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "suggestion", null);
                NotificationWebSocketServer.broadcast(message, "suggestion", null, transportUnitUserId);
                LOGGER.info("Created suggestion notification for cancellations, report ID: " + reportId);
            }
        }
        if (report.getCancelCount() >= 10 && adminUserId != -1) {
            String message = "Báo cáo vận chuyển ID " + reportId + ": Đơn vị vận chuyển " + report.getCompanyName() + " có số lượng đơn hủy nghiêm trọng (" + report.getCancelCount() + ") trong tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Cần kiểm tra gấp!";
            if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "warning", message)) {
                notificationDAO.createNotification(transportUnitUserId, message, "warning", null);
                NotificationWebSocketServer.broadcast(message, "warning", null, transportUnitUserId);
                LOGGER.info("Created warning notification for high cancellations, report ID: " + reportId);
            }
            String adminMessage = "Báo cáo vận chuyển ID " + reportId + ": Đơn vị vận chuyển " + report.getCompanyName() + " có " + report.getCancelCount() + " đơn hủy trong tháng " + report.getReportMonth() + "/" + report.getReportYear() + ". Cần kiểm tra.";
            if (!notificationDAO.isDuplicateNotification(adminUserId, null, "warning", adminMessage)) {
                notificationDAO.createNotification(adminUserId, adminMessage, "warning", null);
                NotificationWebSocketServer.broadcast(adminMessage, "warning", null, adminUserId);
                LOGGER.info("Created admin warning notification for cancellations, report ID: " + reportId);
            }
        }

        // Gợi ý cải thiện hiệu suất
        String message = "Báo cáo vận chuyển ID " + reportId + ": Gợi ý: Đơn vị vận chuyển " + report.getCompanyName() + " nên tối ưu hóa lộ trình vận chuyển để giảm thời gian giao hàng trong tháng " + report.getReportMonth() + "/" + report.getReportYear() + ".";
        if (!notificationDAO.isDuplicateNotification(transportUnitUserId, null, "suggestion", message)) {
            notificationDAO.createNotification(transportUnitUserId, message, "suggestion", null);
            NotificationWebSocketServer.broadcast(message, "suggestion", null, transportUnitUserId);
            LOGGER.info("Created suggestion notification for transport optimization, report ID: " + reportId);
        }
    }

    private int analyzeOrders() throws SQLException {
        List<Orders> orders = orderDAO.getOrderList(null, null, null, null, null, null, null, null);
        Timestamp now = new Timestamp(System.currentTimeMillis());
        int adminUserId = notificationDAO.getAdminUserId();
        int defaultTransportUnitId = userDAO.getTransportUnitId();
        int analyzedCount = 0;
        int cancelledOrderCount = 0;

        for (Orders order : orders) {
            if (notificationDAO.hasOrderBeenAnalyzed(order.getOrderId())) {
                LOGGER.info("Đơn hàng ID " + order.getOrderId() + " đã được phân tích, bỏ qua.");
                continue;
            }

            Integer transportUnitId = order.getTransportUnitId() != null ? order.getTransportUnitId() : defaultTransportUnitId;
            int customerUserId = order.getCustomerId();
            long daysDiff = (now.getTime() - order.getCreatedAt().getTime()) / (1000 * 60 * 60 * 24);

            if (!notificationDAO.isUserIdValid(customerUserId)) {
                LOGGER.warning("Invalid customer_id (user_id): " + customerUserId + " for order ID: " + order.getOrderId());
                continue;
            }

            if ("cancelled".equals(order.getOrderStatus())) {
                cancelledOrderCount++;
            }

            if (transportUnitId != -1 && notificationDAO.isUserIdValid(transportUnitId)) {
                // Đơn hàng pending quá lâu
                if ("pending".equals(order.getOrderStatus()) && daysDiff >= 3) {
                    String message = "Đơn hàng #" + order.getOrderId() + " chưa được xử lý trong " + daysDiff + " ngày. Vui lòng kiểm tra ngay.";
                    if (!notificationDAO.isDuplicateNotification(transportUnitId, order.getOrderId(), "reminder", message)) {
                        notificationDAO.createNotification(transportUnitId, message, "reminder", order.getOrderId());
                        NotificationWebSocketServer.broadcast(message, "reminder", order.getOrderId(), transportUnitId);
                        LOGGER.info("Created reminder notification for order ID: " + order.getOrderId() + ", transport_unit_id: " + transportUnitId);
                    }
                }

                // Đơn hàng quá hạn giao
                if ("in_progress".equals(order.getOrderStatus()) && order.getDeliverySchedule() != null && order.getDeliverySchedule().before(now)) {
                    String message = "Đơn hàng #" + order.getOrderId() + " đã quá hạn giao hàng. Cần xử lý khẩn cấp!";
                    if (!notificationDAO.isDuplicateNotification(transportUnitId, order.getOrderId(), "urgent", message)) {
                        notificationDAO.createNotification(transportUnitId, message, "urgent", order.getOrderId());
                        NotificationWebSocketServer.broadcast(message, "urgent", order.getOrderId(), transportUnitId);
                        LOGGER.info("Created urgent notification for overdue order ID: " + order.getOrderId());
                    }
                }

                // Đơn hàng sắp đến hạn
                if ("in_progress".equals(order.getOrderStatus()) && order.getDeliverySchedule() != null) {
                    long hoursToDeadline = (order.getDeliverySchedule().getTime() - now.getTime()) / (1000 * 60 * 60);
                    if (hoursToDeadline <= 24 && hoursToDeadline > 0) {
                        String message = "Đơn hàng #" + order.getOrderId() + " sắp đến hạn giao trong " + hoursToDeadline + " giờ. Đề nghị ưu tiên xử lý.";
                        if (!notificationDAO.isDuplicateNotification(transportUnitId, order.getOrderId(), "suggestion", message)) {
                            notificationDAO.createNotification(transportUnitId, message, "suggestion", order.getOrderId());
                            NotificationWebSocketServer.broadcast(message, "suggestion", order.getOrderId(), transportUnitId);
                            LOGGER.info("Created suggestion notification for nearing deadline order ID: " + order.getOrderId());
                        }
                    }
                }
            }

            // Đơn hàng đã giao thành công
            if ("delivered".equals(order.getOrderStatus()) && order.getDeliveredAt() != null) {
                String message = "Đơn hàng #" + order.getOrderId() + " của bạn đã được giao thành công.";
                if (!notificationDAO.isDuplicateNotification(customerUserId, order.getOrderId(), "reward", message)) {
                    notificationDAO.createNotification(customerUserId, message, "reward", order.getOrderId());
                    NotificationWebSocketServer.broadcast(message, "reward", order.getOrderId(), customerUserId);
                    LOGGER.info("Created reward notification for delivered order ID: " + order.getOrderId());
                }

                String reviewMessage = "Đơn hàng #" + order.getOrderId() + " đã được giao. Vui lòng đánh giá dịch vụ của chúng tôi.";
                if (!notificationDAO.isDuplicateNotification(customerUserId, order.getOrderId(), "suggestion", reviewMessage)) {
                    notificationDAO.createNotification(customerUserId, reviewMessage, "suggestion", order.getOrderId());
                    NotificationWebSocketServer.broadcast(reviewMessage, "suggestion", order.getOrderId(), customerUserId);
                    LOGGER.info("Created review suggestion notification for order ID: " + order.getOrderId());
                }
            }

            // Đơn hàng bị hủy
            if ("cancelled".equals(order.getOrderStatus())) {
                List<Issue> issues = orderDAO.getIssuesByOrderId(order.getOrderId());
                for (Issue issue : issues) {
                    String message = "Đơn hàng #" + order.getOrderId() + " của bạn đã bị hủy do: " + issue.getDescription();
                    if (!notificationDAO.isDuplicateNotification(customerUserId, order.getOrderId(), "warning", message)) {
                        notificationDAO.createNotification(customerUserId, message, "warning", order.getOrderId());
                        NotificationWebSocketServer.broadcast(message, "warning", order.getOrderId(), customerUserId);
                        LOGGER.info("Created cancellation warning for order ID: " + order.getOrderId());
                    }

                    if (issue.getDescription().toLowerCase().contains("vận chuyển") || issue.getDescription().toLowerCase().contains("giao hàng")) {
                        if (transportUnitId != -1 && notificationDAO.isUserIdValid(transportUnitId)) {
                            String transportMessage = "Đơn hàng #" + order.getOrderId() + " bị hủy do lỗi vận chuyển: " + issue.getDescription();
                            if (!notificationDAO.isDuplicateNotification(transportUnitId, order.getOrderId(), "warning", transportMessage)) {
                                notificationDAO.createNotification(transportUnitId, transportMessage, "warning", order.getOrderId());
                                NotificationWebSocketServer.broadcast(transportMessage, "warning", order.getOrderId(), transportUnitId);
                                LOGGER.info("Created transport warning for order ID: " + order.getOrderId());
                            }
                        }
                    }
                }
            }

            // Trạng thái bất thường
            if (!List.of("pending", "in_progress", "delivered", "cancelled").contains(order.getOrderStatus()) && adminUserId != -1) {
                String message = "Đơn hàng #" + order.getOrderId() + " có trạng thái bất thường: " + order.getOrderStatus() + ". Vui lòng kiểm tra.";
                if (!notificationDAO.isDuplicateNotification(adminUserId, order.getOrderId(), "warning", message)) {
                    notificationDAO.createNotification(adminUserId, message, "warning", order.getOrderId());
                    NotificationWebSocketServer.broadcast(message, "warning", order.getOrderId(), adminUserId);
                    LOGGER.info("Created warning for abnormal status, order ID: " + order.getOrderId());
                }
            }

            analyzedCount++;
        }

        // Thông báo cho admin nếu số đơn hủy lớn
        if (cancelledOrderCount >= 10 && adminUserId != -1) {
            String message = "Có " + cancelledOrderCount + " đơn hàng bị hủy trong lần phân tích này. Cần kiểm tra nguyên nhân.";
            if (!notificationDAO.isDuplicateNotification(adminUserId, null, "warning", message)) {
                notificationDAO.createNotification(adminUserId, message, "warning", null);
                NotificationWebSocketServer.broadcast(message, "warning", null, adminUserId);
                LOGGER.info("Created warning for high cancellation count: " + cancelledOrderCount);
            }
        }

        return analyzedCount;
    }
}
