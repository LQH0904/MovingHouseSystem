/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;
import websocket.NotificationWebSocketServer;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

/**
 *
 * @author admin
 */
public class WebSocketInitializer implements ServletContextListener {
    private NotificationWebSocketServer wsServer;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        wsServer = NotificationWebSocketServer.getInstance();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (wsServer != null) {
            try {
                wsServer.stop();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}