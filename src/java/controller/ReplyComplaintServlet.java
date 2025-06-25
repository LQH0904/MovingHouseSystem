package controller;

import dao.ComplaintDAO; // Đảm bảo đúng import
import model.Complaint; // Đảm bảo đúng import
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

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

        Integer staffId = null; // Đặt staffId là null (hoặc lấy từ session nếu có)

        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String replyContent = request.getParameter("replyContent"); // Lấy giá trị nếu có, nhưng sẽ không lưu vào DB

        int issueId;
        try {
            issueId = Integer.parseInt(issueIdParam);
        } catch (NumberFormatException e) {
            // Chuyển hướng đến ComplaintServlet cho lỗi ID không hợp lệ.
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=ID_khong_hop_le");
            return;
        }

        boolean success = false;

        // Trong ComplaintDAO.java hiện tại, updateComplaintStatusAndPriority KHÔNG nhận replyContent
        // Nếu bạn muốn lưu replyContent, bạn CẦN THÊM cột reply_content vào bảng Issues TRONG DATABASE
        // và chỉnh sửa phương thức updateComplaintStatusAndPriority trong ComplaintDAO cho phù hợp.
        // Hiện tại, chúng ta chỉ cập nhật status và priority.
        success = complaintDAO.updateComplaintStatusAndPriority(issueId, status, priority, null, staffId); // replyContent và staffId hiện tại sẽ là null

        if (success) {
            // Chuyển hướng đến trang ComplaintServlet cho tất cả các cập nhật thành công.
            String redirectUrl = request.getContextPath() + "/ComplaintServlet?updateStatus=success";
            if ("escalated".equalsIgnoreCase(status)) {
                 redirectUrl = request.getContextPath() + "/ComplaintServlet?updateStatus=success_escalated";
            }
            response.sendRedirect(redirectUrl);
        } else {
            // Chuyển hướng đến ComplaintServlet cho tất cả các lỗi cập nhật
            response.sendRedirect(request.getContextPath() + "/ComplaintServlet?updateStatus=error&message=cap_nhat_that_bai");
        }
    }
}