package model;

import java.sql.Timestamp;

public class TransportUnit2 {
    private int transportUnitId;
    private String companyName;
    private String contactInfo;
    private String registrationStatus;
    private Timestamp createdAt;
    private String location;
    private int vehicleCount;
    private double capacity;
    private Integer loader;
    private String businessCertificate; // ảnh
    private String insurance; // ảnh

    // Getters and Setters

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

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
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

    public double getCapacity() {
        return capacity;
    }

    public void setCapacity(double capacity) {
        this.capacity = capacity;
    }

    public Integer getLoader() {
        return loader;
    }

    public void setLoader(Integer loader) {
        this.loader = loader;
    }

    public String getBusinessCertificate() {
        return businessCertificate;
    }

    public void setBusinessCertificate(String businessCertificate) {
        this.businessCertificate = businessCertificate;
    }

    public String getInsurance() {
        return insurance;
    }

    public void setInsurance(String insurance) {
        this.insurance = insurance;
    }
    
}
