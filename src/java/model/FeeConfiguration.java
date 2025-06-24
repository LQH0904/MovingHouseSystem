package model;

public class FeeConfiguration {
    private int id;
    private String feeType;
    private String description;

    public FeeConfiguration() {}

    public FeeConfiguration(int id, String feeType, String description) {
        this.id = id;
        this.feeType = feeType;
        this.description = description;
    }

//    public FeeConfiguration(int aInt, String string) {
//        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
//    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFeeType() {
        return feeType;
    }

    public void setFeeType(String feeType) {
        this.feeType = feeType;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
