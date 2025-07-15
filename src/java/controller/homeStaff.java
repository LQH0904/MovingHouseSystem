/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import dao.HomePageDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.HashMap;
import java.util.Map;

/**
 *
 * @author admin
 */
@WebServlet(name="homeStaff", urlPatterns={"/homeStaff"})
public class homeStaff extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        try {
            HomePageDAO userDAO = new HomePageDAO();

            // Lấy tổng số user
            int totalUsers = userDAO.getTotalUserCount();

            // Lấy số user theo từng role
            Map<String, Integer> usersByRole = userDAO.getUserCountByRole();

            // Lấy số lượng issue theo trạng thái
            Map<String, Integer> issueStats = userDAO.getIssueCountByStatus();
            request.setAttribute("issueStats", issueStats);

            // THÊM DÒNG NÀY - Lấy roleIds
            Map<String, Integer> roleIds = userDAO.getRoleIds();

            // Lấy 5 user đầu tiên
            Map<String, String> topUsers = userDAO.getTop5UsersWithStatus();
            request.setAttribute("topUsers", topUsers);
            request.setAttribute("roleIds", roleIds); // lấy roleID
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("usersByRole", usersByRole);

            request.getRequestDispatcher("page/operator/homeOperator.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace(); // In lỗi ra console để debug
            request.setAttribute("totalUsers", 0);
            request.setAttribute("roleIds", new HashMap<>());  // lấy roleID
            request.setAttribute("usersByRole", new HashMap<>()); // Thêm dòng này
            request.setAttribute("topUsers", new HashMap<>());
            request.setAttribute("issueStats", new HashMap<>());
            request.getRequestDispatcher("page/staff/homeStaff.jsp").forward(request, response);
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
        return "Home Operator Controller with User Statistics";
    }// </editor-fold>

}
