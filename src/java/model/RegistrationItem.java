
package model;

import java.util.Date;

public class RegistrationItem {
    private int id;
    private String type; 
    private String name; 
    private String contactInfo; 
    private String registrationStatus;
    private Date createdAt;
    private String username;
    private String email;
    
    public RegistrationItem() {}
    
    public RegistrationItem(int id, String type, String name, String contactInfo, 
                           String registrationStatus, Date createdAt, String username, String email) {
        this.id = id;
        this.type = type;
        this.name = name;
        this.contactInfo = contactInfo;
        this.registrationStatus = registrationStatus;
        this.createdAt = createdAt;
        this.username = username;
        this.email = email;
    }
    
    public RegistrationItem(int id, String type, String name, String status) {
        this.id = id;
        this.type = type;
        this.name = name;
        this.registrationStatus = status;
    }
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    
    public String getRegistrationStatus() { return registrationStatus; }
    public void setRegistrationStatus(String registrationStatus) { this.registrationStatus = registrationStatus; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getStatusBadgeClass() {
        switch (registrationStatus.toLowerCase()) {
            case "approved": return "badge-success";
            case "rejected": return "badge-danger";
            case "pending": return "badge-warning";
            default: return "badge-secondary";
        }
    }
    
    public String getTypeDisplayName() {
        return type.equals("transport") ? "Đơn vị vận chuyển" : "Đơn vị kho bãi";
    }
}
