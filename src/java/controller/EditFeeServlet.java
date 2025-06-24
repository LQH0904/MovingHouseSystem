/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;
import dao.FeeConfigurationDAO;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.FeeConfiguration;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;
/**
 *
 * @author admin
 */
@WebServlet("/edit-fee")
public class EditFeeServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
         int id = Integer.parseInt(request.getParameter("id"));

        FeeConfigurationDAO dao = new FeeConfigurationDAO();
        FeeConfiguration fee = dao.getById(id);

        if (fee != null) {
            request.setAttribute("id", fee.getId());
            request.setAttribute("feeType", fee.getFeeType());
            request.setAttribute("description", fee.getDescription());
            request.getRequestDispatcher("/page/operator/EditFeeConfiguration.jsp").forward(request, response);
        } else {
            response.sendRedirect("config-fee");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String feeType = request.getParameter("feeType");

        List<String> descriptions = new ArrayList<>();
        Enumeration<String> paramNames = request.getParameterNames();
        while (paramNames.hasMoreElements()) {
            String name = paramNames.nextElement();
            if (name.startsWith("desc")) {
                String value = request.getParameter(name).trim();
                if (!value.isEmpty()) {
                    descriptions.add(value);
                }
            }
        }

        StringBuilder fullDesc = new StringBuilder();
        for (String desc : descriptions) {
            fullDesc.append(". ").append(desc).append("\n");
        }

        FeeConfigurationDAO dao = new FeeConfigurationDAO();
        FeeConfiguration old = dao.getById(id);

        FeeConfiguration updated = new FeeConfiguration(
                id,
                old.getFeeNumber(),
                feeType.trim(),
                fullDesc.toString().trim()
        );

        dao.updateFeeConfiguration(updated);
        response.sendRedirect("config-fee");
    }
    }


