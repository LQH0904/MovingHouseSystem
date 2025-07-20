package model;

public class AlertComplaint {
    private int unitId;
    private String unitName;
    private String email;
    private int issueCount;
    private String unitType; // Changed to String as per DAO's rs.getString("unit_type")

    // Constructor phải khớp với cách bạn tạo đối tượng trong DAO
    public AlertComplaint(int unitId, String unitName, String email, int issueCount, String unitType) {
        this.unitId = unitId;
        this.unitName = unitName;
        this.email = email;
        this.issueCount = issueCount;
        this.unitType = unitType;
    }

    // Các phương thức Getters (quan trọng nhất cho JSP EL)
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

    // Các phương thức Setters (tùy chọn, nhưng tốt cho việc sửa đổi đối tượng)
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
}
