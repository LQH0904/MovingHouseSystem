package controller;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.FeeConfigurationDAO;
import dao.OperationPolicyDAO;
import dao.OperationProcedureDAO;
import java.util.List;
import model.FeeConfiguration;
import model.OperationPolicy;
import model.OperationProcedure;

/**
 *
 * @author admin
 */
@WebServlet("/get-policy-data")
public class GetPolicyDataServlet extends HttpServlet {

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
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet GetPolicyDataServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet GetPolicyDataServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
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
        response.setContentType("text/html;charset=UTF-8");

        OperationProcedureDAO procedureDAO = new OperationProcedureDAO();
        OperationPolicyDAO policyDAO = new OperationPolicyDAO();
        FeeConfigurationDAO feeDAO = new FeeConfigurationDAO();

        List<OperationProcedure> procedures = procedureDAO.getAllProcedures();
        List<OperationPolicy> policies = policyDAO.getAllPolicies();
        List<FeeConfiguration> fees = feeDAO.getAllFeeConfigurations();

        try (PrintWriter out = response.getWriter()) {

            out.println("<h3>Thông tin Chính sách</h3>");
            out.println("<h4>1. Quy trình hoạt động</h4>");
            if (procedures != null && !procedures.isEmpty()) {
                for (OperationProcedure p : procedures) {
                    out.println("<div class='policy-item'>");
                    out.println("<div class='title'>" + p.getStepNumber() + ". " + p.getStepTitle() + "</div>");
                    out.println("<div class='content'>" + p.getStepDescription().replaceFirst("^[\\n\\r]+", "") + "</div>");
                    out.println("</div>");
                }
            } else {
                out.println("<div class='policy-item'><div class='content'>Không có dữ liệu Quy trình hoạt động.</div></div>");
            }

            out.println("<h4>2. Chính sách hoạt động</h4>");
            if (policies != null && !policies.isEmpty()) {
                for (OperationPolicy p : policies) {
                    out.println("<div class='policy-item'>");
                    out.println("<div class='title'>" + p.getPolicyNumber() + ". " + p.getPolicyTitle() + "</div>");
                    out.println("<div class='content'>" + p.getPolicyContent() + "</div>");
                    out.println("</div>");
                }
            } else {
                out.println("<div class='policy-item'><div class='content'>Không có dữ liệu Chính sách hoạt động.</div></div>");
            }

            out.println("<h4>3. Cấu hình phí</h4>");
            if (fees != null && !fees.isEmpty()) {
                for (FeeConfiguration f : fees) {
                    out.println("<div class='policy-item'>");
                    out.println("<div class='title'>" + f.getFeeNumber() + ". " + f.getFeeType() + "</div>");
                    out.println("<div class='content'>" + f.getDescription() + "</div>");
                    out.println("</div>");
                }
            } else {
                out.println("<div class='policy-item'><div class='content'>Không có dữ liệu Cấu hình phí.</div></div>");
            }

        }
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
