package model;

import java.sql.Timestamp;

public class Complaint {
    private int issueId;
    private String username;
    private String description;
    private String status;
    private String priority;
    private Timestamp createdAt;
    private Timestamp resolvedAt; // Thuộc tính mới được thêm vào

    public Complaint() {
        // Constructor mặc định
    }

    // Constructor với tất cả các trường, bao gồm resolvedAt
    public Complaint(int issueId, String username, String description, String status, String priority, Timestamp createdAt, Timestamp resolvedAt) {
        this.issueId = issueId;
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
        this.resolvedAt = resolvedAt; // Khởi tạo resolvedAt
    }

    // Constructor cũ, bạn có thể giữ lại hoặc xóa nếu không cần
    public Complaint(int issueId, String username, String description, String status, String priority, Timestamp createdAt) {
        this.issueId = issueId;
        this.username = username;
        this.description = description;
        this.status = status;
        this.priority = priority;
        this.createdAt = createdAt;
        // resolvedAt sẽ mặc định là null hoặc bạn có thể gán giá trị mặc định khác ở đây
        this.resolvedAt = null;
    }

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

    // Getter và Setter cho resolvedAt
    public Timestamp getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(Timestamp resolvedAt) {
        this.resolvedAt = resolvedAt;
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
                ", resolvedAt=" + resolvedAt + // Thêm resolvedAt vào toString
                '}';
    }
}