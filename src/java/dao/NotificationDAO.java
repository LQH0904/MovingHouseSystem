/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Notification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import utils.DBConnection;

public class NotificationDAO {

    private static final Logger LOGGER = Logger.getLogger(NotificationDAO.class.getName());
    public static final NotificationDAO INSTANCE = new NotificationDAO();

    public void createNotification(int userId, String message, String notificationType, Integer orderId) throws SQLException {
        String query = "INSERT INTO Notifications (user_id, order_id, message, status, notification_type, created_at) VALUES (?, ?, ?, 'sent', ?, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            if (orderId != null) {
                ps.setInt(2, orderId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, message);
            ps.setString(4, notificationType);
            ps.executeUpdate();
            LOGGER.info("Created notification for user_id: " + userId + ", order_id: " + (orderId != null ? orderId : "NULL") + ", type: " + notificationType);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating notification: " + e.getMessage(), e);
            throw e;
        }
    }

    public List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM Notifications WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getInt("notification_id"));
                notification.setUserId(rs.getInt("user_id"));
                notification.setOrderId(rs.getInt("order_id") != 0 ? rs.getInt("order_id") : null);
                notification.setMessage(rs.getString("message"));
                notification.setStatus(rs.getString("status"));
                notification.setNotificationType(rs.getString("notification_type"));
                notification.setCreatedAt(rs.getTimestamp("created_at"));
                notifications.add(notification);
            }
            LOGGER.info("Fetched " + notifications.size() + " notifications for user_id: " + userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching notifications for user_id: " + userId, e);
        }
        return notifications;
    }

    public void markAsRead(int notificationId, int userId) throws SQLException {
        String query = "UPDATE Notifications SET status = 'read' WHERE notification_id = ? AND user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, notificationId);
            ps.setInt(2, userId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("Marked notification_id: " + notificationId + " as read for user_id: " + userId);
            } else {
                LOGGER.warning("No notification found for notification_id: " + notificationId + " and user_id: " + userId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error marking notification as read: " + e.getMessage(), e);
            throw e;
        }
    }

    public boolean isDuplicateNotification(int userId, Integer orderId, String notificationType, String message) throws SQLException {
        String query = "SELECT COUNT(*) FROM Notifications WHERE user_id = ? AND notification_type = ? AND message = ?"
                + (orderId != null ? " AND order_id = ? AND created_at >= DATEADD(hour, -24, GETDATE())" : " AND order_id IS NULL AND created_at >= DATEADD(hour, -24, GETDATE())");
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ps.setString(2, notificationType);
            ps.setString(3, message);
            if (orderId != null) {
                ps.setInt(4, orderId);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi kiểm tra thông báo trùng lặp: " + e.getMessage());
            throw e;
        }
        return false;
    }

    public int countUnanalyzedReports(String reportType, String unitName) throws SQLException {
        String query;
        if ("inventory".equals(reportType)) {
            query = "SELECT COUNT(*) FROM InventoryReports ir "
                  + "LEFT JOIN StorageUnits su ON ir.storage_unit_id = su.storage_unit_id "
                  + "LEFT JOIN Notifications n ON n.user_id = ir.storage_unit_id AND n.message LIKE ('%Báo cáo%' + CAST(ir.report_id AS NVARCHAR) + '%') AND n.created_at >= DATEADD(day, -365, GETDATE()) "
                  + "WHERE ir.created_at >= DATEADD(day, -365, GETDATE()) AND n.notification_id IS NULL "
                  + (unitName != null ? "AND su.warehouse_name LIKE ?" : "");
        } else { // transport
            query = "SELECT COUNT(*) FROM TransportReport tr "
                  + "LEFT JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id "
                  + "LEFT JOIN Notifications n ON n.user_id = tr.transport_unit_id AND n.message LIKE ('%Báo cáo%' + CAST(tr.report_id AS NVARCHAR) + '%') AND n.created_at >= DATEADD(day, -365, GETDATE()) "
                  + "WHERE tr.created_at >= DATEADD(day, -365, GETDATE()) AND n.notification_id IS NULL "
                  + (unitName != null ? "AND tu.company_name LIKE ?" : "");
        }
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            if (unitName != null) {
                ps.setString(1, "%" + unitName + "%");
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting unanalyzed reports for type: " + reportType, e);
            throw e;
        }
        return 0;
    }

    public int countUnanalyzedOrders() throws SQLException {
        String query = "SELECT COUNT(*) FROM Orders o "
                + "LEFT JOIN Notifications n ON n.order_id = o.order_id AND n.created_at >= DATEADD(day, -365, GETDATE()) "
                + "WHERE n.notification_id IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi đếm số đơn hàng chưa phân tích: " + e.getMessage());
            throw e;
        }
        return 0;
    }

    public boolean hasReportBeenAnalyzed(String reportType, int reportId) throws SQLException {
    String query = reportType.equals("inventory")
            ? "SELECT COUNT(*) FROM Notifications n "
            + "JOIN InventoryReports ir ON n.user_id = ir.storage_unit_id "
            + "WHERE ir.report_id = ? AND n.message LIKE ? AND n.created_at >= DATEADD(day, -365, GETDATE())"
            : "SELECT COUNT(*) FROM Notifications n "
            + "JOIN TransportReport tr ON n.user_id = tr.transport_unit_id "
            + "WHERE tr.report_id = ? AND n.message LIKE ? AND n.created_at >= DATEADD(day, -365, GETDATE())";
    try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
        ps.setInt(1, reportId);
        ps.setString(2, "%Báo cáo%" + reportId + "%");
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
    } catch (SQLException e) {
        LOGGER.severe("Lỗi kiểm tra báo cáo đã phân tích: " + reportType + " ID " + reportId + ": " + e.getMessage());
        throw e;
    }
    return false;
}

    public boolean hasOrderBeenAnalyzed(int orderId) throws SQLException {
        String query = "SELECT COUNT(*) FROM Notifications WHERE order_id = ? AND created_at >= DATEADD(day, -365, GETDATE())";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi kiểm tra đơn hàng đã phân tích: Order ID " + orderId + ": " + e.getMessage());
            throw e;
        }
        return false;
    }

    public List<Integer> getUnanalyzedReportIds(String reportType, String unitName) throws SQLException {
        List<Integer> unanalyzedIds = new ArrayList<>();
        String query;
        String idColumn = "report_id"; // Common for both
        if ("inventory".equals(reportType)) {
            query = "SELECT ir.report_id FROM InventoryReports ir "
                  + "LEFT JOIN StorageUnits su ON ir.storage_unit_id = su.storage_unit_id "
                  + "LEFT JOIN Notifications n ON n.user_id = ir.storage_unit_id AND n.message LIKE ('%Báo cáo%' + CAST(ir.report_id AS NVARCHAR) + '%') AND n.created_at >= DATEADD(day, -365, GETDATE()) "
                  + "WHERE ir.created_at >= DATEADD(day, -365, GETDATE()) AND n.notification_id IS NULL "
                  + (unitName != null ? "AND su.warehouse_name LIKE ?" : "");
        } else { // transport
            query = "SELECT tr.report_id FROM TransportReport tr "
                  + "LEFT JOIN TransportUnits tu ON tr.transport_unit_id = tu.transport_unit_id "
                  + "LEFT JOIN Notifications n ON n.user_id = tr.transport_unit_id AND n.message LIKE ('%Báo cáo%' + CAST(tr.report_id AS NVARCHAR) + '%') AND n.created_at >= DATEADD(day, -365, GETDATE()) "
                  + "WHERE tr.created_at >= DATEADD(day, -365, GETDATE()) AND n.notification_id IS NULL "
                  + (unitName != null ? "AND tu.company_name LIKE ?" : "");
        }
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            if (unitName != null) {
                ps.setString(1, "%" + unitName + "%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                unanalyzedIds.add(rs.getInt(idColumn));
            }
            LOGGER.info("Fetched " + unanalyzedIds.size() + " unanalyzed " + reportType + " report IDs");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching unanalyzed report IDs for type: " + reportType, e);
            throw e;
        }
        return unanalyzedIds;
    }

    public List<Integer> getUnanalyzedOrderIds() throws SQLException {
        List<Integer> unanalyzedIds = new ArrayList<>();
        String query = "SELECT o.order_id FROM Orders o "
                + "LEFT JOIN Notifications n ON n.order_id = o.order_id AND n.created_at >= DATEADD(day, -365, GETDATE()) "
                + "WHERE n.notification_id IS NULL";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                unanalyzedIds.add(rs.getInt("order_id"));
            }
            LOGGER.info("Fetched " + unanalyzedIds.size() + " unanalyzed order IDs");
        } catch (SQLException e) {
            LOGGER.severe("Lỗi lấy danh sách order_id chưa phân tích: " + e.getMessage());
            throw e;
        }
        return unanalyzedIds;
    }

    public boolean isUserIdValid(int userId) throws SQLException {
        String query = "SELECT COUNT(*) FROM Users WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi kiểm tra user_id " + userId + ": " + e.getMessage());
            throw e;
        }
        return false;
    }

    public int getAdminUserId() throws SQLException {
        String query = "SELECT TOP 1 user_id FROM Users WHERE role_id = 1 AND status = 'active'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int userId = rs.getInt("user_id");
                LOGGER.info("Found admin user_id: " + userId);
                return userId;
            }
            LOGGER.warning("No active admin user found.");
            return -1;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching admin user_id", e);
            throw e;
        }
    }
}