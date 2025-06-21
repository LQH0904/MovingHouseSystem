// File: src/main/java/controller/ComplaintServlet.java
package controller;

import dao.ComplaintDAO;
import model.Complaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/ComplaintServlet")
public class ComplaintServlet extends HttpServlet {

    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Đảm bảo mã hóa UTF-8 cho yêu cầu và phản hồi
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // Xử lý hành động "view" để xem chi tiết một khiếu nại
        if (action != null && action.equals("view")) {
            int issueId = 0;
            try {
                issueId = Integer.parseInt(request.getParameter("issueId"));
            } catch (NumberFormatException e) {
                System.err.println("ComplaintServlet: Định dạng ID khiếu nại không hợp lệ cho hành động xem: " + request.getParameter("issueId"));
                // Chuyển hướng về trang danh sách nếu ID không hợp lệ
                response.sendRedirect(request.getContextPath() + "/ComplaintServlet");
                return;
            }

            // Chuyển hướng tới ReplyComplaintServlet để xử lý việc xem và phản hồi
            response.sendRedirect(request.getContextPath() + "/replyComplaint?issueId=" + issueId);
            return; // Quan trọng: dừng xử lý ở đây sau khi chuyển hướng
        }
        else {
            // Xử lý hiển thị danh sách khiếu nại với tìm kiếm, lọc và phân trang
            String searchTerm = request.getParameter("search");
            String statusFilter = request.getParameter("statusFilter");
            String priorityFilter = request.getParameter("priorityFilter");

            int currentPage = 1;
            if (request.getParameter("page") != null) {
                try {
                    currentPage = Integer.parseInt(request.getParameter("page"));
                } catch (NumberFormatException e) {
                    // Đặt lại về trang 1 nếu tham số page không hợp lệ
                    currentPage = 1;
                }
            }
            int recordsPerPage = 10; // Số lượng bản ghi mỗi trang
            int offset = (currentPage - 1) * recordsPerPage;

            // Lấy tổng số khiếu nại để tính toán phân trang
            int totalComplaints = complaintDAO.getTotalComplaintCount(searchTerm, statusFilter, priorityFilter);
            int totalPages = (int) Math.ceil((double) totalComplaints / recordsPerPage);

            // Lấy danh sách khiếu nại đã được lọc và phân trang
            List<Complaint> complaints = complaintDAO.getAllComplaints(searchTerm, statusFilter, priorityFilter, offset, recordsPerPage);

            // Đặt các thuộc tính vào request để JSP có thể truy cập
            request.setAttribute("complaints", complaints);
            request.setAttribute("totalComplaints", totalComplaints);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("statusFilter", statusFilter);
            request.setAttribute("priorityFilter", priorityFilter);

            // Xử lý thông báo cập nhật (ví dụ: từ ReplyComplaintServlet chuyển hướng đến)
            String updateStatus = request.getParameter("updateStatus");
            if ("success".equals(updateStatus)) {
                request.setAttribute("updateMessage", "Cập nhật khiếu nại thành công!");
                request.setAttribute("updateMessageType", "success");
            } else if ("success_escalated".equals(updateStatus)) {
                request.setAttribute("updateMessage", "Khiếu nại đã được chuyển cấp thành công!");
                request.setAttribute("updateMessageType", "success");
            }
            else if ("error".equals(updateStatus)) {
                String errorMessage = request.getParameter("message");
                if (errorMessage == null) errorMessage = "Có lỗi xảy ra khi cập nhật khiếu nại.";
                request.setAttribute("updateMessage", "Lỗi: " + errorMessage);
                request.setAttribute("updateMessageType", "danger");
            }

            // Chuyển tiếp tới trang JSP để hiển thị danh sách
            request.getRequestDispatcher("/page/staff/ComplaintList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}