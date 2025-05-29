/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package entity;

/**
 *
 * @author Admin
 */
public class Report {
    private int report_id;
    private int storage_unit_id;
    private String inventory_details;
    private String created_at;
    private String updated_at;
    private String title;

    @Override
    public String toString() {
        return "Report{" + "report_id=" + report_id + ", storage_unit_id=" + storage_unit_id + ", inventory_details=" + inventory_details + ", created_at=" + created_at + ", updated_at=" + updated_at + ", title=" + title + '}';
    }

    public int getReport_id() {
        return report_id;
    }

    public void setReport_id(int report_id) {
        this.report_id = report_id;
    }

    public int getStorage_unit_id() {
        return storage_unit_id;
    }

    public void setStorage_unit_id(int storage_unit_id) {
        this.storage_unit_id = storage_unit_id;
    }

    public String getInventory_details() {
        return inventory_details;
    }

    public void setInventory_details(String inventory_details) {
        this.inventory_details = inventory_details;
    }

    public String getCreated_at() {
        return created_at;
    }

    public void setCreated_at(String created_at) {
        this.created_at = created_at;
    }

    public String getUpdated_at() {
        return updated_at;
    }

    public void setUpdated_at(String updated_at) {
        this.updated_at = updated_at;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Report(int report_id, int storage_unit_id, String inventory_details, String created_at, String updated_at, String title) {
        this.report_id = report_id;
        this.storage_unit_id = storage_unit_id;
        this.inventory_details = inventory_details;
        this.created_at = created_at;
        this.updated_at = updated_at;
        this.title = title;
    }

    public Report() {
    }
}
