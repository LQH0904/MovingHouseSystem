/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class InventoryReports {
    private int reporId;
    private int storageunitId;
    private String inventoryDetails;
    private String createdAt;
    private String updatedAt;
    private String title;
    

    @Override
    public String toString() {
        return "InventoryReports{" + "reporId=" + reporId + ", storageunitId=" + storageunitId + ", inventoryDetails=" + inventoryDetails + ", createdAt=" + createdAt + ", updatedAt=" + updatedAt + ", title=" + title + '}';
    }

    public int getReporId() {
        return reporId;
    }

    public void setReporId(int reporId) {
        this.reporId = reporId;
    }

    public int getStorageunitId() {
        return storageunitId;
    }

    public void setStorageunitId(int storageunitId) {
        this.storageunitId = storageunitId;
    }

    public String getInventoryDetails() {
        return inventoryDetails;
    }

    public void setInventoryDetails(String inventoryDetails) {
        this.inventoryDetails = inventoryDetails;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(String updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public InventoryReports(int reporId, int storageunitId, String inventoryDetails, String createdAt, String updatedAt, String title) {
        this.reporId = reporId;
        this.storageunitId = storageunitId;
        this.inventoryDetails = inventoryDetails;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.title = title;
    }

    public InventoryReports() {
    }

}
