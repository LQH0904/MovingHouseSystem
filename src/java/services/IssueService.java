package services;

import dao.AttachmentDAO;
import dao.IssueDAO;
import dao.IssueHistoryDAO;
import dao.IssueLogDAO;
import dao.NotificationDAO;
import dao.SystemLogDAO;
import model.Attachment;
import model.Issue;
import model.IssueHistory;
import model.IssueLog;
import model.Notification;
import model.SystemLog;
import utils.DBConnection;

import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class IssueService {

    private IssueDAO issueDAO;
    private AttachmentDAO attachmentDAO;
    private IssueHistoryDAO issueHistoryDAO;
    private IssueLogDAO issueLogDAO;
    private NotificationDAO notificationDAO;
    private SystemLogDAO systemLogDAO;

    public IssueService() {
        this.issueDAO = new IssueDAO();
        this.attachmentDAO = new AttachmentDAO();
        this.issueHistoryDAO = new IssueHistoryDAO();
        this.issueLogDAO = new IssueLogDAO();
        this.notificationDAO = new NotificationDAO();
        this.systemLogDAO = new SystemLogDAO();
    }

    public int submitCriticalRequest(int userId, int orderId, String description) throws SQLException {
        Issue newIssue = new Issue(userId, orderId, description);
        return issueDAO.createIssue(newIssue);
    }

    public List<Issue> getCriticalRequestsByUserId(int userId) throws SQLException {
        return issueDAO.getIssuesByUserId(userId);
    }

    public List<Issue> getFilteredCriticalRequests(String statusString, String priorityString, String orderIdString, String userIdString, String startDateString, String endDateString) throws SQLException, DateTimeParseException {
        Integer orderId = null;
        if (orderIdString != null && !orderIdString.isEmpty()) {
            try {
                orderId = Integer.parseInt(orderIdString);
            } catch (NumberFormatException e) {
                System.err.println("Invalid orderId format: " + orderIdString);
            }
        }

        Integer userId = null;
        if (userIdString != null && !userIdString.isEmpty()) {
            try {
                userId = Integer.parseInt(userIdString);
            } catch (NumberFormatException e) {
                System.err.println("Invalid userId format: " + userIdString);
            }
        }

        LocalDateTime startDate = null;
        if (startDateString != null && !startDateString.isEmpty()) {
            try {
                startDate = LocalDateTime.parse(startDateString + "T00:00:00");
            } catch (DateTimeParseException e) {
                System.err.println("Invalid startDate format: " + startDateString);
                throw e;
            }
        }

        LocalDateTime endDate = null;
        if (endDateString != null && !endDateString.isEmpty()) {
            try {
                endDate = LocalDateTime.parse(endDateString + "T23:59:59");
            } catch (DateTimeParseException e) {
                System.err.println("Invalid endDate format: " + endDateString);
                throw e;
            }
        }

        return issueDAO.getFilteredIssues(statusString, priorityString, orderId, userId, startDate, endDate);
    }

    public Map<String, Object> getIssueDetails(int issueId) throws SQLException {
        Map<String, Object> details = new HashMap<>();

        Issue issue = issueDAO.getIssueById(issueId);
        if (issue == null) {
            return null;
        }
        details.put("issue", issue);

        List<Attachment> attachments = attachmentDAO.getAttachmentsByIssueId(issueId);
        details.put("attachments", attachments);

        List<IssueHistory> history = issueHistoryDAO.getHistoryByIssueId(issueId);
        details.put("history", history);

        List<IssueLog> logs = issueLogDAO.getLogsByIssueId(issueId);
        details.put("logs", logs);

        return details;
    }

    public boolean processIssueAction(int issueId, String actionType, int adminId, String reason) throws SQLException {
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);
            boolean issueStatusUpdated = issueDAO.updateIssueStatus(issueId, actionType);
            if (!issueStatusUpdated) {
                conn.rollback();
                return false;
            }

            Issue issue = issueDAO.getIssueById(issueId);
            if (issue == null) {
                conn.rollback();
                return false;
            }

            String logAction = actionType.equals("approved") ? "Approve" : "Reject";
            IssueLog issueLog = new IssueLog(issueId, logAction, LocalDateTime.now(), adminId, reason);
            boolean logCreated = issueLogDAO.createIssueLog(issueLog);
            if (!logCreated) {
                conn.rollback();
                return false;
            }

            // 3. Lưu lịch sử vào IssueHistory
            IssueHistory issueHistory = new IssueHistory(0, issueId, adminId, logAction, reason, LocalDateTime.now());
            boolean historyCreated = issueHistoryDAO.createIssueHistory(issueHistory);
            if (!historyCreated) {
                conn.rollback();
                return false;
            }

            // 4. Gửi thông báo qua Notifications cho khách hàng
            String notificationMessage = "";
            if (actionType.equals("approved")) {
                notificationMessage = "Yêu cầu của bạn về đơn hàng #" + issue.getOrderId() + " đã được phê duyệt. Lý do: " + reason;
            } else {
                notificationMessage = "Yêu cầu của bạn về đơn hàng #" + issue.getOrderId() + " đã bị từ chối. Lý do: " + reason;
            }
            Notification notification = new Notification(issue.getUserId(), issue.getOrderId(), "critical_request_result", notificationMessage, "sent");
            boolean notificationSent = notificationDAO.createNotification(notification);
            if (!notificationSent) {
                conn.rollback();
                return false;
            }

            // 5. Audit log hoạt động vào SystemLogs
            String auditAction = actionType.equals("approved") ? "Approve Critical Request" : "Reject Critical Request";
            SystemLog systemLog = new SystemLog(adminId, auditAction, "Issue ID " + issueId + ": " + reason);
            boolean systemLogCreated = systemLogDAO.createSystemLog(systemLog);
            if (!systemLogCreated) {
                conn.rollback();
                return false;
            }

            conn.commit(); // Hoàn tất transaction
            return true;

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback(); // Rollback nếu có lỗi
                } catch (SQLException ex) {
                    System.err.println("Lỗi khi rollback: " + ex.getMessage());
                }
            }
            throw e; // Ném lại lỗi để API xử lý
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true); // Đặt lại autocommit
                    conn.close();
                } catch (SQLException e) {
                    System.err.println("Lỗi khi đóng kết nối: " + e.getMessage());
                }
            }
        }
    }
}
