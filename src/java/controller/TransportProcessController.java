package controller;

import dao.OrderDAO;
import dao.TransportProcessDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import model.TransportProcess;

@WebServlet(name = "TransportProcessController", urlPatterns = {"/order/detail/*"})
public class TransportProcessController extends HttpServlet {

     private OrderDAO orderDAO;
    private TransportProcessDAO transportProcessDAO;

    @Override
    public void init() {
        orderDAO = new OrderDAO();
        transportProcessDAO = new TransportProcessDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String pathInfo = request.getPathInfo(); // /5
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu ID đơn hàng.");
            return;
        }

        try {
            int orderId = Integer.parseInt(pathInfo.substring(1)); // bỏ dấu "/"

            // Lấy thông tin đơn hàng
            Order order = orderDAO.getOrderById(orderId);

            // Lấy thông tin quy trình vận chuyển
            TransportProcess tp = transportProcessDAO.getByOrderId(orderId);

            if (order != null) {
                request.setAttribute("order", order);
                request.setAttribute("tp", tp); // có thể là null, JSP nên kiểm tra trước khi hiển thị
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
