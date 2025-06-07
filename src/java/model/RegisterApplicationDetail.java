/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author Admin
 */
public class RegisterApplicationDetail {
     private int applicationId;
    private String username;
    private String email;
    private String roleName;
    private String statusName;
    private Timestamp createdAt;
    private String userStatus;
    private String note;

    public RegisterApplicationDetail() {
    }

    public RegisterApplicationDetail(int applicationId, String username, String email, String roleName, String statusName, Timestamp createdAt, String userStatus, String note) {
        this.applicationId = applicationId;
        this.username = username;
        this.email = email;
        this.roleName = roleName;
        this.statusName = statusName;
        this.createdAt = createdAt;
        this.userStatus = userStatus;
        this.note = note;
    }

    public int getApplicationId() {
        return applicationId;
    }

    public void setApplicationId(int applicationId) {
        this.applicationId = applicationId;
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

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getUserStatus() {
        return userStatus;
    }

    public void setUserStatus(String userStatus) {
        this.userStatus = userStatus;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
    
    
}
