package controller;

import dao.OrderDAO2;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name="OrderHistoryServlet", urlPatterns={"/orderHistory"})
public class OrderHistoryServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(OrderHistoryServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            LOGGER.log(Level.INFO, "No session or user not logged in, redirecting to login at {0}", new java.util.Date());
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        Users user = (Users) session.getAttribute("acc");
        if (user.getRoleId() != 6) {
            LOGGER.log(Level.WARNING, "User with role_id {0} attempted to access order history page at {1}", new Object[]{user.getRoleId(), new java.util.Date()});
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only customers can access this page");
            return;
        }

        int pageSize = 7; 
        int currentPage = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        LOGGER.log(Level.INFO, "Forwarding to orderHistory.jsp for user_id: {0}, page: {1} at {2}", new Object[]{user.getUserId(), currentPage, new java.util.Date()});
        request.getRequestDispatcher("/orderHistory.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("acc") == null) {
            LOGGER.log(Level.INFO, "No session or user not logged in, rejecting request at {0}", new java.util.Date());
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please login first");
            return;
        }
        Users user = (Users) session.getAttribute("acc");
        if (user.getRoleId() != 6) {
            LOGGER.log(Level.WARNING, "User with role_id {0} attempted to confirm delivery at {1}", new Object[]{user.getRoleId(), new java.util.Date()});
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Only customers can confirm delivery");
            return;
        }

        // Get current page to redirect back to it
        String pageParam = request.getParameter("page");
        int currentPage = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        String orderIdStr = request.getParameter("orderId");
        try {
            int orderId = Integer.parseInt(orderIdStr);
            OrderDAO2 orderDAO = OrderDAO2.INSTANCE;
            boolean success = orderDAO.confirmOrderDelivery(orderId, user.getUserId());
            if (success) {
                request.setAttribute("successMessage", "Xác nhận giao hàng thành công cho đơn hàng: " + orderId);
                LOGGER.log(Level.INFO, "Order {0} confirmed as delivered by user_id: {1} at {2}", new Object[]{orderId, user.getUserId(), new java.util.Date()});
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy đơn hàng hoặc đơn hàng không ở trạng thái đang xử lý.");
                LOGGER.log(Level.WARNING, "Failed to confirm delivery for order_id: {0} by user_id: {1} at {2}", new Object[]{orderId, user.getUserId(), new java.util.Date()});
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid orderId format: {0} at {1}", new Object[]{orderIdStr, new java.util.Date()});
            request.setAttribute("errorMessage", "Mã đơn hàng không hợp lệ.");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while confirming order {0}: {1} at {2}", new Object[]{orderIdStr, e.getMessage(), new java.util.Date()});
            request.setAttribute("errorMessage", "Lỗi cơ sở dữ liệu: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/orderHistory?page=" + currentPage);
    }
}