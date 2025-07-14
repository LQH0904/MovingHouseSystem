/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package websocket;

/**
 *
 * @author admin
 */

import org.java_websocket.WebSocket;
import org.java_websocket.handshake.ClientHandshake;
import org.java_websocket.server.WebSocketServer;
import java.net.InetSocketAddress;
import java.util.HashMap;
import java.util.Map;
import com.fasterxml.jackson.databind.ObjectMapper;
import dao.UserDAO;
import java.util.logging.Logger;

public class NotificationWebSocketServer extends WebSocketServer {
    private static final Logger LOGGER = Logger.getLogger(NotificationWebSocketServer.class.getName());
    private static NotificationWebSocketServer instance;
    private Map<Integer, WebSocket> userConnections = new HashMap<>();

    private NotificationWebSocketServer() {
        super(new InetSocketAddress(8081));
    }

    public static synchronized NotificationWebSocketServer getInstance() {
        if (instance == null) {
            instance = new NotificationWebSocketServer();
            instance.start();
        }
        return instance;
    }

    @Override
    public void onOpen(WebSocket conn, ClientHandshake handshake) {
        String userId = handshake.getResourceDescriptor().split("userId=")[1];
        userConnections.put(Integer.parseInt(userId), conn);
        LOGGER.info("WebSocket connection opened for user_id: " + userId);
    }

    @Override
    public void onClose(WebSocket conn, int code, String reason, boolean remote) {
        userConnections.values().remove(conn);
        LOGGER.info("WebSocket connection closed: " + reason);
    }

    @Override
    public void onMessage(WebSocket conn, String message) {
        // Không xử lý tin nhắn từ client
    }

    @Override
    public void onError(WebSocket conn, Exception ex) {
        LOGGER.severe("WebSocket error: " + ex.getMessage());
    }

    @Override
    public void onStart() {
        LOGGER.info("WebSocket Server started on port 8081");
    }

    public static void broadcast(String message, String notificationType, Integer orderId, int userId) {
    try {
        NotificationWebSocketServer server = getInstance();
        ObjectMapper mapper = new ObjectMapper();
        Map<String, Object> notification = new HashMap<>();
        notification.put("message", message);
        notification.put("status", notificationType);
        notification.put("orderId", orderId);
        notification.put("createdAt", System.currentTimeMillis());

        String json = mapper.writeValueAsString(notification);
        WebSocket conn = server.userConnections.get(userId);
        if (conn != null && conn.isOpen()) {
            conn.send(json);
            LOGGER.info("Broadcasted notification to user_id: " + userId);
        }

        // Gửi cho Admin
        int adminId = UserDAO.INSTANCE.getAdminUserId();
        if (adminId != -1) {
            conn = server.userConnections.get(adminId);
            if (conn != null && conn.isOpen()) {
                conn.send(json);
                LOGGER.info("Broadcasted notification to admin_id: " + adminId);
            } else {
                LOGGER.warning("Admin WebSocket connection not found or closed for admin_id: " + adminId);
            }
        } else {
            LOGGER.warning("No active admin found to broadcast notification.");
        }
    } catch (Exception e) {
        LOGGER.severe("Error broadcasting notification: " + e.getMessage());
    }
}
    
    
}