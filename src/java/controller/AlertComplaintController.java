package controller;

import dao.AlertComplaintDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.AlertComplaint;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "AlertComplaintController", urlPatterns = {"/operator/alert-complaint"})
public class AlertComplaintController extends HttpServlet {
    private final int PAGE_SIZE = 5; // số dòng mỗi trang

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy tham số từ request
        String name = request.getParameter("search");
        String type = request.getParameter("type");
        String pageParam = request.getParameter("page");

        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1; // Đảm bảo page luôn là số hợp lệ
            }
        }

        // Chuẩn hóa tham số 'type' để khớp với casing trong DB (nếu cần)
        // Logic này vẫn cần cho việc lọc bảng và phân trang
        String normalizedType = type;
        if (type != null && !type.isEmpty() && !type.equalsIgnoreCase("all")) {
            // Ví dụ: chuyển 'transport' -> 'Transport', 'storage' -> 'Storage'
            // Giả định rằng trong DB, 'Transport' và 'Storage' là chữ hoa đầu
            normalizedType = type.substring(0, 1).toUpperCase() + type.substring(1).toLowerCase();
        } else if (type != null && type.equalsIgnoreCase("all")) {
            normalizedType = null; // Nếu là 'all', không áp dụng filter type
        }

        AlertComplaintDAO dao = new AlertComplaintDAO();

        // Lấy danh sách đơn vị theo filter + phân trang (cho bảng)
        List<AlertComplaint> list = dao.getUnitIssueSummaryWithFilters(name, normalizedType, page, PAGE_SIZE);

        // Tính toán tổng số đơn vị thỏa điều kiện cho PHÂN TRANG (vẫn theo filter của bảng)
        int totalRecordsForPagination = dao.countTotalUnits(name, normalizedType);
        int totalPages = (int) Math.ceil((double) totalRecordsForPagination / PAGE_SIZE);

        // Tính toán TỔNG SỐ ĐƠN VỊ và TỔNG SỐ PHẢN ÁNH cho THẺ THỐNG KÊ (KHÔNG THEO FILTER)
        // Truyền null cho name và type để lấy tổng số lượng không lọc
        int totalUnitsForStats = dao.countTotalUnits(null, null);
        int totalIssuesForStats = dao.countTotalIssues(null, null);

        // Gửi dữ liệu sang JSP
        request.setAttribute("data", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUnits", totalUnitsForStats); // Sử dụng giá trị không lọc cho thẻ thống kê
        request.setAttribute("totalIssues", totalIssuesForStats); // Sử dụng giá trị không lọc cho thẻ thống kê
        request.setAttribute("search", name);
        request.setAttribute("type", type); // Giữ nguyên 'type' gốc để JSP hiển thị đúng option đã chọn
        request.getRequestDispatcher("/page/operator/AlertComplaint.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
