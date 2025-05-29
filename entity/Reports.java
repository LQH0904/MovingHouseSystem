/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Admin
 */
public class Reports {
    private int reportId;
    private String reportType;
    private int generated_by;
    private String data;
    private String created_at;
    private String title;

    @Override
    public String toString() {
        return "Reports{" + "reportId=" + reportId + ", reportType=" + reportType + ", generated_by=" + generated_by + ", data=" + data + ", created_at=" + created_at + ", title=" + title + '}';
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

    public int getGenerated_by() {
        return generated_by;
    }

    public void setGenerated_by(int generated_by) {
        this.generated_by = generated_by;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Reports(int reportId, String reportType, int generated_by, String data, String created_at, String title) {
        this.reportId = reportId;
        this.reportType = reportType;
        this.generated_by = generated_by;
        this.data = data;
        this.created_at = created_at;
        this.title = title;
    }

    public Reports() {
    }

}
