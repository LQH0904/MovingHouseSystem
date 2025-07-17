/*
 * Click nbfs://SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Orders;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Issue;

public class OrderDAO {

    private static final Logger LOGGER = Logger.getLogger(OrderDAO.class.getName());
    public static final OrderDAO INSTANCE = new OrderDAO();

    public List<Orders> getOrderList(String status, String startDate, String endDate, String transportUnitName,
            String warehouseName, String orderId, String sortBy, String sortOrder) {
        List<Orders> orders = new ArrayList<>();
        StringBuilder query = new StringBuilder(
                "SELECT o.order_id, o.customer_id, c.full_name, o.transport_unit_id, t.company_name, "
                + "o.storage_unit_id, s.warehouse_name, o.order_status, o.created_at, o.updated_at, "
                + "o.delivery_schedule, o.total_fee, o.accepted_at, o.delivered_at "
                + "FROM Orders o "
                + "LEFT JOIN Customers c ON o.customer_id = c.customer_id "
                + "LEFT JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id "
                + "LEFT JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id WHERE 1=1");

        // Thêm điều kiện lọc
        List<Object> params = new ArrayList<>();
        try {
            if (orderId != null && !orderId.isEmpty()) {
                query.append(" AND o.order_id = ?");
                params.add(Integer.parseInt(orderId));
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid orderId format: " + orderId, e);
        }

        if (status != null && !status.isEmpty()) {
            query.append(" AND o.order_status = ?");
            params.add(status);
        }
        if (startDate != null && !startDate.isEmpty()) {
            query.append(" AND o.delivery_schedule >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            query.append(" AND o.delivery_schedule <= ?");
            params.add(endDate);
        }
        if (transportUnitName != null && !transportUnitName.isEmpty()) {
            query.append(" AND t.company_name LIKE ?");
            params.add("%" + transportUnitName + "%");
        }
        if (warehouseName != null && !warehouseName.isEmpty()) {
            query.append(" AND s.warehouse_name LIKE ?");
            params.add("%" + warehouseName + "%");
        }

        if (sortBy != null && (sortBy.equals("created_at") || sortBy.equals("updated_at"))) {
            query.append(" ORDER BY o.").append(sortBy);
            if (sortOrder != null && sortOrder.equals("desc")) {
                query.append(" DESC");
            } else {
                query.append(" ASC");
            }
        }

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setCustomerName(rs.getString("full_name"));
                order.setTransportUnitId(rs.getObject("transport_unit_id") != null ? rs.getInt("transport_unit_id") : null);
                String companyName = rs.getString("company_name");
                order.setTransportUnitName(companyName != null ? companyName : "Chưa chỉ định");
                order.setStorageUnitId(rs.getObject("storage_unit_id") != null ? rs.getInt("storage_unit_id") : null);
                order.setStorageUnitName(rs.getString("warehouse_name"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setUpdatedAt(rs.getTimestamp("updated_at"));
                order.setDeliverySchedule(rs.getTimestamp("delivery_schedule"));
                order.setTotalFee(rs.getBigDecimal("total_fee"));
                order.setAcceptedAt(rs.getTimestamp("accepted_at"));
                order.setDeliveredAt(rs.getTimestamp("delivered_at"));
                LOGGER.info("Order ID: " + order.getOrderId() + ", Transport Unit ID: " + order.getTransportUnitId()
                        + ", Company Name: " + (companyName != null ? companyName : "NULL"));
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error: " + e.getMessage(), e);
        }
        return orders;
    }

    public List<Issue> getIssuesByOrderId(int orderId) throws SQLException {
        String query = "SELECT * FROM Issues WHERE order_id = ?";
        List<Issue> issues = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Issue issue = new Issue();
                issue.setIssueId(rs.getInt("issue_id"));
                issue.setDescription(rs.getString("description"));
                issues.add(issue);
                LOGGER.info("Fetched Issue ID: " + issue.getIssueId() + " for Order ID: " + orderId);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching issues for Order ID: " + orderId, e);
            throw e;
        }
        return issues;
    }
    
    public List<Orders> getOrderListNotification(String status, String customerId, String transportUnitId, String startDate, String endDate, String orderBy, String sortOrder, String limit) throws SQLException {
        List<Orders> orders = new ArrayList<>();
        String query = "SELECT o.* FROM Orders o " +
                      "LEFT JOIN Notifications n ON n.order_id = o.order_id AND n.created_at >= DATEADD(hour, -24, GETDATE()) " +
                      "WHERE n.notification_id IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Orders order = new Orders();
                order.setOrderId(rs.getInt("order_id"));
                order.setCustomerId(rs.getInt("customer_id"));
                order.setTransportUnitId(rs.getInt("transport_unit_id"));
                order.setOrderStatus(rs.getString("order_status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                order.setDeliverySchedule(rs.getTimestamp("delivery_schedule"));
                order.setDeliveredAt(rs.getTimestamp("delivered_at"));
                orders.add(order);
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn danh sách đơn hàng: " + e.getMessage());
            throw e;
        }
        return orders;
    }

    public List<Issue> getIssuesByOrderIdNotification(int orderId) throws SQLException {
        List<Issue> issues = new ArrayList<>();
        String query = "SELECT * FROM Issues WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {
            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Issue issue = new Issue();
                issue.setOrderId(rs.getInt("order_id"));
                issue.setDescription(rs.getString("description"));
                issues.add(issue);
            }
        } catch (SQLException e) {
            LOGGER.severe("Lỗi truy vấn vấn đề đơn hàng ID " + orderId + ": " + e.getMessage());
            throw e;
        }
        return issues;
    }
    
}
