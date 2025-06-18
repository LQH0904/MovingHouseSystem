/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Notifications {
    private int notificationId;
    private int userId;
    private int orderId;
    private String message;
    private String status;
    private String created_at;

    public Notifications() {
    }

    public Notifications(int notificationId, int userId, int orderId, String message, String status, String created_at) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.orderId = orderId;
        this.message = message;
        this.status = status;
        this.created_at = created_at;
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

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
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

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    @Override
    public String toString() {
        return "Notifications{" + "notificationId=" + notificationId + ", userId=" + userId + ", orderId=" + orderId + ", message=" + message + ", status=" + status + ", created_at=" + created_at + '}';
    }
    
}
