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
    private String assignedToUsername;

    public int getIssueId() {
        return issueId;
    }

    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public String getDescription() {
        return description;
    }

    public String getStatus() {
        return status;
    }

    public String getPriority() {
        return priority;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public String getAssignedToUsername() {
        return assignedToUsername;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
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
                + ", assignedToUsername='" + assignedToUsername + '\''
                + '}';
    }
}