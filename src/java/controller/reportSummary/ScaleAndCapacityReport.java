/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reportSummary;

import dao.DAOTransportUnit;
import model.TransportUnit;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Vector;

/**
 * Servlet xử lý báo cáo quy mô và năng lực vận tải
 * @author Admin
 */
@WebServlet(name = "ScaleAndCapacityReport", urlPatterns = {"/ScaleAndCapacityReport"})
public class ScaleAndCapacityReport extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(true);
        
        String service = request.getParameter("service");
        
        if (service == null) {
            service = "listScaleAndCapacity";
        }
        
        switch (service) {
            case "listScaleAndCapacity":
                listScaleAndCapacity(request, response);
                break;
            case "filterByLocation":
                filterByLocation(request, response);
                break;
            case "filterByScale":
                filterByScale(request, response);
                break;
            default:
                listScaleAndCapacity(request, response);
                break;
        }
    }
    
    /**
     * Lấy danh sách tất cả đơn vị vận tải với thông tin quy mô và năng lực
     */
    private void listScaleAndCapacity(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Khởi tạo DAO
            DAOTransportUnit daoTransportUnit = new DAOTransportUnit();
            
            // Lấy dữ liệu từ database - chỉ lấy các đơn vị đã được duyệt
            String sql = "SELECT * FROM TransportUnits WHERE registration_status = 'approved' " +
                        "ORDER BY capacity DESC, vehicle_count DESC";
            
            Vector<TransportUnit> transportUnitData = daoTransportUnit.getReports(sql);
            
            // Debug log
            System.out.println("ScaleAndCapacityReport - transportUnitData size: " + 
                             (transportUnitData != null ? transportUnitData.size() : "null"));
            
            if (transportUnitData != null && !transportUnitData.isEmpty()) {
                for (TransportUnit unit : transportUnitData) {
                    System.out.println("Unit: " + unit.getCompanyName() + 
                                     ", Vehicles: " + unit.getVehicleCount() + 
                                     ", Capacity: " + unit.getCapacity());
                }
            }
            
            // Đặt dữ liệu vào request attributes
            request.setAttribute("transportUnitData", transportUnitData);
            
            // Forward đến JSP
            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/reportSummary/scaleTransportDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi tải dữ liệu: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/reportSummary/scaleTransportDetail.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * Lọc đơn vị vận tải theo địa điểm
     */
    private void filterByLocation(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String location = request.getParameter("location");
            
            DAOTransportUnit daoTransportUnit = new DAOTransportUnit();
            
            String sql = "SELECT * FROM TransportUnits WHERE registration_status = 'approved'";
            if (location != null && !location.trim().isEmpty() && !location.equals("all")) {
                sql += " AND location = '" + location + "'";
            }
            sql += " ORDER BY capacity DESC, vehicle_count DESC";
            
            Vector<TransportUnit> transportUnitData = daoTransportUnit.getReports(sql);
            
            System.out.println("Filter by location SQL: " + sql);
            System.out.println("Results: " + (transportUnitData != null ? transportUnitData.size() : 0));
            
            request.setAttribute("transportUnitData", transportUnitData);
            request.setAttribute("selectedLocation", location);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/reportSummary/scaleTransportDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lọc dữ liệu: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/reportSummary/scaleTransportDetail.jsp");
            dispatcher.forward(request, response);
        }
    }
    
    /**
     * Lọc đơn vị vận tải theo quy mô
     */
    private void filterByScale(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String scale = request.getParameter("scale");
            
            DAOTransportUnit daoTransportUnit = new DAOTransportUnit();
            
            String sql = "SELECT * FROM TransportUnits WHERE registration_status = 'approved'";
            
            // Phân loại quy mô dựa trên số lượng xe và năng lực
            if (scale != null && !scale.equals("all")) {
                switch (scale) {
                    case "large":
                        sql += " AND vehicle_count >= 20 AND capacity >= 20";
                        break;
                    case "medium":
                        sql += " AND ((vehicle_count >= 15 AND vehicle_count < 20) OR (capacity >= 15 AND capacity < 20))";
                        break;
                    case "small":
                        sql += " AND vehicle_count < 15 AND capacity < 15";
                        break;
                }
            }
            sql += " ORDER BY capacity DESC, vehicle_count DESC";
            
            Vector<TransportUnit> transportUnitData = daoTransportUnit.getReports(sql);
            
            System.out.println("Filter by scale SQL: " + sql);
            System.out.println("Results: " + (transportUnitData != null ? transportUnitData.size() : 0));
            
            request.setAttribute("transportUnitData", transportUnitData);
            request.setAttribute("selectedScale", scale);
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/reportSummary/scaleTransportDetail.jsp");
            dispatcher.forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Lỗi khi lọc dữ liệu: " + e.getMessage());
            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/reportSummary/scaleTransportDetail.jsp");
            dispatcher.forward(request, response);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet xử lý báo cáo quy mô và năng lực vận tải";
    }// </editor-fold>
}