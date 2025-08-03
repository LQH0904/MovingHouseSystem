package controller;

import com.google.gson.Gson;
import dao.OrderDAO2;
import model.OrderDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderDetailServlet", urlPatterns = {"/orderDetails"})
public class OrderDetailServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(OrderDetailServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String orderId = request.getParameter("orderId");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            if (orderId == null || orderId.isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"orderId is required\"}");
                LOGGER.log(Level.WARNING, "Missing orderId parameter");
                return;
            }

            int parsedOrderId;
            try {
                parsedOrderId = Integer.parseInt(orderId);
            } catch (NumberFormatException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid orderId format\"}");
                LOGGER.log(Level.WARNING, "Invalid orderId format: {0}", orderId);
                return;
            }

            OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
            List<OrderDetail> orderDetails = orderDAO.getOrderDetailsByOrderId(parsedOrderId);
            Gson gson = new Gson();
            String json = gson.toJson(orderDetails);
            response.getWriter().write(json);
            LOGGER.log(Level.INFO, "Successfully fetched order details for orderId: {0}, {1} items found", 
                       new Object[]{parsedOrderId, orderDetails.size()});
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Database error: " + e.getMessage() + "\"}");
            LOGGER.log(Level.SEVERE, "Database error fetching order details for orderId: {0}, SQL State: {1}, Error Code: {2}, Message: {3}", 
                       new Object[]{orderId, e.getSQLState(), e.getErrorCode(), e.getMessage()});
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Unexpected error: " + e.getMessage() + "\"}");
            LOGGER.log(Level.SEVERE, "Unexpected error fetching order details for orderId: {0}, {1}", 
                       new Object[]{orderId, e.getMessage()});
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet to fetch order details by order ID";
    }
}