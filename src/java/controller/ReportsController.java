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
import model.DAOReports;
import entity.Reports;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpSession;
import java.util.Vector;

/**
 *
 * @author Admin
 */
@WebServlet(name = "ReportsController", urlPatterns = {"/repURL"})
public class ReportsController extends HttpServlet {

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
        DAOReports dao = new DAOReports();
        HttpSession session = request.getSession(true);
        try (PrintWriter out = response.getWriter()) {
            String service = request.getParameter("service");
            if (service == null) {
                service = "listReports";
            }
            if (service.equals("listReports")) {
                Vector<Reports> vector;
                String sort = request.getParameter("sort");
                String reportTitle = request.getParameter("reportTitle");
                if (sort != null && sort.equals("desc") && reportTitle != null && !reportTitle.isEmpty()) {
                    vector = dao.getReports(
                            "SELECT * FROM Reports WHERE title LIKE '%" + reportTitle + "%' ORDER BY created_at DESC"
                    );
                } else if (sort != null && sort.equals("desc")) {
                    vector = dao.getReports("SELECT * FROM Reports ORDER BY created_at DESC");
                } else if (reportTitle != null && !reportTitle.isEmpty()) {
                    vector = dao.getReports(
                            "SELECT * FROM Reports WHERE title LIKE '%" + reportTitle + "%'"
                    );
                } else {
                    vector = dao.getReports("SELECT * FROM Reports");
                }
                request.setAttribute("reportsData", vector);
                RequestDispatcher dis = request.getRequestDispatcher("/Layout/listReports.jsp");
                dis.forward(request, response);
            }

            if (service.equals("viewDetail")) {
                String reportId = request.getParameter("reportId");
                if (reportId != null && !reportId.isEmpty()) {
                    Vector<Reports> vector = dao.getReports(
                            "select * from Reports where report_id = " + reportId
                    );
                    if (!vector.isEmpty()) {
                        request.setAttribute("reportDetail", vector);
                    }
                }
                // Chuyển hướng đến trang chi tiết
                RequestDispatcher dis = request.getRequestDispatcher("/Layout/reportDetail.jsp");
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
