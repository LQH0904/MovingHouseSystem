/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class transportUnit {
    private int transportUnitId;
    private String companyName;
    private String contactInfo;
    private String registrationStatus;
    private String createdAt;
    private String location;
    private int vehicleCount;
    private int capacity;

    public transportUnit() {
    }

    public transportUnit(int transportUnitId, String companyName, String contactInfo, String registrationStatus, String createdAt, String location, int vehicleCount, int capacity) {
        this.transportUnitId = transportUnitId;
        this.companyName = companyName;
        this.contactInfo = contactInfo;
        this.registrationStatus = registrationStatus;
        this.createdAt = createdAt;
        this.location = location;
        this.vehicleCount = vehicleCount;
        this.capacity = capacity;
    }

    public int getTransportUnitId() {
        return transportUnitId;
    }

    public void setTransportUnitId(int transportUnitId) {
        this.transportUnitId = transportUnitId;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }

    public String getContactInfo() {
        return contactInfo;
    }

    public void setContactInfo(String contactInfo) {
        this.contactInfo = contactInfo;
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

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public int getVehicleCount() {
        return vehicleCount;
    }

    public void setVehicleCount(int vehicleCount) {
        this.vehicleCount = vehicleCount;
    }

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    @Override
    public String toString() {
        return "transportUnit{" + "transportUnitId=" + transportUnitId + ", companyName=" + companyName + ", contactInfo=" + contactInfo + ", registrationStatus=" + registrationStatus + ", createdAt=" + createdAt + ", location=" + location + ", vehicleCount=" + vehicleCount + ", capacity=" + capacity + '}';
    }
    
}
