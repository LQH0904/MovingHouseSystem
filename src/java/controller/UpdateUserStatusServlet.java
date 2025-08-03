package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Users;
import java.io.IOException;

@WebServlet(name = "UpdateUserStatusServlet", urlPatterns = {"/operator/UpdateUserStatusServlet"})
public class UpdateUserStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();

            // SỬ DỤNG PHƯƠNG THỨC MỚI getUserById1()
            Users user = userDAO.getUserById1(userId);

            if (user != null) {
                // Xác định trạng thái mới: nếu là 'active' thì đổi thành 'inactive', và ngược lại
                String newStatus = "active".equalsIgnoreCase(user.getStatus()) ? "inactive" : "active";

                // Gọi DAO để cập nhật trạng thái
                userDAO.updateUserStatus(userId, newStatus);
            }
            // Sau khi xử lý, chuyển hướng về trang danh sách người dùng
            response.sendRedirect(request.getContextPath() + "/UserListServlet");
        } catch (Exception e) {
            e.printStackTrace();
            // Có thể chuyển hướng đến một trang báo lỗi
            response.getWriter().println("Lỗi khi xử lý yêu cầu cập nhật trạng thái.");
        }
    }
}