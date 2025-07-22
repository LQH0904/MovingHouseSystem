package model;

public class UnitIssueSummary {
    private int unitId;
    private String unitName;
    private String unitType;
    private int issueCount;
    private int warningCount;

    public UnitIssueSummary() {}

    public UnitIssueSummary(int unitId, String unitName, String unitType, int issueCount, int warningCount) {
        this.unitId = unitId;
        this.unitName = unitName;
        this.unitType = unitType;
        this.issueCount = issueCount;
        this.warningCount = warningCount;
    }

    public int getUnitId() {
        return unitId;
    }

    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public String getUnitName() {
        return unitName;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
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

    public int getWarningCount() {
        return warningCount;
    }

    public void setWarningCount(int warningCount) {
        this.warningCount = warningCount;
    }
}
