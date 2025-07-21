package controller;

import dao.StorageUnitDetailDAO;
import model.StorageUnitDetail;
import dao.TransportUnitDetailDAO;
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

        if (idParam == null || typeParam == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id or type parameter.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            int type = Integer.parseInt(typeParam);

            if (type == 5) { // Type 5 = Storage Unit
                StorageUnitDetailDAO storageDAO = new StorageUnitDetailDAO();
                StorageUnitDetail detail = storageDAO.getStorageUnitById(id);

                if (detail != null) {
                    request.setAttribute("unit", detail);
                    request.setAttribute("type", "storage");
                    request.getRequestDispatcher("/page/operator/StorageUnitDetail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy kho lưu trữ.");
                }
            } else if (type == 4)  {
                TransportUnitDetailDAO transportDAO = new TransportUnitDetailDAO();
                TransportUnitDetail detailTransport = transportDAO.getTransportUnitById(id);

                if (detailTransport != null) {
                    request.setAttribute("unitT", detailTransport);
                    request.setAttribute("type", "transport");
                    request.getRequestDispatcher("/page/operator/TransportUnitDetail.jsp").forward(request, response);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy kho lưu trữ.");
                }
            }
            

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Tham số không hợp lệ.");
        }
    }
}
