package controller;

import dao.StorageUnitDetailDAO;
import model.StorageUnitDetail;
import dao.TransportUnitDetailDAO;
import dao.UnitRegistrationDAO;
import model.TransportUnitDetail;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/application-detail")
public class ApplicationDetailController extends HttpServlet {

    @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    String idParam = request.getParameter("id");
    String typeParam = request.getParameter("type");
    String action = request.getParameter("action");

    if (idParam == null || typeParam == null) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id or type parameter.");
        return;
    }

    try {
        int id = Integer.parseInt(idParam);
        int type = Integer.parseInt(typeParam);

        // Xử lý approve / reject
       if (action != null && (action.equals("approve") || action.equals("reject"))) {
    String registrationStatus = action.equals("approve") ? "approved" : "rejected";
    String userStatus = action.equals("approve") ? "active" : "inactive";

    boolean success = false;

    if (type == 5) { // storage
        StorageUnitDetailDAO storageDAO = new StorageUnitDetailDAO();
        success = storageDAO.updateApprovalStatus(id, registrationStatus, userStatus);
    } else if (type == 4) { // transport
        TransportUnitDetailDAO transportDAO = new TransportUnitDetailDAO();
        success = transportDAO.updateApprovalStatus(id, registrationStatus, userStatus);
    }

    if (success) {
        response.sendRedirect(request.getContextPath() + "/operator/listApplication");
    } else {
        response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Cập nhật trạng thái thất bại.");
    }
    return;
}




        // Hiển thị chi tiết
        if (type == 5) {
            StorageUnitDetailDAO storageDAO = new StorageUnitDetailDAO();
            StorageUnitDetail detail = storageDAO.getStorageUnitById(id);

            if (detail != null) {
                request.setAttribute("unit", detail);
                request.setAttribute("type", "storage");
                request.getRequestDispatcher("/page/operator/StorageUnitDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy kho lưu trữ.");
            }
        } else if (type == 4) {
            TransportUnitDetailDAO transportDAO = new TransportUnitDetailDAO();
            TransportUnitDetail detail = transportDAO.getTransportUnitById(id);

            if (detail != null) {
                request.setAttribute("unitT", detail);
                request.setAttribute("type", "transport");
                request.getRequestDispatcher("/page/operator/TransportUnitDetail.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn vị vận chuyển.");
            }
        }

    } catch (NumberFormatException e) {
        response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ.");
    }
}

}
