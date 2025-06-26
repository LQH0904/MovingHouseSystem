package controller;

import dao.UserDAO;
import model.User;
import model.Role;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.Timestamp;
import java.util.Date;

public class AddUserServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        String passwordHash = password;

        Role role = new Role(roleId, "");

        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPasswordHash(passwordHash);
        newUser.setEmail(email);
        newUser.setRole(role);
        newUser.setStatus("active");

        newUser.setCreatedAt(new Timestamp(new Date().getTime()));

        UserDAO userDAO = new UserDAO();
        boolean success = userDAO.addUser(newUser);

        if (success) {
            if (roleId == 6) {
                // Nếu là customer thì về trang danh sách khách hàng cho staff
                response.sendRedirect(request.getContextPath() + "/CustomerListServlet");
            } else {
                // Còn lại thì operator xử lý như cũ
                response.sendRedirect(request.getContextPath() + "/UserListServlet");
            }
        } else {
            response.getWriter().println("Có lỗi xảy ra khi thêm người dùng.");
        }

    }
}
