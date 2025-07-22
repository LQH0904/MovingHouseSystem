package dao.staff;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

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
                OrderDetailItem od = new OrderDetailItem();
                od.setOrderDetailId(rs.getInt("order_detail_id"));
                od.setOrderId(rs.getInt("order_id"));
                od.setItemName(rs.getString("item_name"));
                od.setImageUrl(rs.getString("image_url"));
                od.setQuantity(rs.getInt("quantity"));
                od.setWeightKg(rs.getDouble("weight_kg"));
                od.setLengthCm(rs.getInt("length_cm"));
                od.setWidthCm(rs.getInt("width_cm"));
                od.setHeightCm(rs.getInt("height_cm"));
                od.setNote(rs.getString("note"));

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
        String query = "SELECT * FROM OrderDetail WHERE order_id = ? AND item_name LIKE ? ORDER BY order_detail_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(query)) {

            ps.setInt(1, orderId);
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, offset);
            ps.setInt(4, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                OrderDetailItem od = new OrderDetailItem();
                od.setOrderDetailId(rs.getInt("order_detail_id"));
                od.setOrderId(rs.getInt("order_id"));
                od.setItemName(rs.getString("item_name"));
                od.setImageUrl(rs.getString("image_url"));
                od.setQuantity(rs.getInt("quantity"));
                od.setWeightKg(rs.getDouble("weight_kg"));
                od.setLengthCm(rs.getInt("length_cm"));
                od.setWidthCm(rs.getInt("width_cm"));
                od.setHeightCm(rs.getInt("height_cm"));
                od.setNote(rs.getString("note"));
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

    public static void main(String[] args) {
    OrderDetailItemDAO dao = new OrderDetailItemDAO();

    int testOrderId = 5; // ID đơn hàng muốn test
    String keyword = "bàn"; // Từ khóa cần tìm, bạn có thể thử đổi sang "" hoặc null
    int page = 1; // Trang muốn xem
    int pageSize = 5; // Số dòng mỗi trang
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
            System.out.println("Ghi chú: " + item.getNote());
            System.out.println("-----------------------------------");
        }
    }
}


}
