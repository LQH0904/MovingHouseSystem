package controller;

import dao.OrderDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet(name = "TransportProcessController", urlPatterns = {"/order/detail/*"})
public class TransportProcessController extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Lấy orderId từ URL: /order/detail/123
        String pathInfo = request.getPathInfo(); // /123
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID đơn hàng.");
            return;
        }

        try {
            int orderId = Integer.parseInt(pathInfo.substring(1)); // bỏ dấu "/"
            Order order = orderDAO.getOrderById(orderId);

            if (order != null) {
                request.setAttribute("order", order);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/TransportProcess.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ.");
        }
    }

}
