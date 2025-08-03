package dao.staff;

import model.TransportProcess;
import utils.DBConnection;

import java.sql.*;
import java.time.LocalDateTime;

public class TransportProcessDAO {

    public TransportProcess getTransportProcessByOrderId(int orderId) {
        TransportProcess process = null;
        String sql = """
            SELECT 
                order_id, pickup_location, warehouse_location, shipping_location,
                pickup_date, warehouse_date, shipping_date,
                pickup_warehouse_dist, warehouse_shipping_dist,
                pickup_lat, pickup_lng, shipping_lat, shipping_lng, map_url
            FROM TransportProcess
            WHERE order_id = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    process = new TransportProcess();
                    process.setOrderId(rs.getInt("order_id"));
                    process.setPickupLocation(rs.getString("pickup_location"));
                    process.setWarehouseLocation(rs.getString("warehouse_location"));
                    process.setShippingLocation(rs.getString("shipping_location"));
                    
                    Timestamp pickupTs = rs.getTimestamp("pickup_date");
                    if (pickupTs != null) process.setPickupDate(pickupTs.toLocalDateTime());

                    Timestamp warehouseTs = rs.getTimestamp("warehouse_date");
                    if (warehouseTs != null) process.setWarehouseDate(warehouseTs.toLocalDateTime());

                    Timestamp shippingTs = rs.getTimestamp("shipping_date");
                    if (shippingTs != null) process.setShippingDate(shippingTs.toLocalDateTime());

                    process.setPickupWarehouseDist(rs.getString("pickup_warehouse_dist"));
                    process.setWarehouseShippingDist(rs.getString("warehouse_shipping_dist"));
                    process.setPickupLat(rs.getBigDecimal("pickup_lat"));
                    process.setPickupLng(rs.getBigDecimal("pickup_lng"));
                    process.setShippingLat(rs.getBigDecimal("shipping_lat"));
                    process.setShippingLng(rs.getBigDecimal("shipping_lng"));
                    process.setMapUrl(rs.getString("map_url"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return process;
    }

    
}
