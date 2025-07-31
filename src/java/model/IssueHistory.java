package model;

import java.time.LocalDateTime;

public class IssueHistory {

    private int historyId;
    private int issueId;
    private int staffId;
    private String actionType;
    private String description;
    private LocalDateTime createdAt;

    public IssueHistory() {
    }

    public IssueHistory(int historyId, int issueId, int staffId, String actionType, String description, LocalDateTime createdAt) {
        this.historyId = historyId;
        this.issueId = issueId;
        this.staffId = staffId;
        this.actionType = actionType;
        this.description = description;
        this.createdAt = createdAt;
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getIssueId() {
        return issueId;
    }

    public void setIssueId(int issueId) {
        this.issueId = issueId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getActionType() {
        return actionType;
    }

    public void setActionType(String actionType) {
        this.actionType = actionType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
