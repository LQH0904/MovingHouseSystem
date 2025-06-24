package controller;

import dao.OperatorComplaintDAO;
import model.OperatorComplaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "OperatorReplyComplaintServlet", urlPatterns = {"/OperatorReplyComplaintServlet"})
public class OperatorReplyComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO operatorComplaintDAO;

    @Override
    public void init() throws ServletException {
        operatorComplaintDAO = new OperatorComplaintDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");

        if (issueIdParam != null && !issueIdParam.isEmpty()) {
            try {
                int issueId = Integer.parseInt(issueIdParam);
                OperatorComplaint complaint = operatorComplaintDAO.getComplaintById(issueId);

                if (complaint != null) {
                    request.setAttribute("currentComplaint", complaint);
                    request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                } else {
                    request.setAttribute("errorMessage", "Không tìm thấy khiếu nại với ID: " + issueId);
                    request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("errorMessage", "ID khiếu nại không hợp lệ.");
                request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("errorMessage", "Thiếu ID khiếu nại.");
            request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String assignedToParam = request.getParameter("assignedTo"); // Có thể là ID operator hoặc "unassigned"

        int issueId;
        try {
            issueId = Integer.parseInt(issueIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=error&message=ID_khong_hop_le");
            return;
        }

        Integer assignedTo = null;
        if (assignedToParam != null && !assignedToParam.isEmpty() && !assignedToParam.equals("unassigned")) {
            try {
                assignedTo = Integer.parseInt(assignedToParam);
            } catch (NumberFormatException e) {
                // Xử lý lỗi nếu assignedTo không phải là số hợp lệ
                System.err.println("OperatorReplyComplaintServlet: Định dạng ID operator được gán không hợp lệ: " + assignedToParam);
                response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=error&message=ID_operator_khong_hop_le");
                return;
            }
        }

        boolean success = false;
        String updateStatusMessage = "";

        // Kiểm tra logic tương tự như bạn có trong ComplaintServlet
        // Ví dụ: Nếu chuyển trạng thái thành "resolved" hoặc "closed", có thể yêu cầu replyContent không trống
        String replyContent = request.getParameter("replyContent"); // Lấy giá trị, nhưng hiện tại không lưu vào DB

        if ("resolved".equalsIgnoreCase(status) || "closed".equalsIgnoreCase(status)) {
            if (replyContent == null || replyContent.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Vui lòng nhập nội dung phản hồi khi giải quyết/đóng khiếu nại.");
                try {
                    request.setAttribute("currentComplaint", operatorComplaintDAO.getComplaintById(issueId));
                } catch (Exception ex) {
                    System.err.println("Error re-fetching complaint in doPost: " + ex.getMessage());
                }
                request.getRequestDispatcher("/page/operator/OperatorReplyComplaint.jsp").forward(request, response);
                return;
            }
        }

        // Gọi phương thức DAO mới để cập nhật
        success = operatorComplaintDAO.updateOperatorComplaint(issueId, status, priority, assignedTo);

        if (success) {
            if ("resolved".equalsIgnoreCase(status)) {
                updateStatusMessage = "success";
            } else if ("closed".equalsIgnoreCase(status)) {
                updateStatusMessage = "success";
            } else if (assignedTo != null) {
                updateStatusMessage = "success_assigned"; // Tùy chỉnh thông báo nếu chỉ gán
            } else {
                updateStatusMessage = "success"; // Thông báo chung cho các cập nhật khác
            }
            response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=" + updateStatusMessage);
        } else {
            response.sendRedirect(request.getContextPath() + "/operatorComplaintList?updateStatus=error&message=cap_nhat_that_bai");
        }
    }
}