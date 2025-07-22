package model;

public class AlertComplaint {
    private int unitId;
    private String unitName;
    private String email;
    private int issueCount;
    private String unitType;
    private String warningLevel; // Có thể null nếu không được gán

    // Constructor đầy đủ (có warningLevel)
    public AlertComplaint(int unitId, String unitName, String email, int issueCount, String unitType, String warningLevel) {
        this.unitId = unitId;
        this.unitName = unitName;
        this.email = email;
        this.issueCount = issueCount;
        this.unitType = unitType;
        this.warningLevel = warningLevel;
    }

    // Constructor mới, khớp với cách DAO của bạn tạo đối tượng ban đầu
    public AlertComplaint(int unitId, String unitName, String email, int issueCount, String unitType) {
        this.unitId = unitId;
        this.unitName = unitName;
        this.email = email;
        this.issueCount = issueCount;
        this.unitType = unitType;
        this.warningLevel = null; // Mặc định là null, sẽ được gán sau ở Controller
    }

    // Các phương thức Getters
    public int getUnitId() {
        return unitId;
    }

    public String getUnitName() {
        return unitName;
    }

    public String getEmail() {
        return email;
    }

    public int getIssueCount() {
        return issueCount;
    }

    public String getUnitType() {
        return unitType;
    }

    public String getWarningLevel() {
        return warningLevel;
    }

    // Các phương thức Setters
    public void setUnitId(int unitId) {
        this.unitId = unitId;
    }

    public void setUnitName(String unitName) {
        this.unitName = unitName;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setIssueCount(int issueCount) {
        this.issueCount = issueCount;
    }

    public void setUnitType(String unitType) {
        this.unitType = unitType;
    }

    public void setWarningLevel(String warningLevel) {
        this.warningLevel = warningLevel;
    }
}
