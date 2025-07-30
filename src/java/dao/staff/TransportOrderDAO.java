/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao.staff;

import java.sql.*;
import java.util.*;
import model.TransportOrder;
import utils.DBConnection;
import utils.GeoUtils;
import utils.DistanceCalculator;


public class TransportOrderDAO {
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

    // ✅ Test main
    public static void main(String[] args) {
        TransportOrderDAO dao = new TransportOrderDAO();
        String pickupLocation = "Đại Học Hồng Đức"; // địa chỉ lấy hàng thử

        TransportOrder nearest = dao.findNearestTransportUnit(pickupLocation);
        if (nearest != null) {
            System.out.println("Đơn vị vận chuyển gần nhất:");
            System.out.println("ID: " + nearest.getId());
            System.out.println("Tên: " + nearest.getCompanyName());
            System.out.println("Địa chỉ: " + nearest.getLocation());
        } else {
            System.out.println("Không tìm thấy đơn vị vận chuyển phù hợp.");
        }
    }
}
