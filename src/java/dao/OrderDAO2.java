package dao;

import model.Orders;
import model.CustomerSurvey;
import model.TransportReport1;
import model.StorageReport;
import model.Issue;
import model.SuggestedItem;
import model.Configuration;
import model.Service;
import model.OrderDetail;
import utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.math.BigDecimal;

public class OrderDAO2 {
    private static final Logger LOGGER = Logger.getLogger(OrderDAO2.class.getName());
    public static final OrderDAO2 INSTANCE = new OrderDAO2();
    private static final String QUERY_ORDER_LIST = "SELECT o.order_id, o.customer_id, c.full_name, o.transport_unit_id, t.company_name, "
            + "o.storage_unit_id, s.warehouse_name, o.order_status, o.created_at, o.updated_at, "
            + "o.delivery_schedule, o.total_fee, o.accepted_at, o.delivered_at, o.description, "
            + "o.special_note, o.service_type, o.pickup_time_desired, o.transport_fee, o.service_fee, "
            + "o.vat_amount, o.discount, o.total_distance_km "
            + "FROM Orders o "
            + "LEFT JOIN Customers c ON o.customer_id = c.customer_id "
            + "LEFT JOIN TransportUnits t ON o.transport_unit_id = t.transport_unit_id "
            + "LEFT JOIN StorageUnits s ON o.storage_unit_id = s.storage_unit_id WHERE 1=1";
    private static final String QUERY_TOTAL_ORDER_COUNT = "SELECT COUNT(*) FROM Orders o WHERE 1=1";
    private static final String QUERY_ISSUES_BY_ORDER_ID = "SELECT issue_id, user_id, order_id, description, status, priority, created_at, resolved_at, unit_id, unit_type, operator_reply FROM Issues WHERE order_id = ?";
    private static final String QUERY_ORDER_LIST_NOTIFICATION = "SELECT o.order_id, o.customer_id, o.transport_unit_id, "
            + "o.order_status, o.created_at, o.delivery_schedule, o.delivered_at, o.total_fee, "
            + "o.description, o.special_note, o.service_type, o.pickup_time_desired, o.transport_fee, "
            + "o.service_fee, o.vat_amount, o.discount, o.total_distance_km "
            + "FROM Orders o "
            + "LEFT JOIN Notifications n ON n.order_id = o.order_id AND n.created_at >= DATEADD(hour, -24, GETDATE()) "
            + "WHERE n.notification_id IS NULL";
    private static final String QUERY_SUGGESTED_ITEMS = "SELECT item_id, name, default_quantity, default_weight_kg, default_volume_m3, default_price, description FROM SuggestedItems";
    private static final String QUERY_CONFIGURATION_BY_KEY = "SELECT config_id, config_key, config_value, updated_by, updated_at FROM Configurations WHERE config_key = ?";
    private static final String QUERY_ALL_CONFIGURATIONS = "SELECT config_id, config_key, config_value, updated_by, updated_at FROM Configurations";
    private static final String QUERY_ALL_SERVICES = "SELECT id, name, description, base_price, rate_per_km FROM Services";
    private static final String QUERY_SERVICE_BY_NAME = "SELECT id, name, description, base_price, rate_per_km FROM Services WHERE name = ?";
    private static final String QUERY_ORDER_DETAILS_BY_ORDER_ID = "SELECT order_detail_id, order_id, customer_id, item_name, image_url, quantity, weight_kg, length_cm, width_cm, height_cm, note, volume_m3, item_price FROM OrderDetail WHERE order_id = ?";
    private static final String UPDATE_ORDER_STATUS = "UPDATE Orders SET order_status = ?, delivered_at = ? WHERE order_id = ? AND customer_id = ? AND order_status = ?";
    private static final String INSERT_NOTIFICATION = "INSERT INTO Notifications (user_id, order_id, message, status, created_at, notification_type) VALUES (?, ?, ?, ?, ?, ?)";
    private static final String FALLBACK_TRANSPORT_UNIT_NAME = "Chưa chỉ định";

