package model;

public class FeeConfiguration {

    private int id;
    private int feeNumber;         
    private String feeType;
    private String description;

    public FeeConfiguration() {}

    public FeeConfiguration(int id, int feeNumber, String feeType, String description) {
        this.id = id;
        this.feeNumber = feeNumber;
        this.feeType = feeType;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public int getFeeNumber() {
        return feeNumber;
    }

    public String getFeeType() {
        return feeType;
    }

    public String getDescription() {
        return description;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setFeeNumber(int feeNumber) {
        this.feeNumber = feeNumber;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
