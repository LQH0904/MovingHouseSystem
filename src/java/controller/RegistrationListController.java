
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
        
        System.out.println("=== Registration Controller ===");
        
        
        try {
            // Lấy dữ liệu từ DAO
            RegistrationDAO dao = new RegistrationDAO();
            List<RegistrationItem> registrations = dao.getAllRegistrations();
            
            // Debug log
            System.out.println("Found " + registrations.size() + " registrations");
            
            // Đặt dữ liệu vào request
            request.setAttribute("registrations", registrations);
            request.setAttribute("totalCount", registrations.size());
            
            
            // Forward đến JSP - theo cấu trúc thư mục của bạn
            request.getRequestDispatcher("/page/ListApplicationRegistration.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Controller Error: " + e.getMessage());
            e.printStackTrace();
            
            // Trả về lỗi đơn giản
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>Lỗi: " + e.getMessage() + "</h1>");
        }
    }
}
