package model;

import java.time.LocalDateTime;

public class Issue {

    private int issueId;
    private int userId;
    private int orderId;
    private String description;
    private String status;
    private String priority;
    private LocalDateTime createdAt;

    public Issue() {
    }

    public Issue(int userId, int orderId, String description) {
        this.userId = userId;
        this.orderId = orderId;
        this.description = description;
        this.status = "pending";
        this.priority = "medium";
        this.createdAt = LocalDateTime.now();
    }

    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
