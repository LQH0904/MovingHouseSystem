// model/ChatbotLog.java
package model;

import java.util.Date;

public class ChatbotLog {
    private int logId;
    private int userId;
    private String message;
    private String response;
    private Date createdAt;
    private String username;

    public ChatbotLog() {
    }

    public ChatbotLog(int logId, int userId, String message, String response, Date createdAt, String username) {
        this.logId = logId;
        this.userId = userId;
        this.message = message;
        this.response = response;
        this.createdAt = createdAt;
        this.username = username;
    }

    public ChatbotLog(int logId, int userId, String message, String response, Date createdAt) {
        this.logId = logId;
        this.userId = userId;
        this.message = message;
        this.response = response;
        this.createdAt = createdAt;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
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

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getResponse() {
        return response;
    }

    public void setResponse(String response) {
        this.response = response;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}