package dao;

import model.Complaint;
import utils.DBConnection; // Import lớp DBConnection đã tạo
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    // Không cần khai báo lại JDBC_URL, DB_USER, DB_PASSWORD ở đây nữa
    // vì chúng đã được quản lý trong lớp DBConnection.java

    // Phương thức để lấy kết nối tới database từ lớp DBConnection
    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    // Phương thức duy nhất để lấy tất cả khiếu nại
    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        
        // Truy vấn SQL để lấy thông tin khiếu nại và username từ bảng Users
        // Các tên cột (issue_id, created_at) khớp với script SQL bạn đã cung cấp
        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at " +
                     "FROM Issues i " + // Đặt alias 'i' cho bảng Issues
                     "JOIN Users u ON i.user_id = u.user_id"; // Nối với bảng Users để lấy username

        try (Connection conn = getConnection(); // Lấy kết nối từ DBConnection
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("Debug: Executing SQL query: " + sql);

            while (rs.next()) {
                Complaint complaint = new Complaint();
                // Gán giá trị cho đối tượng Complaint, đảm bảo tên cột khớp với truy vấn SQL
                complaint.setIssueId(rs.getInt("issue_id"));
                complaint.setUsername(rs.getString("username"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaints.add(complaint);
                System.out.println("Debug: Added complaint: " + complaint.toString());
            }
            System.out.println("Debug: Total complaints retrieved by DAO: " + complaints.size());
        } catch (SQLException e) {
            System.err.println("Database error in getAllComplaints: " + e.getMessage());
            e.printStackTrace(); // Rất quan trọng để in stack trace
        }
        return complaints;
    }
}