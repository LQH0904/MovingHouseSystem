package model;

import java.sql.Timestamp;

public class Complaint {
    private int issueId;
    private String username;
    private String description;
    private String status;
    private String priority;
    private Timestamp createdAt;

    // Constructor mặc định (THÊM HOẶC ĐẢM BẢO CÓ DÒNG NÀY!)
    public Complaint() {
    }

    // Constructor đầy đủ tham số của bạn
    public Complaint(int issueId, String username, String description, String status, String priority, Timestamp createdAt) {
        this.issueId = issueId;
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
    }

    // --- Getters và Setters ---
    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
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

    @Override
    public String toString() {
        return "Complaint{" +
               "issueId=" + issueId +
               ", username='" + username + '\'' +
               ", description='" + description + '\'' +
               ", status='" + status + '\'' +
               ", priority='" + priority + '\'' +
               ", createdAt=" + createdAt +
               '}';
    }
}