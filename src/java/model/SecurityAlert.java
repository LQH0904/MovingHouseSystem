package model;

import java.util.Date;

public class SecurityAlert {
    private int id;
    private String title;
    private String description;
    private String level;
    private String status;
    private String ipAddress;
    private String userEmail;
    private Date createdAt;

    public SecurityAlert(int id, String title, String description, String level, String status, String ipAddress, String userEmail, Date createdAt) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.level = level;
        this.status = status;
        this.ipAddress = ipAddress;
        this.userEmail = userEmail;
        this.createdAt = createdAt;
    }

    public SecurityAlert() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserEmail() {
        return userEmail;
    }

    public void setUserEmail(String userEmail) {
        this.userEmail = userEmail;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    
}
