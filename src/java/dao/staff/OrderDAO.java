package dao.staff;

import model.Order;
import utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();

        String sql = """
            SELECT 
                o.order_id,
                o.customer_id,
                c.full_name AS customer_name,
                c.phone_number,
                o.transport_unit_id,
                t.company_name AS transport_company_name,
                o.storage_unit_id,
                s.warehouse_name,
                o.order_status,
                o.created_at,
                o.updated_at,
                o.delivery_schedule,
                o.total_fee
            FROM Orders o
            JOIN Customers c ON o.customer_id = c.customer_id
            JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id
            JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Order order = new Order();

                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setCustomerName(rs.getString("customer_name"));
                order.setCustomerPhone(rs.getString("phone_number"));
                order.setTransportUnitId(rs.getInt("transport_unit_id"));
                order.setTransportCompanyName(rs.getString("transport_company_name"));
                order.setStorageUnitId(rs.getInt("storage_unit_id"));
                order.setWarehouseName(rs.getString("warehouse_name"));
                order.setOrderStatus(rs.getString("order_status"));

                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    order.setUpdatedAt(updatedAt.toLocalDateTime());
                }

                order.setDeliverySchedule(rs.getString("delivery_schedule"));
                order.setTotalFee(rs.getDouble("total_fee"));

                orders.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orders;
    }

    public Order getOrderById(int orderId) {
        Order order = null;
        String sql = """
            SELECT 
                o.order_id,
                o.order_status,
                o.delivery_schedule,
                o.total_fee,
                o.created_at,
                o.updated_at,
                o.customer_id,
                c.full_name AS customer_name,
                c.phone_number,
                o.transport_unit_id,
                t.company_name AS transport_company_name,
                o.storage_unit_id,
                s.warehouse_name
            FROM Orders o
            JOIN Customers c ON o.customer_id = c.customer_id
            JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id
            JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id
            WHERE o.order_id = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                order = new Order();
                order.setOrderId(rs.getInt("order_id"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setDeliverySchedule(rs.getString("delivery_schedule"));
                order.setTotalFee(rs.getDouble("total_fee"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setCustomerName(rs.getString("customer_name"));
                order.setCustomerPhone(rs.getString("phone_number"));
                order.setTransportUnitId(rs.getInt("transport_unit_id"));
                order.setTransportCompanyName(rs.getString("transport_company_name"));
                order.setStorageUnitId(rs.getInt("storage_unit_id"));
                order.setWarehouseName(rs.getString("warehouse_name"));

                Timestamp createdAt = rs.getTimestamp("created_at");
                if (createdAt != null) {
                    order.setCreatedAt(createdAt.toLocalDateTime());
                }

                Timestamp updatedAt = rs.getTimestamp("updated_at");
                if (updatedAt != null) {
                    order.setUpdatedAt(updatedAt.toLocalDateTime());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return order;
    }

    public static void main(String[] args) {
        OrderDAO dao = new OrderDAO();
        List<Order> orders = dao.getAllOrders();

        for (Order o : orders) {
            System.out.println("Mã đơn: " + o.getOrderId());
            System.out.println("Khách hàng: " + o.getCustomerName() );
            System.out.println("Đơn vị vận chuyển: " + o.getTransportCompanyName());
            System.out.println("Kho: " + o.getWarehouseName());
            System.out.println("Trạng thái: " + o.getOrderStatus());
            System.out.println("Tổng phí: " + o.getTotalFee());
            System.out.println("-------------");
        }
    }
}
