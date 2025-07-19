package model;

public class UnitIssueSummary {
    private int unitId;
    private String unitType;
    private int issueCount;

    public UnitIssueSummary() {}

    public UnitIssueSummary(int unitId, String unitType, int issueCount) {
        this.unitId = unitId;
        this.unitType = unitType;
        this.issueCount = issueCount;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public String getUnitType() {
        return unitType;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public int getIssueCount() {
        return issueCount;
    }

    public void setIssueCount(int issueCount) {
        this.issueCount = issueCount;
    }
}
