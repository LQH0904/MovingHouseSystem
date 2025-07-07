/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.OperationPolicy;
import dao.OperationPolicyDAO;
import jakarta.servlet.annotation.WebServlet;

/**
 *
 * @author admin
 */
@WebServlet("/add-policy")
public class AddPolicyServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
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
        request.getRequestDispatcher("/page/operator/AddOperationPolicies.jsp").forward(request, response);
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
        String policyTitle = request.getParameter("policyTitle");
        String[] contents = request.getParameterValues("contents");

        StringBuilder fullContent = new StringBuilder();
        for (String content : contents) {
            if (!content.trim().isEmpty()) {
                fullContent.append(". ").append(content.trim()).append("\n");
            }

        }

        OperationPolicyDAO dao = new OperationPolicyDAO();
        int nextPolicyNumber = dao.getNextPolicyNumber();

        OperationPolicy p = new OperationPolicy(0, nextPolicyNumber, policyTitle.trim(), fullContent.toString().trim());
        dao.insertPolicy(p);

        response.sendRedirect("operation-policy");
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
