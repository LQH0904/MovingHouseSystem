/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import com.fasterxml.jackson.annotation.JsonProperty;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 *
 * @author admin
 */
public class TransportReport1 {

   @JsonProperty("report_id")
private int reportId;
@JsonProperty("transport_unit_id")
private int transportUnitId;
@JsonProperty("report_year")
private int reportYear;
@JsonProperty("report_month")
private int reportMonth;
@JsonProperty("total_shipments")
private int totalShipments;
@JsonProperty("total_revenue")
private BigDecimal totalRevenue;
@JsonProperty("planned_revenue")
private BigDecimal plannedRevenue;
@JsonProperty("total_weight")
private BigDecimal totalWeight;
@JsonProperty("on_time_count")
private int onTimeCount;
@JsonProperty("cancel_count")
private int cancelCount;
@JsonProperty("delay_count")
private int delayCount;
@JsonProperty("created_at")
private Timestamp createdAt;
@JsonProperty("company_name")
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
