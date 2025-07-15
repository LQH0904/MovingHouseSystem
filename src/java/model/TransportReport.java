// 3. Updated transportReport.java model
package model;

public class transportReport {
    private int reportId;
    private int transportUnitId;
    private int reportYear;
    private int reportMonth;
    private int totalShipments;
    private double totalRevenue;
    private double plannedRevenue;
    private double totalWeight;
    private int onTimeCount;
    private int cancelCount;
    private int delayCount;
    private String createdAt;
    
    // ADDED: Company name field
    private String companyName;

    public transportReport() {
    }

    public transportReport(int reportId, int transportUnitId, int reportYear, int reportMonth, 
                          int totalShipments, double totalRevenue, double plannedRevenue, double totalWeight, 
                          int onTimeCount, int cancelCount, int delayCount, String createdAt) {
        this.reportId = reportId;
        this.transportUnitId = transportUnitId;
        this.reportYear = reportYear;
        this.reportMonth = reportMonth;
        this.totalShipments = totalShipments;
        this.totalRevenue = totalRevenue;
        this.plannedRevenue = plannedRevenue;
        this.totalWeight = totalWeight;
        this.onTimeCount = onTimeCount;
        this.cancelCount = cancelCount;
        this.delayCount = delayCount;
        this.createdAt = createdAt;
    }

    // All existing getters and setters...
    public int getReportId() { return reportId; }
    public void setReportId(int reportId) { this.reportId = reportId; }
    
    public int getTransportUnitId() { return transportUnitId; }
    public void setTransportUnitId(int transportUnitId) { this.transportUnitId = transportUnitId; }
    
    public int getReportYear() { return reportYear; }
    public void setReportYear(int reportYear) { this.reportYear = reportYear; }
    
    public int getReportMonth() { return reportMonth; }
    public void setReportMonth(int reportMonth) { this.reportMonth = reportMonth; }
    
    public int getTotalShipments() { return totalShipments; }
    public void setTotalShipments(int totalShipments) { this.totalShipments = totalShipments; }
    
    public double getTotalRevenue() { return totalRevenue; }
    public void setTotalRevenue(double totalRevenue) { this.totalRevenue = totalRevenue; }
    
    public double getPlannedRevenue() { return plannedRevenue; }
    public void setPlannedRevenue(double plannedRevenue) { this.plannedRevenue = plannedRevenue; }
    
    public double getTotalWeight() { return totalWeight; }
    public void setTotalWeight(double totalWeight) { this.totalWeight = totalWeight; }
    
    public int getOnTimeCount() { return onTimeCount; }
    public void setOnTimeCount(int onTimeCount) { this.onTimeCount = onTimeCount; }
    
    public int getCancelCount() { return cancelCount; }
    public void setCancelCount(int cancelCount) { this.cancelCount = cancelCount; }
    
    public int getDelayCount() { return delayCount; }
    public void setDelayCount(int delayCount) { this.delayCount = delayCount; }
    
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
    
    // ADDED: Company name getter and setter
    public String getCompanyName() { return companyName; }
    public void setCompanyName(String companyName) { this.companyName = companyName; }

    @Override
    public String toString() {
        return "transportReport{" + 
               "reportId=" + reportId + 
               ", transportUnitId=" + transportUnitId + 
               ", companyName='" + companyName + "'" +
               ", reportYear=" + reportYear + 
               ", reportMonth=" + reportMonth + 
               ", totalShipments=" + totalShipments + 
               ", totalRevenue=" + totalRevenue + 
               ", plannedRevenue=" + plannedRevenue + 
               ", totalWeight=" + totalWeight + 
               ", onTimeCount=" + onTimeCount + 
               ", cancelCount=" + cancelCount + 
               ", delayCount=" + delayCount + 
               ", createdAt='" + createdAt + "'" + 
               '}';
    }
}