package dao;

import java.sql.*;
import java.util.*;
import model.PromotionSuggestion;
import model.User;
import utils.DBConnection;

public class PromotionSuggestionDAO {

    public void insertSuggestion(PromotionSuggestion ps) {
        String sql = "INSERT INTO PromotionSuggestion (user_id, title, content, reason, start_date, end_date, status, created_at, updated_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'pending', GETDATE(), GETDATE())";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement psmt = conn.prepareStatement(sql)) {

            psmt.setInt(1, ps.getUserId());
            psmt.setString(2, ps.getTitle());
            psmt.setString(3, ps.getContent());
            psmt.setString(4, ps.getReason());
            psmt.setDate(5, ps.getStartDate());
            psmt.setDate(6, ps.getEndDate());

            psmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public List<PromotionSuggestion> getSuggestionsByUser(int userId) {
        List<PromotionSuggestion> list = new ArrayList<>();
        String sql = "SELECT * FROM PromotionSuggestion WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement psmt = conn.prepareStatement(sql)) {

            psmt.setInt(1, userId);
            ResultSet rs = psmt.executeQuery();
            while (rs.next()) {
                PromotionSuggestion p = new PromotionSuggestion();
                p.setId(rs.getInt("id"));
                p.setUserId(rs.getInt("user_id"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setReason(rs.getString("reason"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setStatus(rs.getString("status"));
                p.setReply(rs.getString("reply"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                p.setUpdatedAt(rs.getTimestamp("updated_at"));
                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    } 

    public List<PromotionSuggestion> getAllSuggestions() {
        List<PromotionSuggestion> list = new ArrayList<>();
        String sql = "SELECT ps.*, u.username FROM PromotionSuggestion ps JOIN Users u ON ps.user_id = u.user_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psmt = conn.prepareStatement(sql);
             ResultSet rs = psmt.executeQuery()) {

            while (rs.next()) {
                PromotionSuggestion p = new PromotionSuggestion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setReason(rs.getString("reason"));
                p.setStatus(rs.getString("status"));
                p.setReply(rs.getString("reply"));
                
                User u = new User();
                u.setUsername(rs.getString("username"));
                p.setUserId(rs.getInt("user_id"));

                list.add(p);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
    public PromotionSuggestion getSuggestionById(int id) {
        String sql = "SELECT ps.*, u.username FROM PromotionSuggestion ps JOIN Users u ON ps.user_id = u.user_id WHERE ps.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psmt = conn.prepareStatement(sql)) {
            psmt.setInt(1, id);
            ResultSet rs = psmt.executeQuery();

            if (rs.next()) {
                PromotionSuggestion p = new PromotionSuggestion();
                p.setId(rs.getInt("id"));
                p.setTitle(rs.getString("title"));
                p.setContent(rs.getString("content"));
                p.setStartDate(rs.getDate("start_date"));
                p.setEndDate(rs.getDate("end_date"));
                p.setReason(rs.getString("reason"));
                p.setStatus(rs.getString("status"));
                p.setReply(rs.getString("reply"));

                User u = new User();
                u.setUsername(rs.getString("username"));
                p.setUserId(rs.getInt("user_id"));
                return p;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateReply(int id, String reply) {
        String sql = "UPDATE PromotionSuggestion SET reply = ?, status = 'Đã phản hồi' WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement psmt = conn.prepareStatement(sql)) {
            psmt.setString(1, reply);
            psmt.setInt(2, id);
            psmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public void updateStatusAndReply(int id, String status, String reply) {
    String sql = "UPDATE PromotionSuggestion SET status = ?, reply = ? WHERE id = ?";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {

        stmt.setString(1, status);
        stmt.setString(2, reply);
        stmt.setInt(3, id);
        stmt.executeUpdate();

    } catch (SQLException e) {
        e.printStackTrace();
    }
}
    
    public void updateReview(int id, String status, String reply) {
    String sql = "UPDATE PromotionSuggestion SET status = ?, reply = ? WHERE id = ?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, status);
        stmt.setString(2, reply);
        stmt.setInt(3, id);
        stmt.executeUpdate();
    } catch (SQLException e) {
        e.printStackTrace();
    }
}





}
