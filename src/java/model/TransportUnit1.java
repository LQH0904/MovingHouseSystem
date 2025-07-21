package model;

public class TransportUnit1 {

    private String companyName;
    private String contactInfo;
    private String location;
    private int vehicleCount;
    private double capacity;
    private int loader;
    private String businessCertificate;
    private String registrationStatus;
    private String insurance;   // thêm

    public TransportUnit1(String companyName, String contactInfo, String location,
                         int vehicleCount, double capacity, int loader,
                         String businessCertificate, String registrationStatus, String insurance) {
        this.companyName = companyName;
        this.contactInfo = contactInfo;
        this.location = location;
        this.vehicleCount = vehicleCount;
        this.capacity = capacity;
        this.loader = loader;
        this.businessCertificate = businessCertificate;
        this.registrationStatus = registrationStatus;
        this.insurance = insurance;
    }

    public TransportUnit1() {
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

    public String getInsurance() {
        return insurance;
    }

    public void setInsurance(String insurance) {
        this.insurance = insurance;
    }
}
