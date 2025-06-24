package model;

import java.sql.Timestamp;

public class OperatorComplaint {

    private int issueId;
    private int userId;
    private String username;
    private String description;
    private String status;
    private String priority;
    private Timestamp createdAt;
    private Timestamp resolvedAt;
    private Integer assignedTo; // Đã thêm trường này
    private String assignedToUsername;

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

    public Integer getAssignedTo() { // Getter cho assignedTo
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) { // Setter cho assignedTo
        this.assignedTo = assignedTo;
    }

    public String getAssignedToUsername() {
        return assignedToUsername;
    }

    public void setAssignedToUsername(String assignedToUsername) {
        this.assignedToUsername = assignedToUsername;
    }

    @Override
    public String toString() {
        return "OperatorComplaint{"
                + "issueId=" + issueId
                + ", userId=" + userId
                + ", username='" + username + '\''
                + ", description='" + description + '\''
                + ", status='" + status + '\''
                + ", priority='" + priority + '\''
                + ", createdAt=" + createdAt
                + ", resolvedAt=" + resolvedAt
                + ", assignedTo=" + assignedTo // Đã thêm vào toString
                + ", assignedToUsername='" + assignedToUsername + '\''
                + '}';
    }
}
