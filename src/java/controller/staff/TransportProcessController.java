package controller.staff;

import dao.staff.OrderDAO;
import dao.staff.TransportProcessDAO;
import model.Order;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import model.TransportProcess;

@WebServlet(name = "TransportProcessController", urlPatterns = {"/order/process/*"})
public class TransportProcessController extends HttpServlet {


   @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {

    String pathInfo = request.getPathInfo(); // "/123"

    if (pathInfo == null || pathInfo.equals("/")) {
        request.setAttribute("error", "Không tìm thấy mã đơn hàng.");
        request.getRequestDispatcher("/page/staff/TransportProcess.jsp").forward(request, response);
        return;
    }

    try {
        int orderId = Integer.parseInt(pathInfo.substring(1));

        TransportProcessDAO dao = new TransportProcessDAO();
        TransportProcess process = dao.getTransportProcessByOrderId(orderId);

        OrderDAO orderDAO = new OrderDAO(); // bạn cần class này
        Order order = orderDAO.getOrderById(orderId); // giả sử bạn có hàm này

        if (process == null) {
            request.setAttribute("error", "Không tìm thấy thông tin vận chuyển cho đơn hàng #" + orderId);
        } else {
            request.setAttribute("process", process);
        }

        if (order != null) {
            request.setAttribute("order", order);
        }

        request.getRequestDispatcher("/page/staff/TransportProcess.jsp").forward(request, response);

    } catch (NumberFormatException e) {
        request.setAttribute("error", "Mã đơn hàng không hợp lệ.");
        request.getRequestDispatcher("/page/staff/TransportProcess.jsp").forward(request, response);
    }
}

}
