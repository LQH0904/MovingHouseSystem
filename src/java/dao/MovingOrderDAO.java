
package dao;

import com.fasterxml.jackson.databind.ObjectMapper;
import model.MovingOrder;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.math.BigDecimal;
import java.sql.Timestamp;

public class MovingOrderDAO {

    private LogAdminDAO logAdminDAO = new LogAdminDAO();
    private ObjectMapper objectMapper = new ObjectMapper();

    public MovingOrder getMovingOrderById(int orderId) {
        String sql = "SELECT o.*, c.customer_name FROM MovingOrders o JOIN Customers c ON o.customer_id = c.customer_id WHERE o.order_id = ?";
        MovingOrder order = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    order = new MovingOrder();
                    order.setOrderId(rs.getInt("order_id"));
                    order.setCustomerId(rs.getInt("customer_id"));
                    order.setPickupAddress(rs.getString("pickup_address"));
                    order.setDeliveryAddress(rs.getString("delivery_address"));
                    order.setMovingDate(new Date(rs.getTimestamp("moving_date").getTime()));
                    order.setStatus(rs.getString("status"));
                    order.setEstimatedCost(rs.getBigDecimal("estimated_cost"));
                    order.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
                    order.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
                    order.setCustomerName(rs.getString("customer_name"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return order;
    }

    public List<MovingOrder> getAllMovingOrders() {
        List<MovingOrder> orders = new ArrayList<>();
        // Assuming there is a Customer table and customer_name column
        String sql = "SELECT o.*, c.customer_name FROM MovingOrders o JOIN Customers c ON o.customer_id = c.customer_id ORDER BY o.moving_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                MovingOrder order = new MovingOrder();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setPickupAddress(rs.getString("pickup_address"));
                order.setDeliveryAddress(rs.getString("delivery_address"));
                order.setMovingDate(new Date(rs.getTimestamp("moving_date").getTime()));
                order.setStatus(rs.getString("status"));
                order.setEstimatedCost(rs.getBigDecimal("estimated_cost"));
                order.setCreatedAt(new Date(rs.getTimestamp("created_at").getTime()));
                order.setUpdatedAt(new Date(rs.getTimestamp("updated_at").getTime()));
                order.setCustomerName(rs.getString("customer_name"));
                orders.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return orders;
    }

    public boolean addMovingOrder(MovingOrder order, int userId) {
        String sql = "INSERT INTO MovingOrders (customer_id, pickup_address, delivery_address, moving_date, status, estimated_cost, created_at, updated_at) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), GETDATE())";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, order.getCustomerId());
            ps.setString(2, order.getPickupAddress());
            ps.setString(3, order.getDeliveryAddress());
            ps.setTimestamp(4, new Timestamp(order.getMovingDate().getTime()));
            ps.setString(5, order.getStatus());
            ps.setBigDecimal(6, order.getEstimatedCost());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int newOrderId = generatedKeys.getInt(1);
                        order.setOrderId(newOrderId);

                        logAdminDAO.logSystemActivity(userId, "CREATE_MOVING_ORDER", "Created new moving order ID: " + newOrderId + " for customer ID: " + order.getCustomerId());

                        String newOrderJson = objectMapper.writeValueAsString(order);
                        logAdminDAO.logDataChange("MovingOrders", String.valueOf(newOrderId), null, null, newOrderJson, userId, "INSERT");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean updateMovingOrder(MovingOrder order, int userId) {
        MovingOrder oldOrder = getMovingOrderById(order.getOrderId());
        if (oldOrder == null) {
            return false;
        }

        String sql = "UPDATE MovingOrders SET customer_id = ?, pickup_address = ?, delivery_address = ?, moving_date = ?, status = ?, estimated_cost = ?, updated_at = GETDATE() WHERE order_id = ?";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, order.getCustomerId());
            ps.setString(2, order.getPickupAddress());
            ps.setString(3, order.getDeliveryAddress());
            ps.setTimestamp(4, new Timestamp(order.getMovingDate().getTime()));
            ps.setString(5, order.getStatus());
            ps.setBigDecimal(6, order.getEstimatedCost());
            ps.setInt(7, order.getOrderId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                logAdminDAO.logSystemActivity(userId, "UPDATE_MOVING_ORDER", "Updated moving order ID: " + order.getOrderId() + " (Status changed to: " + order.getStatus() + ")");

                try {
                    String oldOrderJson = objectMapper.writeValueAsString(oldOrder);
                    MovingOrder newOrder = getMovingOrderById(order.getOrderId());
                    String newOrderJson = objectMapper.writeValueAsString(newOrder);
                    logAdminDAO.logDataChange("MovingOrders", String.valueOf(order.getOrderId()), null, oldOrderJson, newOrderJson, userId, "UPDATE");
                } catch (Exception e) {
                    System.err.println("Error converting moving order to JSON for DataChangeLog: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }

    public boolean deleteMovingOrder(int orderId, int userId) {
        MovingOrder oldOrder = getMovingOrderById(orderId);
        if (oldOrder == null) {
            return false;
        }

        String sql = "DELETE FROM MovingOrders WHERE order_id = ?";
        boolean success = false;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                success = true;
                logAdminDAO.logSystemActivity(userId, "DELETE_MOVING_ORDER", "Deleted moving order with ID: " + orderId + " (Customer: " + oldOrder.getCustomerName() + ")");

                try {
                    String oldOrderJson = objectMapper.writeValueAsString(oldOrder);
                    logAdminDAO.logDataChange("MovingOrders", String.valueOf(orderId), null, oldOrderJson, null, userId, "DELETE");
                } catch (Exception e) {
                    System.err.println("Error converting moving order to JSON for DataChangeLog: " + e.getMessage());
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return success;
    }
}
