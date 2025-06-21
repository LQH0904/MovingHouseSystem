// File: src/main/java/com/yourpackage/model/Issue.java (hoặc Complaint.java)

package model; // Đảm bảo đúng package của bạn

import java.sql.Timestamp;

public class Issue {
    private int issueId;
    private int userId;
    private String username;
    private Integer orderId;
    private String description;
    private String status;
    private String priority;
    private Integer assignedTo;
    private Timestamp createdAt;
    private Timestamp resolvedAt;
    private String escalationReason;
    private Integer escalatedByUserId;

    // Constructors
    public Issue() {
    }

    public Issue(int issueId, int userId, String username, Integer orderId, String description, String status, String priority, Integer assignedTo, Timestamp createdAt, Timestamp resolvedAt, String escalationReason, Integer escalatedByUserId) {
        this.issueId = issueId;
        this.userId = userId;
        this.username = username;
        this.orderId = orderId;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.assignedTo = assignedTo;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
        this.escalationReason = escalationReason;
        this.escalatedByUserId = escalatedByUserId;
    }

    // Getters and Setters (đã lược bớt để tiết kiệm không gian, bạn cần có đầy đủ trong file của mình)
    public int getIssueId() { return issueId; }
    public void setIssueId(int issueId) { this.issueId = issueId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public Integer getOrderId() { return orderId; }
    public void setOrderId(Integer orderId) { this.orderId = orderId; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getPriority() { return priority; }
    public void setPriority(String priority) { this.priority = priority; }
    public Integer getAssignedTo() { return assignedTo; }
    public void setAssignedTo(Integer assignedTo) { this.assignedTo = assignedTo; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    public Timestamp getResolvedAt() { return resolvedAt; }
    public void setResolvedAt(Timestamp resolvedAt) { this.resolvedAt = resolvedAt; }
    public String getEscalationReason() { return escalationReason; }
    public void setEscalationReason(String escalationReason) { this.escalationReason = escalationReason; }
    public Integer getEscalatedByUserId() { return escalatedByUserId; }
    public void setEscalatedByUserId(Integer escalatedByUserId) { this.escalatedByUserId = escalatedByUserId; }

    @Override
    public String toString() {
        return "Issue{" +
               "issueId=" + issueId +
               ", userId=" + userId +
               ", username='" + username + '\'' +
               ", description='" + description + '\'' +
               ", status='" + status + '\'' +
               ", priority='" + priority + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}