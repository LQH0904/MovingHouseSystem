/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.reportSummary;

import dao.DAOReports;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Vector;
import model.Reports;

/**
 *
 * @author Admin
 */
@WebServlet(name = "TransportUnitController", urlPatterns = {"/TransportUnitController"})
public class TransportUnitController extends HttpServlet {

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
        response.setContentType("text/html;charset=UTF-8");
        DAOReports dao = new DAOReports();
        HttpSession session = request.getSession(true);
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            if (service == null) {
                service = "listTransportUnit";
            }
            if (service.equals("listTransportUnit")) {
                Vector<Reports> vector;
                String sort = request.getParameter("sort");
                String reportTitle = request.getParameter("reportTitle");
                if (sort != null && sort.equals("desc")) {
                    vector = dao.getReports("SELECT * FROM dbo.TransportUnits as tu join dbo.TransportReport as tp on tu.transport_unit_id = tp.transport_unit_id ORDER BY created_at DESC");
                } else if (reportTitle != null && !reportTitle.isEmpty()) {
                    vector = dao.getReports(
                            "SELECT * FROM Reports WHERE title LIKE '%" + reportTitle + "%'"
                    );
                } else {
                    vector = dao.getReports("select * from dbo.TransportUnits as tu join dbo.TransportReport as tp on tu.transport_unit_id = tp.transport_unit_id;");
                }
                request.setAttribute("transportUnitData", vector);
                RequestDispatcher dis = request.getRequestDispatcher("page/operator/homeOperator.jsp");
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
        protected void doGet
        (HttpServletRequest request, HttpServletResponse response)
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
        protected void doPost
        (HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
            processRequest(request, response);
        }

        /**
         * Returns a short description of the servlet.
         *
         * @return a String containing servlet description
         */
        @Override
        public String getServletInfo
        
            () {
        return "Short description";
        }// </editor-fold>

    }
