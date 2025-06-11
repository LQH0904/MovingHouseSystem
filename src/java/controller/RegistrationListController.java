package controller;

import dao.RegistrationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import model.RegistrationItem;

public class RegistrationListController extends HttpServlet {

   protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            RegistrationDAO dao = new RegistrationDAO();
            List<RegistrationItem> registrations = dao.getAllRegistrations();            
            System.out.println("Found " + registrations.size() + " registrations");
            
            int totalCount = registrations.size();
            int pendingCount = 0;
            int approvedCount = 0;
            int rejectedCount = 0;

            for (RegistrationItem item : registrations) {
                String status = item.getRegistrationStatus();
                if (status != null) {
                    switch (status.toLowerCase()) {
                        case "pending":
                            pendingCount++;
                            break;
                        case "approved":
                            approvedCount++;
                            break;
                        case "rejected":
                            rejectedCount++;
                            break;
                        default:
                            
                            break;
                    }
                }
            }            
            request.setAttribute("registrations", registrations);
            request.setAttribute("totalCount", totalCount);
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            
            request.getRequestDispatcher("/page/admin/ListApplicationRegistration.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Controller Error: " + e.getMessage());
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>Lỗi: " + e.getMessage() + "</h1>");
        }
    }
}
