package model;

public class TransportUnit {
    private int transportUnitId;
    private String companyName;
    private String contactInfo;
    private String registrationStatus;
    private String createdAt;
    private String location;
    private int vehicleCount;
    private double capacity;
    private int loader;
    private String businessCertificate;

    public TransportUnit() {
    }

    public TransportUnit(int transportUnitId, String companyName, String contactInfo, String registrationStatus, String createdAt, String location, int vehicleCount, double capacity, int loader, String businessCertificate) {
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

    @Override
    public String toString() {
        return "TransportUnit{" +
                "transportUnitId=" + transportUnitId +
                ", companyName='" + companyName + '\'' +
                ", contactInfo='" + contactInfo + '\'' +
                ", registrationStatus='" + registrationStatus + '\'' +
                ", createdAt='" + createdAt + '\'' +
                ", location='" + location + '\'' +
                ", vehicleCount=" + vehicleCount +
                ", capacity=" + capacity +
                ", loader=" + loader +
                ", businessCertificate='" + businessCertificate + '\'' +
                '}';
    }
}