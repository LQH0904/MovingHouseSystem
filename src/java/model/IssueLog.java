package model;

import java.time.LocalDateTime;

public class IssueLog {

    private int logId;
    private int issueId;
    private String action;
    private LocalDateTime createdAt;
    private int createdBy;
    private String details;

    public IssueLog() {
    }

    public IssueLog(int issueId, String action, LocalDateTime createdAt, int createdBy, String details) {
        this.issueId = issueId;
        this.action = action;
        this.createdAt = createdAt;
        this.createdBy = createdBy;
        this.details = details;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(int createdBy) {
        this.createdBy = createdBy;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
