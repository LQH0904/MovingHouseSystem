package model;

import java.time.LocalDateTime;

public class SystemLogAdmin {

    private int logId;
    private int userId;
    private String action;
    private LocalDateTime timestamp;
    private String details;

    public SystemLogAdmin() {
    }

    public SystemLogAdmin(int userId, String action, String details) {
        this.userId = userId;
        this.action = action;
        this.timestamp = LocalDateTime.now();
        this.details = details;
    }

    public int getLogId() {
        return logId;
    }

    public void setLogId(int logId) {
        this.logId = logId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }
}
