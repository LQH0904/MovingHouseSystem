package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;

public class DeleteUserServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();
            boolean success = userDAO.deleteUser(userId);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/UserListServlet"); 
            } else {
                response.getWriter().println("Có lỗi xảy ra khi xóa người dùng.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi xử lý yêu cầu xóa.");
        }
    }
}
