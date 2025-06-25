package controller;

import dao.OperatorComplaintDAO;
import model.OperatorComplaint;
import model.UserComplaint;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OperatorReplyComplaintServlet", urlPatterns = {"/OperatorReplyComplaintServlet"})
public class OperatorReplyComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private OperatorComplaintDAO operatorComplaintDAO;

    private static final String LOGGED_IN_USER_SESSION_ATTR = "loggedInUser";
    private static final String STATUS_RESOLVED = "resolved";
    private static final String STATUS_CLOSED = "closed";
    private static final String UNASSIGNED_VALUE = "unassigned";

    private static final String ERROR_MESSAGE_ATTR = "errorMessage";
    private static final String SUCCESS_MESSAGE_ATTR = "successMessage";
    private static final String CURRENT_COMPLAINT_ATTR = "currentComplaint";
    private static final String OPERATORS_LIST_ATTR = "operatorsList";
    private static final String COMPLAINT_REPLIES_ATTR = "complaintReplies";

    private static final String OPERATOR_REPLY_COMPLAINT_JSP = "/page/operator/OperatorReplyComplaint.jsp";
    // Đã loại bỏ OPERATOR_COMPLAINT_LIST_REDIRECT vì không còn dùng nữa
    // private static final String OPERATOR_COMPLAINT_LIST_REDIRECT = "/operatorComplaintList"; 
    // Thay vào đó, chúng ta sẽ chuyển hướng trực tiếp về context path + "/"

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
        HttpSession session = request.getSession();

        if (issueIdParam == null || issueIdParam.trim().isEmpty()) {
            session.setAttribute(ERROR_MESSAGE_ATTR, "Thiếu ID khiếu nại để xem chi tiết.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        }

        try {
            int issueId = Integer.parseInt(issueIdParam);
            OperatorComplaint complaint = operatorComplaintDAO.getComplaintById(issueId);

            if (complaint != null) {
                request.setAttribute(CURRENT_COMPLAINT_ATTR, complaint);

                List<UserComplaint> operators = operatorComplaintDAO.getOperators();
                request.setAttribute(OPERATORS_LIST_ATTR, operators);

                List<String> replies = operatorComplaintDAO.getComplaintReplies(issueId);
                request.setAttribute(COMPLAINT_REPLIES_ATTR, replies);

                request.getRequestDispatcher(OPERATOR_REPLY_COMPLAINT_JSP).forward(request, response);
            } else {
                session.setAttribute(ERROR_MESSAGE_ATTR, "Không tìm thấy khiếu nại với ID: " + issueId + ".");
                response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
                return;
            }
        } catch (NumberFormatException e) {
            System.err.println("OperatorReplyComplaintServlet (doGet): Lỗi định dạng ID khiếu nại: " + issueIdParam + " - " + e.getMessage());
            session.setAttribute(ERROR_MESSAGE_ATTR, "ID khiếu nại không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        } catch (Exception e) {
            System.err.println("OperatorReplyComplaintServlet (doGet): Lỗi khi lấy khiếu nại hoặc operators: " + e.getMessage());
            session.setAttribute(ERROR_MESSAGE_ATTR, "Đã xảy ra lỗi khi tải chi tiết khiếu nại hoặc danh sách operator.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        UserComplaint currentUser = null;
        Integer repliedByUserId = null;

        if (session != null) {
            currentUser = (UserComplaint) session.getAttribute(LOGGED_IN_USER_SESSION_ATTR);
        }

        if (currentUser == null || currentUser.getUserId() == 0) {
            System.out.println("OperatorReplyComplaintServlet (doPost): Người dùng chưa đăng nhập hoặc session hết hạn.");
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }
        repliedByUserId = currentUser.getUserId();

        String issueIdParam = request.getParameter("issueId");
        String status = request.getParameter("status");
        String priority = request.getParameter("priority");
        String assignedToParam = request.getParameter("assignedTo");
        String replyContent = request.getParameter("replyContent");

        int issueId;
        if (issueIdParam == null || issueIdParam.trim().isEmpty()) {
            session.setAttribute(ERROR_MESSAGE_ATTR, "ID khiếu nại không tồn tại.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        }
        try {
            issueId = Integer.parseInt(issueIdParam);
        } catch (NumberFormatException e) {
            System.err.println("OperatorReplyComplaintServlet (doPost): Lỗi định dạng ID khiếu nại: " + issueIdParam + " - " + e.getMessage());
            session.setAttribute(ERROR_MESSAGE_ATTR, "ID khiếu nại không hợp lệ.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        }

        Integer assignedTo = null;
        if (assignedToParam != null && !assignedToParam.trim().isEmpty() && !UNASSIGNED_VALUE.equals(assignedToParam)) {
            try {
                assignedTo = Integer.parseInt(assignedToParam);
            } catch (NumberFormatException e) {
                System.err.println("OperatorReplyComplaintServlet (doPost): Định dạng ID operator được gán không hợp lệ: " + assignedToParam + " - " + e.getMessage());
                session.setAttribute(ERROR_MESSAGE_ATTR, "ID operator được gán không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
                return;
            }
        }
        
        if (status == null || status.trim().isEmpty() || priority == null || priority.trim().isEmpty()) {
            session.setAttribute(ERROR_MESSAGE_ATTR, "Trạng thái hoặc mức độ ưu tiên không được để trống.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        }

        if (STATUS_RESOLVED.equalsIgnoreCase(status) || STATUS_CLOSED.equalsIgnoreCase(status)) {
            if (replyContent == null || replyContent.trim().isEmpty()) {
                session.setAttribute(ERROR_MESSAGE_ATTR, "Vui lòng nhập nội dung phản hồi khi giải quyết hoặc đóng khiếu nại.");
                response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
                return;
            }
        }
        
        boolean success = operatorComplaintDAO.updateComplaintAndAddReply(issueId, status, priority, assignedTo, replyContent, repliedByUserId);

        if (success) {
            String message = "Khiếu nại đã được cập nhật và phản hồi thành công!";
            if (STATUS_RESOLVED.equalsIgnoreCase(status)) {
                message = "Khiếu nại đã được giải quyết thành công!";
            } else if (STATUS_CLOSED.equalsIgnoreCase(status)) {
                message = "Khiếu nại đã được đóng thành công!";
            } else if (assignedTo != null) {
                message = "Khiếu nại đã được gán và cập nhật thành công!";
            }
            session.setAttribute(SUCCESS_MESSAGE_ATTR, message);
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        } else {
            System.err.println("OperatorReplyComplaintServlet (doPost): Cập nhật khiếu nại thất bại cho ID: " + issueId);
            session.setAttribute(ERROR_MESSAGE_ATTR, "Cập nhật khiếu nại thất bại. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/"); // CHỈNH SỬA TẠI ĐÂY
            return;
        }
    }
}