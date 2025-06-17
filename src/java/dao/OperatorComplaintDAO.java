package dao;

import model.Complaint;
import utils.DBConnection; // Import DBConnection của bạn

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger; // Thêm import cho Logger

public class OperatorComplaintDAO {

    public OperatorComplaintDAO() {
        // Constructor rỗng
    }

    // Phương thức để lấy một khiếu nại theo ID (có thể vẫn cần cho Operator để xem chi tiết)
    public Complaint getComplaintById(int issueId) {
        Complaint complaint = null;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        String sql = "SELECT issue_id, username, description, status, priority, created_at, resolved_at FROM Complaints WHERE issue_id = ?";

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setInt(1, issueId);
            rs = ps.executeQuery();

            if (rs.next()) {
                complaint = new Complaint();
                complaint.setIssueId(rs.getInt("issue_id"));
                complaint.setUsername(rs.getString("username"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
            }
        } catch (SQLException e) {
            System.err.println("Error in OperatorComplaintDAO.getComplaintById: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên thủ công vì DBConnection không có closeResources
            try {
                if (rs != null) rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (con != null) con.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return complaint;
    }

    // Phương thức để cập nhật trạng thái và ưu tiên của khiếu nại (Operator có thể làm)
    public boolean updateComplaintStatusAndPriority(int issueId, String status, String priority) {
        Connection con = null;
        PreparedStatement ps = null;
        String sql;
        boolean isResolved = "resolved".equalsIgnoreCase(status);

        if (isResolved) {
            sql = "UPDATE Complaints SET status = ?, priority = ?, resolved_at = GETDATE() WHERE issue_id = ?";
        } else {
            sql = "UPDATE Complaints SET status = ?, priority = ?, resolved_at = NULL WHERE issue_id = ?";
        }

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql);
            ps.setString(1, status);
            ps.setString(2, priority);
            ps.setInt(3, issueId);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error in OperatorComplaintDAO.updateComplaintStatusAndPriority: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên thủ công
            try {
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (con != null) con.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return false;
    }

    // Đếm tổng số khiếu nại CÓ TRẠNG THÁI LÀ 'escalated'
    public int getTotalEscalatedComplaintCount(String searchTerm, String priorityFilter) {
        int count = 0;
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM Complaints WHERE status = 'escalated'");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR description LIKE ?)");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            sql.append(" AND priority = ?");
            params.add(priorityFilter);
        }

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error in OperatorComplaintDAO.getTotalEscalatedComplaintCount: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên thủ công
            try {
                if (rs != null) rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (con != null) con.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return count;
    }

    // Lấy tất cả khiếu nại CÓ TRẠNG THÁI LÀ 'escalated'
    public List<Complaint> getAllEscalatedComplaints(String searchTerm, String priorityFilter, int offset, int recordsPerPage) {
        List<Complaint> complaints = new ArrayList<>();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        StringBuilder sql = new StringBuilder("SELECT issue_id, username, description, status, priority, created_at, resolved_at FROM Complaints WHERE status = 'escalated'");
        List<Object> params = new ArrayList<>();

        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            sql.append(" AND (username LIKE ? OR description LIKE ?)");
            params.add("%" + searchTerm + "%");
            params.add("%" + searchTerm + "%");
        }
        if (priorityFilter != null && !priorityFilter.trim().isEmpty()) {
            sql.append(" AND priority = ?");
            params.add(priorityFilter);
        }

        sql.append(" ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(recordsPerPage);

        try {
            con = DBConnection.getConnection();
            ps = con.prepareStatement(sql.toString());

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            rs = ps.executeQuery();

            while (rs.next()) {
                Complaint complaint = new Complaint();
                complaint.setIssueId(rs.getInt("issue_id"));
                complaint.setUsername(rs.getString("username"));
                complaint.setDescription(rs.getString("description"));
                complaint.setStatus(rs.getString("status"));
                complaint.setPriority(rs.getString("priority"));
                complaint.setCreatedAt(rs.getTimestamp("created_at"));
                complaint.setResolvedAt(rs.getTimestamp("resolved_at"));
                complaints.add(complaint);
            }
        } catch (SQLException e) {
            System.err.println("Error in OperatorComplaintDAO.getAllEscalatedComplaints: " + e.getMessage());
            e.printStackTrace();
        } finally {
            // Đóng tài nguyên thủ công
            try {
                if (rs != null) rs.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (ps != null) ps.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
            try {
                if (con != null) con.close();
            } catch (SQLException ex) {
                Logger.getLogger(OperatorComplaintDAO.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        return complaints;
    }
}