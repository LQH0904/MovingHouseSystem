package model;

public class UserStaff {

    private int userId;
    private String username;
    private String email;
    private String status;
    private String avatarUrl;
    private String phone;   
    private String address; 

    public UserStaff(int userId, String username, String email, String status, String avatarUrl, String phone, String address) {
        this.userId = userId;
        this.username = username;
        this.email = email;
        this.status = status;
        this.avatarUrl = avatarUrl;
        this.phone = phone;
        this.address = address;
    }

    // Getters & setters
    public int getUserId() {
        return userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAvatarUrl() {
        return avatarUrl;
    }

    public void setAvatarUrl(String avatarUrl) {
        this.avatarUrl = avatarUrl;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }
}
