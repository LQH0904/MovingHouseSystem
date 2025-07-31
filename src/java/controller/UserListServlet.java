package controller;

import dao.UserDAO;
import model.User;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/UserListServlet")
public class UserListServlet extends HttpServlet {

    private static final int RECORDS_PER_PAGE = 15;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        String keyword = request.getParameter("searchKeyword");
        String roleIdParam = request.getParameter("roleId");
        Integer roleId = (roleIdParam != null && !roleIdParam.isEmpty()) ? Integer.parseInt(roleIdParam) : null;

        UserDAO userDAO = new UserDAO();
        List<User> users = null;
        int totalRecords = 0;
        int offset = (page - 1) * RECORDS_PER_PAGE;

        try {
            if ((keyword != null && !keyword.trim().isEmpty()) || roleId != null) {
                users = userDAO.searchUsers(roleId, keyword, offset, RECORDS_PER_PAGE);
                totalRecords = userDAO.countSearchUsers(roleId, keyword);
            } else {
                users = userDAO.getUsersByPage(offset, RECORDS_PER_PAGE);
                totalRecords = userDAO.countAllUsers();
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        int totalPages = (int) Math.ceil((double) totalRecords / RECORDS_PER_PAGE);

        request.setAttribute("users", users);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchKeyword", keyword);
        request.setAttribute("roleId", roleId);

        request.getRequestDispatcher("/page/operator/UserList.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Gửi về POST mặc định (để form phân trang cũng hoạt động nếu GET)
        doPost(request, response);
    }
}
