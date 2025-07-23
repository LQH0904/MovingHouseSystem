package model;

public class Staff {

    private int staffId;
    private String fullName;
    private String department;
    private String status;
    private String email;
    private String phone;
    private String address; // Thêm địa chỉ

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Staff() {
    }

    public Staff(int staffId, String fullName, String department, String status, String email, String phone, String address) {
        this.staffId = staffId;
        this.fullName = fullName;
        this.department = department;
        this.status = status;
        this.email = email;
        this.phone = phone;
        this.address = address;
    }

}