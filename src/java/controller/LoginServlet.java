/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.UserDAO;
import model.Users;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.Timestamp;

/**
 *
 * @author admin
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

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
        request.getRequestDispatcher("page/login/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO dao = new UserDAO();
        Users user = dao.getAccountLoginByEmail(email, password);

        if (user != null) {
            HttpSession session = request.getSession();
            HttpSession oldSession = request.getSession(false);
            if (oldSession != null) {
                oldSession.invalidate();
            }

            // Tạo session mới
            HttpSession newSession = request.getSession(true);
            newSession.setAttribute("acc", user);
            newSession.setAttribute("username", user.getUsername());
            newSession.setAttribute("email", user.getEmail());

            switch (user.getRoleId()) {
                case 1: // Admin
                    if ("active".equalsIgnoreCase(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "/page/admin/ListApplicationRegistration.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                    break;
                case 2: // Operator
                    if ("active".equalsIgnoreCase(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "/admin/ListApplicationRegistration.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                    break;
                case 3: // Staff
                    if ("active".equalsIgnoreCase(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "admin/ListApplicationRegistration.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                    break;
                case 4: // Transport Unit
                    if ("active".equalsIgnoreCase(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "admin/ListApplicationRegistration.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                    break;
                case 5: // Storage Unit
                    if ("active".equalsIgnoreCase(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "admin/ListApplicationRegistration.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                    break;
                case 6: // Customer
                    if ("active".equalsIgnoreCase(user.getStatus())) {
                        response.sendRedirect(request.getContextPath() + "admin/ListApplicationRegistration.jsp");
                    } else {
                        response.sendRedirect("error.jsp");
                    }
                    break;
                default:
                    response.sendRedirect("error.jsp");
                    break;
            }

        } else {
            request.setAttribute("mess", "Wrong email or password!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Login processing servlet";
    }
    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */

}
