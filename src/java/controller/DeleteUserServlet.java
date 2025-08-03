package controller;

import dao.UserDAO;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "DeleteUserServlet", urlPatterns = {"/operator/DeleteUserServlet"})
public class DeleteUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int userId = Integer.parseInt(request.getParameter("id"));
            UserDAO userDAO = new UserDAO();

            // Gọi DAO để xóa người dùng
            boolean success = userDAO.deleteUser(userId);

            if (!success) {
                // Nếu xóa không thành công, bạn có thể muốn ghi log hoặc thêm thông báo
                System.out.println("Xóa người dùng với ID " + userId + " không thành công. Kiểm tra log server để biết chi tiết.");
            }
            
            // Dù thành công hay không, vẫn chuyển hướng về trang danh sách
            response.sendRedirect(request.getContextPath() + "/UserListServlet");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi khi xử lý yêu cầu xóa.");
        }
    }
}