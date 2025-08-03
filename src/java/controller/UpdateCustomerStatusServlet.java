package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Users;
import java.io.IOException;

// =================================================================
// TÊN SERVLET VÀ URL PATTERN ĐÃ ĐƯỢC ĐỔI TÊN
// =================================================================
@WebServlet(name = "UpdateCustomerStatusServlet", urlPatterns = {"/staff/UpdateCustomerStatusServlet"})
public class UpdateCustomerStatusServlet extends HttpServlet { // <-- ĐỔI TÊN CLASS

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();
            Users user = userDAO.getUserById1(userId);

            // Vẫn giữ logic kiểm tra chỉ tác động lên Khách hàng (roleId = 6)
            if (user != null && user.getRoleId() == 6) {
                String newStatus = "active".equalsIgnoreCase(user.getStatus()) ? "inactive" : "active";
                userDAO.updateUserStatus(userId, newStatus);
            } else {
                System.out.println("Cảnh báo: Có hành vi cố gắng thay đổi trạng thái của user không phải khách hàng từ tài khoản Staff.");
            }

            response.sendRedirect(request.getContextPath() + "/CustomerListServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi xử lý yêu cầu cập nhật trạng thái.");
        }
    }
}