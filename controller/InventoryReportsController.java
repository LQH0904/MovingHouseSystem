/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DAOInventoryReports;
import entity.InventoryReports;
import jakarta.servlet.RequestDispatcher;
import java.util.Vector;

/**
 *
 * @author Admin
 */
@WebServlet(name = "InventoryReportsController", urlPatterns = {"/invRURL"})
public class InventoryReportsController extends HttpServlet {

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
        DAOInventoryReports dao = new DAOInventoryReports();
        HttpSession session = request.getSession(true);
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            if (service == null) {
                service = "listInventoryReports";
            }
            if (service.equals("listInventoryReports")) {
                Vector<InventoryReports> vector;
                String submit = request.getParameter("submit");
                if (submit == null) {//list all
                    vector = dao.getInventoryReports("select * from InventoryReports;");
                } else {//search
                    String invRTitle = request.getParameter("invRTitle");
                    vector = dao.getInventoryReports("select * from InventoryReports where title like '%" + invRTitle + "%'");
                }
                request.setAttribute("inventoryReportsData", vector);
                RequestDispatcher dis = request.getRequestDispatcher("/operator/listInventoryReports.jsp");
                dis.forward(request, response);
            }
            if (service.equals("viewDetail")) {
                String reportId = request.getParameter("reportId");
                if (reportId != null && !reportId.isEmpty()) {
                    Vector<InventoryReports> vector = dao.getInventoryReports(
                        "select * from InventoryReports where report_id = " + reportId
                    );
                    if (!vector.isEmpty()) {
                        request.setAttribute("invReportDetail", vector);
                    }
                }
                // Chuyển hướng đến trang chi tiết
                RequestDispatcher dis = request.getRequestDispatcher("/operator/inventoryReportDetail.jsp");
                dis.forward(request, response);
            }
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
        return "Short description";
    }// </editor-fold>

}
