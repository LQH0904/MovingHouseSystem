/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class TransportUnit {

    private String companyName;
    private String contactInfo;
    private String location;
    private int vehicleCount;
    private double capacity;
    private int loader;
    private String businessCertificate;
    private String registrationStatus;

    public TransportUnit(String companyName, String contactInfo, String location, int vehicleCount, double capacity, int loader, String businessCertificate, String registrationStatus) {
        this.companyName = companyName;
        this.contactInfo = contactInfo;
        this.location = location;
        this.vehicleCount = vehicleCount;
        this.capacity = capacity;
        this.loader = loader;
        this.businessCertificate = businessCertificate;
        this.registrationStatus = registrationStatus;
    }

    public TransportUnit() {
    }

    
    // Getters and Setters
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

    public int getLoader() {
        return loader;
    }

    public void setLoader(int loader) {
        this.loader = loader;
    }

    public String getBusinessCertificate() {
        return businessCertificate;
    }

    public void setBusinessCertificate(String businessCertificate) {
        this.businessCertificate = businessCertificate;
    }

    public String getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(String registrationStatus) {
        this.registrationStatus = registrationStatus;
    }
}
