/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class StorageUnit {
    private int storageUnitId;
    private String warehouseName;
    private String location;
    private String registrationStatus;
    private String createdAt;
    private String businessCertificate;
    private Double area;
    private int employee;
    private String phoneNumber;

    public StorageUnit() {
    }

    public StorageUnit(int storageUnitId, String warehouseName, String location, String registrationStatus, String createdAt, String businessCertificate, Double area, int employee, String phoneNumber) {
        this.storageUnitId = storageUnitId;
        this.warehouseName = warehouseName;
        this.location = location;
        this.registrationStatus = registrationStatus;
        this.createdAt = createdAt;
        this.businessCertificate = businessCertificate;
        this.area = area;
        this.employee = employee;
        this.phoneNumber = phoneNumber;
    }

    public int getStorageUnitId() {
        return storageUnitId;
    }

    public void setStorageUnitId(int storageUnitId) {
        this.storageUnitId = storageUnitId;
    }

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(String registrationStatus) {
        this.registrationStatus = registrationStatus;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getBusinessCertificate() {
        return businessCertificate;
    }

    public void setBusinessCertificate(String businessCertificate) {
        this.businessCertificate = businessCertificate;
    }

    public Double getArea() {
        return area;
    }

    public void setArea(Double area) {
        this.area = area;
    }

    public int getEmployee() {
        return employee;
    }

    public void setEmployee(int employee) {
        this.employee = employee;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    @Override
    public String toString() {
        return "StorageUnit{" + "storageUnitId=" + storageUnitId + ", warehouseName=" + warehouseName + ", location=" + location + ", registrationStatus=" + registrationStatus + ", createdAt=" + createdAt + ", businessCertificate=" + businessCertificate + ", area=" + area + ", employee=" + employee + ", phoneNumber=" + phoneNumber + '}';
    }

    
}
