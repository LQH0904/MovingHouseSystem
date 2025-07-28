package dao;

import model.UserBlock;
import utils.DBContext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserBlockDAO extends DBContext {

    public List<UserBlock> getAllBlockedUsers() {
        List<UserBlock> list = new ArrayList<>();
        String sql = "SELECT * FROM user_blocks ORDER BY blocked_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new UserBlock(
                        rs.getInt("id"),
                        rs.getInt("user_id"),
                        rs.getString("reason"),
                        rs.getString("blocked_at")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void insertBlock(UserBlock block) {
        String sql = "INSERT INTO user_blocks (user_id, reason) VALUES (?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, block.getUserId());
            ps.setString(2, block.getReason());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
