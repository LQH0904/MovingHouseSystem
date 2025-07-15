package dao;

import model.Notification;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Timestamp;

public class NotificationDAO {

    public boolean createNotification(Notification notification) throws SQLException {
        String SQL = "INSERT INTO [dbo].[Notifications] (user_id, order_id, notification_type, message, status, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement pstmt = conn.prepareStatement(SQL)) {
            pstmt.setInt(1, notification.getUserId());
            if (notification.getOrderId() != null) {
                pstmt.setInt(2, notification.getOrderId());
            } else {
                pstmt.setNull(2, java.sql.Types.INTEGER);
            }
            pstmt.setString(3, notification.getNotificationType());
            pstmt.setString(4, notification.getMessage());
            pstmt.setString(5, notification.getStatus());
            pstmt.setTimestamp(6, Timestamp.valueOf(notification.getCreatedAt()));
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
}
