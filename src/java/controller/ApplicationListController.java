package controller;

import dao.RegisterApplicationDAO;
import model.RegisterApplication;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ApplicationListController", urlPatterns = {"/operator/listApplication"})
public class ApplicationListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        if (keyword == null) {
            keyword = "";
        }

        String statusParam = request.getParameter("status");
        int statusId = -1; // -1 nghĩa là ALL

        if (statusParam != null) {
            switch (statusParam.toLowerCase()) {
                case "pending" ->
                    statusId = 1;
                case "approved" ->
                    statusId = 2;
                case "rejected" ->
                    statusId = 3;
                case "all" ->
                    statusId = -1;
            }
        }

        int page = 1;
        int pageSize = 4;

        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) {
                    page = 1;
                }
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int offset = (page - 1) * pageSize;

        RegisterApplicationDAO dao = new RegisterApplicationDAO();
        List<RegisterApplication> applications;
        int totalRecords;

        if (statusId == -1) {
            // Không lọc theo trạng thái
            applications = dao.getApplicationsPaginated(keyword, offset, pageSize);
            totalRecords = dao.countApplications(keyword);
        } else {
            // Lọc theo trạng thái
            applications = dao.getApplicationsByStatusPaginated(keyword, statusId, offset, pageSize);
            totalRecords = dao.countApplicationsByStatus(keyword, statusId);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);

        // Lấy tổng số cho các card (đếm toàn cục)
        int total = dao.countApplications("");
        int pending = dao.countApplicationsByStatus("", 1);
        int approved = dao.countApplicationsByStatus("", 2);
        int rejected = dao.countApplicationsByStatus("", 3);

        // Truyền dữ liệu sang JSP
        request.setAttribute("keyword", keyword);
        request.setAttribute("status", statusParam); // Dùng để tô đậm hoặc giữ trạng thái lọc
        request.setAttribute("applications", applications);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("total", total);
        request.setAttribute("pending", pending);
        request.setAttribute("approved", approved);
        request.setAttribute("rejected", rejected);

        request.getRequestDispatcher("/page/operator/ListApplicationRegistration.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
