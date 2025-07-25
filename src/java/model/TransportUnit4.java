package model;

import java.sql.Timestamp;

public class TransportUnit4 {
    private int transportUnitId;
    private String companyName;
    private String contactInfo;
    private String registrationStatus;
    private Timestamp createdAt;
    private String location;
    private int vehicleCount;
    private int capacity;
    private String loader;
    private String businessCertificate;
    private String insurance;

    // Constructor
    public TransportUnit4() {
    }

    public TransportUnit4(int transportUnitId, String companyName, String contactInfo, String registrationStatus,
                         Timestamp createdAt, String location, int vehicleCount, int capacity,
                         String loader, String businessCertificate, String insurance) {
        this.transportUnitId = transportUnitId;
        this.companyName = companyName;
        this.contactInfo = contactInfo;
        this.registrationStatus = registrationStatus;
        this.createdAt = createdAt;
        this.location = location;
        this.vehicleCount = vehicleCount;
        this.capacity = capacity;
        this.loader = loader;
        this.businessCertificate = businessCertificate;
        this.insurance = insurance;
    }

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

    public int getCapacity() {
        return capacity;
    }

    public void setCapacity(int capacity) {
        this.capacity = capacity;
    }

    public String getLoader() {
        return loader;
    }

    public void setLoader(String loader) {
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