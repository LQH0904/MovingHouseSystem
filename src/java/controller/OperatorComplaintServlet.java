package controller;

import dao.OperatorComplaintDAO; // Đã đổi import
import model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/OperatorComplaintServlet")
public class OperatorComplaintServlet extends HttpServlet {

    private OperatorComplaintDAO operatorComplaintDAO; // Đã đổi tên biến

    @Override
    public void init() throws ServletException {
        super.init();
        operatorComplaintDAO = new OperatorComplaintDAO(); // Đã khởi tạo OperatorComplaintDAO
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if (action != null && action.equals("view")) {
            int issueId = 0;
            try {
                issueId = Integer.parseInt(request.getParameter("issueId"));
            } catch (NumberFormatException e) {
                System.err.println("OperatorComplaintServlet: Invalid issue ID format for view action: " + request.getParameter("issueId"));
                response.sendRedirect(request.getContextPath() + "/OperatorComplaintServlet");
                return;
            }

            // Chuyển hướng đến Servlet xử lý chi tiết/phản hồi riêng cho Operator
            // Đảm bảo OperatorReplyComplaintServlet tồn tại và xử lý issueId
            response.sendRedirect(request.getContextPath() + "/OperatorReplyComplaintServlet?issueId=" + issueId);
            return;
        }
        else {
            String searchTerm = request.getParameter("search");
            // String statusFilter = "escalated"; // KHÔNG CẦN THIẾT NỮA VÌ ĐÃ CỐ ĐỊNH TRONG DAO
            String priorityFilter = request.getParameter("priorityFilter");

            int currentPage = 1;
            if (request.getParameter("page") != null) {
                try {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    currentPage = 1; // Mặc định về trang 1 nếu lỗi
                }
            }
            int recordsPerPage = 10;
            int offset = (currentPage - 1) * recordsPerPage;

            // Gọi phương thức DAO đã được sửa để lấy tổng số lượng khiếu nại cấp cao
            // Đã thay đổi đối số: không còn statusFilter
            int totalComplaints = operatorComplaintDAO.getTotalEscalatedComplaintCount(searchTerm, priorityFilter);
            int totalPages = (int) Math.ceil((double) totalComplaints / recordsPerPage);

            // Gọi phương thức DAO đã được sửa để lấy danh sách khiếu nại cấp cao
            // Đã thay đổi đối số: không còn statusFilter
            List<Complaint> complaints = operatorComplaintDAO.getAllEscalatedComplaints(searchTerm, priorityFilter, offset, recordsPerPage);

            request.setAttribute("complaints", complaints);
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", "escalated"); // Vẫn truyền để giữ nhất quán trên JSP nếu cần hiển thị
            request.setAttribute("priorityFilter", priorityFilter);

            String updateStatus = request.getParameter("updateStatus");
            if ("success".equals(updateStatus)) {
                request.setAttribute("updateMessage", "Cập nhật khiếu nại thành công!");
                request.setAttribute("updateMessageType", "success");
            } else if ("error".equals(updateStatus)) {
                String errorMessage = request.getParameter("message");
                if (errorMessage == null) errorMessage = "Có lỗi xảy ra khi cập nhật khiếu nại.";
                request.setAttribute("updateMessage", "Lỗi: " + errorMessage);
                request.setAttribute("updateMessageType", "danger");
            }

            // Chuyển tiếp đến JSP riêng cho Operator
            request.getRequestDispatcher("/page/operator/OperatorComplaintList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}