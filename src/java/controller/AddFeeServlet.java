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
import model.FeeConfiguration;

import java.io.IOException;
import dao.FeeConfigurationDAO;
import jakarta.servlet.annotation.WebServlet;

/**
 *
 * @author admin
 */
@WebServlet("/add-fee")
public class AddFeeServlet extends HttpServlet {

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
        request.getRequestDispatcher("/page/operator/AddFeeConfigurations.jsp").forward(request, response);
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
        String feeType = request.getParameter("feeType");

        String[] descriptions = request.getParameterValues("descriptions");

        StringBuilder fullDesc = new StringBuilder();

        for (String desc : descriptions) {
            if (!desc.trim().isEmpty()) {
                fullDesc.append(". ").append(desc.trim()).append("\n");
            }
        }

        FeeConfigurationDAO dao = new FeeConfigurationDAO();
        int nextFeeNumber = dao.getNextFeeNumber();

        FeeConfiguration fee = new FeeConfiguration(0, nextFeeNumber, feeType.trim(), fullDesc.toString().trim());
        dao.insertFee(fee);

        response.sendRedirect("config-fee");
    }

}

/**
 * Returns a short description of the servlet.
 *
 * @return a String containing servlet description
 */
