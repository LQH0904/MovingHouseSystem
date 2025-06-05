/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RegistrationDAO;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RegistrationItem;

/**
 *
 * @author Admin
 */
public class ApplicationDetailController extends HttpServlet {

    private RegistrationDAO dao = new RegistrationDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String type = request.getParameter("type");

            RegistrationItem item = dao.getRegistrationByIdAndType(id, type);
            request.setAttribute("registration", item);

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/page/admin/ApplicationRegistrationDetail.jsp").forward(request, response);
    }
}
