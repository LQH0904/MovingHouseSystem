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
            int page = 1;
            int recordsPerPage = 15;

            String pageParam = request.getParameter("page");
            if (pageParam != null) {
                page = Integer.parseInt(pageParam);
            }

            // Lấy searchKeyword và roleId từ request
            String searchKeyword = request.getParameter("searchKeyword");
            String roleIdParam = request.getParameter("roleId");
            Integer roleId = null;
            if (roleIdParam != null && !roleIdParam.isEmpty()) {
                roleId = Integer.parseInt(roleIdParam);
            }

            UserDAO userDAO = new UserDAO();
            int totalRecords;
            List<User> users;
            int offset = (page - 1) * recordsPerPage;

            // Nếu có tìm kiếm hoặc lọc theo role
            if ((searchKeyword != null && !searchKeyword.trim().isEmpty()) || roleId != null) {
                users = userDAO.searchUsers(roleId, searchKeyword, offset, recordsPerPage);
                totalRecords = userDAO.countSearchUsers(roleId, searchKeyword);
            } else {
                // Mặc định (giữ nguyên logic cũ)
                users = userDAO.getUsersByPage(offset, recordsPerPage);
                totalRecords = userDAO.countAllUsers();
            }

            int totalPages = (int) Math.ceil(totalRecords * 1.0 / recordsPerPage);

            // Gửi dữ liệu sang JSP
            request.setAttribute("users", users);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchKeyword", searchKeyword);
            request.setAttribute("roleId", roleId);

            RequestDispatcher dispatcher = request.getRequestDispatcher("/page/operator/UserList.jsp");
            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Có lỗi khi xử lý danh sách người dùng.");
        }
    }
}
