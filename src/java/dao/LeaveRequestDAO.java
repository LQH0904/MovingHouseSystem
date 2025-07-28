package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.LeaveRequest;

public class LeaveRequestDAO {

    private Connection connection;

    public LeaveRequestDAO(Connection connection) {
        this.connection = connection;
    }

    // Tạo đơn xin nghỉ mới
    public boolean createLeaveRequest(LeaveRequest request) throws SQLException {
        String sql = "INSERT INTO LeaveRequests (staff_id, start_date, end_date, number_of_days_off, reason, status, created_at) "
                + "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";

        try (PreparedStatement stmt = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, request.getStaffId());
            stmt.setDate(2, new java.sql.Date(request.getStartDate().getTime()));
            stmt.setDate(3, new java.sql.Date(request.getEndDate().getTime()));
            stmt.setInt(4, request.getNumberOfDaysOff()); // ✅ mới thêm dòng này
            stmt.setString(5, request.getReason());
            stmt.setString(6, request.getStatus());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows == 0) {
                return false;
            }

            try (ResultSet generatedKeys = stmt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    request.setRequestId(generatedKeys.getInt(1));
                }
            }
            return true;
        }
    }

    // Lấy danh sách đơn xin nghỉ của nhân viên
    public List<LeaveRequest> getLeaveRequestsByStaff(int staffId) throws SQLException {
        List<LeaveRequest> requests = new ArrayList<>();
        String sql = "SELECT lr.*, s.full_name as staff_name FROM LeaveRequests lr "
                + "JOIN Staff s ON lr.staff_id = s.staff_id "
                + "WHERE lr.staff_id = ? ORDER BY lr.created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, staffId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LeaveRequest request = mapRowToLeaveRequest(rs);
                request.setStaffName(rs.getString("staff_name"));
                requests.add(request);
            }
        }
        return requests;
    }

    // Lấy tất cả đơn xin nghỉ (cho operator)
    public List<LeaveRequest> getAllLeaveRequests() throws SQLException {
        List<LeaveRequest> requests = new ArrayList<>();
        String sql = "SELECT lr.*, s.full_name as staff_name FROM LeaveRequests lr "
                + "JOIN Staff s ON lr.staff_id = s.staff_id "
                + "ORDER BY lr.status, lr.created_at DESC";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                LeaveRequest request = mapRowToLeaveRequest(rs);
                request.setStaffName(rs.getString("staff_name"));
                requests.add(request);
            }
        }
        return requests;
    }

    // Cập nhật trạng thái đơn xin nghỉ
    public boolean updateLeaveRequestStatus(int requestId, String status, String reply, int operatorId) throws SQLException {
        String sql = "UPDATE LeaveRequests SET status = ?, operator_reply = ?, operator_id = ?, updated_at = GETDATE() "
                + "WHERE request_id = ?";

        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setString(2, reply);
            stmt.setInt(3, operatorId);
            stmt.setInt(4, requestId);

            return stmt.executeUpdate() > 0;
        }
    }

    // Lấy đơn xin nghỉ theo ID
    public LeaveRequest getLeaveRequestById(int requestId) throws SQLException {
        String sql = "SELECT lr.*, u.username AS staff_name " +
             "FROM LeaveRequests lr " +
             "JOIN Users u ON lr.staff_id = u.user_id " +
             "WHERE lr.request_id = ?";


        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, requestId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                LeaveRequest leaveRequest = new LeaveRequest();
                leaveRequest.setRequestId(rs.getInt("request_id"));
                leaveRequest.setStaffId(rs.getInt("staff_id"));
                leaveRequest.setStaffName(rs.getString("staff_name"));
                leaveRequest.setStartDate(rs.getDate("start_date"));
                leaveRequest.setEndDate(rs.getDate("end_date"));
                leaveRequest.setReason(rs.getString("reason"));
                leaveRequest.setStatus(rs.getString("status"));
                leaveRequest.setOperatorReply(rs.getString("operator_reply"));
                leaveRequest.setOperatorId(rs.getInt("operator_id"));
                leaveRequest.setCreatedAt(rs.getTimestamp("created_at"));
                leaveRequest.setUpdatedAt(rs.getTimestamp("updated_at"));

                // ⚠️ QUAN TRỌNG: set số ngày nghỉ
                leaveRequest.setNumberOfDaysOff(rs.getInt("number_of_days_off"));

                return leaveRequest;
            }
        }
        return null;
    }

    private LeaveRequest mapRowToLeaveRequest(ResultSet rs) throws SQLException {
        LeaveRequest request = new LeaveRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setStaffId(rs.getInt("staff_id"));
        request.setStartDate(rs.getDate("start_date"));
        request.setEndDate(rs.getDate("end_date"));
        request.setReason(rs.getString("reason"));
        request.setStatus(rs.getString("status"));
        request.setOperatorReply(rs.getString("operator_reply"));
        request.setOperatorId(rs.getInt("operator_id"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        request.setUpdatedAt(rs.getTimestamp("updated_at"));
        return request;
    }
}
