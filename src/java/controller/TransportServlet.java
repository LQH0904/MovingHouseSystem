package controller;

import dao.OrderDAO2;
import model.Orders;
import model.TransportProcess;
import model.OrderDetail;
import model.Service;
import model.Users;
import utils.DBConnection;
import org.json.JSONArray;
import org.json.JSONObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "TransportServlet", urlPatterns = {"/transport"})
public class TransportServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(TransportServlet.class.getName());
    private static final BigDecimal VAT_RATE = new BigDecimal("0.10");

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            LOGGER.info("No session or user not logged in, redirecting to login at " + new java.util.Date());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Users user = (Users) session.getAttribute("acc");
        if (user.getRoleId() != 6) {
            LOGGER.warning("User with role_id " + user.getRoleId() + " attempted to access transport page at " + new java.util.Date());
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only customers can access this page");
            return;
        }

        if (session.getAttribute("orderDetails") == null) {
            session.setAttribute("orderDetails", new ArrayList<OrderDetail>());
        }

        request.setAttribute("distanceKm", BigDecimal.ZERO);
        request.setAttribute("transportFee", BigDecimal.ZERO);
        request.setAttribute("serviceFee", BigDecimal.ZERO);
        request.setAttribute("vatAmount", BigDecimal.ZERO);
        request.setAttribute("totalFee", BigDecimal.ZERO);

        LOGGER.info("Forwarding to transport.jsp for user_id: " + user.getUserId() + " at " + new java.util.Date());
        request.getRequestDispatcher("/transport.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            if (session == null || session.getAttribute("acc") == null) {
                LOGGER.info("No session or user not logged in, rejecting request at " + new java.util.Date());
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
                return;
            }
            Users user = (Users) session.getAttribute("acc");
            if (user.getRoleId() != 6) {
                LOGGER.warning("User with role_id " + user.getRoleId() + " attempted to place order at " + new java.util.Date());
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only customers can place orders");
                return;
            }
            int customerId = user.getUserId();

            String action = request.getParameter("action");
            if ("updateOrderDetails".equals(action)) {
                String orderDetailsJson = request.getParameter("orderDetails");
                LOGGER.info("Received orderDetailsJson: " + orderDetailsJson);
                if (orderDetailsJson != null && !orderDetailsJson.trim().isEmpty()) {
                    List<OrderDetail> details = new ArrayList<>();
                    try {
                        JSONArray jsonArray = new JSONArray(orderDetailsJson);
                        for (int i = 0; i < jsonArray.length(); i++) {
                            JSONObject obj = jsonArray.getJSONObject(i);
                            OrderDetail detail = new OrderDetail();
                            detail.setItemName(obj.getString("itemName"));
                            detail.setQuantity(obj.getInt("quantity"));
                            String weightStr = obj.get("weightKg").toString().trim().replaceAll("[^0-9.]", "");
                            String volumeStr = obj.get("volumeM3").toString().trim().replaceAll("[^0-9.]", "");
                            String priceStr = obj.get("itemPrice").toString().trim().replaceAll("[^0-9.]", "");
                            if (weightStr.isEmpty() || volumeStr.isEmpty() || priceStr.isEmpty()) {
                                LOGGER.warning("Empty numeric field in orderDetailsJson at index " + i + ": weight=" + weightStr + ", volume=" + volumeStr + ", price=" + priceStr);
                                throw new NumberFormatException("Empty numeric field");
                            }
                            detail.setWeightKg(new BigDecimal(weightStr).setScale(2, BigDecimal.ROUND_HALF_UP));
                            detail.setVolumeM3(new BigDecimal(volumeStr).setScale(2, BigDecimal.ROUND_HALF_UP));
                            detail.setItemPrice(new BigDecimal(priceStr).setScale(2, BigDecimal.ROUND_HALF_UP));
                            detail.setNote(obj.optString("note", ""));
                            details.add(detail);
                        }
                        session.setAttribute("orderDetails", details);
                        LOGGER.info("Session orderDetails updated with " + details.size() + " items");
                        response.setContentType("application/json");
                        response.setCharacterEncoding("UTF-8");
                        try (PrintWriter out = response.getWriter()) {
                            out.print(new JSONObject().put("status", "success").toString());
                            out.flush();
                        }
                    } catch (Exception e) {
                        LOGGER.severe("Error parsing orderDetailsJson: " + e.getMessage());
                        sendAjaxError(response, "Lỗi khi lưu chi tiết hàng hóa: " + e.getMessage());
                    }
                    return;
                } else {
                    LOGGER.warning("Empty or null orderDetailsJson received");
                    sendAjaxError(response, "Dữ liệu hàng hóa rỗng hoặc không hợp lệ.");
                    return;
                }
            } else if ("updateFees".equals(action)) {
                String totalItemPriceStr = request.getParameter("totalItemPrice") != null ? request.getParameter("totalItemPrice").trim().replaceAll("[^0-9.]", "") : "0";
                String distanceKmStr = request.getParameter("distanceKm") != null ? request.getParameter("distanceKm").trim().replaceAll("[^0-9.]", "") : "0";
                String serviceType = request.getParameter("serviceType");

                LOGGER.info("Processing updateFees with totalItemPrice: " + totalItemPriceStr + ", distanceKm: " + distanceKmStr + ", serviceType: " + serviceType);

                if (serviceType == null || serviceType.isEmpty()) {
                    LOGGER.warning("Missing serviceType in updateFees request");
                    sendAjaxError(response, "Vui lòng chọn loại dịch vụ.");
                    return;
                }

                BigDecimal totalItemPrice, distanceKm;
                try {
                    totalItemPrice = new BigDecimal(totalItemPriceStr).setScale(2, BigDecimal.ROUND_HALF_UP);
                    distanceKm = new BigDecimal(distanceKmStr).setScale(2, BigDecimal.ROUND_HALF_UP);
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid number format for updateFees: totalItemPrice=" + totalItemPriceStr + ", distanceKm=" + distanceKmStr + ": " + e.getMessage());
                    sendAjaxError(response, "Dữ liệu số không hợp lệ (tổng giá hoặc khoảng cách).");
                    return;
                }

                OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
                Service service = orderDAO.getServiceByName(serviceType);

                BigDecimal serviceFee = BigDecimal.ZERO;
                if (service != null) {
                    BigDecimal basePrice = service.getBasePrice();
                    BigDecimal ratePerKm = service.getRatePerKm() != null ? service.getRatePerKm() : BigDecimal.ZERO;
                    serviceFee = basePrice.add(ratePerKm.multiply(distanceKm)).setScale(2, BigDecimal.ROUND_HALF_UP);
                } else {
                    LOGGER.warning("Service not found for type: " + serviceType);
                    sendAjaxError(response, "Không tìm thấy dịch vụ: " + serviceType);
                    return;
                }

                BigDecimal transportFee = totalItemPrice.setScale(2, BigDecimal.ROUND_HALF_UP);
                // Calculate VAT on the sum of transportFee and serviceFee
                BigDecimal taxableAmount = transportFee.add(serviceFee);
                BigDecimal vatAmount = taxableAmount.multiply(VAT_RATE).setScale(2, BigDecimal.ROUND_HALF_UP);
                BigDecimal totalFee = transportFee.add(serviceFee).add(vatAmount).setScale(2, BigDecimal.ROUND_HALF_UP);

                LOGGER.info("Returning fees: transportFee=" + transportFee + ", serviceFee=" + serviceFee + ", vatAmount=" + vatAmount + ", totalFee=" + totalFee);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                JSONObject jsonResponse = new JSONObject();
                jsonResponse.put("transportFee", transportFee);
                jsonResponse.put("serviceFee", serviceFee);
                jsonResponse.put("vatAmount", vatAmount);
                jsonResponse.put("totalFee", totalFee);
                try (PrintWriter out = response.getWriter()) {
                    out.print(jsonResponse.toString());
                    out.flush();
                }
                return;
            } else if ("calculateRoute".equals(action)) {
                String pickupLat = request.getParameter("pickup_lat");
                String pickupLng = request.getParameter("pickup_lng");
                String shippingLat = request.getParameter("shipping_lat");
                String shippingLng = request.getParameter("shipping_lng");
                String serviceType = request.getParameter("service_type");

                LOGGER.info("Processing calculateRoute with coordinates: pickupLat=" + pickupLat + ", pickupLng=" + pickupLng + ", shippingLat=" + shippingLat + ", shippingLng=" + shippingLng);

                try {
                    BigDecimal pickupLatVal = new BigDecimal(pickupLat.trim().replaceAll("[^0-9.-]", ""));
                    BigDecimal pickupLngVal = new BigDecimal(pickupLng.trim().replaceAll("[^0-9.-]", ""));
                    BigDecimal shippingLatVal = new BigDecimal(shippingLat.trim().replaceAll("[^0-9.-]", ""));
                    BigDecimal shippingLngVal = new BigDecimal(shippingLng.trim().replaceAll("[^0-9.-]", ""));

                    // Validate coordinate ranges
                    if (pickupLatVal.abs().compareTo(new BigDecimal("90")) > 0
                            || shippingLatVal.abs().compareTo(new BigDecimal("90")) > 0
                            || pickupLngVal.abs().compareTo(new BigDecimal("180")) > 0
                            || shippingLngVal.abs().compareTo(new BigDecimal("180")) > 0) {
                        LOGGER.warning("Coordinates out of valid range: pickupLat=" + pickupLat + ", pickupLng=" + pickupLng + ", shippingLat=" + shippingLat + ", shippingLng=" + shippingLng);
                        sendAjaxError(response, "Tọa độ ngoài phạm vi hợp lệ.");
                        return;
                    }

                    // Calculate distance and fetch route geometry
                    JSONObject routeData = calculateRouteAndDistance(
                            pickupLatVal.doubleValue(), pickupLngVal.doubleValue(),
                            shippingLatVal.doubleValue(), shippingLngVal.doubleValue()
                    );
                    BigDecimal distanceKm = new BigDecimal(routeData.getDouble("distance") / 1000.0)
                            .setScale(2, BigDecimal.ROUND_HALF_UP);

                    if (distanceKm.compareTo(BigDecimal.ZERO) == 0) {
                        LOGGER.warning("Unable to calculate distance at " + new java.util.Date());
                        sendAjaxError(response, "Không thể tính khoảng cách.");
                        return;
                    }

                    OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
                    Service service = orderDAO.getServiceByName(serviceType);

                    BigDecimal serviceFee = BigDecimal.ZERO;
                    if (service != null) {
                        BigDecimal basePrice = service.getBasePrice();
                        BigDecimal ratePerKm = service.getRatePerKm() != null ? service.getRatePerKm() : BigDecimal.ZERO;
                        serviceFee = basePrice.add(ratePerKm.multiply(distanceKm)).setScale(2, BigDecimal.ROUND_HALF_UP);
                    }

                    List<OrderDetail> details = (List<OrderDetail>) session.getAttribute("orderDetails");
                    BigDecimal transportFee = BigDecimal.ZERO;
                    if (details != null) {
                        for (OrderDetail detail : details) {
                            transportFee = transportFee.add(detail.getItemPrice().multiply(new BigDecimal(detail.getQuantity())))
                                    .setScale(2, BigDecimal.ROUND_HALF_UP);
                        }
                    }

                    // Calculate VAT on the sum of transportFee and serviceFee
                    BigDecimal taxableAmount = transportFee.add(serviceFee);
                    BigDecimal vatAmount = taxableAmount.multiply(VAT_RATE).setScale(2, BigDecimal.ROUND_HALF_UP);
                    BigDecimal totalFee = transportFee.add(serviceFee).add(vatAmount).setScale(2, BigDecimal.ROUND_HALF_UP);

                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    JSONObject jsonResponse = new JSONObject();
                    jsonResponse.put("distanceKm", distanceKm);
                    jsonResponse.put("transportFee", transportFee);
                    jsonResponse.put("serviceFee", serviceFee);
                    jsonResponse.put("vatAmount", vatAmount);
                    jsonResponse.put("totalFee", totalFee);
                    jsonResponse.put("routeGeometry", routeData.getJSONObject("geometry"));
                    try (PrintWriter out = response.getWriter()) {
                        out.print(jsonResponse.toString());
                        out.flush();
                    }
                    LOGGER.info("AJAX response sent successfully with route geometry at " + new java.util.Date());
                    return;
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid coordinate format: pickupLat=" + pickupLat + ", pickupLng=" + pickupLng + ", shippingLat=" + shippingLat + ", shippingLng=" + shippingLng + ": " + e.getMessage());
                    sendAjaxError(response, "Định dạng tọa độ không hợp lệ.");
                    return;
                }
            }

            String pickupAddress = request.getParameter("pickup_address");
            String shippingAddress = request.getParameter("shipping_address");
            String pickupLat = request.getParameter("pickup_lat");
            String pickupLng = request.getParameter("pickup_lng");
            String shippingLat = request.getParameter("shipping_lat");
            String shippingLng = request.getParameter("shipping_lng");
            String description = request.getParameter("description");
            String specialNote = request.getParameter("special_note");
            String serviceType = request.getParameter("service_type");
            String pickupTimeDesired = request.getParameter("pickup_time_desired");

            if (pickupTimeDesired != null && !pickupTimeDesired.isEmpty()) {
                try {
                    SimpleDateFormat inputFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                    SimpleDateFormat inputFormatNoSeconds = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
                    SimpleDateFormat outputFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                    try {
                        pickupTimeDesired = outputFormat.format(inputFormat.parse(pickupTimeDesired));
                    } catch (Exception e) {
                        pickupTimeDesired = outputFormat.format(inputFormatNoSeconds.parse(pickupTimeDesired));
                    }
                } catch (Exception e) {
                    LOGGER.warning("Invalid pickup_time_desired format: " + pickupTimeDesired + " at " + new java.util.Date());
                    request.setAttribute("errorMessage", "Định dạng thời gian không hợp lệ. Vui lòng chọn thời gian hợp lệ.");
                    setDefaultAttributes(request);
                    request.getRequestDispatcher("/transport.jsp").forward(request, response);
                    return;
                }
            }

            if (pickupAddress == null || shippingAddress == null || pickupLat == null || pickupLng == null
                    || shippingLat == null || shippingLng == null || serviceType == null || pickupTimeDesired == null) {
                LOGGER.warning("Missing required fields at " + new java.util.Date());
                request.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc.");
                setDefaultAttributes(request);
                request.getRequestDispatcher("/transport.jsp").forward(request, response);
                return;
            }

            try {
                BigDecimal pickupLatVal = new BigDecimal(pickupLat.trim().replaceAll("[^0-9.-]", ""));
                BigDecimal pickupLngVal = new BigDecimal(pickupLng.trim().replaceAll("[^0-9.-]", ""));
                BigDecimal shippingLatVal = new BigDecimal(shippingLat.trim().replaceAll("[^0-9.-]", ""));
                BigDecimal shippingLngVal = new BigDecimal(shippingLng.trim().replaceAll("[^0-9.-]", ""));

                // Calculate distance and fetch route geometry
                JSONObject routeData = calculateRouteAndDistance(
                        pickupLatVal.doubleValue(), pickupLngVal.doubleValue(),
                        shippingLatVal.doubleValue(), shippingLngVal.doubleValue()
                );
                BigDecimal distanceKm = new BigDecimal(routeData.getDouble("distance") / 1000.0)
                        .setScale(2, BigDecimal.ROUND_HALF_UP);

                if (distanceKm.compareTo(BigDecimal.ZERO) == 0) {
                    LOGGER.warning("Unable to calculate distance at " + new java.util.Date());
                    request.setAttribute("errorMessage", "Không thể tính khoảng cách.");
                    setDefaultAttributes(request);
                    request.getRequestDispatcher("/transport.jsp").forward(request, response);
                    return;
                }

                OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
                Service service = orderDAO.getServiceByName(serviceType);

                if (service == null) {
                    LOGGER.severe("Missing service for type: " + serviceType + " at " + new java.util.Date());
                    request.setAttribute("errorMessage", "Không tìm thấy dịch vụ.");
                    setDefaultAttributes(request);
                    request.getRequestDispatcher("/transport.jsp").forward(request, response);
                    return;
                }

                BigDecimal serviceFee = service.getBasePrice().add(
                        service.getRatePerKm() != null ? service.getRatePerKm().multiply(distanceKm) : BigDecimal.ZERO
                ).setScale(2, BigDecimal.ROUND_HALF_UP);

                String[] itemNames = request.getParameterValues("item_name");
                String[] quantities = request.getParameterValues("quantity");
                String[] weights = request.getParameterValues("weight_kg");
                String[] volumes = request.getParameterValues("volume_m3");
                String[] itemPrices = request.getParameterValues("item_price");
                String[] notes = request.getParameterValues("item_note");

                List<OrderDetail> details = new ArrayList<>();
                BigDecimal transportFee = BigDecimal.ZERO;
                if (itemNames != null && quantities != null && weights != null && volumes != null && itemPrices != null && notes != null) {
                    int length = Math.min(Math.min(Math.min(itemNames.length, quantities.length), weights.length), Math.min(volumes.length, Math.min(itemPrices.length, notes.length)));
                    for (int i = 0; i < length; i++) {
                        try {
                            String weightStr = weights[i] != null ? weights[i].trim().replaceAll("[^0-9.]", "") : "0";
                            String volumeStr = volumes[i] != null ? volumes[i].trim().replaceAll("[^0-9.]", "") : "0";
                            String priceStr = itemPrices[i] != null ? itemPrices[i].trim().replaceAll("[^0-9.]", "") : "0";

                            if (weightStr.isEmpty() || volumeStr.isEmpty() || priceStr.isEmpty()) {
                                LOGGER.warning("Empty numeric field at index " + i + ": weight=" + weights[i] + ", volume=" + volumes[i] + ", price=" + itemPrices[i]);
                                throw new NumberFormatException("Empty numeric field");
                            }

                            if (weightStr.split("\\.").length > 2 || volumeStr.split("\\.").length > 2 || priceStr.split("\\.").length > 2) {
                                LOGGER.warning("Invalid decimal format at index " + i + ": weight=" + weights[i] + ", volume=" + volumes[i] + ", price=" + itemPrices[i]);
                                throw new NumberFormatException("Invalid decimal format");
                            }

                            OrderDetail detail = new OrderDetail();
                            detail.setOrderId(0);
                            detail.setVolumeM3(new BigDecimal(volumeStr).setScale(2, BigDecimal.ROUND_HALF_UP));
                            detail.setItemPrice(new BigDecimal(priceStr).setScale(2, BigDecimal.ROUND_HALF_UP));
                            detail.setItemName(itemNames[i]);
                            detail.setQuantity(Integer.parseInt(quantities[i]));
                            detail.setWeightKg(new BigDecimal(weightStr).setScale(2, BigDecimal.ROUND_HALF_UP));
                            detail.setNote(notes[i]);
                            details.add(detail);
                            transportFee = transportFee.add(detail.getItemPrice().multiply(new BigDecimal(detail.getQuantity()))).setScale(2, BigDecimal.ROUND_HALF_UP);
                        } catch (NumberFormatException e) {
                            LOGGER.warning("Invalid number format at index " + i + ": weight=" + weights[i] + ", volume=" + volumes[i] + ", price=" + itemPrices[i] + ": " + e.getMessage());
                            request.setAttribute("errorMessage", "Dữ liệu số không hợp lệ (khối lượng, thể tích hoặc giá).");
                            setDefaultAttributes(request);
                            request.getRequestDispatcher("/transport.jsp").forward(request, response);
                            return;
                        }
                    }
                } else {
                    LOGGER.warning("No items provided for the order at " + new java.util.Date());
                    request.setAttribute("errorMessage", "Vui lòng thêm ít nhất một mặt hàng.");
                    setDefaultAttributes(request);
                    request.getRequestDispatcher("/transport.jsp").forward(request, response);
                    return;
                }

                // Calculate VAT on the sum of transportFee and serviceFee
                BigDecimal taxableAmount = transportFee.add(serviceFee);
                BigDecimal vatAmount = taxableAmount.multiply(VAT_RATE).setScale(2, BigDecimal.ROUND_HALF_UP);
                BigDecimal totalFee = transportFee.add(serviceFee).add(vatAmount).setScale(2, BigDecimal.ROUND_HALF_UP);

                try (Connection conn = DBConnection.getConnection()) {
                    conn.setAutoCommit(false);
                    try {
                        Orders order = new Orders();
                        order.setCustomerId(customerId);
                        order.setTransportUnitId(null);
                        order.setOrderStatus("pending");
                        order.setCreatedAt(new Timestamp(System.currentTimeMillis()));
                        order.setDeliverySchedule(Timestamp.valueOf(pickupTimeDesired));
                        order.setTotalFee(totalFee);
                        order.setDescription(description);
                        order.setSpecialNote(specialNote);
                        order.setServiceType(serviceType);
                        order.setPickupTimeDesired(Timestamp.valueOf(pickupTimeDesired));
                        order.setTransportFee(transportFee);
                        order.setServiceFee(serviceFee);
                        order.setVatAmount(vatAmount);
                        order.setDiscount(BigDecimal.ZERO);
                        order.setTotalDistanceKm(distanceKm);

                        String orderSql = "INSERT INTO Orders (customer_id, transport_unit_id, order_status, created_at, delivery_schedule, total_fee, description, special_note, service_type, pickup_time_desired, transport_fee, service_fee, vat_amount, discount, total_distance_km) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
                        int orderId;
                        try (PreparedStatement orderStmt = conn.prepareStatement(orderSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                            orderStmt.setInt(1, order.getCustomerId());
                            orderStmt.setObject(2, order.getTransportUnitId(), java.sql.Types.INTEGER);
                            orderStmt.setString(3, order.getOrderStatus());
                            orderStmt.setTimestamp(4, order.getCreatedAt());
                            orderStmt.setTimestamp(5, order.getDeliverySchedule());
                            orderStmt.setBigDecimal(6, order.getTotalFee());
                            orderStmt.setString(7, order.getDescription());
                            orderStmt.setString(8, order.getSpecialNote());
                            orderStmt.setString(9, order.getServiceType());
                            orderStmt.setTimestamp(10, order.getPickupTimeDesired());
                            orderStmt.setBigDecimal(11, order.getTransportFee());
                            orderStmt.setBigDecimal(12, order.getServiceFee());
                            orderStmt.setBigDecimal(13, order.getVatAmount());
                            orderStmt.setBigDecimal(14, order.getDiscount());
                            orderStmt.setBigDecimal(15, order.getTotalDistanceKm());
                            int rowsAffected = orderStmt.executeUpdate();
                            if (rowsAffected == 0) {
                                throw new SQLException("Failed to insert into Orders table");
                            }

                            try (ResultSet rs = orderStmt.getGeneratedKeys()) {
                                if (rs.next()) {
                                    orderId = rs.getInt(1);
                                    order.setOrderId(orderId);
                                } else {
                                    throw new SQLException("Failed to retrieve generated order_id");
                                }
                            }
                        }

                        TransportProcess process = new TransportProcess();
                        process.setOrderId(order.getOrderId());
                        process.setPickupLocation(pickupAddress);
                        process.setShippingLocation(shippingAddress);
                        process.setPickupLat(pickupLatVal);
                        process.setPickupLng(pickupLngVal);
                        process.setShippingLat(shippingLatVal);
                        process.setShippingLng(shippingLngVal);
                        process.setMapUrl(generateMapUrl(pickupLatVal, pickupLngVal, shippingLatVal, shippingLngVal));

                        String transportSql = "INSERT INTO TransportProcess (order_id, pickup_location, shipping_location, pickup_lat, pickup_lng, shipping_lat, shipping_lng, map_url) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement transportStmt = conn.prepareStatement(transportSql)) {
                            transportStmt.setInt(1, process.getOrderId());
                            transportStmt.setString(2, process.getPickupLocation());
                            transportStmt.setString(3, process.getShippingLocation());
                            transportStmt.setBigDecimal(4, process.getPickupLat());
                            transportStmt.setBigDecimal(5, process.getPickupLng());
                            transportStmt.setBigDecimal(6, process.getShippingLat());
                            transportStmt.setBigDecimal(7, process.getShippingLng());
                            transportStmt.setString(8, process.getMapUrl());
                            int rowsAffected = transportStmt.executeUpdate();
                            if (rowsAffected == 0) {
                                throw new SQLException("Failed to insert into TransportProcess table");
                            }
                        }

                        String detailSql = "INSERT INTO OrderDetail (order_id, volume_m3, item_price, item_name, quantity, weight_kg, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement detailStmt = conn.prepareStatement(detailSql)) {
                            for (OrderDetail detail : details) {
                                detail.setOrderId(order.getOrderId());
                                detailStmt.setInt(1, detail.getOrderId());
                                detailStmt.setBigDecimal(2, detail.getVolumeM3());
                                detailStmt.setBigDecimal(3, detail.getItemPrice());
                                detailStmt.setString(4, detail.getItemName());
                                detailStmt.setInt(5, detail.getQuantity());
                                detailStmt.setBigDecimal(6, detail.getWeightKg());
                                detailStmt.setString(7, detail.getNote());
                                int rowsAffected = detailStmt.executeUpdate();
                                if (rowsAffected == 0) {
                                    throw new SQLException("Failed to insert into OrderDetail table for item: " + detail.getItemName());
                                }
                            }
                        }

                        String notificationSql = "INSERT INTO Notifications (user_id, order_id, message, status, created_at, notification_type) VALUES (?, ?, ?, ?, ?, ?)";
                        try (PreparedStatement notificationStmt = conn.prepareStatement(notificationSql)) {
                            notificationStmt.setInt(1, customerId);
                            notificationStmt.setInt(2, order.getOrderId());
                            notificationStmt.setString(3, "Đặt hàng thành công! Mã đơn hàng: " + order.getOrderId());
                            notificationStmt.setString(4, "sent");
                            notificationStmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                            notificationStmt.setString(6, "reminder");
                            int rowsAffected = notificationStmt.executeUpdate();
                            if (rowsAffected == 0) {
                                LOGGER.warning("Failed to insert notification for order_id: " + order.getOrderId());
                                throw new SQLException("No rows affected for notification insertion");
                            }
                            LOGGER.info("Notification inserted successfully for order_id: " + order.getOrderId());
                        } catch (SQLException e) {
                            LOGGER.severe("Error inserting notification for order_id: " + order.getOrderId() + ": " + e.getMessage());
                            throw e;
                        }

                        conn.commit();
                        session.removeAttribute("orderDetails"); // Clear session data
                        request.setAttribute("orderId", order.getOrderId());
                        request.setAttribute("distanceKm", distanceKm);
                        request.setAttribute("transportFee", transportFee);
                        request.setAttribute("serviceFee", serviceFee);
                        request.setAttribute("vatAmount", vatAmount);
                        request.setAttribute("totalFee", totalFee);
                        request.setAttribute("successMessage", "Đặt hàng thành công! Mã đơn hàng: " + order.getOrderId());

                        LOGGER.info("Order placed successfully, forwarding to transport.jsp at " + new java.util.Date());
                        request.getRequestDispatcher("/transport.jsp").forward(request, response);
                    } catch (SQLException e) {
                        conn.rollback();
                        LOGGER.severe("Database error: " + e.getMessage() + " at " + new java.util.Date());
                        request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
                        setDefaultAttributes(request);
                        request.getRequestDispatcher("/transport.jsp").forward(request, response);
                    }
                }
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid coordinate format: pickupLat=" + pickupLat + ", pickupLng=" + pickupLng + ", shippingLat=" + shippingLat + ", shippingLng=" + shippingLng + ": " + e.getMessage());
                request.setAttribute("errorMessage", "Định dạng tọa độ không hợp lệ.");
                setDefaultAttributes(request);
                request.getRequestDispatcher("/transport.jsp").forward(request, response);
            }
        } catch (Exception e) {
            LOGGER.severe("Unexpected error: " + e.getMessage() + " at " + new java.util.Date());
            request.setAttribute("errorMessage", "Lỗi không xác định: " + e.getMessage());
            setDefaultAttributes(request);
            request.getRequestDispatcher("/transport.jsp").forward(request, response);
        }
    }

    private void setDefaultAttributes(HttpServletRequest request) {
        request.setAttribute("distanceKm", BigDecimal.ZERO);
        request.setAttribute("transportFee", BigDecimal.ZERO);
        request.setAttribute("serviceFee", BigDecimal.ZERO);
        request.setAttribute("vatAmount", BigDecimal.ZERO);
        request.setAttribute("totalFee", BigDecimal.ZERO);
    }

    private void sendAjaxError(HttpServletResponse response, String message) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        JSONObject jsonResponse = new JSONObject();
        jsonResponse.put("error", message);
        try (PrintWriter out = response.getWriter()) {
            out.print(jsonResponse.toString());
            out.flush();
        }
    }

    private JSONObject calculateRouteAndDistance(double lat1, double lng1, double lat2, double lng2) throws IOException {
        String url = String.format("http://router.project-osrm.org/route/v1/driving/%f,%f;%f,%f?overview=full&geometries=geojson", lng1, lat1, lng2, lat2);
        URL apiUrl = new URL(url);
        HttpURLConnection conn = (HttpURLConnection) apiUrl.openConnection();
        conn.setRequestMethod("GET");
        conn.setConnectTimeout(5000);
        conn.setReadTimeout(5000);
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream()))) {
            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            JSONObject json = new JSONObject(response.toString());
            if (!json.has("routes") || json.getJSONArray("routes").isEmpty()) {
                throw new IOException("No routes found in OSRM response");
            }
            JSONObject route = json.getJSONArray("routes").getJSONObject(0);
            JSONObject geometry = route.getJSONObject("geometry");
            double distance = route.getDouble("distance");
            JSONObject result = new JSONObject();
            result.put("geometry", geometry);
            result.put("distance", distance);
            return result;
        } catch (Exception e) {
            LOGGER.warning("Error calculating route and distance: " + e.getMessage() + " at " + new java.util.Date());
            throw new IOException("Failed to fetch route from OSRM: " + e.getMessage());
        } finally {
            if (conn != null) {
                conn.disconnect();
            }
        }
    }

    private String generateMapUrl(BigDecimal pickupLat, BigDecimal pickupLng, BigDecimal shippingLat, BigDecimal shippingLng) {
        return String.format("https://www.openstreetmap.org/directions?engine=graphhopper_car&route=%f,%f;%f,%f",
                pickupLat.doubleValue(), pickupLng.doubleValue(), shippingLat.doubleValue(), shippingLng.doubleValue());
    }
}