    // Method to get total number of orders for pagination
    public int getTotalOrderCount(String customerId) {
        StringBuilder query = new StringBuilder(QUERY_TOTAL_ORDER_COUNT);
        List<Object> params = new ArrayList<>();
        try {
            if (customerId != null && !customerId.isEmpty()) {
                query.append(" AND o.customer_id = ?");
                params.add(Integer.parseInt(customerId));
            }
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query.toString())) {
                setParameters(ps, params);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching total order count: {0}", e.getMessage());
            } catch (NumberFormatException e) {
                LOGGER.log(Level.WARNING, "Invalid customerId format: {0}", customerId);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Unexpected error in getTotalOrderCount: {0}", e.getMessage());
        }
        return 0;
    }

    // Updated getOrderList with pagination support
    public List<Orders> getOrderList(String status, String startDate, String endDate, String transportUnitName,
            String warehouseName, String orderId, String customerId, String sortBy, String sortOrder, int limit, int offset) {
        List<Orders> orders = new ArrayList<>();
        StringBuilder query = new StringBuilder(QUERY_ORDER_LIST);
        List<Object> params = new ArrayList<>();
        try {
            if (orderId != null && !orderId.isEmpty()) {
                query.append(" AND o.order_id = ?");
                params.add(Integer.parseInt(orderId));
            }
            if (customerId != null && !customerId.isEmpty()) {
                query.append(" AND o.customer_id = ?");
                params.add(Integer.parseInt(customerId));
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
            // Add pagination
            query.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            params.add(offset);
            params.add(limit);

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(query.toString())) {
                setParameters(ps, params);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        Orders order = mapToOrders(rs);
                        orders.add(order);
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error fetching order list: {0}", e.getMessage());
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid orderId or customerId format: orderId={0}, customerId={1}", new Object[]{orderId, customerId});
        }
        return orders;
    }

    public List<Issue> getIssuesByOrderId(int orderId) throws SQLException {
        List<Issue> issues = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_ISSUES_BY_ORDER_ID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Issue issue = mapToIssue(rs);
                    issues.add(issue);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching issues for Order ID: {0}, {1}", new Object[]{orderId, e.getMessage()});
            throw e;
        }
        return issues;
    }

    public List<Orders> getOrderListNotification(String status, String customerId, String transportUnitId, String startDate, String endDate, String orderBy, String sortOrder, String limit) throws SQLException {
        List<Orders> orders = new ArrayList<>();
        StringBuilder query = new StringBuilder(QUERY_ORDER_LIST_NOTIFICATION);
        List<Object> params = new ArrayList<>();
        if (status != null && !status.isEmpty()) {
            query.append(" AND o.order_status = ?");
            params.add(status);
        }
        if (customerId != null && !customerId.isEmpty()) {
            query.append(" AND o.customer_id = ?");
            params.add(Integer.parseInt(customerId));
        }
        if (transportUnitId != null && !transportUnitId.isEmpty()) {
            query.append(" AND o.transport_unit_id = ?");
            params.add(Integer.parseInt(transportUnitId));
        }
        if (startDate != null && !startDate.isEmpty()) {
            query.append(" AND o.delivery_schedule >= ?");
            params.add(startDate);
        }
        if (endDate != null && !endDate.isEmpty()) {
            query.append(" AND o.delivery_schedule <= ?");
            params.add(endDate);
        }
        if (orderBy != null && !orderBy.isEmpty()) {
            query.append(" ORDER BY ").append(orderBy);
            query.append(sortOrder != null && sortOrder.equalsIgnoreCase("desc") ? " DESC" : " ASC");
        }
        if (limit != null && !limit.isEmpty()) {
            query.append(" OFFSET 0 ROWS FETCH NEXT ? ROWS ONLY");
            params.add(Integer.parseInt(limit));
        }
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query.toString())) {
            setParameters(ps, params);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Orders order = mapToOrders(rs);
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching order list for notifications: {0}", e.getMessage());
            throw e;
        }
        return orders;
    }

    public List<SuggestedItem> getSuggestedItems() throws SQLException {
        List<SuggestedItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_SUGGESTED_ITEMS)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    SuggestedItem item = mapToSuggestedItem(rs);
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching suggested items: {0}", e.getMessage());
            throw e;
        }
        return items;
    }

    public Configuration getConfigurationByKey(String key) throws SQLException {
        Configuration config = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_CONFIGURATION_BY_KEY)) {
            ps.setString(1, key);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    config = mapToConfiguration(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching configuration for key: {0}, {1}", new Object[]{key, e.getMessage()});
            throw e;
        }
        return config;
    }

    public List<Configuration> getAllConfigurations() throws SQLException {
        List<Configuration> configs = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_ALL_CONFIGURATIONS)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Configuration config = mapToConfiguration(rs);
                    configs.add(config);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all configurations: {0}", e.getMessage());
            throw e;
        }
        return configs;
    }

    public List<Service> getAllServices() throws SQLException {
        List<Service> services = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_ALL_SERVICES)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Service service = mapToService(rs);
                    services.add(service);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all services: {0}", e.getMessage());
            throw e;
        }
        return services;
    }

    public Service getServiceByName(String name) throws SQLException {
        Service service = null;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_SERVICE_BY_NAME)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    service = mapToService(rs);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching service by name: {0}, {1}", new Object[]{name, e.getMessage()});
            throw e;
        }
        return service;
    }

    public List<OrderDetail> getOrderDetailsByOrderId(int orderId) throws SQLException {
        List<OrderDetail> details = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(QUERY_ORDER_DETAILS_BY_ORDER_ID)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail detail = mapToOrderDetail(rs);
                    details.add(detail);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching order details for Order ID: {0}, {1}", new Object[]{orderId, e.getMessage()});
            throw e;
        }
        return details;
    }

    public boolean confirmOrderDelivery(int orderId, int customerId) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Update order status to "delivered" and set delivered_at
                try (PreparedStatement updateStmt = conn.prepareStatement(UPDATE_ORDER_STATUS)) {
                    updateStmt.setString(1, "delivered");
                    updateStmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
                    updateStmt.setInt(3, orderId);
                    updateStmt.setInt(4, customerId);
                    updateStmt.setString(5, "in_progress");
                    int rowsAffected = updateStmt.executeUpdate();
                    if (rowsAffected == 0) {
                        conn.rollback();
                        return false;
                    }
                }
                // Insert notification
                try (PreparedStatement notificationStmt = conn.prepareStatement(INSERT_NOTIFICATION)) {
                    notificationStmt.setInt(1, customerId);
                    notificationStmt.setInt(2, orderId);
                    notificationStmt.setString(3, "Đơn hàng " + orderId + " đã được xác nhận giao thành công!");
                    notificationStmt.setString(4, "sent");
                    notificationStmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                    notificationStmt.setString(6, "reminder");
                    int rowsAffected = notificationStmt.executeUpdate();
                    if (rowsAffected == 0) {
                        conn.rollback();
                        return false;
                    }
                }
                conn.commit();
                return true;
            } catch (SQLException e) {
                conn.rollback();
                LOGGER.log(Level.SEVERE, "Error confirming delivery for order_id: {0}, customer_id: {1}, {2}", new Object[]{orderId, customerId, e.getMessage()});
                throw e;
            }
        }
    }

    private void setParameters(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }

    private Orders mapToOrders(ResultSet rs) throws SQLException {
        Orders order = new Orders();
        order.setOrderId(rs.getInt("order_id"));
        order.setCustomerId(rs.getInt("customer_id"));
        order.setCustomerName(rs.getString("full_name"));
        order.setTransportUnitId(rs.getObject("transport_unit_id") != null ? rs.getInt("transport_unit_id") : null);
        String companyName = rs.getString("company_name");
        order.setTransportUnitName(companyName != null ? companyName : FALLBACK_TRANSPORT_UNIT_NAME);
        order.setStorageUnitId(rs.getObject("storage_unit_id") != null ? rs.getInt("storage_unit_id") : null);
        order.setStorageUnitName(rs.getString("warehouse_name"));
        order.setOrderStatus(rs.getString("order_status"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        order.setUpdatedAt(rs.getTimestamp("updated_at"));
        order.setDeliverySchedule(rs.getTimestamp("delivery_schedule"));
        order.setTotalFee(rs.getBigDecimal("total_fee"));
        order.setAcceptedAt(rs.getTimestamp("accepted_at"));
        order.setDeliveredAt(rs.getTimestamp("delivered_at"));
        order.setDescription(rs.getString("description"));
        order.setSpecialNote(rs.getString("special_note"));
        order.setServiceType(rs.getString("service_type"));
        order.setPickupTimeDesired(rs.getTimestamp("pickup_time_desired"));
        order.setTransportFee(rs.getBigDecimal("transport_fee"));
        order.setServiceFee(rs.getBigDecimal("service_fee"));
        order.setVatAmount(rs.getBigDecimal("vat_amount"));
        order.setDiscount(rs.getBigDecimal("discount"));
        order.setTotalDistanceKm(rs.getBigDecimal("total_distance_km"));
        return order;
    }

    private Issue mapToIssue(ResultSet rs) throws SQLException {
        Issue issue = new Issue();
        issue.setIssueId(rs.getInt("issue_id"));
        issue.setUserId(rs.getInt("user_id"));
        issue.setOrderId(rs.getInt("order_id"));
        issue.setDescription(rs.getString("description"));
        issue.setStatus(rs.getString("status"));
        issue.setPriority(rs.getString("priority"));
        issue.setCreatedAt(rs.getTimestamp("created_at"));
        issue.setResolvedAt(rs.getTimestamp("resolved_at"));
        issue.setUnitId(rs.getObject("unit_id") != null ? rs.getInt("unit_id") : null);
        issue.setUnitType(rs.getString("unit_type"));
        issue.setOperatorReply(rs.getString("operator_reply"));
        return issue;
    }

    private SuggestedItem mapToSuggestedItem(ResultSet rs) throws SQLException {
        SuggestedItem item = new SuggestedItem();
        item.setItemId(rs.getInt("item_id"));
        item.setName(rs.getString("name"));
        item.setDefaultQuantity(rs.getInt("default_quantity"));
        BigDecimal weight = rs.getBigDecimal("default_weight_kg");
        item.setDefaultWeightKg(weight != null ? weight.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        BigDecimal volume = rs.getBigDecimal("default_volume_m3");
        item.setDefaultVolumeM3(volume != null ? volume.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        BigDecimal price = rs.getBigDecimal("default_price");
        item.setDefaultPrice(price != null ? price.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        item.setDescription(rs.getString("description"));
        return item;
    }

    private Configuration mapToConfiguration(ResultSet rs) throws SQLException {
        Configuration config = new Configuration();
        config.setConfigId(rs.getInt("config_id"));
        config.setConfigKey(rs.getString("config_key"));
        config.setConfigValue(rs.getString("config_value"));
        config.setUpdatedBy(rs.getInt("updated_by"));
        config.setUpdatedAt(rs.getTimestamp("updated_at"));
        return config;
    }

    private Service mapToService(ResultSet rs) throws SQLException {
        Service service = new Service();
        service.setId(rs.getInt("id"));
        service.setName(rs.getString("name"));
        service.setDescription(rs.getString("description"));
        BigDecimal basePrice = rs.getBigDecimal("base_price");
        service.setBasePrice(basePrice != null ? basePrice.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        BigDecimal ratePerKm = rs.getBigDecimal("rate_per_km");
        service.setRatePerKm(ratePerKm != null ? ratePerKm.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        return service;
    }

    private OrderDetail mapToOrderDetail(ResultSet rs) throws SQLException {
        OrderDetail detail = new OrderDetail();
        detail.setOrderDetailId(rs.getInt("order_detail_id"));
        detail.setOrderId(rs.getInt("order_id"));
        detail.setItemName(rs.getString("item_name"));
        detail.setImageUrl(rs.getString("image_url"));
        detail.setQuantity(rs.getInt("quantity"));
        BigDecimal weight = rs.getBigDecimal("weight_kg");
        detail.setWeightKg(weight != null ? weight.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        detail.setLengthCm(rs.getInt("length_cm"));
        detail.setWidthCm(rs.getInt("width_cm"));
        detail.setHeightCm(rs.getInt("height_cm"));
        detail.setNote(rs.getString("note"));
        BigDecimal volume = rs.getBigDecimal("volume_m3");
        detail.setVolumeM3(volume != null ? volume.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        BigDecimal price = rs.getBigDecimal("item_price");
        detail.setItemPrice(price != null ? price.setScale(2, BigDecimal.ROUND_HALF_UP) : BigDecimal.ZERO);
        return detail;
    }
}