package dao.staff;

import model.OrderDetail;
import java.sql.*;
import utils.DBConnection;

public class OrderDetailDAO {

    public static OrderDetail getOrderDetailById(int orderId) {
        OrderDetail order = null;
        String sql = "SELECT o.order_id, o.customer_id, c.full_name, c.phone_number, " +
                "o.transport_unit_id, t.company_name, " +
                "o.storage_unit_id, s.warehouse_name, " +
                "o.order_status, o.created_at, o.updated_at, o.delivery_schedule, " +
                "o.accepted_at, o.delivered_at, o.total_fee " +
                "FROM Orders o " +
                "JOIN Customers c ON o.customer_id = c.customer_id " +
                "LEFT JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id " +
                "LEFT JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id " +
                "WHERE o.order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    order = new OrderDetail();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setCustomerId(rs.getInt("customer_id"));
                    order.setCustomerName(rs.getString("full_name"));
                    order.setCustomerPhone(rs.getString("phone_number"));
                    order.setTransportUnitId(rs.getInt("transport_unit_id"));
                    order.setTransportCompanyName(rs.getString("company_name"));
                    order.setStorageUnitId(rs.getInt("storage_unit_id"));
                    order.setWarehouseName(rs.getString("warehouse_name"));
                    order.setOrderStatus(rs.getString("order_status"));
                    order.setCreatedAt(formatDateOnly(rs.getTimestamp("created_at")));
                    order.setUpdatedAt(formatDateOnly(rs.getTimestamp("updated_at")));
                    order.setDeliverySchedule(formatDateOnly(rs.getTimestamp("delivery_schedule")));
                    order.setAcceptedAt(formatDateOnly(rs.getTimestamp("accepted_at")));
                    order.setDeliveredAt(formatDateOnly(rs.getTimestamp("delivered_at")));
                    order.setTotalFee(rs.getDouble("total_fee"));
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    // Xử lý ngày tháng thành chuỗi yyyy-MM-dd
    private static String formatDateOnly(Timestamp timestamp) {
        if (timestamp == null) return "N/A";
        return timestamp.toLocalDateTime().toLocalDate().toString(); // yyyy-MM-dd
    }

    // Hàm main để test
    public static void main(String[] args) {
        int testOrderId = 5; // đổi ID này nếu cần
        OrderDetail order = getOrderDetailById(testOrderId);

        if (order != null) {
            System.out.println("Order ID: " + order.getOrderId());
            System.out.println("Customer Name: " + order.getCustomerName());
            System.out.println("Customer Phone: " + order.getCustomerPhone());
            System.out.println("Transport Company: " + order.getTransportCompanyName());
            System.out.println("Warehouse Name: " + order.getWarehouseName());
            System.out.println("Order Status: " + order.getOrderStatus());
            System.out.println("Created At: " + order.getCreatedAt());
            System.out.println("Updated At: " + order.getUpdatedAt());
            System.out.println("Delivery Schedule: " + order.getDeliverySchedule());
            System.out.println("Accepted At: " + order.getAcceptedAt());
            System.out.println("Delivered At: " + order.getDeliveredAt());
            System.out.println("Total Fee: " + order.getTotalFee());
        } else {
            System.out.println("Không tìm thấy đơn hàng với ID = " + testOrderId);
        }
    }
}
