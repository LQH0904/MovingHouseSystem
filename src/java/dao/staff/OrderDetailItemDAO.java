package dao.staff;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.math.BigDecimal;

import model.OrderDetailItem;
import utils.DBConnection;

public class OrderDetailItemDAO {

    // Lấy danh sách OrderDetail theo orderId
    public List<OrderDetailItem> getOrderDetailsByOrderId(int orderId) {
        List<OrderDetailItem> list = new ArrayList<>();

        String query = "SELECT * FROM OrderDetail WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                OrderDetailItem od = extractOrderDetailItemFromResultSet(rs);
                list.add(od);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }

    // Lấy danh sách có tìm kiếm + phân trang
    public List<OrderDetailItem> getFilteredOrderDetails(int orderId, String keyword, int offset, int limit) {
        List<OrderDetailItem> list = new ArrayList<>();
        String query = "SELECT * FROM OrderDetail WHERE order_id = ? AND item_name LIKE ? " +
                       "ORDER BY order_detail_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, offset);
            ps.setInt(4, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetailItem od = extractOrderDetailItemFromResultSet(rs);
                list.add(od);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tổng số bản ghi để tính số trang
    public int countOrderDetails(int orderId, String keyword) {
        String query = "SELECT COUNT(*) FROM OrderDetail WHERE order_id = ? AND item_name LIKE ?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ps.setString(2, "%" + keyword + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Tách xử lý chung khi đọc từ ResultSet
    private OrderDetailItem extractOrderDetailItemFromResultSet(ResultSet rs) throws SQLException {
        OrderDetailItem od = new OrderDetailItem();
        od.setOrderDetailId(rs.getInt("order_detail_id"));
        od.setOrderId(rs.getInt("order_id"));
        od.setItemName(rs.getString("item_name"));
        od.setImageUrl(rs.getString("image_url"));
        od.setQuantity(rs.getInt("quantity"));
        od.setWeightKg(rs.getBigDecimal("weight_kg"));
        od.setLengthCm((Integer) rs.getObject("length_cm"));
        od.setWidthCm((Integer) rs.getObject("width_cm"));
        od.setHeightCm((Integer) rs.getObject("height_cm"));
        od.setNote(rs.getString("note"));
        od.setVolumeM3(rs.getBigDecimal("volume_m3"));
        od.setItemPrice(rs.getBigDecimal("item_price"));
        return od;
    }

    // Test thử main
    public static void main(String[] args) {
        OrderDetailItemDAO dao = new OrderDetailItemDAO();

        int testOrderId = 5; // ID đơn hàng muốn test
        String keyword = "bàn"; // Từ khóa tìm kiếm
        int page = 1;
        int pageSize = 5;
        int offset = (page - 1) * pageSize;

        List<OrderDetailItem> results = dao.getFilteredOrderDetails(testOrderId, keyword, offset, pageSize);
        int totalRecords = dao.countOrderDetails(testOrderId, keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        System.out.println("===== KẾT QUẢ TÌM KIẾM =====");
        System.out.println("Từ khóa: \"" + keyword + "\", Đơn hàng ID: " + testOrderId);
        System.out.println("Trang hiện tại: " + page + " / " + totalPages);
        System.out.println("Tổng kết quả: " + totalRecords);
        System.out.println();

        if (results.isEmpty()) {
            System.out.println("❌ Không có mặt hàng nào được tìm thấy.");
        } else {
            for (OrderDetailItem item : results) {
                System.out.println("ID: " + item.getOrderDetailId());
                System.out.println("Tên: " + item.getItemName());
                System.out.println("Hình ảnh: " + item.getImageUrl());
                System.out.println("Số lượng: " + item.getQuantity());
                System.out.println("Trọng lượng (kg): " + item.getWeightKg());
                System.out.println("Kích thước (cm): " + item.getLengthCm() + " x " + item.getWidthCm() + " x " + item.getHeightCm());
                System.out.println("Thể tích (m³): " + item.getVolumeM3());
                System.out.println("Đơn giá: " + item.getItemPrice());
                System.out.println("Ghi chú: " + item.getNote());
                System.out.println("-----------------------------------");
            }
        }
    }
}
