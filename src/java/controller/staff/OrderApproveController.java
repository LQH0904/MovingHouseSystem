package controller.staff;

import dao.staff.TransportOrderDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.OrderInfo;

import java.io.IOException;
import java.util.List;
import model.TransportOrder;

@WebServlet(name = "OrderApprove", urlPatterns = {"/staff/order-approve"})
public class OrderApproveController extends HttpServlet {

    TransportOrderDAO dao = new TransportOrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        String idParam = request.getParameter("id");

        if (action == null) {
            // ✅ Lấy danh sách đơn hàng đang pending
            List<OrderInfo> pendingOrders = dao.getPendingOrders();
            request.setAttribute("orders", pendingOrders);  // key là "orders"
            request.getRequestDispatcher("/page/staff/ListOrderApprove.jsp").forward(request, response);

        } else if ("detail".equals(action) && idParam != null) {
            int orderId = Integer.parseInt(idParam);
            OrderInfo order = dao.getOrderInfo(orderId);
            // ✅ Tìm đơn vị gần nhất
            TransportOrder nearestUnit = dao.findNearestTransportUnit(order.getPickupLocation());

            request.setAttribute("order", order);
            request.setAttribute("nearestUnit", nearestUnit);  // ✅ THÊM DÒNG NÀY

            request.getRequestDispatcher("/page/staff/OrderApproveDetail.jsp").forward(request, response);
        }
    }

    @Override
protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    int orderId = Integer.parseInt(request.getParameter("orderId"));

    // Lấy thông tin đơn hàng để lấy customerId
    OrderInfo order = dao.getOrderInfo(orderId);
    int customerId = order.getCustomerId(); // ✅ Lấy customerId

    boolean success = false;
    try {
        success = dao.assignNearestUnit(orderId, customerId);  // ✅ Truyền thêm customerId
    } catch (Exception e) {
        e.printStackTrace();
    }

    if (success) {
        request.setAttribute("message", "✅ Gán đơn vị vận chuyển thành công!");
    } else {
        request.setAttribute("error", "❌ Gán đơn vị vận chuyển thất bại!");
    }

    // Lấy lại thông tin đơn hàng sau khi gán (cập nhật trạng thái mới)
    order = dao.getOrderInfo(orderId);
    TransportOrder nearestUnit = dao.findNearestTransportUnit(order.getPickupLocation());

    request.setAttribute("order", order);
    request.setAttribute("nearestUnit", nearestUnit);
    request.getRequestDispatcher("/page/staff/OrderApproveDetail.jsp").forward(request, response);
}


}