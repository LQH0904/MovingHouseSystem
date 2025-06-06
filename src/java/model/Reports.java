/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author Admin
 */
public class Reports {
    private int reportId;
    private String reportType;
    private int generatedBy;
    private String data;
    private String createdAt;
    private String title;

    public Reports(int reportId, String reportType, int generatedBy, String data, String createdAt, String title) {
        this.reportId = reportId;
        this.reportType = reportType;
        this.generatedBy = generatedBy;
        this.data = data;
        this.createdAt = createdAt;
        this.title = title;
    }

    public Reports() {
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public String getReportType() {
        return reportType;
    }

    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    public int getGeneratedBy() {
        return generatedBy;
    }

    public void setGeneratedBy(int generatedBy) {
        this.generatedBy = generatedBy;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    @Override
    public String toString() {
        return "Reports{" + "reportId=" + reportId + ", reportType=" + reportType + ", generatedBy=" + generatedBy + ", data=" + data + ", createdAt=" + createdAt + ", title=" + title + '}';
    }

}
