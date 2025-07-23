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

      // Chuẩn hóa tham số 'type':
      // - Nếu là "all" hoặc rỗng (""), coi là null (không lọc theo loại)
      // - Nếu là "transport" hoặc "storage", chuẩn hóa chữ cái đầu
      String normalizedType = null; // Default to null (no type filter)
      if (type != null && !type.trim().isEmpty() && !type.equalsIgnoreCase("all")) {
          // Only normalize if it's not empty and not "all"
          normalizedType = type.substring(0, 1).toUpperCase() + type.substring(1).toLowerCase();
      }
      // If type is null, empty string, or "all", normalizedType remains null. This is correct.

      AlertComplaintDAO dao = new AlertComplaintDAO();

      // Lấy danh sách đơn vị theo filter + phân trang (cho bảng)
      List<AlertComplaint> list = dao.getUnitIssueSummaryWithFilters(name, normalizedType, page, PAGE_SIZE);

      // Tính toán tổng số đơn vị thỏa điều kiện cho PHÂN TRANG
      int totalRecordsForPagination = dao.countTotalUnits(name, normalizedType);
      int totalPages = (int) Math.ceil((double) totalRecordsForPagination / PAGE_SIZE);

      // Tính toán TỔNG SỐ ĐƠN VỊ và TỔNG SỐ PHẢN ÁNH cho THẺ THỐNG KÊ (KHÔNG THEO FILTER)
      int totalUnitsForStats = dao.countTotalUnits(null, null);
      int totalIssuesForStats = dao.countTotalIssues(null, null);

      // Gửi dữ liệu sang JSP
      request.setAttribute("data", list);
      request.setAttribute("currentPage", page);
      request.setAttribute("totalPages", totalPages);
      request.setAttribute("totalUnits", totalUnitsForStats);
      request.setAttribute("totalIssues", totalIssuesForStats);
      request.setAttribute("search", name);
      request.setAttribute("type", type);
      request.getRequestDispatcher("/page/operator/AlertComplaint.jsp").forward(request, response);
  }

  @Override
  protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
      doGet(request, response);
  }
}
