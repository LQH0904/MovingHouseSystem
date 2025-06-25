package model;

public class OperationPolicy {
    private int id;
    private int policyNumber;
    private String policyTitle;
    private String policyContent;

    public OperationPolicy() {}

    public OperationPolicy(int id, int policyNumber, String policyTitle, String policyContent) {
        this.id = id;
        this.policyNumber = policyNumber;
        this.policyTitle = policyTitle;
        this.policyContent = policyContent;
    }

    public int getId() {
        return id;
    }

    public int getPolicyNumber() {
        return policyNumber;
    }

    public String getPolicyTitle() {
        return policyTitle;
    }

    public String getPolicyContent() {
        return policyContent;
    }

    public void setId(int id) {
        this.id = id;
    }

    public void setPolicyNumber(int policyNumber) {
        this.policyNumber = policyNumber;
    }

    public void setPolicyTitle(String policyTitle) {
        this.policyTitle = policyTitle;
    }

    public void setPolicyContent(String policyContent) {
        this.policyContent = policyContent;
    }
}
