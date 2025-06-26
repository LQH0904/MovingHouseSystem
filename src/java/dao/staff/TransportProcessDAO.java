package dao.staff;

import model.TransportProcess;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;

public class TransportProcessDAO {

    public TransportProcess getByOrderId(int orderId) {
        TransportProcess tp = null;

        String sql = """
            SELECT * FROM TransportProcess WHERE order_id = ?
        """;

        try (Connection conn = DBConnection.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                tp = new TransportProcess();

                tp.setOrderId(rs.getInt("order_id"));
                tp.setPickupLocation(rs.getString("pickup_location"));
                tp.setWarehouseLocation(rs.getString("warehouse_location"));
                tp.setShippingLocation(rs.getString("shipping_location"));

                Timestamp pickup = rs.getTimestamp("pickup_date");
                if (pickup != null) {
                    tp.setPickupDate(pickup.toLocalDateTime());
                }

                Timestamp warehouse = rs.getTimestamp("warehouse_date");
                if (warehouse != null) {
                    tp.setWarehouseDate(warehouse.toLocalDateTime());
                }

                Timestamp shipping = rs.getTimestamp("shipping_date");
                if (shipping != null) {
                    tp.setShippingDate(shipping.toLocalDateTime());
                }

                tp.setPickupWarehouseDist(rs.getString("pickup_warehouse_dist"));
                tp.setWarehouseShippingDist(rs.getString("warehouse_shipping_dist"));

            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tp;
    }

    // Test main
    public static void main(String[] args) {
        TransportProcessDAO dao = new TransportProcessDAO();
        TransportProcess tp = dao.getByOrderId(5); // test với order_id = 1

        if (tp != null) {
            System.out.println("Thông tin vận chuyển cho đơn hàng #" + tp.getOrderId());
            System.out.println("Pickup: " + tp.getPickupLocation());
            System.out.println("Ngày lấy hàng: " + tp.getPickupDate());
            System.out.println("Kho: " + tp.getWarehouseLocation());
            System.out.println("Ngày về kho: " + tp.getWarehouseDate());
            System.out.println("Giao tới: " + tp.getShippingLocation());
            System.out.println("Ngày giao hàng: " + tp.getShippingDate());
            System.out.println("Khoảng cách từ pickup -> kho: " + tp.getPickupWarehouseDist());
            System.out.println("Khoảng cách từ kho -> giao hàng: " + tp.getWarehouseShippingDist());
        } else {
            System.out.println("Không tìm thấy dữ liệu cho đơn hàng này.");
        }
    }
}
