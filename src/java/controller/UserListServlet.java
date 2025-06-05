package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.util.List;

public class UserListServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String roleIdParam = request.getParameter("roleId");

            UserDAO userDAO = new UserDAO();
            List<User> users = userDAO.getAllUsers();  

            if (roleIdParam != null && !roleIdParam.isEmpty() && !roleIdParam.equals("")) {
                int roleId = Integer.parseInt(roleIdParam);
                users = users.stream().filter(user -> user.getRole().getRoleId() == roleId).toList();
            }

            request.setAttribute("users", users);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/UserList.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Có lỗi khi xử lý danh sách người dùng.");
        }
    }
}
