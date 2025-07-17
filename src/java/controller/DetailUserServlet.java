/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.DAOStorageUnit1;
import dao.DAOTransportUnit1;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.sql.SQLException;
import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import model.StorageUnit1;
import model.TransportUnit1;

/**
 *
 * @author admin
 */
@WebServlet("/DetailUserServlet")
public class DetailUserServlet extends HttpServlet {

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
        String userIdParam = request.getParameter("id");

        if (userIdParam == null || userIdParam.isEmpty()) {
            response.sendRedirect("UserListServlet");
            return;
        }

        int userId = Integer.parseInt(userIdParam);
        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserById(userId);

        if (user == null) {
            response.sendRedirect("UserListServlet");
            return;
        }

        int roleId = user.getRole().getRoleId();
        request.setAttribute("user", user);

        if (roleId == 4) { // Transport Unit
            DAOTransportUnit1 daoTU = new DAOTransportUnit1();
            TransportUnit1 tu = daoTU.getTransportUnitByUserId(userId);
            request.setAttribute("transportUnit", tu);
            request.getRequestDispatcher("/page/operator/TransportUnitDetail.jsp").forward(request, response);

        } else if (roleId == 5) { // Storage Unit
            DAOStorageUnit1 daoSU = new DAOStorageUnit1();
            StorageUnit1 su = daoSU.getStorageUnitByUserId(userId); // bạn sẽ viết hàm này
            request.setAttribute("storageUnit", su);
            request.getRequestDispatcher("/page/operator/StorageUnitDetail.jsp").forward(request, response);
        } else {
            // Customer, Staff, Operator
            request.getRequestDispatcher("/page/operator/UserDetail.jsp").forward(request, response);
        }
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
