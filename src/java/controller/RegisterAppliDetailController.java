/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RegisterApplicationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RegisterApplicationDetail;

/**
 *
 * @author Admin
 */
public class RegisterAppliDetailController extends HttpServlet {

    private RegisterApplicationDAO dao;

    @Override
    public void init() throws ServletException {
        dao = new RegisterApplicationDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        try {
            int applicationId = Integer.parseInt(idParam);
            RegisterApplicationDetail detail = dao.getApplicationDetailById(applicationId);

            if (detail != null) {
                request.setAttribute("detail", detail);
                request.getRequestDispatcher("/page/operator/ApplicationRegistrationDetail.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy đơn đăng ký với ID = " + applicationId);
                
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID không hợp lệ: " + idParam);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
