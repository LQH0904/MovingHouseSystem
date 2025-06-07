/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.RegisterApplicationDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import java.util.List;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.RegisterApplicationDTO;


public class ApplicationListController extends HttpServlet {

    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ApplicationListController</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ApplicationListController at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        RegisterApplicationDAO dao = new RegisterApplicationDAO();
        List<RegisterApplicationDTO> applications = dao.getAllApplications();
        
        // Đếm theo status_id
    int total = applications.size();
    int pending = 0;
    int approved = 0;
    int rejected = 0;

    for (RegisterApplicationDTO app : applications) {
        int statusId = app.getStatus_id();

        switch (statusId) {
            case 1 -> pending++;
            case 2 -> approved++;
            case 3 -> rejected++;
        }
    }

    // Set attribute cho JSP
   
    request.setAttribute("total", total);
    request.setAttribute("pending", pending);
    request.setAttribute("approved", approved);
    request.setAttribute("rejected", rejected);
        
        // Gửi dữ liệu đến JSP
        request.setAttribute("applications", applications);
        
        // Forward  trang JSP
        request.getRequestDispatcher("/page/operator/ListApplicationRegistration.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

   
}
