
package controller.staff;

import dao.staff.OrderDetailItemDAO;
import model.OrderDetailItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderDetailItemController", urlPatterns = {"/order/detail/item/*"})
public class OrderDetailItemController extends HttpServlet {
    private static final int PAGE_SIZE = 5; 

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    try {
        // Lấy orderId từ URL path
        String pathInfo = request.getPathInfo(); // /5
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu orderId");
            return;
        }

        int orderId = Integer.parseInt(pathInfo.substring(1)); // bỏ dấu "/"

        // Lấy keyword và page từ query string
        int page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
        String keyword = request.getParameter("keyword");
        if (keyword == null) keyword = "";

        int offset = (page - 1) * PAGE_SIZE;

        OrderDetailItemDAO dao = new OrderDetailItemDAO();
        List<OrderDetailItem> orderDetails = dao.getFilteredOrderDetails(orderId, keyword, offset, PAGE_SIZE);
        int totalRecords = dao.countOrderDetails(orderId, keyword);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);

        request.setAttribute("orderId", orderId);
        request.setAttribute("orderDetails", orderDetails);
        request.setAttribute("keyword", keyword);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/page/staff/DetailItem.jsp").forward(request, response);

    } catch (Exception e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lỗi tham số hoặc hệ thống");
    }
}

}
