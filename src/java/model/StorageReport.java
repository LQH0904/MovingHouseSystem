/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class StorageReport {

    private String reportDate;
    private int storageUnitId;
    private int quantityOnHand;
    private double usedArea;
    private double totalArea;
    private int orderCount;
    private int inboundCount;
    private int outboundCount;
    private int returnedOrders;
    private double personnelCost;
    private double maintenanceCost;
    private double storageCostPerUnit;
    private double profit;

    public StorageReport() {
    }

    public StorageReport(String reportDate, int storageUnitId, int quantityOnHand, double usedArea, double totalArea, int orderCount, int inboundCount, int outboundCount, int returnedOrders, double personnelCost, double maintenanceCost, double storageCostPerUnit, double profit) {
        this.reportDate = reportDate;
        this.storageUnitId = storageUnitId;
        this.quantityOnHand = quantityOnHand;
        this.usedArea = usedArea;
        this.totalArea = totalArea;
        this.orderCount = orderCount;
        this.inboundCount = inboundCount;
        this.outboundCount = outboundCount;
        this.returnedOrders = returnedOrders;
        this.personnelCost = personnelCost;
        this.maintenanceCost = maintenanceCost;
        this.storageCostPerUnit = storageCostPerUnit;
        this.profit = profit;
    }

    public String getReportDate() {
        return reportDate;
    }

    public void setReportDate(String reportDate) {
        this.reportDate = reportDate;
    }

    public int getStorageUnitId() {
        return storageUnitId;
    }

    public void setStorageUnitId(int storageUnitId) {
        this.storageUnitId = storageUnitId;
    }

    public int getQuantityOnHand() {
        return quantityOnHand;
    }

    public void setQuantityOnHand(int quantityOnHand) {
        this.quantityOnHand = quantityOnHand;
    }

    public double getUsedArea() {
        return usedArea;
    }

    public void setUsedArea(double usedArea) {
        this.usedArea = usedArea;
    }

    public double getTotalArea() {
        return totalArea;
    }

    public void setTotalArea(double totalArea) {
        this.totalArea = totalArea;
    }

    public int getOrderCount() {
        return orderCount;
    }

    public void setOrderCount(int orderCount) {
        this.orderCount = orderCount;
    }

    public int getInboundCount() {
        return inboundCount;
    }

    public void setInboundCount(int inboundCount) {
        this.inboundCount = inboundCount;
    }

    public int getOutboundCount() {
        return outboundCount;
    }

    public void setOutboundCount(int outboundCount) {
        this.outboundCount = outboundCount;
    }

    public int getReturnedOrders() {
        return returnedOrders;
    }

    public void setReturnedOrders(int returnedOrders) {
        this.returnedOrders = returnedOrders;
    }

    public double getPersonnelCost() {
        return personnelCost;
    }

    public void setPersonnelCost(double personnelCost) {
        this.personnelCost = personnelCost;
    }

    public double getMaintenanceCost() {
        return maintenanceCost;
    }

    public void setMaintenanceCost(double maintenanceCost) {
        this.maintenanceCost = maintenanceCost;
    }

    public double getStorageCostPerUnit() {
        return storageCostPerUnit;
    }

    public void setStorageCostPerUnit(double storageCostPerUnit) {
        this.storageCostPerUnit = storageCostPerUnit;
    }

    public double getProfit() {
        return profit;
    }

    public void setProfit(double profit) {
        this.profit = profit;
    }

    
    
    // add tên kho bãi
    private String warehouseName;

    public String getWarehouseName() {
        return warehouseName;
    }

    public void setWarehouseName(String warehouseName) {
        this.warehouseName = warehouseName;
    }    

    @Override
    public String toString() {
        return "StorageReport{" + "reportDate=" + reportDate + ", storageUnitId=" + storageUnitId + ", quantityOnHand=" + quantityOnHand + ", usedArea=" + usedArea + ", totalArea=" + totalArea + ", orderCount=" + orderCount + ", inboundCount=" + inboundCount + ", outboundCount=" + outboundCount + ", returnedOrders=" + returnedOrders + ", personnelCost=" + personnelCost + ", maintenanceCost=" + maintenanceCost + ", storageCostPerUnit=" + storageCostPerUnit + ", profit=" + profit + ", warehouseName=" + warehouseName + '}';
    }
}
