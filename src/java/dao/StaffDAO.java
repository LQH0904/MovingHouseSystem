package dao;

import java.sql.*;
import model.Staff;
import utils.DBConnection;

public class StaffDAO {

    public Staff getStaffById(int staffId) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "SELECT * FROM Staff WHERE staff_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, staffId);
        ResultSet rs = ps.executeQuery();
        Staff staff = null;
        if (rs.next()) {
            staff = new Staff(
                    rs.getInt("staff_id"),
                    rs.getString("full_name"),
                    rs.getString("department"),
                    rs.getString("avatar_url"),
                    rs.getString("status"),
                    rs.getString("email"),
                    rs.getString("phone")
            );
        }
        rs.close();
        ps.close();
        conn.close();
        return staff;
    }

    public void updateStaff(Staff staff) throws Exception {
        Connection conn = DBConnection.getConnection();
        String sql = "UPDATE Staff SET full_name = ?, department = ?, avatar_url = ?, status = ?, email = ?, phone = ?, updated_at = GETDATE() WHERE staff_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setString(1, staff.getFullName());
        ps.setString(2, staff.getDepartment());
        ps.setString(3, staff.getAvatarUrl());
        ps.setString(4, staff.getStatus());
        ps.setString(5, staff.getEmail());
        ps.setString(6, staff.getPhone());
        ps.setInt(7, staff.getStaffId());
        ps.executeUpdate();
        ps.close();
        conn.close();
    }
}
