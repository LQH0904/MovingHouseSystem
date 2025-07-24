package model;

import java.util.Date;

public class LeaveRequest {

    private int requestId;
    private int staffId;
    private String staffName;
    private Date startDate;
    private Date endDate;
    private String reason;
    private String status;
    private String operatorReply;
    private Integer operatorId;
    private Date createdAt;
    private Date updatedAt;

    // Constructors
    public LeaveRequest() {
    }

    public LeaveRequest(int staffId, Date startDate, Date endDate, String reason) {
        this.staffId = staffId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.reason = reason;
        this.status = "pending";
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public String getReason() {
        return reason;
    }

    public void setReason(String reason) {
        this.reason = reason;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getOperatorReply() {
        return operatorReply;
    }

    public void setOperatorReply(String operatorReply) {
        this.operatorReply = operatorReply;
    }

    public Integer getOperatorId() {
        return operatorId;
    }

    public void setOperatorId(Integer operatorId) {
        this.operatorId = operatorId;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

}
