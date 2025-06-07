package dao;

import model.Complaint;
import utils.DBConnection; 
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {

    private Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id";
        
        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            System.out.println("Debug: Executing SQL query: " + sql);

            while (rs.next()) {
                Complaint complaint = new Complaint();
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
            e.printStackTrace();
        }
        return complaints;
    }

    public Complaint getComplaintById(int issueId) {
        Complaint complaint = null;
        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at " +
                     "FROM Issues i " +
                     "JOIN Users u ON i.user_id = u.user_id " +
                     "WHERE i.issue_id = ?"; 

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, issueId); 
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    complaint = new Complaint();
                    complaint.setIssueId(rs.getInt("issue_id"));
                    complaint.setUsername(rs.getString("username"));
                    complaint.setDescription(rs.getString("description"));
                    complaint.setStatus(rs.getString("status"));
                    complaint.setPriority(rs.getString("priority"));
                    complaint.setCreatedAt(rs.getTimestamp("created_at"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Database error in getComplaintById: " + e.getMessage());
            e.printStackTrace();
        }
        return complaint;
    }
    
    public boolean updateComplaintStatus(int issueId, String status) {
        String sql = "UPDATE Issues SET status = ?, resolved_at = GETDATE() WHERE issue_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, issueId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Database error in updateComplaintStatus: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}