package model;

import java.util.Date;

public class StaffLeaveBalance {
    private int balanceId;
    private int staffId;
    private int year;
    private int totalDays;
    private int remainingDays;
    private Date updatedAt;

    public StaffLeaveBalance() {}

    public StaffLeaveBalance(int staffId, int year) {
        this.staffId = staffId;
        this.year = year;
        this.totalDays = 28;
        this.remainingDays = 28;
    }
    

    public int getBalanceId() {
        return balanceId;
    }

    public void setBalanceId(int balanceId) {
        this.balanceId = balanceId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public int getYear() {
        return year;
    }

    public void setYear(int year) {
        this.year = year;
    }

    public int getTotalDays() {
        return totalDays;
    }

    public void setTotalDays(int totalDays) {
        this.totalDays = totalDays;
    }

    public int getRemainingDays() {
        return remainingDays;
    }

    public void setRemainingDays(int remainingDays) {
        this.remainingDays = remainingDays;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
