package model;

import java.time.LocalDateTime;

public class Notification {

    private int notificationId;
    private int userId;
    private Integer orderId;
    private String notificationType;
    private String message;
    private String status;
    private LocalDateTime createdAt;

    public Notification() {
    }

    public Notification(int userId, Integer orderId, String notificationType, String message, String status) {
        this.userId = userId;
        this.orderId = orderId;
        this.notificationType = notificationType;
        this.message = message;
        this.status = status;
        this.createdAt = LocalDateTime.now();
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getNotificationType() {
        return notificationType;
    }

    public void setNotificationType(String notificationType) {
        this.notificationType = notificationType;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
