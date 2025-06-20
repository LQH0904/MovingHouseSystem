package controller.staff;

import dao.staff.OrderDetailDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OrderDetail;

import java.io.IOException;

@WebServlet(name = "OrderDetailController", urlPatterns = {"/order/detailid/*"})
public class OrderDetailController extends HttpServlet {

    private OrderDetailDAO orderDetailDAO;

    @Override
    public void init() {
        orderDetailDAO = new OrderDetailDAO();
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
            int orderId = Integer.parseInt(pathInfo.substring(1)); // loại bỏ dấu "/"

            // Lấy thông tin chi tiết đơn hàng
            OrderDetail orderDetail = orderDetailDAO.getOrderDetailById(orderId);

            if (orderDetail != null) {
                request.setAttribute("orderDetail", orderDetail);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/page/staff/OrderDetail.jsp");
                dispatcher.forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng.");
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ.");
        }
    }
}
