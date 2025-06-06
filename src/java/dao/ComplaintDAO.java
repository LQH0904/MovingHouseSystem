package dao;

import model.Complaint;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComplaintDAO {
    private String jdbcURL = "jdbc:sqlserver://localhost:1433;databaseName=systemhouse1";
    private String jdbcUsername = "sa";
    private String jdbcPassword = "123456";

    private Connection getConnection() throws Exception {
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        return DriverManager.getConnection(jdbcURL, jdbcUsername, jdbcPassword);
    }

    public List<Complaint> getAllComplaints() {
        List<Complaint> complaints = new ArrayList<>();
        String sql = "SELECT i.issue_id, u.username, i.description, i.status, i.priority, i.created_at " +
                     "FROM Issues i JOIN Users u ON i.user_id = u.user_id";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Complaint c = new Complaint(
                        rs.getInt("issue_id"),
                        rs.getString("username"),
                        rs.getString("description"),
                        rs.getString("status"),
                        rs.getString("priority"),
                        rs.getTimestamp("created_at")
                );
                complaints.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return complaints;
    }
}
