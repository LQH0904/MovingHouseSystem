package controller;

import dao.OrderDAO;
import model.Orders;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderListServlet", urlPatterns = {"/orderList"})
public class OrderListServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(OrderListServlet.class.getName());
    private static final int ORDERS_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Lấy tham số lọc, tìm kiếm, sắp xếp
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String transportUnitName = request.getParameter("transportUnitName");
        String warehouseName = request.getParameter("warehouseName");
        String orderId = request.getParameter("orderId");
        String sortBy = request.getParameter("sortBy");
        String sortOrder = request.getParameter("sortOrder");
        int page = 1;

        // Xử lý tham số page
        try {
            String pageStr = request.getParameter("page");
            if (pageStr != null) {
                page = Integer.parseInt(pageStr);
                if (page < 1) {
                    page = 1;
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid page number format: " + request.getParameter("page"), e);
            page = 1;
        }

        // Validate đầu vào
        String errorMessage = null;
        boolean hasValidationError = false;

        // Validate orderId
        if (orderId != null && !orderId.trim().isEmpty()) {
            try {
                int id = Integer.parseInt(orderId);
                if (id <= 1) {
                    errorMessage = "ID đơn hàng phải lớn hơn 1.";
                    hasValidationError = true;
                }
            } catch (NumberFormatException e) {
                errorMessage = "ID đơn hàng phải là số.";
                hasValidationError = true;
            }
        }

        // Validate transportUnitName
        if (transportUnitName != null && !transportUnitName.trim().isEmpty()) {
            if (!transportUnitName.matches("^[a-zA-Z0-9\\s]+$")) {
                errorMessage = "Tên đơn vị vận chuyển chỉ được chứa chữ cái, số và khoảng trắng.";
                hasValidationError = true;
            }
        }

        // Validate warehouseName
        if (warehouseName != null && !warehouseName.trim().isEmpty()) {
            if (!warehouseName.matches("^[a-zA-Z0-9\\s]+$")) {
                errorMessage = "Tên đơn vị kho bãi chỉ được chứa chữ cái, số và khoảng trắng.";
                hasValidationError = true;
            }
        }

        List<Orders> orders = null;
        int totalPages = 0;

        if (!hasValidationError) {
            // Lấy danh sách đơn hàng nếu không có lỗi validate
            OrderDAO dao = OrderDAO.INSTANCE;
            List<Orders> allOrders = dao.getOrderList(status, startDate, endDate, transportUnitName, warehouseName,
                    orderId, sortBy, sortOrder);

            // Kiểm tra kết quả trả về
            if (allOrders.isEmpty()) {
                if (orderId != null && !orderId.trim().isEmpty()) {
                    errorMessage = "Không tìm thấy ID đơn hàng.";
                } else if (transportUnitName != null && !transportUnitName.trim().isEmpty()) {
                    errorMessage = "Không tìm thấy tên đơn vị vận chuyển.";
                } else if (warehouseName != null && !warehouseName.trim().isEmpty()) {
                    errorMessage = "Không tìm thấy tên đơn vị kho bãi.";
                }
            }

            // Phân trang
            int totalOrders = allOrders.size();
            totalPages = (int) Math.ceil((double) totalOrders / ORDERS_PER_PAGE);
            int startIndex = (page - 1) * ORDERS_PER_PAGE;
            int endIndex = Math.min(startIndex + ORDERS_PER_PAGE, totalOrders);
            orders = allOrders.subList(startIndex, endIndex);

            // Lưu trạng thái hiện tại vào session để sử dụng lại nếu có lỗi
            session.setAttribute("lastOrders", allOrders);
            session.setAttribute("lastStatus", status);
            session.setAttribute("lastStartDate", startDate);
            session.setAttribute("lastEndDate", endDate);
            session.setAttribute("lastTransportUnitName", transportUnitName);
            session.setAttribute("lastWarehouseName", warehouseName);
            session.setAttribute("lastOrderId", orderId);
            session.setAttribute("lastSortBy", sortBy);
            session.setAttribute("lastSortOrder", sortOrder);
            session.setAttribute("lastPage", page);
            session.setAttribute("lastTotalPages", totalPages);
        } else {
            // Nếu có lỗi validate, sử dụng dữ liệu từ trạng thái trước đó
            List<Orders> lastOrders = (List<Orders>) session.getAttribute("lastOrders");
            if (lastOrders != null) {
                // Phân trang lại dựa trên trạng thái trước đó
                int totalOrders = lastOrders.size();
                totalPages = (int) Math.ceil((double) totalOrders / ORDERS_PER_PAGE);
                int startIndex = (page - 1) * ORDERS_PER_PAGE;
                int endIndex = Math.min(startIndex + ORDERS_PER_PAGE, totalOrders);
                orders = lastOrders.subList(startIndex, endIndex);

                // Khôi phục các tham số trước đó
                status = (String) session.getAttribute("lastStatus");
                startDate = (String) session.getAttribute("lastStartDate");
                endDate = (String) session.getAttribute("lastEndDate");
                transportUnitName = (String) session.getAttribute("lastTransportUnitName");
                warehouseName = (String) session.getAttribute("lastWarehouseName");
                orderId = (String) session.getAttribute("lastOrderId");
                sortBy = (String) session.getAttribute("lastSortBy");
                sortOrder = (String) session.getAttribute("lastSortOrder");
                page = (Integer) session.getAttribute("lastPage");
                totalPages = (Integer) session.getAttribute("lastTotalPages");
            } else {
                // Nếu không có trạng thái trước đó, trả về danh sách mặc định
                OrderDAO dao = OrderDAO.INSTANCE;
                List<Orders> allOrders = dao.getOrderList(null, null, null, null, null, null, null, null);
                int totalOrders = allOrders.size();
                totalPages = (int) Math.ceil((double) totalOrders / ORDERS_PER_PAGE);
                int startIndex = (page - 1) * ORDERS_PER_PAGE;
                int endIndex = Math.min(startIndex + ORDERS_PER_PAGE, totalOrders);
                orders = allOrders.subList(startIndex, endIndex);

                // Lưu trạng thái mặc định vào session
                session.setAttribute("lastOrders", allOrders);
                session.setAttribute("lastStatus", null);
                session.setAttribute("lastStartDate", null);
                session.setAttribute("lastEndDate", null);
                session.setAttribute("lastTransportUnitName", null);
                session.setAttribute("lastWarehouseName", null);
                session.setAttribute("lastOrderId", null);
                session.setAttribute("lastSortBy", null);
                session.setAttribute("lastSortOrder", null);
                session.setAttribute("lastPage", page);
                session.setAttribute("lastTotalPages", totalPages);
            }
        }

        // Truyền dữ liệu sang JSP
        request.setAttribute("orders", orders);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("transportUnitName", transportUnitName);
        request.setAttribute("warehouseName", warehouseName);
        request.setAttribute("orderId", orderId);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        if (errorMessage != null) {
            request.setAttribute("errorMessage", errorMessage);
        }

        request.getRequestDispatcher("page/staff/viewOrderList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
