package model;

import java.sql.Timestamp;
import java.time.LocalDateTime;

public class Issue {

    private int issueId;
    private int userId;
    private int orderId;
    private String description;
    private String status;
    private String priority;
    private Timestamp createdAt;
    private Timestamp resolvedAt; // ✅ Bổ sung trường này
    private Integer unitId;
    private String unitType;
    private String operatorReply;

    public Issue() {
    }

    public Issue(int userId, int orderId, String description) {
        this.userId = userId;
        this.orderId = orderId;
        this.description = description;
        this.status = "pending";
        this.priority = "medium";
        this.createdAt = Timestamp.valueOf(LocalDateTime.MIN);
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

   public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
    }
    public void setUnitId(Integer unitId) {
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


