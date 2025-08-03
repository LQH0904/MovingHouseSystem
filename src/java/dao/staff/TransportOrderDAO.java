
package dao.staff;
import java.sql.PreparedStatement;

import java.sql.*;
import java.util.*;
import model.OrderInfo;
import model.TransportOrder;
import utils.DBConnection;
import utils.GeoUtils;
import utils.DistanceCalculator;


public class TransportOrderDAO {
    
     private static final String INSERT_NOTIFICATION = 
        "INSERT INTO Notifications (user_id, order_id, message, status, created_at, notification_type) VALUES (?, ?, ?, ?, ?, ?)";

    public List<OrderInfo> getPendingOrders() {
        List<OrderInfo> list = new ArrayList<>();

        String sql = """
            SELECT o.order_id, c.full_name, o.created_at, o.updated_at, o.customer_id,
                   o.delivery_schedule, o.total_distance_km, o.order_status,
                   tp.pickup_location, tp.shipping_location
            FROM Orders o
            JOIN Customers c ON o.customer_id = c.customer_id
            JOIN TransportProcess tp ON o.order_id = tp.order_id         
            WHERE o.order_status = 'pending'
            ORDER BY o.created_at DESC
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                OrderInfo order = new OrderInfo(
                    rs.getInt("order_id"),
                    rs.getInt("customer_id"),
                    rs.getString("full_name"),
                    rs.getString("created_at"),
                    rs.getString("updated_at"),
                    rs.getString("delivery_schedule"),
                    rs.getDouble("total_distance_km"),
                    rs.getString("pickup_location"),
                    rs.getString("shipping_location"),
                    rs.getString("order_status")
                );
                list.add(order);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public TransportOrder findNearestTransportUnit(String pickupLocation) {
        GeoUtils.Coordinate pickupCoord = GeoUtils.getCoordinates(pickupLocation);
        if (pickupCoord == null) {
            System.out.println("Không thể lấy tọa độ địa chỉ lấy hàng.");
            return null;
        }

        TransportOrder nearestUnit = null;
        double minDistance = Double.MAX_VALUE;

        String sql = "SELECT transport_unit_id, company_name, location FROM TransportUnits WHERE registration_status = 'approved'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("transport_unit_id");
                String name = rs.getString("company_name");
                String location = rs.getString("location");

                GeoUtils.Coordinate unitCoord = GeoUtils.getCoordinates(location);
                if (unitCoord == null) continue;

                double distance = DistanceCalculator.haversine(
                    pickupCoord.lat, pickupCoord.lon,
                    unitCoord.lat, unitCoord.lon
                );

                if (distance < minDistance) {
                    minDistance = distance;
                    nearestUnit = new TransportOrder(id, name, location);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return nearestUnit;
    }

    public OrderInfo getOrderInfo(int orderId) {
        String query = """
            SELECT o.order_id, c.full_name, o.created_at, o.updated_at, o.delivery_schedule,
                   o.customer_id, o.total_distance_km, o.order_status,
                   tp.pickup_location, tp.shipping_location
            FROM Orders o
            JOIN Customers c ON o.customer_id = c.customer_id
            JOIN TransportProcess tp ON o.order_id = tp.order_id
            WHERE o.order_id = ?
        """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new OrderInfo(
                        rs.getInt("order_id"),
                        rs.getInt("customer_id"),
                        rs.getString("full_name"),
                        rs.getString("created_at"),
                        rs.getString("updated_at"),
                        rs.getString("delivery_schedule"),
                        rs.getDouble("total_distance_km"),
                        rs.getString("pickup_location"),
                        rs.getString("shipping_location"),
                        rs.getString("order_status")
                    );
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean assignNearestUnit(int orderId, int customerId)  {
        String pickupLocation = getPickupLocation(orderId);
        TransportOrder unit = findNearestTransportUnit(pickupLocation);

        if (unit == null) return false;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            String update = """
                UPDATE Orders 
                SET transport_unit_id = ?, order_status = 'in_progress', updated_at = GETDATE()
                WHERE order_id = ?
            """;

            try (PreparedStatement ps = conn.prepareStatement(update)) {
                ps.setInt(1, unit.getId());
                ps.setInt(2, orderId);
                ps.executeUpdate();
            }

            try (PreparedStatement notificationStmt = conn.prepareStatement(INSERT_NOTIFICATION)) {
                notificationStmt.setInt(1, customerId);
                notificationStmt.setInt(2, orderId);
                notificationStmt.setString(3, "Xác nhận đơn hàng " + orderId + " thành công! Đơn hàng của bạn đang được thực hiện!");
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

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    private String getPickupLocation(int orderId) {
        String sql = "SELECT pickup_location FROM TransportProcess WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getString("pickup_location");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }


//public static void main(String[] args) {
//        TransportOrderDAO dao = new TransportOrderDAO();
//        List<OrderInfo> orders = dao.getPendingOrders();
//
//        if (orders.isEmpty()) {
//            System.out.println("Không có đơn hàng nào đang chờ duyệt.");
//        } else {
//            System.out.println("Danh sách đơn hàng đang chờ duyệt:");
//            for (OrderInfo order : orders) {
//                System.out.println("Mã đơn hàng: " + order.getOrderId());
//                System.out.println("Tên khách hàng: " + order.getFullName());
//                System.out.println("Ngày tạo: " + order.getCreatedAt());
//                System.out.println("Ngày cập nhật: " + order.getUpdatedAt());
//                System.out.println("Lịch giao hàng: " + order.getDeliverySchedule());
//                System.out.println("Quãng đường (km): " + order.getTotalDistanceKm());
//                System.out.println("Điểm lấy hàng: " + order.getPickupLocation());
//                System.out.println("Điểm giao hàng: " + order.getShippingLocation());
//                System.out.println("-------------------------------");
//            }
//        }
//    }

//    // ✅ Test main
//    public static void main(String[] args) {
//    TransportOrderDAO dao = new TransportOrderDAO();
//    int orderId = 28; // test với đơn hàng có ID này
//
//    // 1. Lấy thông tin đơn hàng
//    System.out.println("=== 🧾 THÔNG TIN ĐƠN HÀNG ===");
//    OrderInfo info = dao.getOrderInfo(orderId);
//    if (info == null) {
//        System.out.println("Không tìm thấy đơn hàng.");
//        return;
//    }
//
//    System.out.println("Order ID: " + info.getOrderId());
//    System.out.println("Khách hàng: " + info.getFullName());
//    System.out.println("Ngày tạo: " + info.getCreatedAt());
//    System.out.println("Lịch giao: " + info.getDeliverySchedule());
//    System.out.println("Khoảng cách (km): " + info.getTotalDistanceKm());
//    System.out.println("Địa chỉ lấy hàng: " + info.getPickupLocation());
//    System.out.println("Địa chỉ giao hàng: " + info.getShippingLocation());
//
//    // 2. Tìm đơn vị gần nhất
//    System.out.println("\n=== 🚛 ĐƠN VỊ GẦN NHẤT ===");
//    TransportOrder unit = dao.findNearestTransportUnit(info.getPickupLocation());
//    if (unit != null) {
//        System.out.println("ID: " + unit.getId());
//        System.out.println("Tên: " + unit.getCompanyName());
//        System.out.println("Địa chỉ: " + unit.getLocation());
//    } else {
//        System.out.println("Không tìm thấy đơn vị phù hợp.");
//        return;
//    }
//
//    // 3. Gán đơn vị vào đơn hàng
//    System.out.println("\n=== ✅ XÉT DUYỆT ĐƠN ===");
//    boolean assigned = dao.assignNearestUnit(orderId);
//    if (assigned) {
//        System.out.println("Đơn hàng đã được xét duyệt và gán đơn vị thành công.");
//    } else {
//        System.out.println("❌ Gán đơn vị thất bại.");
//    }
//}

}
