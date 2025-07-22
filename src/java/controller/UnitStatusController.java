package controller;

import dao.StorageUnitDetailDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/operator/application-status")
public class UnitStatusController extends HttpServlet {
    
    private final StorageUnitDetailDAO storageUnitDAO = new StorageUnitDetailDAO(); // Đảm bảo bạn đã tạo class DAO này

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action"); // "approve" hoặc "reject"
        String idStr = request.getParameter("id");     // ID của đơn vị
        String type = request.getParameter("type");    // "storage" hoặc "transport"

        if (action == null || idStr == null || type == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu tham số.");
            return;
        }

        int unitId;
        try {
            unitId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID không hợp lệ.");
            return;
        }

        // Xác định trạng thái tương ứng
        String newRegistrationStatus = action.equals("approve") ? "approved" : "rejected";
        String newUserStatus = action.equals("approve") ? "active" : "inactive";

        boolean success = false;

        if (type.equals("storage")) {
            success = storageUnitDAO.updateApprovalStatus(unitId, newRegistrationStatus, newUserStatus);
        } else if (type.equals("transport")) {
            // Bạn cần có thêm `TransportUnitDAO` với method tương tự để xử lý loại này
            // TransportUnitDAO transportDAO = new TransportUnitDAO();
            // success = transportDAO.updateApprovalStatus(unitId, newRegistrationStatus, newUserStatus);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Loại đơn vị không hợp lệ.");
            return;
        }

        if (success) {
            // Điều hướng về trang danh sách đơn vị sau khi cập nhật
            response.sendRedirect(request.getContextPath() + "/operator/listApplication");
        } else {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật trạng thái thất bại.");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response); // Cho phép GET gọi lại POST
    }
}
