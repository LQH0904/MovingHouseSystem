/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.OrderDAO;
import model.Orders;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
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
        // Lấy tham số lọc, tìm kiếm, sắp xếp
        String status = request.getParameter("status");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String transportUnitName = request.getParameter("transportUnitName"); // Thay transportUnitId bằng transportUnitName
        String warehouseName = request.getParameter("warehouseName"); // Thay storageUnitId bằng warehouseName
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
                    page = 1; // Đảm bảo page không âm
                }
            }
        } catch (NumberFormatException e) {
            LOGGER.log(Level.WARNING, "Invalid page number format: " + request.getParameter("page"), e);
            page = 1; // Mặc định page = 1 nếu lỗi
        }

        // Lấy danh sách đơn hàng
        OrderDAO dao = OrderDAO.INSTANCE;
        List<Orders> allOrders = dao.getOrderList(status, startDate, endDate, transportUnitName, warehouseName,
                orderId, sortBy, sortOrder);

        // Phân trang
        int totalOrders = allOrders.size();
        int totalPages = (int) Math.ceil((double) totalOrders / ORDERS_PER_PAGE);
        int startIndex = (page - 1) * ORDERS_PER_PAGE;
        int endIndex = Math.min(startIndex + ORDERS_PER_PAGE, totalOrders);
        List<Orders> orders = allOrders.subList(startIndex, endIndex);

        // Truyền dữ liệu sang JSP
        request.setAttribute("orders", orders);
        request.setAttribute("status", status);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("transportUnitName", transportUnitName); // Cập nhật tên thuộc tính
        request.setAttribute("warehouseName", warehouseName); // Cập nhật tên thuộc tính
        request.setAttribute("orderId", orderId);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("page/staff/viewOrderList.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
