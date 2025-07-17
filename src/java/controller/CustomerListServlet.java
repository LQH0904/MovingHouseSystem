
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
import java.util.stream.Collectors;

public class CustomerListServlet extends HttpServlet {
    private static final int USERS_PER_PAGE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserDAO userDAO = new UserDAO();
        List<User> allUsers = null;

        try {
            allUsers = userDAO.getAllUsers();
        } catch (SQLException ex) {
            Logger.getLogger(CustomerListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        List<User> customers = allUsers.stream()
                .filter(user -> user.getRole().getRoleId() == 6)
                .collect(Collectors.toList());

        int page = 1;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        int totalUsers = customers.size();
        int totalPages = (int) Math.ceil((double) totalUsers / USERS_PER_PAGE);

        int fromIndex = (page - 1) * USERS_PER_PAGE;
        int toIndex = Math.min(fromIndex + USERS_PER_PAGE, totalUsers);
        

        List<User> usersToDisplay = customers.subList(fromIndex, toIndex);

        request.setAttribute("users", usersToDisplay);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        request.getRequestDispatcher("/page/staff/CustomerList.jsp").forward(request, response);
    }
}