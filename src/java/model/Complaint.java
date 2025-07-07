package model;

import java.sql.Timestamp;

public class Complaint {
    private int issueId;
    private int userId;
    private String username; // Tên người tạo khiếu nại
    private String description;
    private String status;
    private String priority;
    private Timestamp createdAt;
    private Timestamp resolvedAt;
    private Integer assignedTo; // ID của operator được gán
    private String assignedToUsername; // Tên của operator được gán
    // Các cột sau KHÔNG CÓ TRONG SCHEMA DB bạn đã cung cấp, nên sẽ không được đưa vào đây.
    // private String escalationReason;
    // private Integer escalatedByUserId;
    // private String replyContent;

    // Constructor đầy đủ khớp với các cột CÓ TRONG DB của bạn
    public Complaint(int issueId, int userId, String username, String description, String status, String priority,
                     Timestamp createdAt, Timestamp resolvedAt, Integer assignedTo, String assignedToUsername) {
        this.issueId = issueId;
        this.userId = userId;
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt;
        this.assignedTo = assignedTo;
        this.assignedToUsername = assignedToUsername;
    }

    // Constructor mặc định (cần cho một số trường hợp khởi tạo)
    public Complaint() {
    }

    // --- Getters and Setters ---
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

    public Integer getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(Integer assignedTo) {
        this.assignedTo = assignedTo;
    }

    public String getAssignedToUsername() {
        return assignedToUsername;
    }

    public void setAssignedToUsername(String assignedToUsername) {
        this.assignedToUsername = assignedToUsername;
    }
}