package model;

import java.time.LocalDateTime;

public class AlertComplaint {
    private int issueId;
    private int userId;
    private int orderId;
    private String description;
    private String status;
    private String priority;
    private String assignedTo;
    private LocalDateTime createdAt;
    private LocalDateTime resolvedAt;
    private int unitId;
    private String unitType;
    private String operatorReply;

    // Constructors
    public AlertComplaint() {}

    public AlertComplaint(int issueId, int userId, int orderId, String description, String status,
                          String priority, String assignedTo, LocalDateTime createdAt, LocalDateTime resolvedAt,
                          int unitId, String unitType, String operatorReply) {
        this.issueId = issueId;
        this.userId = userId;
        this.orderId = orderId;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.assignedTo = assignedTo;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
        this.unitId = unitId;
        this.unitType = unitType;
        this.operatorReply = operatorReply;
    }

    // Getters and Setters
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

    public String getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(String assignedTo) {
        this.assignedTo = assignedTo;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public String getOperatorReply() {
        return operatorReply;
    }

    public void setOperatorReply(String operatorReply) {
        this.operatorReply = operatorReply;
    }
}
