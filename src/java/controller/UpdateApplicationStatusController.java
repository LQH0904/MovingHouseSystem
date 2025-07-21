package controller;

import dao.StorageUnitDetailDAO;
import dao.TransportUnitDetailDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet({"/update-storage-status", "/update-transport-status"})
public class UpdateStatusController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private StorageUnitDetailDAO storageUnitDAO;
    private TransportUnitDetailDAO transportUnitDAO;
    
    @Override
    public void init() throws ServletException {
        super.init();
        storageUnitDAO = new StorageUnitDetailDAO();
        transportUnitDAO = new TransportUnitDetailDAO();
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String servletPath = request.getServletPath();
        
        try {
            if ("/update-storage-status".equals(servletPath)) {
                handleStorageStatusUpdate(request, response);
            } else if ("/update-transport-status".equals(servletPath)) {
                handleTransportStatusUpdate(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                "An error occurred while updating status");
        }
    }
    
    /**
     * Xử lý cập nhật trạng thái Storage Unit
     */
    private void handleStorageStatusUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String storageUnitIdStr = request.getParameter("storage_unit_id");
        String action = request.getParameter("registration_status");
        
        if (storageUnitIdStr == null || action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Missing required parameters");
            return;
        }
        
        try {
            int storageUnitId = Integer.parseInt(storageUnitIdStr);
            String status = "pending".equals(action) ? "approved" : "rejected";
            
            boolean success = storageUnitDAO.updateRegistrationStatus(storageUnitId, status);
            
            if (success) {
                // Redirect về trang chi tiết với thông báo thành công
                response.sendRedirect(request.getContextPath() + 
                    "/application-detail?id=" + storageUnitId + "&type=5&status=updated");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Failed to update storage unit status");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Invalid storage unit ID format");
        }
    }
    
    /**
     * Xử lý cập nhật trạng thái Transport Unit
     */
    private void handleTransportStatusUpdate(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String transportUnitIdStr = request.getParameter("transport_unit_id");
        String action = request.getParameter("action");
        
        if (transportUnitIdStr == null || action == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Missing required parameters");
            return;
        }
        
        try {
            int transportUnitId = Integer.parseInt(transportUnitIdStr);
            String status = "approve".equals(action) ? "approved" : "rejected";
            
            boolean success = transportUnitDAO.updateRegistrationStatus(transportUnitId, status);
            
            if (success) {
                // Redirect về trang chi tiết với thông báo thành công
                response.sendRedirect(request.getContextPath() + 
                    "/application-detail?id=" + transportUnitId + "&type=4&status=updated");
            } else {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Failed to update transport unit status");
            }
            
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, 
                "Invalid transport unit ID format");
        }
    }
}
