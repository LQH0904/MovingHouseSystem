package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.OperationProcedure;
import utils.DBContext;

public class OperationProcedureDAO {

    public OperationProcedure getProcedure() {
        String sql = "SELECT * FROM OperationProcedures";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new OperationProcedure(rs.getInt("id"), rs.getString("content"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateProcedure(String content) {
        String sql = "UPDATE OperationProcedures SET content = ? WHERE id = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, content);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

   public List<OperationProcedure> getAllProcedures() {
    List<OperationProcedure> list = new ArrayList<>();
    try (Connection conn = new DBContext().getConnection()) {
        String sql = "SELECT * FROM OperationProcedure"; // Viết đúng tên bảng
        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            OperationProcedure p = new OperationProcedure();
            p.setId(rs.getInt("id"));
            p.setStepNumber(rs.getInt("step_number"));
            p.setStepTitle(rs.getString("step_title"));
            p.setStepDescription(rs.getString("step_description"));
            list.add(p);
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}



}
