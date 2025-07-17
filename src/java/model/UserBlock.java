/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class UserBlock {
     private int id;
    private int userId;
    private String reason;
    private String blockedAt;

    public UserBlock() {}

    public UserBlock(int id, int userId, String reason, String blockedAt) {
        this.id = id;
        this.userId = userId;
        this.reason = reason;
        this.blockedAt = blockedAt;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getBlockedAt() {
        return blockedAt;
    }

    public void setBlockedAt(String blockedAt) {
        this.blockedAt = blockedAt;
    }
    
}
