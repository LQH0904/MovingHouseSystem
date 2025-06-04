/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RegistrationDAO;
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

    private RegistrationDAO dao;

    @Override
    public void init() throws ServletException {
        super.init();
        dao = new RegistrationDAO();
    }

   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idStr = request.getParameter("id");
            String type = request.getParameter("type");

            if (idStr == null || type == null) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing id or type parameter");
                return;
            }

            int id = Integer.parseInt(idStr);

            RegistrationItem item = dao.getRegistrationDetail(id, type);

            if (item == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Registration not found");
                return;
            }

            // Đặt đối tượng vào request để JSP sử dụng
            request.setAttribute("registration", item);

            // Forward đến trang detail (ví dụ: registrationDetail.jsp)
            request.getRequestDispatcher("/page/ApplicationRegistrationDetail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid id format");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Server error");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
