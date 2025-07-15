package model;

import java.util.Date;

public class SystemLog {

    private int logId;
    private int userId;
    private String username;
    private String action;
    private Date timestamp;
    private String details;

    public SystemLog(int adminId, String auditAction, String par) {
    }

    public SystemLog(int logId, int userId, String username, String action, Date timestamp, String details) {
        this.logId = logId;
        this.userId = userId;
        this.username = username;
        this.action = action;
        this.timestamp = timestamp;
        this.details = details;
    }

    // Getters and Setters
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

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public Date getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Date timestamp) {
        this.timestamp = timestamp;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    @Override
    public String toString() {
        return "SystemLog{"
                + "logId=" + logId
                + ", userId=" + userId
                + ", username='" + username + '\''
                + ", action='" + action + '\''
                + ", timestamp=" + timestamp
                + ", details='" + details + '\''
                + '}';
    }
}
