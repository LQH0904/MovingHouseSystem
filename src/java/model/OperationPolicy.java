package model;

public class OperationPolicy {
    private int id;
    private String policyTitle;
    private String policyContent;

    public OperationPolicy() {}

    public OperationPolicy(int id, String policyTitle, String policyContent) {
        this.id = id;
        this.policyTitle = policyTitle;
        this.policyContent = policyContent;
    }

    public OperationPolicy(int aInt, String string) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getPolicyTitle() {
        return policyTitle;
    }

    public void setPolicyTitle(String policyTitle) {
        this.policyTitle = policyTitle;
    }

    public String getPolicyContent() {
        return policyContent;
    }

    public void setPolicyContent(String policyContent) {
        this.policyContent = policyContent;
    }
}
