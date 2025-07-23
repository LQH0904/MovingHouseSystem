package model;

import java.util.Date;

public class BankConfig {
    private int configId;
    private String bankName;
    private String accountNumber;
    private String accountName;
    private Date updatedAt;

    // Constructor không tham số
    public BankConfig() {}

    // Constructor đầy đủ
    public BankConfig(int configId, String bankName, String accountNumber, String accountName, Date updatedAt) {
        this.configId = configId;
        this.bankName = bankName;
        this.accountNumber = accountNumber;
        this.accountName = accountName;
        this.updatedAt = updatedAt;
    }

    // Getter & Setter
    public int getConfigId() {
        return configId;
    }

    public void setConfigId(int configId) {
        this.configId = configId;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getAccountNumber() {
        return accountNumber;
    }

    public void setAccountNumber(String accountNumber) {
        this.accountNumber = accountNumber;
    }

    public String getAccountName() {
        return accountName;
    }

    public void setAccountName(String accountName) {
        this.accountName = accountName;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }
}
