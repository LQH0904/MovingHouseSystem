// File: src/main/java/model/Complaint.java
package model;

import java.sql.Timestamp;

public class Complaint {
    private int issueId;
    private int userId; // THÊM TRƯỜNG NÀY
    private String username;
    private String description;
    private String status;
    private String priority;
    private Timestamp createdAt;
    private Timestamp resolvedAt;
    private String escalationReason;
    private Integer escalatedByUserId;

    public Complaint() {
    }

    // CẬP NHẬT CONSTRUCTOR NÀY
    public Complaint(int issueId, int userId, String username, String description, String status, String priority, Timestamp createdAt, Timestamp resolvedAt) {
        this.issueId = issueId;
        this.userId = userId; // Gán userId
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
        this.escalationReason = null;
        this.escalatedByUserId = null;
    }

    // CẬP NHẬT CONSTRUCTOR NÀY
    public Complaint(int issueId, int userId, String username, String description, String status, String priority, Timestamp createdAt) {
        this.issueId = issueId;
        this.userId = userId; // Gán userId
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
        this.resolvedAt = null;
        this.escalationReason = null;
        this.escalatedByUserId = null;
    }

    // CẬP NHẬT CONSTRUCTOR NÀY
    public Complaint(int issueId, int userId, String username, String description, String status, String priority, Timestamp createdAt, Timestamp resolvedAt, String escalationReason, Integer escalatedByUserId) {
        this.issueId = issueId;
        this.userId = userId; // Gán userId
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
        this.escalationReason = escalationReason;
        this.escalatedByUserId = escalatedByUserId;
    }

    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
    }

    // THÊM GETTER VÀ SETTER CHO userId
    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getEscalationReason() {
        return escalationReason;
    }

    public void setEscalationReason(String escalationReason) {
        this.escalationReason = escalationReason;
    }

    public Integer getEscalatedByUserId() {
        return escalatedByUserId;
    }

    public void setEscalatedByUserId(Integer escalatedByUserId) {
        this.escalatedByUserId = escalatedByUserId;
    }

    @Override
    public String toString() {
        return "Complaint{" +
                "issueId=" + issueId +
                ", userId=" + userId + // THÊM VÀO toString()
                ", username='" + username + '\'' +
                ", description='" + description + '\'' +
                ", status='" + status + '\'' +
                ", priority='" + priority + '\'' +
                ", createdAt=" + createdAt +
                ", resolvedAt=" + resolvedAt +
                ", escalationReason='" + escalationReason + '\'' +
                ", escalatedByUserId=" + escalatedByUserId +
                '}';
    }
}