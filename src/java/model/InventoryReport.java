/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

/**
 *
 * @author admin
 */
public class InventoryReport {

    private int reportId;
    private int storageUnitId;
    private String inventoryDetails;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String title;
    private String status;
    private String warehouseName;

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getStorageUnitId() {
        return storageUnitId;
    }

    public void setStorageUnitId(int storageUnitId) {
        this.storageUnitId = storageUnitId;
    }

    public String getInventoryDetails() {
        return inventoryDetails;
    }

    public void setInventoryDetails(String inventoryDetails) {
        this.inventoryDetails = inventoryDetails;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }
}
