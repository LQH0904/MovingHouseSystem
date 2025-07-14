/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author admin
 */
public class TransportReport {

    private int reportId;
    private int transportUnitId;
    private int reportYear;
    private int reportMonth;
    private int totalShipments;
    private BigDecimal totalRevenue;
    private BigDecimal plannedRevenue;
    private BigDecimal totalWeight;
    private int onTimeCount;
    private int cancelCount;
    private int delayCount;
    private Timestamp createdAt;
    private String companyName;

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getTransportUnitId() {
        return transportUnitId;
    }

    public void setTransportUnitId(int transportUnitId) {
        this.transportUnitId = transportUnitId;
    }

    public int getReportYear() {
        return reportYear;
    }

    public void setReportYear(int reportYear) {
        this.reportYear = reportYear;
    }

    public int getReportMonth() {
        return reportMonth;
    }

    public void setReportMonth(int reportMonth) {
        this.reportMonth = reportMonth;
    }

    public int getTotalShipments() {
        return totalShipments;
    }

    public void setTotalShipments(int totalShipments) {
        this.totalShipments = totalShipments;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public BigDecimal getPlannedRevenue() {
        return plannedRevenue;
    }

    public void setPlannedRevenue(BigDecimal plannedRevenue) {
        this.plannedRevenue = plannedRevenue;
    }

    public BigDecimal getTotalWeight() {
        return totalWeight;
    }

    public void setTotalWeight(BigDecimal totalWeight) {
        this.totalWeight = totalWeight;
    }

    public int getOnTimeCount() {
        return onTimeCount;
    }

    public void setOnTimeCount(int onTimeCount) {
        this.onTimeCount = onTimeCount;
    }

    public int getCancelCount() {
        return cancelCount;
    }

    public void setCancelCount(int cancelCount) {
        this.cancelCount = cancelCount;
    }

    public int getDelayCount() {
        return delayCount;
    }

    public void setDelayCount(int delayCount) {
        this.delayCount = delayCount;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCompanyName() {
        return companyName;
    }

    public void setCompanyName(String companyName) {
        this.companyName = companyName;
    }
}
