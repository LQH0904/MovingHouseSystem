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

@WebServlet("/CustomerListServlet")
public class CustomerListServlet extends HttpServlet {
    private static final int USERS_PER_PAGE = 15;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String pageParam = request.getParameter("page");

        int page = 1;
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        UserDAO userDAO = new UserDAO();
        List<User> allUsers = null;

        try {
            allUsers = userDAO.getAllUsers();
        } catch (SQLException ex) {
            Logger.getLogger(CustomerListServlet.class.getName()).log(Level.SEVERE, null, ex);
        }

        if (allUsers == null) allUsers = List.of();

        // Lọc khách hàng
        List<User> customers = allUsers.stream()
                .filter(user -> user.getRole().getRoleId() == 6)
                .collect(Collectors.toList());

        // Lọc theo từ khóa nếu có
        if (keyword != null && !keyword.trim().isEmpty()) {
            String lower = keyword.toLowerCase();
            customers = customers.stream()
                    .filter(u -> u.getUsername().toLowerCase().contains(lower) ||
                                 u.getEmail().toLowerCase().contains(lower))
                    .collect(Collectors.toList());
        }

        int totalUsers = customers.size();
        int totalPages = (int) Math.ceil((double) totalUsers / USERS_PER_PAGE);

        int fromIndex = (page - 1) * USERS_PER_PAGE;
        int toIndex = Math.min(fromIndex + USERS_PER_PAGE, totalUsers);

        List<User> usersToDisplay = customers.subList(fromIndex, toIndex);

        request.setAttribute("users", usersToDisplay);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("keyword", keyword); // giữ lại keyword cho input

        request.getRequestDispatcher("/page/staff/CustomerList.jsp").forward(request, response);
    }

    // Nếu cần fallback GET → chuyển về POST
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
