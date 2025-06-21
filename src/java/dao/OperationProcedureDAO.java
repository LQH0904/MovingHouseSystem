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
        String sql = "SELECT * FROM OperationProcedures WHERE id = 1";
        try (Connection conn = new DBContext().getConnection(); // ✅ đúng 100%; 
                PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new OperationProcedure(
                        rs.getInt("id"),
                        rs.getInt("step_number"),
                        rs.getString("step_title"),
                        rs.getString("step_description")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateProcedure(OperationProcedure p) {
        String sql = "UPDATE OperationProcedures SET step_number = ?, step_title = ?, step_description = ? WHERE id = ?";
        try (Connection conn = new DBContext().getConnection(); // ✅ đúng 100%

                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getStepNumber());
            ps.setString(2, p.getStepTitle());
            ps.setString(3, p.getStepDescription());
            ps.setInt(4, p.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<OperationProcedure> getAllProcedures() {
        List<OperationProcedure> list = new ArrayList<>();
        try {
            DBContext db = new DBContext();
            Connection conn = db.getConnection(); // Đảm bảo không gọi static getConnection()

            String sql = "SELECT * FROM OperationProcedures";
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
