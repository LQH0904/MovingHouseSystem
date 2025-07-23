package model;

import java.util.Date;

public class DataChangeLog {
    private int changeId;
    private String tableName;
    private String recordId;
    private String columnName;
    private String oldValue;  
    private String newValue; 
    private int changedByUserId;
    private String changedByUsername; 
    private Date changeTimestamp;
    private String changeType; 

    public DataChangeLog() {
    }

    public DataChangeLog(int changeId, String tableName, String recordId, String columnName,
                         String oldValue, String newValue, int changedByUserId, String changedByUsername,
                         Date changeTimestamp, String changeType) {
        this.changeId = changeId;
        this.tableName = tableName;
        this.recordId = recordId;
        this.columnName = columnName;
        this.oldValue = oldValue;
        this.newValue = newValue;
        this.changedByUserId = changedByUserId;
        this.changedByUsername = changedByUsername;
        this.changeTimestamp = changeTimestamp;
        this.changeType = changeType;
    }

    // Getters and Setters
    public int getChangeId() {
        return changeId;
    }

    public void setChangeId(int changeId) {
        this.changeId = changeId;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public String getRecordId() {
        return recordId;
    }

    public void setRecordId(String recordId) {
        this.recordId = recordId;
    }

    public String getColumnName() {
        return columnName;
    }

    public void setColumnName(String columnName) {
        this.columnName = columnName;
    }

    public String getOldValue() {
        return oldValue;
    }

    public void voidsetOldValue(String oldValue) {
        this.oldValue = oldValue;
    }

    public String getNewValue() {
        return newValue;
    }

    public void setNewValue(String newValue) {
        this.newValue = newValue;
    }

    public int getChangedByUserId() {
        return changedByUserId;
    }

    public void setChangedByUserId(int changedByUserId) {
        this.changedByUserId = changedByUserId;
    }

    public String getChangedByUsername() {
        return changedByUsername;
    }

    public void setChangedByUsername(String changedByUsername) {
        this.changedByUsername = changedByUsername;
    }

    public Date getChangeTimestamp() {
        return changeTimestamp;
    }

    public void setChangeTimestamp(Date changeTimestamp) {
        this.changeTimestamp = changeTimestamp;
    }

    public String getChangeType() {
        return changeType;
    }

    public void setChangeType(String changeType) {
        this.changeType = changeType;
    }

    @Override
    public String toString() {
        return "DataChangeLog{" +
               "changeId=" + changeId +
               ", tableName='" + tableName + '\'' +
               ", recordId='" + recordId + '\'' +
               ", columnName='" + columnName + '\'' +
               ", oldValue='" + oldValue + '\'' +
               ", newValue='" + newValue + '\'' +
               ", changedByUserId=" + changedByUserId +
               ", changedByUsername='" + changedByUsername + '\'' +
               ", changeTimestamp=" + changeTimestamp +
               ", changeType='" + changeType + '\'' +
               '}';
    }

    public void setOldValue(String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}