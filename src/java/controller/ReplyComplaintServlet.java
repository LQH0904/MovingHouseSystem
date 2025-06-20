package controller;

import dao.ComplaintDAO;
import model.Complaint;
// import model.User; // Bỏ import nếu bạn không cần sử dụng User model trực tiếp trong phần này nữa
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
// import jakarta.servlet.http.HttpSession; // Bỏ import nếu bạn không cần sử dụng HttpSession trực tiếp trong phần này nữa

@WebServlet(name = "ReplyComplaintServlet", urlPatterns = {"/replyComplaint"})
public class ReplyComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private ComplaintDAO complaintDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        complaintDAO = new ComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đảm bảo mã hóa UTF-8 cho yêu cầu và phản hồi để xử lý tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");

        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                Complaint complaint = complaintDAO.getComplaintById(issueId);

                if (complaint != null) {
                    request.setAttribute("currentComplaint", complaint);
                    // Chuyển tiếp tới trang JSP hiển thị chi tiết khiếu nại để nhân viên phản hồi.
                    request.getRequestDispatcher("/page/staff/replyComplaint.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy khiếu nại với ID: " + issueId);
                    request.getRequestDispatcher("/page/staff/replyComplaint.jsp").forward(request, response);
                }

            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu issueId không phải là số hợp lệ
                request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ.");
                request.getRequestDispatcher("/page/staff/replyComplaint.jsp").forward(request, response);
            }
        } else {
            // Xử lý lỗi nếu thiếu issueId
            request.setAttribute("errorMessage", "Thiếu ID khiếu nại.");
            request.getRequestDispatcher("/page/staff/replyComplaint.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đảm bảo mã hóa UTF-8 cho yêu cầu và phản hồi
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // --- PHẦN ĐƯỢC THAY ĐỔI THEO YÊU CẦU CỦA BẠN ---
        // Loại bỏ phần lấy staffId từ session.
        // staffId sẽ được đặt là null để các trường operator_id/escalated_by_user_id trong DB có thể là NULL.
        // Cần lưu ý rằng việc này sẽ bỏ qua việc xác định người thực hiện hành động.
        Integer staffId = null; // Đặt staffId là null
        // --- KẾT THÚC PHẦN THAY ĐỔI ---

        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String replyContent = request.getParameter("replyContent");

        int issueId;
        try {
            issueId = Integer.parseInt(issueIdParam);
        } catch (NumberFormatException e) {
            // Chuyển hướng đến ComplaintServlet cho lỗi ID không hợp lệ.
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=ID_khong_hop_le");
            return;
        }

        boolean success = false;

        if ("escalated".equalsIgnoreCase(status)) {
            if (replyContent == null || replyContent.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập lý do chuyển cấp cao.");
                try {
                    request.setAttribute("currentComplaint", complaintDAO.getComplaintById(issueId));
                } catch (Exception ex) {
                    System.err.println("Error re-fetching complaint in doPost: " + ex.getMessage());
                }
                // Chuyển tiếp lại về JSP phù hợp để hiển thị lỗi và form
                request.getRequestDispatcher("/page/staff/replyComplaint.jsp").forward(request, response);
                return;
            }
            // Gọi DAO để cập nhật trạng thái khiếu nại (staffId là null)
            success = complaintDAO.updateComplaintStatusAndPriority(issueId, status, priority, replyContent, staffId);
        } else {
            // Gọi DAO để cập nhật trạng thái khiếu nại (staffId là null)
            success = complaintDAO.updateComplaintStatusAndPriority(issueId, status, priority, null, staffId);
        }

        if (success) {
            // --- PHẦN ĐƯỢC THAY ĐỔI THEO YÊU CẦU CỦA BẠN ---
            // Chuyển hướng đến trang ComplaintServlet cho tất cả các cập nhật thành công.
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=success");
            // --- KẾT THÚC PHẦN THAY ĐỔI ---
        } else {
            // Chuyển hướng đến ComplaintServlet cho tất cả các lỗi cập nhật
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=cap_nhat_that_bai");
        }
    }
}