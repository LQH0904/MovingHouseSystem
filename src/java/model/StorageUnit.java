/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author admin
 */
public class StorageUnit {

    private String warehouseName;
    private String location;
    private String businessCertificate;
private String area;
    private int employee;
    private String phoneNumber;
    private String registrationStatus;

    public StorageUnit(String warehouseName, String location, String businessCertificate, String area, int employee, String phoneNumber, String registrationStatus) {
        this.warehouseName = warehouseName;
        this.location = location;
        this.businessCertificate = businessCertificate;
        this.area = area;
        this.employee = employee;
        this.phoneNumber = phoneNumber;
        this.registrationStatus = registrationStatus;
    }

    public StorageUnit() {
    }

      
    // Getters and Setters
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

    public String getBusinessCertificate() {
        return businessCertificate;
    }

    public void setBusinessCertificate(String businessCertificate) {
        this.businessCertificate = businessCertificate;
    }

    public String getArea() {
    return area;
}


   public void setArea(String area) {
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

    public String getRegistrationStatus() {
        return registrationStatus;
    }

    public void setRegistrationStatus(String registrationStatus) {
        this.registrationStatus = registrationStatus;
    }
}

